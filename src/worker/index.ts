import { Hono } from "hono";
import { cors } from "hono/cors";
import { zValidator } from '@hono/zod-validator';
import { getCookie, setCookie } from "hono/cookie";
import {
  exchangeCodeForSessionToken,
  getOAuthRedirectUrl,
  deleteSession,
  MOCHA_SESSION_TOKEN_COOKIE_NAME,
  getCurrentUser,
} from "@getmocha/users-service/backend";
import {
  UserSchema,
  CreateUserSchema,
  UpdateUserSchema,
  CreateCourseSchema,
  CourseSchema,
  UserProgressSchema,
} from "@/shared/types";

function nanoid() {
  return crypto.randomUUID();
}

const app = new Hono<{ Bindings: Env }>();

app.use('*', cors({
  origin: '*',
  credentials: true,
}));



// OAuth routes
app.get('/api/oauth/google/redirect_url', async (c) => {
  const redirectUrl = await getOAuthRedirectUrl('google', {
    apiUrl: c.env.MOCHA_USERS_SERVICE_API_URL,
    apiKey: c.env.MOCHA_USERS_SERVICE_API_KEY,
  });

  return c.json({ redirectUrl }, 200);
});

// Temporary login for demo purposes
app.post("/api/temp-login", zValidator('json', CreateUserSchema.partial()), async (c) => {
  try {
    const body = await c.req.json();
    
    if (!body.user_type) {
      return c.json({ error: "User type required" }, 400);
    }

    // Create temporary user
    const userId = nanoid();
    const tempEmail = `temp_${userId}@demo.com`;
    const tempGoogleSub = `temp_${userId}`;

    await c.env.DB.prepare(`
      INSERT INTO users (id, email, name, user_type, avatar_id, phone_number, google_sub, created_at, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, datetime('now'), datetime('now'))
    `).bind(
      userId,
      tempEmail,
      body.name || `Demo ${body.user_type}`,
      body.user_type,
      body.avatar_id || (body.user_type === 'child' ? '👦' : '👨‍🏫'),
      body.phone_number || null,
      tempGoogleSub
    ).run();

    // Create a temporary session token (just the user ID for demo)
    setCookie(c, MOCHA_SESSION_TOKEN_COOKIE_NAME, `temp_session_${userId}`, {
      httpOnly: true,
      path: "/",
      sameSite: "none",
      secure: true,
      maxAge: 60 * 60, // 1 hour
    });

    return c.json({ success: true, userId }, 200);
  } catch (error) {
    console.error('Temp login error:', error);
    return c.json({ error: 'Failed to create temporary user' }, 500);
  }
});

app.post("/api/sessions", zValidator('json', CreateUserSchema.partial()), async (c) => {
  const body = await c.req.json();

  if (!body.code) {
    return c.json({ error: "No authorization code provided" }, 400);
  }

  const sessionToken = await exchangeCodeForSessionToken(body.code, {
    apiUrl: c.env.MOCHA_USERS_SERVICE_API_URL,
    apiKey: c.env.MOCHA_USERS_SERVICE_API_KEY,
  });

  // Get user info from the session
  const mochaUser = await getCurrentUser(sessionToken, {
    apiUrl: c.env.MOCHA_USERS_SERVICE_API_URL,
    apiKey: c.env.MOCHA_USERS_SERVICE_API_KEY,
  });

  if (mochaUser) {
    // Check if user exists in our database
    const existingUser = await c.env.DB.prepare(
      "SELECT * FROM users WHERE google_sub = ?"
    ).bind(mochaUser.google_sub).first();

    if (!existingUser && body.user_type) {
      // Create new user in our database
      const userId = nanoid();
      await c.env.DB.prepare(`
        INSERT INTO users (id, email, name, user_type, google_sub, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, datetime('now'), datetime('now'))
      `).bind(
        userId,
        mochaUser.email,
        mochaUser.google_user_data.name || '',
        body.user_type,
        mochaUser.google_sub
      ).run();
    }
  }

  setCookie(c, MOCHA_SESSION_TOKEN_COOKIE_NAME, sessionToken, {
    httpOnly: true,
    path: "/",
    sameSite: "none",
    secure: true,
    maxAge: 60 * 24 * 60 * 60, // 60 days
  });

  return c.json({ success: true }, 200);
});

app.get("/api/users/me", async (c) => {
  const sessionToken = getCookie(c, MOCHA_SESSION_TOKEN_COOKIE_NAME);
  
  // Handle temporary sessions
  if (sessionToken && sessionToken.startsWith('temp_session_')) {
    const userId = sessionToken.replace('temp_session_', '');
    const appUser = await c.env.DB.prepare(
      "SELECT * FROM users WHERE id = ?"
    ).bind(userId).first();

    if (appUser) {
      return c.json({
        mochaUser: {
          id: appUser.id,
          email: appUser.email,
          google_sub: appUser.google_sub,
          google_user_data: { name: appUser.name }
        },
        appUser: UserSchema.parse(appUser)
      });
    }
    
    return c.json({ error: "User not found" }, 404);
  }

  // Handle regular Mocha authentication
  const mochaUser = c.get("user");
  if (!mochaUser) {
    return c.json({ error: "Not authenticated" }, 401);
  }

  // Get our app user data
  const appUser = await c.env.DB.prepare(
    "SELECT * FROM users WHERE google_sub = ?"
  ).bind(mochaUser.google_sub).first();

  return c.json({
    mochaUser,
    appUser: appUser ? UserSchema.parse(appUser) : null
  });
});

