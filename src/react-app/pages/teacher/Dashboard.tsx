import { Routes, Route, useNavigate, useLocation } from 'react-router';
import { motion } from 'framer-motion';
import { Home, BookOpen, BarChart3, User, Plus } from 'lucide-react';
import { useAuth } from '@getmocha/users-service/react';
import { useLanguage } from '@/react-app/hooks/useLanguage';
import { useEffect, useState } from 'react';

import TeacherHome from './Home';
import TeacherCourses from './Courses';
import TeacherAnalytics from './Analytics';
import TeacherProfile from './Profile';

export default function TeacherDashboard() {
  const { } = useAuth();
  const { t } = useLanguage();
  const navigate = useNavigate();
  const location = useLocation();
  const [userData, setUserData] = useState<any>(null);

  useEffect(() => {
    // Fetch user data from our API
    fetch('/api/users/me')
      .then(res => res.json())
      .then(data => {
        if (data.appUser) {
          setUserData(data.appUser);
        }
      })
      .catch(console.error);
  }, []);

  const currentPath = location.pathname.split('/').pop() || 'teacher';

  const navItems = [
    { id: 'home', label: 'Dashboard', icon: Home, path: '/teacher' },
    { id: 'courses', label: 'Courses', icon: BookOpen, path: '/teacher/courses' },
    { id: 'analytics', label: 'Analytics', icon: BarChart3, path: '/teacher/analytics' },
    { id: 'profile', label: t('profile'), icon: User, path: '/teacher/profile' },
  ];

  if (!userData) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-orange-50 to-pink-50 dark:from-gray-900 dark:to-gray-800 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin mb-4">
            <div className="w-12 h-12 border-4 border-orange-500 border-t-transparent rounded-full"></div>
          </div>
          <p className="text-gray-600 dark:text-gray-300">Loading your dashboard...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 via-blue-50 to-purple-50 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900">
      {/* Top Bar */}
      <div className="sticky top-0 z-50 bg-white/80 dark:bg-gray-800/80 backdrop-blur-lg border-b border-white/20">
        <div className="flex items-center justify-between p-4">
          {/* Left: Teacher Info */}
          <motion.div 
            whileHover={{ scale: 1.02 }}
            onClick={() => navigate('/teacher/profile')}
            className="flex items-center gap-3 cursor-pointer"
          >
            <div className="w-12 h-12 bg-gradient-to-r from-orange-400 to-pink-400 rounded-full flex items-center justify-center text-white font-bold text-lg">
              {userData.name?.charAt(0)?.toUpperCase() || 'T'}
            </div>
            <div className="hidden sm:block">
              <p className="font-semibold text-gray-800 dark:text-white">
                {userData.name || 'Teacher'}
              </p>
              <p className="text-sm text-gray-600 dark:text-gray-400">
                Educator
              </p>
            </div>
          </motion.div>

          {/* Center: App Title */}
          <div className="hidden md:block">
            <h1 className="text-2xl font-bold text-gray-800 dark:text-white">
              Edugram Teacher
            </h1>
          </div>

          {/* Right: Quick Action */}
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => navigate('/teacher/courses')}
            className="flex items-center gap-2 px-4 py-2 bg-orange-500 hover:bg-orange-600 text-white rounded-xl shadow-lg font-medium"
          >
            <Plus className="w-4 h-4" />
            <span className="hidden sm:inline">New Course</span>
          </motion.button>
        </div>
      </div>

      {/* Main Content */}
      <div className="pb-20">
        <Routes>
          <Route index element={<TeacherHome userData={userData} />} />
          <Route path="courses" element={<TeacherCourses />} />
          <Route path="analytics" element={<TeacherAnalytics />} />
          <Route path="profile" element={<TeacherProfile userData={userData} />} />
        </Routes>
      </div>

      {/* Bottom Navigation */}
      <div className="fixed bottom-0 left-0 right-0 z-50 bg-white/90 dark:bg-gray-800/90 backdrop-blur-lg border-t border-white/20">
        <div className="flex justify-around items-center py-2">
          {navItems.map((item) => {
            const Icon = item.icon;
            const isActive = (item.path === '/teacher' && currentPath === 'teacher') || 
                           (item.path !== '/teacher' && currentPath === item.path.split('/').pop());
            
            return (
              <motion.button
                key={item.id}
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.9 }}
                onClick={() => navigate(item.path)}
                className={`flex flex-col items-center gap-1 px-3 py-2 rounded-xl transition-all ${
                  isActive 
                    ? 'text-orange-500 bg-orange-100 dark:bg-orange-900/30' 
                    : 'text-gray-600 dark:text-gray-400 hover:text-orange-500 hover:bg-orange-50 dark:hover:bg-orange-900/20'
                }`}
              >
                <Icon className="w-5 h-5" />
                <span className="text-xs font-medium">{item.label}</span>
              </motion.button>
            );
          })}
        </div>
      </div>
    </div>
  );
}
