import { Routes, Route, useNavigate, useLocation } from 'react-router';
import { motion } from 'framer-motion';
import { Home, Gamepad2, TrendingUp, User, Star, Coins } from 'lucide-react';
import { useAuth } from '@getmocha/users-service/react';
import { useLanguage } from '@/react-app/hooks/useLanguage';
import { useEffect, useState } from 'react';

import ChildHome from './Home';
import ChildGames from './Games';
import ChildProgress from './Progress';
import ChildProfile from './Profile';
import ChildLearn from './Learn';

export default function ChildDashboard() {
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

  const currentPath = location.pathname.split('/').pop() || 'home';

  const navItems = [
    { id: 'home', label: 'Home', icon: Home, path: '/child' },
    { id: 'learn', label: t('learn'), icon: TrendingUp, path: '/child/learn' },
    { id: 'games', label: t('games'), icon: Gamepad2, path: '/child/games' },
    { id: 'progress', label: t('achievements'), icon: Star, path: '/child/progress' },
    { id: 'profile', label: t('profile'), icon: User, path: '/child/profile' },
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
    <div className="min-h-screen bg-gradient-to-br from-orange-50 via-pink-50 to-purple-50 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900">
      {/* Top Bar */}
      <div className="sticky top-0 z-50 bg-white/80 dark:bg-gray-800/80 backdrop-blur-lg border-b border-white/20">
        <div className="flex items-center justify-between p-4">
          {/* Left: Avatar */}
          <motion.div 
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.9 }}
            onClick={() => navigate('/child/profile')}
            className="flex items-center gap-3 cursor-pointer"
          >
            <div className="text-3xl p-2 bg-orange-100 dark:bg-orange-900/30 rounded-full">
              {userData.avatar_id || '👦'}
            </div>
            <div className="hidden sm:block">
              <p className="font-semibold text-gray-800 dark:text-white">
                {userData.name || 'Child'}
              </p>
              <p className="text-sm text-gray-600 dark:text-gray-400">
                Level 1 Explorer
              </p>
            </div>
          </motion.div>

          {/* Center: Progress Ribbon */}
          <div className="hidden md:flex items-center gap-4 px-6 py-2 bg-gradient-to-r from-orange-100 to-pink-100 dark:from-orange-900/30 dark:to-pink-900/30 rounded-full">
            <div className="flex items-center gap-1">
              <Star className="w-5 h-5 text-yellow-400 fill-yellow-400" />
              <span className="font-bold text-gray-800 dark:text-white">{userData.total_stars || 0}</span>
            </div>
            <div className="w-px h-4 bg-gray-300 dark:bg-gray-600"></div>
            <div className="flex items-center gap-1">
              <Coins className="w-5 h-5 text-orange-500" />
              <span className="font-bold text-gray-800 dark:text-white">{userData.total_coins || 0}</span>
            </div>
          </div>

          {/* Right: Stats (mobile) */}
          <div className="md:hidden flex items-center gap-2">
            <div className="flex items-center gap-1 px-3 py-1 bg-yellow-100 dark:bg-yellow-900/30 rounded-full">
              <Star className="w-4 h-4 text-yellow-400 fill-yellow-400" />
              <span className="text-sm font-bold">{userData.total_stars || 0}</span>
            </div>
            <div className="flex items-center gap-1 px-3 py-1 bg-orange-100 dark:bg-orange-900/30 rounded-full">
              <Coins className="w-4 h-4 text-orange-500" />
              <span className="text-sm font-bold">{userData.total_coins || 0}</span>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="pb-20">
        <Routes>
          <Route index element={<ChildHome userData={userData} />} />
          <Route path="learn" element={<ChildLearn />} />
          <Route path="games" element={<ChildGames />} />
          <Route path="progress" element={<ChildProgress />} />
          <Route path="profile" element={<ChildProfile userData={userData} />} />
        </Routes>
      </div>

      {/* Bottom Navigation */}
      <div className="fixed bottom-0 left-0 right-0 z-50 bg-white/90 dark:bg-gray-800/90 backdrop-blur-lg border-t border-white/20">
        <div className="flex justify-around items-center py-2">
          {navItems.map((item) => {
            const Icon = item.icon;
            const isActive = (item.path === '/child' && currentPath === 'child') || 
                           (item.path !== '/child' && currentPath === item.path.split('/').pop());
            
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