app.put("/api/users/me", zValidator('json', UpdateUserSchema), async (c) => {
  const sessionToken = getCookie(c, MOCHA_SESSION_TOKEN_COOKIE_NAME);
  
  // Handle temporary sessions
  if (sessionToken && sessionToken.startsWith('temp_session_')) {
    const userId = sessionToken.replace('temp_session_', '');
    const body = await c.req.json();
    
    await c.env.DB.prepare(`
      UPDATE users SET 
        name = COALESCE(?, name),
        avatar_id = COALESCE(?, avatar_id),
        language = COALESCE(?, language),
        theme = COALESCE(?, theme),
        updated_at = datetime('now')
      WHERE id = ?
    `).bind(
      body.name || null,
      body.avatar_id || null,
      body.language || null,
      body.theme || null,
      userId
    ).run();

    const updatedUser = await c.env.DB.prepare(
      "SELECT * FROM users WHERE id = ?"
    ).bind(userId).first();

    return c.json(UserSchema.parse(updatedUser));
  }

  // Handle regular authenticated users
  const mochaUser = c.get("user");
  if (!mochaUser) {
    return c.json({ error: "Not authenticated" }, 401);
  }

  const body = await c.req.json();
  
  await c.env.DB.prepare(`
    UPDATE users SET 
      name = COALESCE(?, name),
      avatar_id = COALESCE(?, avatar_id),
      language = COALESCE(?, language),
      theme = COALESCE(?, theme),
      updated_at = datetime('now')
    WHERE google_sub = ?
  `).bind(
    body.name || null,
    body.avatar_id || null,
    body.language || null,
    body.theme || null,
    mochaUser.google_sub
  ).run();

  const updatedUser = await c.env.DB.prepare(
    "SELECT * FROM users WHERE google_sub = ?"
  ).bind(mochaUser.google_sub).first();

  return c.json(UserSchema.parse(updatedUser));
});

// Helper function to get current user (handles both temp and regular sessions)
async function getCurrentAppUser(c: any) {
  const sessionToken = getCookie(c, MOCHA_SESSION_TOKEN_COOKIE_NAME);
  
  if (sessionToken && sessionToken.startsWith('temp_session_')) {
    const userId = sessionToken.replace('temp_session_', '');
    return await c.env.DB.prepare(
      "SELECT * FROM users WHERE id = ?"
    ).bind(userId).first();
  }

  const mochaUser = c.get("user");
  if (!mochaUser) {
    return null;
  }

  return await c.env.DB.prepare(
    "SELECT * FROM users WHERE google_sub = ?"
  ).bind(mochaUser.google_sub).first();
}

// Courses API
app.get("/api/courses", async (c) => {
  const appUser = await getCurrentAppUser(c);
  
  if (!appUser) {
    return c.json({ error: "Not authenticated" }, 401);
  }

  let query;
  if (appUser.user_type === 'teacher') {
    // Teachers see their own courses
    query = c.env.DB.prepare("SELECT * FROM courses WHERE teacher_id = ? ORDER BY created_at DESC");
  } else {
    // Children see published courses
    query = c.env.DB.prepare("SELECT * FROM courses WHERE is_published = 1 ORDER BY created_at DESC");
  }

  const { results } = await query.bind(appUser.id).all();
  return c.json(results.map(course => CourseSchema.parse(course)));
});

app.post("/api/courses", zValidator('json', CreateCourseSchema), async (c) => {
  const appUser = await getCurrentAppUser(c);
  
  if (!appUser) {
    return c.json({ error: "Not authenticated" }, 401);
  }

  if (appUser.user_type !== 'teacher') {
    return c.json({ error: "Only teachers can create courses" }, 403);
  }

  const body = await c.req.json();
  const courseId = nanoid();

  await c.env.DB.prepare(`
    INSERT INTO courses (id, title, description, teacher_id, language, thumbnail_url, created_at, updated_at)
    VALUES (?, ?, ?, ?, ?, ?, datetime('now'), datetime('now'))
  `).bind(
    courseId,
    body.title,
    body.description || null,
    appUser.id,
    body.language,
    body.thumbnail_url || null
  ).run();

  const newCourse = await c.env.DB.prepare(
    "SELECT * FROM courses WHERE id = ?"
  ).bind(courseId).first();

  return c.json(CourseSchema.parse(newCourse), 201);
});

// User progress API
app.get("/api/progress", async (c) => {
  const appUser = await getCurrentAppUser(c);
  
  if (!appUser) {
    return c.json({ error: "Not authenticated" }, 401);
  }

  const { results } = await c.env.DB.prepare(
    "SELECT * FROM user_progress WHERE user_id = ? ORDER BY created_at DESC"
  ).bind(appUser.id).all();

  return c.json(results.map(progress => UserProgressSchema.parse(progress)));
});

app.get('/api/logout', async (c) => {
  const sessionToken = getCookie(c, MOCHA_SESSION_TOKEN_COOKIE_NAME);

  if (sessionToken && !sessionToken.startsWith('temp_session_')) {
    await deleteSession(sessionToken, {
      apiUrl: c.env.MOCHA_USERS_SERVICE_API_URL,
      apiKey: c.env.MOCHA_USERS_SERVICE_API_KEY,
    });
  }

  setCookie(c, MOCHA_SESSION_TOKEN_COOKIE_NAME, '', {
    httpOnly: true,
    path: '/',
    sameSite: 'none',
    secure: true,
    maxAge: 0,
  });

  return c.json({ success: true }, 200);
});

export default app;
