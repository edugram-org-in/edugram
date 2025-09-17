  import { motion } from 'framer-motion';
  import { BookOpen, Gamepad2, Trophy, User, ArrowRight, Sparkles } from 'lucide-react';
  import { useNavigate } from 'react-router';
  import Card from '@/react-app/components/Card';
  import { useLanguage } from '@/react-app/hooks/useLanguage';
  
  interface ChildHomeProps {
    userData: any;
  }
  
  export default function ChildHome({ userData }: ChildHomeProps) {
    const navigate = useNavigate();
    const { t } = useLanguage();
  
    const menuCards = [
      {
        id: 'learn',
        title: t('learn'),
        description: 'Stories, lessons & fun activities',
        icon: BookOpen,
        color: 'from-blue-400 to-blue-600',
        bgColor: 'bg-blue-100 dark:bg-blue-900/30',
        path: '/child/learn',
        emoji: '📚'
      },
      {
        id: 'games',
        title: t('games'),
        description: 'Educational games & quizzes',
        icon: Gamepad2,
        color: 'from-green-400 to-green-600',
        bgColor: 'bg-green-100 dark:bg-green-900/30',
        path: '/child/games',
        emoji: '🎮'
      },
      {
        id: 'achievements',
        title: t('achievements'),
        description: 'Your progress & rewards',
        icon: Trophy,
        color: 'from-yellow-400 to-yellow-600',
        bgColor: 'bg-yellow-100 dark:bg-yellow-900/30',
        path: '/child/progress',
        emoji: '🏆'
      },
      {
        id: 'profile',
        title: t('profile'),
        description: 'Settings & avatar',
        icon: User,
        color: 'from-purple-400 to-purple-600',
        bgColor: 'bg-purple-100 dark:bg-purple-900/30',
        path: '/child/profile',
        emoji: '👤'
      }
    ];
  
    const recentActivities = [
      { title: 'Numbers Game', type: 'game', progress: 85, emoji: '🔢' },
      { title: 'Animal Stories', type: 'story', progress: 60, emoji: '🦁' },
      { title: 'Shape Quiz', type: 'quiz', progress: 100, emoji: '⭐' },
    ];
  
    return (
      <div className="p-6 space-y-8">
        {/* Welcome Section */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-center"
        >
          <motion.div
            animate={{ 
              rotate: [0, 10, -10, 0],
              scale: [1, 1.1, 1]
            }}
            transition={{ 
              duration: 2, 
              repeat: Infinity, 
              repeatDelay: 3 
            }}
            className="text-6xl mb-4"
          >
            👋
          </motion.div>
          <h1 className="text-3xl font-bold text-gray-800 dark:text-white mb-2">
            Welcome back, {userData.name}!
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Ready to learn something new today?
          </p>
        </motion.div>
  
        {/* Quick Stats */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
        >
          <Card className="p-4 mb-6" gradient>
            <div className="flex justify-between items-center">
              <div className="text-center flex-1">
                <div className="text-2xl font-bold text-orange-500">{userData.total_stars || 0}</div>
                <div className="text-sm text-gray-600 dark:text-gray-400">{t('stars')}</div>
              </div>
              <div className="text-center flex-1">
                <div className="text-2xl font-bold text-orange-500">{userData.total_coins || 0}</div>
                <div className="text-sm text-gray-600 dark:text-gray-400">{t('coins')}</div>
              </div>
              <div className="text-center flex-1">
                <div className="text-2xl font-bold text-orange-500">{userData.total_badges || 0}</div>
                <div className="text-sm text-gray-600 dark:text-gray-400">{t('badges')}</div>
              </div>
            </div>
          </Card>
        </motion.div>
  
        {/* Main Menu Grid */}
        <div className="grid grid-cols-2 gap-4">
          {menuCards.map((card, index) => {
            return (
              <motion.div
                key={card.id}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.2 + index * 0.1 }}
              >
                <Card
                  onClick={() => navigate(card.path)}
                  className="p-6 h-full"
                  hover={true}
                >
                  <div className="text-center space-y-4">
                    {/* Icon with animated background */}
                    <motion.div
                      whileHover={{ rotate: [0, -10, 10, 0] }}
                      transition={{ duration: 0.5 }}
                      className={`w-16 h-16 ${card.bgColor} rounded-2xl flex items-center justify-center mx-auto relative overflow-hidden`}
                    >
                      <div className="text-3xl relative z-10">{card.emoji}</div>
                      <motion.div
                        animate={{ 
                          scale: [1, 1.2, 1],
                          opacity: [0.5, 0.8, 0.5]
                        }}
                        transition={{ 
                          duration: 2, 
                          repeat: Infinity,
                          repeatDelay: 1
                        }}
                        className={`absolute inset-0 bg-gradient-to-r ${card.color} opacity-20`}
                      />
                    </motion.div>
  
                    {/* Title and Description */}
                    <div>
                      <h3 className="text-lg font-bold text-gray-800 dark:text-white mb-1">
                        {card.title}
                      </h3>
                      <p className="text-sm text-gray-600 dark:text-gray-400">
                        {card.description}
                      </p>
                    </div>
                  </div>
                </Card>
              </motion.div>
            );
          })}
        </div>
  
        {/* Recent Activities */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
          className="space-y-4"
        >
          <div className="flex items-center gap-2">
            <Sparkles className="w-5 h-5 text-orange-500" />
            <h2 className="text-xl font-bold text-gray-800 dark:text-white">
              Continue Learning
            </h2>
          </div>
  
          <div className="space-y-3">
            {recentActivities.map((activity, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.7 + index * 0.1 }}
              >
                <Card 
                  className="p-4 cursor-pointer"
                  onClick={() => navigate('/child/learn')}
                  hover
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="text-2xl">{activity.emoji}</div>
                      <div>
                        <h4 className="font-semibold text-gray-800 dark:text-white">
                          {activity.title}
                        </h4>
                        <p className="text-sm text-gray-600 dark:text-gray-400 capitalize">
                          {activity.type}
                        </p>
                      </div>
                    </div>
                    
                    <div className="flex items-center gap-3">
                      {/* Progress bar */}
                      <div className="flex items-center gap-2">
                        <div className="w-16 h-2 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
                          <motion.div 
                            className="h-full bg-gradient-to-r from-orange-400 to-orange-600 rounded-full"
                            initial={{ width: 0 }}
                            animate={{ width: `${activity.progress}%` }}
                            transition={{ delay: 1 + index * 0.1, duration: 0.8 }}
                          />
                        </div>
                        <span className="text-sm font-medium text-gray-600 dark:text-gray-400">
                          {activity.progress}%
                        </span>
                      </div>
                      
                      <ArrowRight className="w-4 h-4 text-gray-400" />
                    </div>
                  </div>
                </Card>
              </motion.div>
            ))}
          </div>
        </motion.div>
      </div>
    );
  }
