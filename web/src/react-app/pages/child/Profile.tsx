import { useState } from 'react';
import { motion } from 'framer-motion';
import { Edit, Save, Moon, Sun, Globe, LogOut, Settings } from 'lucide-react';
import { useAuth } from '@getmocha/users-service/react';
import { useNavigate } from 'react-router';
import Card from '@/react-app/components/Card';
import Button from '@/react-app/components/Button';
import LanguageSelector from '@/react-app/components/LanguageSelector';
import ThemeToggle from '@/react-app/components/ThemeToggle';
import { useLanguage } from '@/react-app/hooks/useLanguage';

const avatars = [
  '👦', '👧', '🧒', '👶', '🦸‍♂️', '🦸‍♀️', '🐱', '🐶', '🦁', '🐸',
  '🦋', '🌟', '🎨', '🎵', '⚽', '🏀', '📚', '🎯', '🚀', '🌙'
];

interface ChildProfileProps {
  userData: any;
}

export default function ChildProfile({ userData }: ChildProfileProps) {
  const [isEditing, setIsEditing] = useState(false);
  const [editedName, setEditedName] = useState(userData?.name || '');
  const [selectedAvatar, setSelectedAvatar] = useState(userData?.avatar_id || avatars[0]);
  const { logout } = useAuth();
  const navigate = useNavigate();
  const { t } = useLanguage();

  const handleSave = async () => {
    try {
      const response = await fetch('/api/users/me', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: editedName,
          avatar_id: selectedAvatar,
        }),
      });

      if (response.ok) {
        setIsEditing(false);
        // In a real app, you'd update the parent component's state
      }
    } catch (error) {
      console.error('Failed to update profile:', error);
    }
  };

  const handleLogout = async () => {
    await logout();
    navigate('/');
  };

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className="text-center"
      >
        <h1 className="text-3xl font-bold text-gray-800 dark:text-white mb-2">
          {t('profile')}
        </h1>
        <p className="text-gray-600 dark:text-gray-400">
          Customize your learning experience
        </p>
      </motion.div>

      {/* Profile Card */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
      >
        <Card className="p-8" gradient>
          <div className="text-center">
            {/* Avatar */}
            <motion.div
              whileHover={{ scale: 1.1 }}
              className="relative inline-block mb-6"
            >
              <div className="text-8xl mb-2">
                {selectedAvatar}
              </div>
              {isEditing && (
                <motion.button
                  whileHover={{ scale: 1.1 }}
                  whileTap={{ scale: 0.9 }}
                  onClick={() => {/* Avatar selection modal would open here */}}
                  className="absolute -bottom-2 -right-2 w-8 h-8 bg-orange-500 text-white rounded-full flex items-center justify-center shadow-lg"
                >
                  <Edit className="w-4 h-4" />
                </motion.button>
              )}
            </motion.div>

            {/* Name */}
            <div className="mb-6">
              {isEditing ? (
                <input
                  type="text"
                  value={editedName}
                  onChange={(e) => setEditedName(e.target.value)}
                  className="text-2xl font-bold text-gray-800 dark:text-white bg-transparent border-b-2 border-orange-500 focus:outline-none text-center"
                  autoFocus
                />
              ) : (
                <h2 className="text-2xl font-bold text-gray-800 dark:text-white">
                  {userData?.name || 'Child'}
                </h2>
              )}
              <p className="text-gray-600 dark:text-gray-400 mt-1">
                Level 1 Explorer
              </p>
            </div>

            {/* Edit/Save Button */}
            <div className="flex justify-center gap-4">
              {isEditing ? (
                <>
                  <Button
                    onClick={handleSave}
                    className="flex items-center gap-2"
                  >
                    <Save className="w-4 h-4" />
                    Save Changes
                  </Button>
                  <Button
                    variant="secondary"
                    onClick={() => {
                      setIsEditing(false);
                      setEditedName(userData?.name || '');
                      setSelectedAvatar(userData?.avatar_id || avatars[0]);
                    }}
                  >
                    Cancel
                  </Button>
                </>
              ) : (
                <Button
                  onClick={() => setIsEditing(true)}
                  variant="secondary"
                  className="flex items-center gap-2"
                >
                  <Edit className="w-4 h-4" />
                  Edit Profile
                </Button>
              )}
            </div>
          </div>
        </Card>
      </motion.div>

      {/* Avatar Selection Grid (shown when editing) */}
      {isEditing && (
        <motion.div
          initial={{ opacity: 0, height: 0 }}
          animate={{ opacity: 1, height: 'auto' }}
          exit={{ opacity: 0, height: 0 }}
        >
          <Card className="p-6">
            <h3 className="text-lg font-bold text-gray-800 dark:text-white mb-4">
              Choose Your Avatar
            </h3>
            <div className="grid grid-cols-5 sm:grid-cols-10 gap-3">
              {avatars.map((avatar) => (
                <motion.button
                  key={avatar}
                  whileHover={{ scale: 1.1 }}
                  whileTap={{ scale: 0.9 }}
                  onClick={() => setSelectedAvatar(avatar)}
                  className={`text-3xl p-3 rounded-xl transition-all ${
                    selectedAvatar === avatar 
                      ? 'bg-orange-100 dark:bg-orange-900/30 ring-2 ring-orange-500' 
                      : 'hover:bg-gray-100 dark:hover:bg-gray-700'
                  }`}
                >
                  {avatar}
                </motion.button>
              ))}
            </div>
          </Card>
        </motion.div>
      )}

      {/* Settings */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
      >
        <Card className="p-6">
          <div className="flex items-center gap-3 mb-6">
            <Settings className="w-6 h-6 text-orange-500" />
            <h3 className="text-xl font-bold text-gray-800 dark:text-white">
              Settings
            </h3>
          </div>

          <div className="space-y-4">
            {/* Language Setting */}
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <Globe className="w-5 h-5 text-gray-600 dark:text-gray-400" />
                <div>
                  <h4 className="font-medium text-gray-800 dark:text-white">
                    Language
                  </h4>
                  <p className="text-sm text-gray-600 dark:text-gray-400">
                    Choose your learning language
                  </p>
                </div>
              </div>
              <LanguageSelector />
            </div>

            {/* Theme Setting */}
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-5 h-5 text-gray-600 dark:text-gray-400">
                  <Sun className="w-5 h-5 dark:hidden" />
                  <Moon className="w-5 h-5 hidden dark:block" />
                </div>
                <div>
                  <h4 className="font-medium text-gray-800 dark:text-white">
                    Theme
                  </h4>
                  <p className="text-sm text-gray-600 dark:text-gray-400">
                    Light or dark mode
                  </p>
                </div>
              </div>
              <ThemeToggle />
            </div>
          </div>
        </Card>
      </motion.div>

      {/* Progress Summary */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3 }}
      >
        <Card className="p-6">
          <h3 className="text-xl font-bold text-gray-800 dark:text-white mb-4">
            Learning Summary
          </h3>
          
          <div className="grid grid-cols-2 gap-6">
            <div className="text-center">
              <div className="text-3xl font-bold text-orange-500 mb-1">
                {userData?.total_stars || 0}
              </div>
              <div className="text-sm text-gray-600 dark:text-gray-400">
                Total Stars Earned
              </div>
            </div>
            
            <div className="text-center">
              <div className="text-3xl font-bold text-orange-500 mb-1">
                {userData?.total_coins || 0}
              </div>
              <div className="text-sm text-gray-600 dark:text-gray-400">
                Coins Collected
              </div>
            </div>
          </div>
        </Card>
      </motion.div>

      {/* Logout */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4 }}
      >
        <Card className="p-6">
          <Button
            onClick={handleLogout}
            variant="secondary"
            className="w-full flex items-center justify-center gap-2 text-red-600 border-red-200 hover:bg-red-50 dark:text-red-400 dark:border-red-800 dark:hover:bg-red-900/20"
          >
            <LogOut className="w-4 h-4" />
            Sign Out
          </Button>
        </Card>
      </motion.div>
    </div>
  );
}
