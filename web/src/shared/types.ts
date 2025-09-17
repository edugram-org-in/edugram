import z from "zod";

// User Types
export const UserTypeSchema = z.enum(['child', 'teacher']);
export type UserType = z.infer<typeof UserTypeSchema>;

export const LanguageSchema = z.enum(['english', 'hindi', 'odia', 'telugu', 'bangla', 'malayalam', 'kannada']);
export type Language = z.infer<typeof LanguageSchema>;

export const ThemeSchema = z.enum(['light', 'dark']);
export type Theme = z.infer<typeof ThemeSchema>;

// User Schema
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().optional(),
  name: z.string().optional(),
  user_type: UserTypeSchema,
  avatar_id: z.string().optional(),
  language: LanguageSchema.default('english'),
  theme: ThemeSchema.default('light'),
  phone_number: z.string().optional(),
  total_stars: z.number().default(0),
  total_coins: z.number().default(0),
  total_badges: z.number().default(0),
  google_sub: z.string().optional(),
  created_at: z.string(),
  updated_at: z.string(),
});
export type User = z.infer<typeof UserSchema>;

// Course Schema
export const CourseSchema = z.object({
  id: z.string(),
  title: z.string(),
  description: z.string().optional(),
  teacher_id: z.string(),
  language: LanguageSchema.default('english'),
  thumbnail_url: z.string().optional(),
  is_published: z.boolean().default(false),
  created_at: z.string(),
  updated_at: z.string(),
});
export type Course = z.infer<typeof CourseSchema>;

// Lesson Schema
export const LessonTypeSchema = z.enum(['story', 'game', 'quiz', 'video']);
export type LessonType = z.infer<typeof LessonTypeSchema>;

export const LessonSchema = z.object({
  id: z.string(),
  course_id: z.string(),
  title: z.string(),
  content: z.string().optional(),
  lesson_type: LessonTypeSchema,
  order_index: z.number(),
  points_reward: z.number().default(10),
  created_at: z.string(),
  updated_at: z.string(),
});
export type Lesson = z.infer<typeof LessonSchema>;

// User Progress Schema
export const UserProgressSchema = z.object({
  id: z.string(),
  user_id: z.string(),
  lesson_id: z.string(),
  course_id: z.string(),
  is_completed: z.boolean().default(false),
  stars_earned: z.number().default(0),
  coins_earned: z.number().default(0),
  completion_date: z.string().optional(),
  created_at: z.string(),
  updated_at: z.string(),
});
export type UserProgress = z.infer<typeof UserProgressSchema>;

// Badge Schema
export const BadgeSchema = z.object({
  id: z.string(),
  name: z.string(),
  description: z.string().optional(),
  icon_url: z.string().optional(),
  requirements: z.string().optional(),
  created_at: z.string(),
});
export type Badge = z.infer<typeof BadgeSchema>;

// User Badge Schema
export const UserBadgeSchema = z.object({
  id: z.string(),
  user_id: z.string(),
  badge_id: z.string(),
  earned_date: z.string(),
  created_at: z.string(),
});
export type UserBadge = z.infer<typeof UserBadgeSchema>;

// API Request/Response Schemas
export const CreateUserSchema = z.object({
  email: z.string().email().optional(),
  name: z.string(),
  user_type: UserTypeSchema,
  phone_number: z.string().optional(),
  avatar_id: z.string().optional(),
  language: LanguageSchema.default('english'),
});
export type CreateUserRequest = z.infer<typeof CreateUserSchema>;

export const UpdateUserSchema = z.object({
  name: z.string().optional(),
  avatar_id: z.string().optional(),
  language: LanguageSchema.optional(),
  theme: ThemeSchema.optional(),
});
export type UpdateUserRequest = z.infer<typeof UpdateUserSchema>;

export const CreateCourseSchema = z.object({
  title: z.string(),
  description: z.string().optional(),
  language: LanguageSchema.default('english'),
  thumbnail_url: z.string().optional(),
});
export type CreateCourseRequest = z.infer<typeof CreateCourseSchema>;

