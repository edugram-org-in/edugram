import { useState } from 'react';
import { motion } from 'framer-motion';
import { Edit, Save, Moon, Sun, Globe, LogOut, Settings, BookOpen, Award, Users } from 'lucide-react';
import { useAuth } from '@getmocha/users-service/react';
import { useNavigate } from 'react-router';
import Card from '@/react-app/components/Card';
import Button from '@/react-app/components/Button';
import LanguageSelector from '@/react-app/components/LanguageSelector';
import ThemeToggle from '@/react-app/components/ThemeToggle';
import { useLanguage } from '@/react-app/hooks/useLanguage';

interface TeacherProfileProps {
  userData: any;
}

export default function TeacherProfile({ userData }: TeacherProfileProps) {
  const [isEditing, setIsEditing] = useState(false);
  const [editedName, setEditedName] = useState(userData?.name || '');
  const [editedBio, setEditedBio] = useState(userData?.bio || '');
  const { logout } = useAuth();
  const navigate = useNavigate();
  const { } = useLanguage();

  const handleSave = async () => {
    try {
      const response = await fetch('/api/users/me', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: editedName,
          bio: editedBio,
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

  // Mock stats - would come from API in real app
  const teacherStats = {
    totalCourses: 5,
    totalStudents: 45,
    coursesPublished: 3,
    totalLessons: 28,
    avgRating: 4.8,
    totalViews: 1247
  };

  const achievements = [
    {
      title: 'Course Creator',
      description: 'Created your first course',
      icon: '🎓',
      earned: true,
      date: '2024-01-15'
    },
    {
      title: 'Popular Teacher',
      description: '50+ students enrolled',
      icon: '⭐',
      earned: false,
      progress: 45,
      target: 50
    },
    {
      title: 'Content Master',
      description: 'Published 10 courses',
      icon: '📚',
      earned: false,
      progress: 3,
      target: 10
    }
  ];

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className="text-center"
      >
        <h1 className="text-3xl font-bold text-gray-800 dark:text-white mb-2">
          Teacher Profile
        </h1>
        <p className="text-gray-600 dark:text-gray-400">
          Manage your teaching profile and preferences
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
              <div className="w-24 h-24 bg-gradient-to-r from-orange-400 to-pink-400 rounded-full flex items-center justify-center text-white font-bold text-3xl mx-auto">
                {userData?.name?.charAt(0)?.toUpperCase() || 'T'}
              </div>
              {isEditing && (
                <motion.button
                  whileHover={{ scale: 1.1 }}
                  whileTap={{ scale: 0.9 }}
                  className="absolute -bottom-2 -right-2 w-8 h-8 bg-orange-500 text-white rounded-full flex items-center justify-center shadow-lg"
                >
                  <Edit className="w-4 h-4" />
                </motion.button>
              )}
            </motion.div>

            {/* Name and Bio */}
            <div className="mb-6">
              {isEditing ? (
                <div className="space-y-4">
                  <input
                    type="text"
                    value={editedName}
                    onChange={(e) => setEditedName(e.target.value)}
                    className="text-2xl font-bold text-gray-800 dark:text-white bg-transparent border-b-2 border-orange-500 focus:outline-none text-center w-full"
                    placeholder="Your name"
                    autoFocus
                  />
                  <textarea
                    value={editedBio}
                    onChange={(e) => setEditedBio(e.target.value)}
                    className="text-gray-600 dark:text-gray-400 bg-transparent border-b-2 border-orange-500 focus:outline-none text-center w-full resize-none"
                    placeholder="Tell students about yourself..."
                    rows={3}
                  />
                </div>
              ) : (
                <div>
                  <h2 className="text-2xl font-bold text-gray-800 dark:text-white">
                    {userData?.name || 'Teacher'}
                  </h2>
                  <p className="text-gray-600 dark:text-gray-400 mt-2">
                    {userData?.bio || 'Passionate educator helping children learn and grow'}
                  </p>
                  <p className="text-sm text-gray-500 dark:text-gray-500 mt-1">
                    Educator • {userData?.email}
                  </p>
                </div>
              )}
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
                      setEditedBio(userData?.bio || '');
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

      {/* Teaching Stats */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
      >
        <Card className="p-6">
          <div className="flex items-center gap-3 mb-6">
            <Award className="w-6 h-6 text-orange-500" />
            <h3 className="text-xl font-bold text-gray-800 dark:text-white">
              Teaching Statistics
            </h3>
          </div>

          <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
            {[
              { label: 'Total Courses', value: teacherStats.totalCourses, icon: BookOpen, color: 'text-blue-500' },
              { label: 'Total Students', value: teacherStats.totalStudents, icon: Users, color: 'text-green-500' },
              { label: 'Published', value: teacherStats.coursesPublished, icon: Award, color: 'text-purple-500' },
              { label: 'Total Lessons', value: teacherStats.totalLessons, icon: BookOpen, color: 'text-orange-500' },
              { label: 'Avg Rating', value: `${teacherStats.avgRating}/5`, icon: '⭐', color: 'text-yellow-500' },
              { label: 'Total Views', value: teacherStats.totalViews, icon: '👀', color: 'text-gray-500' },
            ].map((stat, index) => {
              return (
                <motion.div
                  key={stat.label}
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: 0.3 + index * 0.1 }}
                  className="text-center p-4 bg-gray-50 dark:bg-gray-700 rounded-xl"
                >
                  <div className="text-2xl mb-2">
                    {typeof stat.icon === 'string' ? (
                      <span>{stat.icon}</span>
                    ) : (
                      <stat.icon className={`w-6 h-6 ${stat.color} mx-auto`} />
                    )}
                  </div>
                  <div className="text-lg font-bold text-gray-800 dark:text-white">
                    {stat.value}
                  </div>
                  <div className="text-sm text-gray-600 dark:text-gray-400">
                    {stat.label}
                  </div>
                </motion.div>
              );
            })}
          </div>
        </Card>
      </motion.div>

      {/* Achievements */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3 }}
      >
        <Card className="p-6">
          <div className="flex items-center gap-3 mb-6">
            <Award className="w-6 h-6 text-orange-500" />
            <h3 className="text-xl font-bold text-gray-800 dark:text-white">
              Teaching Achievements
            </h3>
          </div>

          <div className="space-y-4">
            {achievements.map((achievement, index) => (
              <motion.div
                key={achievement.title}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.4 + index * 0.1 }}
                className={`p-4 rounded-xl border-2 ${
                  achievement.earned
                    ? 'bg-green-50 border-green-200 dark:bg-green-900/20 dark:border-green-700'
                    : 'bg-gray-50 border-gray-200 dark:bg-gray-700 dark:border-gray-600'
                }`}
              >
                <div className="flex items-center gap-4">
                  <div className={`text-3xl ${achievement.earned ? '' : 'grayscale opacity-50'}`}>
                    {achievement.icon}
                  </div>
                  <div className="flex-1">
                    <h4 className={`font-bold ${
                      achievement.earned 
                        ? 'text-gray-800 dark:text-white' 
                        : 'text-gray-500 dark:text-gray-400'
                    }`}>
                      {achievement.title}
                    </h4>
                    <p className={`text-sm ${
                      achievement.earned 
                        ? 'text-gray-600 dark:text-gray-300' 
                        : 'text-gray-400 dark:text-gray-500'
                    }`}>
                      {achievement.description}
                    </p>
                    
                    {achievement.earned ? (
                      <p className="text-xs text-green-600 dark:text-green-400 mt-1">
                        Earned on {new Date(achievement.date!).toLocaleDateString()}
                      </p>
                    ) : achievement.progress !== undefined ? (
                      <div className="mt-2">
                        <div className="flex justify-between text-xs text-gray-600 dark:text-gray-400 mb-1">
                          <span>Progress</span>
                          <span>{achievement.progress}/{achievement.target}</span>
                        </div>
                        <div className="w-full h-2 bg-gray-200 dark:bg-gray-600 rounded-full">
                          <div 
                            className="h-full bg-orange-500 rounded-full"
                            style={{ width: `${(achievement.progress! / achievement.target!) * 100}%` }}
                          />
                        </div>
                      </div>
                    ) : null}
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        </Card>
      </motion.div>

      {/* Settings */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4 }}
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
                    Interface language
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

      {/* Logout */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5 }}
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
