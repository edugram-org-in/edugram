import { BrowserRouter as Router, Routes, Route } from "react-router";
import { AuthProvider } from '@getmocha/users-service/react';
import { LanguageProvider } from '@/react-app/hooks/useLanguage';
import { ThemeProvider } from '@/react-app/hooks/useTheme';

import SplashScreen from "@/react-app/pages/SplashScreen";
import Onboarding from "@/react-app/pages/Onboarding";
import LoginPage from "@/react-app/pages/Login";
import AuthCallback from "@/react-app/pages/AuthCallback";
import ChildDashboard from "@/react-app/pages/child/Dashboard";
import TeacherDashboard from "@/react-app/pages/teacher/Dashboard";
import HomePage from "@/react-app/pages/Home";

export default function App() {
  return (
    <ThemeProvider>
      <LanguageProvider>
        <AuthProvider>
          <Router>
            <Routes>
              <Route path="/" element={<HomePage />} />
              <Route path="/splash" element={<SplashScreen />} />
              <Route path="/onboarding" element={<Onboarding />} />
              <Route path="/login" element={<LoginPage />} />
              <Route path="/auth/callback" element={<AuthCallback />} />
              <Route path="/child/*" element={<ChildDashboard />} />
              <Route path="/teacher/*" element={<TeacherDashboard />} />
            </Routes>
          </Router>
        </AuthProvider>
      </LanguageProvider>
    </ThemeProvider>
  );
}
