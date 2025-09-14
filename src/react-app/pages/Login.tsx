import { useState } from 'react';
import { useNavigate } from 'react-router';
import { motion, AnimatePresence } from 'framer-motion';
import { User, GraduationCap, Phone, Mail } from 'lucide-react';
import { useAuth } from '@getmocha/users-service/react';
import Button from '@/react-app/components/Button';
import Card from '@/react-app/components/Card';
import LanguageSelector from '@/react-app/components/LanguageSelector';
import ThemeToggle from '@/react-app/components/ThemeToggle';
import { useLanguage } from '@/react-app/hooks/useLanguage';
import { UserType } from '@/shared/types';

const avatars = [
  '👦', '👧', '🧒', '👶', '🦸‍♂️', '🦸‍♀️', '🐱', '🐶', '🦁', '🐸',
  '🦋', '🌟', '🎨', '🎵', '⚽', '🏀', '📚', '🎯'
];

export default function Login() {
  const [userType, setUserType] = useState<UserType | null>(null);
  const [selectedAvatar, setSelectedAvatar] = useState(avatars[0]);
  const [phoneNumber, setPhoneNumber] = useState('');
  const { redirectToLogin } = useAuth();
  const { t } = useLanguage();
  const navigate = useNavigate();

  const handleGoogleLogin = async () => {
    // Store user type and avatar in localStorage for use in callback
    if (userType) {
      localStorage.setItem('edugram-user-type', userType);
      localStorage.setItem('edugram-avatar', selectedAvatar);
      if (phoneNumber && userType === 'child') {
        localStorage.setItem('edugram-phone', phoneNumber);
      }
      await redirectToLogin();
    }
  };

  const handleTempLogin = async () => {
    if (!userType) return;

    try {
      const response = await fetch('/api/temp-login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          user_type: userType,
          avatar_id: selectedAvatar,
          phone_number: phoneNumber || null,
          name: userType === 'child' ? 'Demo Child' : 'Demo Teacher',
        }),
      });

      if (response.ok) {
        // Redirect to appropriate dashboard
        if (userType === 'child') {
          navigate('/child');
        } else if (userType === 'teacher') {
          navigate('/teacher');
        }
      } else {
        console.error('Temporary login failed');
      }
    } catch (error) {
      console.error('Temporary login error:', error);
    }
  };

  if (!userType) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-orange-50 to-pink-50 dark:from-gray-900 dark:to-gray-800 flex items-center justify-center p-6">
        <div className="w-full max-w-md">
          {/* Header */}
          <div className="text-center mb-12">
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ type: 'spring', stiffness: 200 }}
              className="text-6xl mb-4"
            >
              🎓
            </motion.div>
            <h1 className="text-4xl font-bold text-gray-800 dark:text-white mb-2">
              {t('welcome')}
            </h1>
            <p className="text-gray-600 dark:text-gray-300">
              Choose your account type
            </p>
          </div>

          {/* Language and Theme controls */}
          <div className="flex justify-center gap-4 mb-8">
            <LanguageSelector />
            <ThemeToggle />
          </div>

          {/* User type selection */}
          <div className="space-y-4">
            <motion.div
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
            >
              <Card
                onClick={() => setUserType('child')}
                className="p-6 cursor-pointer hover:shadow-xl transition-all"
                gradient
              >
                <div className="flex items-center gap-4">
                  <div className="p-3 bg-orange-100 dark:bg-orange-900/30 rounded-xl">
                    <User className="w-8 h-8 text-orange-500" />
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-gray-800 dark:text-white">
                      {t('child')}
                    </h3>
                    <p className="text-gray-600 dark:text-gray-300 text-sm">
                      Learn with games and activities
                    </p>
                  </div>
                </div>
              </Card>
            </motion.div>

            <motion.div
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
            >
              <Card
                onClick={() => setUserType('teacher')}
                className="p-6 cursor-pointer hover:shadow-xl transition-all"
                gradient
              >
                <div className="flex items-center gap-4">
                  <div className="p-3 bg-orange-100 dark:bg-orange-900/30 rounded-xl">
                    <GraduationCap className="w-8 h-8 text-orange-500" />
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-gray-800 dark:text-white">
                      {t('teacher')}
                    </h3>
                    <p className="text-gray-600 dark:text-gray-300 text-sm">
                      Create and manage courses
                    </p>
                  </div>
                </div>
              </Card>
            </motion.div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 to-pink-50 dark:from-gray-900 dark:to-gray-800 flex items-center justify-center p-6">
      <div className="w-full max-w-md">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ type: 'spring', stiffness: 300 }}
        >
          {/* Back button */}
          <Button
            variant="ghost"
            onClick={() => setUserType(null)}
            className="mb-6"
          >
            ← Back
          </Button>

          <Card className="p-8">
            <div className="text-center mb-8">
              <h2 className="text-3xl font-bold text-gray-800 dark:text-white mb-2">
                {userType === 'child' ? 'Child Login' : 'Teacher Login'}
              </h2>
              <p className="text-gray-600 dark:text-gray-300">
                {userType === 'child' 
                  ? 'Select your avatar and login' 
                  : 'Login with your teacher account'
                }
              </p>
            </div>

            <AnimatePresence>
              {userType === 'child' && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: 'auto' }}
                  exit={{ opacity: 0, height: 0 }}
                  className="space-y-6"
                >
                  {/* Avatar selection */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-3">
                      Choose your avatar
                    </label>
                    <div className="grid grid-cols-6 gap-2">
                      {avatars.map((avatar) => (
                        <motion.button
                          key={avatar}
                          whileHover={{ scale: 1.1 }}
                          whileTap={{ scale: 0.9 }}
                          onClick={() => setSelectedAvatar(avatar)}
                          className={`text-2xl p-2 rounded-xl transition-all ${
                            selectedAvatar === avatar 
                              ? 'bg-orange-100 dark:bg-orange-900/30 ring-2 ring-orange-500' 
                              : 'hover:bg-gray-100 dark:hover:bg-gray-700'
                          }`}
                        >
                          {avatar}
                        </motion.button>
                      ))}
                    </div>
                  </div>

                  {/* Phone number input */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Phone Number (Optional)
                    </label>
                    <div className="relative">
                      <Phone className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                      <input
                        type="tel"
                        value={phoneNumber}
                        onChange={(e) => setPhoneNumber(e.target.value)}
                        placeholder="+91 XXXXX XXXXX"
                        className="w-full pl-10 pr-4 py-3 border border-gray-300 dark:border-gray-600 rounded-xl bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                      />
                    </div>
                  </div>
                </motion.div>
              )}
            </AnimatePresence>

            {/* Login buttons */}
            <div className="mt-8 space-y-3">
              <Button
                onClick={handleGoogleLogin}
                className="w-full flex items-center justify-center gap-3 text-lg"
                size="lg"
              >
                <Mail className="w-5 h-5" />
                Login with Google
              </Button>
              
              {/* Temporary Login for Testing */}
              <Button
                onClick={handleTempLogin}
                variant="secondary"
                className="w-full flex items-center justify-center gap-3 text-lg"
                size="lg"
              >
                <User className="w-5 h-5" />
                Quick Login (Demo)
              </Button>
            </div>
          </Card>
        </motion.div>
      </div>
    </div>
  );
}