// Language translations
export const translations = {
  english: {
    welcome: "Welcome to Edugram",
    learn: "Learn",
    games: "Games",
    profile: "Profile",
    achievements: "Achievements",
    login: "Login",
    signup: "Sign Up",
    teacher: "Teacher",
    child: "Child",
    stars: "Stars",
    coins: "Coins",
    badges: "Badges",
  },
  hindi: {
    welcome: "एडुग्राम में आपका स्वागत है",
    learn: "सीखें",
    games: "खेल",
    profile: "प्रोफाइल",
    achievements: "उपलब्धियां",
    login: "लॉगिन",
    signup: "साइन अप",
    teacher: "शिक्षक",
    child: "बच्चा",
    stars: "सितारे",
    coins: "सिक्के",
    badges: "बैज",
  },
  odia: {
    welcome: "ଏଡୁଗ୍ରାମରେ ଆପଣଙ୍କୁ ସ୍ୱାଗତ",
    learn: "ଶିଖନ୍ତୁ",
    games: "ଖେଳ",
    profile: "ପ୍ରୋଫାଇଲ୍",
    achievements: "ଉପଲବ୍ଧି",
    login: "ଲଗଇନ୍",
    signup: "ସାଇନ୍ ଅପ୍",
    teacher: "ଶିକ୍ଷକ",
    child: "ଶିଶୁ",
    stars: "ତାରକା",
    coins: "ମୁଦ୍ରା",
    badges: "ବ୍ୟାଜ୍",
  },
  telugu: {
    welcome: "ఎడుగ్రామ్‌కు స్వాగతం",
    learn: "నేర్చుకోండి",
    games: "ఆటలు",
    profile: "ప్రొఫైల్",
    achievements: "విజయాలు",
    login: "లాగిన్",
    signup: "సైన్ అప్",
    teacher: "ఉపాధ్యాయుడు",
    child: "పిల్లవాడు",
    stars: "నక్షత్రాలు",
    coins: "నాణేలు",
    badges: "బ్యాజ్‌లు",
  },
  bangla: {
    welcome: "এডুগ্রামে স্বাগতম",
    learn: "শিখুন",
    games: "গেমস",
    profile: "প্রোফাইল",
    achievements: "অর্জন",
    login: "লগইন",
    signup: "সাইন আপ",
    teacher: "শিক্ষক",
    child: "শিশু",
    stars: "তারা",
    coins: "কয়েন",
    badges: "ব্যাজ",
  },
  malayalam: {
    welcome: "എഡുഗ്രാമിലേക്ക് സ്വാഗതം",
    learn: "പഠിക്കുക",
    games: "ഗെയിമുകൾ",
    profile: "പ്രൊഫൈൽ",
    achievements: "നേട്ടങ്ങൾ",
    login: "ലോഗിൻ",
    signup: "സൈൻ അപ്പ്",
    teacher: "അധ്യാപകൻ",
    child: "കുട്ടി",
    stars: "നക്ഷത്രങ്ങൾ",
    coins: "നാണയങ്ങൾ",
    badges: "ബാഡ്ജുകൾ",
  },
  kannada: {
    welcome: "ಎಡುಗ್ರಾಮ್‌ಗೆ ಸ್ವಾಗತ",
    learn: "ಕಲಿಯಿರಿ",
    games: "ಆಟಗಳು",
    profile: "ಪ್ರೊಫೈಲ್",
    achievements: "ಸಾಧನೆಗಳು",
    login: "ಲಾಗಿನ್",
    signup: "ಸೈನ್ ಅಪ್",
    teacher: "ಶಿಕ್ಷಕ",
    child: "ಮಗು",
    stars: "ನಕ್ಷತ್ರಗಳು",
    coins: "ನಾಣ್ಯಗಳು",
    badges: "ಬ್ಯಾಡ್ಜ್‌ಗಳು",
  },
} as const;

export type TranslationKey = keyof typeof translations.english;
export type Translations = typeof translations;
