import { motion } from 'framer-motion';
import { Trophy, Star, Coins, Award, TrendingUp, Target } from 'lucide-react';
import Card from '@/react-app/components/Card';
import { useLanguage } from '@/react-app/hooks/useLanguage';

const achievements = [
  {
    id: 1,
    title: 'First Steps',
    description: 'Complete your first lesson',
    icon: '🎯',
    earned: true,
    earnedDate: '2024-01-15',
    category: 'milestone'
  },
  {
    id: 2,
    title: 'Story Explorer',
    description: 'Read 5 complete stories',
    icon: '📚',
    earned: true,
    earnedDate: '2024-01-18',
    category: 'reading'
  },
  {
    id: 3,
    title: 'Math Wizard',
    description: 'Score 100% in a math game',
    icon: '🧙‍♂️',
    earned: true,
    earnedDate: '2024-01-20',
    category: 'math'
  },
  {
    id: 4,
    title: 'Speed Runner',
    description: 'Complete 3 lessons in one day',
    icon: '⚡',
    earned: false,
    progress: 2,
    maxProgress: 3,
    category: 'milestone'
  },
  {
    id: 5,
    title: 'Perfect Score',
    description: 'Get 100% in 5 different games',
    icon: '💯',
    earned: false,
    progress: 1,
    maxProgress: 5,
    category: 'games'
  },
  {
    id: 6,
    title: 'Daily Learner',
    description: 'Learn for 7 days in a row',
    icon: '📅',
    earned: false,
    progress: 3,
    maxProgress: 7,
    category: 'consistency'
  }
];

const weeklyProgress = [
  { day: 'Mon', lessons: 2, games: 1 },
  { day: 'Tue', lessons: 1, games: 3 },
  { day: 'Wed', lessons: 3, games: 2 },
  { day: 'Thu', lessons: 0, games: 0 },
  { day: 'Fri', lessons: 2, games: 1 },
  { day: 'Sat', lessons: 1, games: 2 },
  { day: 'Sun', lessons: 1, games: 1 }
];

export default function ChildProgress() {
  const { t } = useLanguage();

  const totalStars = achievements.filter(a => a.earned).length * 3 + 25; // Base stars from lessons
  const totalCoins = 145;
  const totalBadges = achievements.filter(a => a.earned).length;

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className="text-center"
      >
        <motion.div
          animate={{ 
            rotate: [0, 10, -10, 0],
            scale: [1, 1.2, 1]
          }}
          transition={{ 
            duration: 2, 
            repeat: Infinity, 
            repeatDelay: 1 
          }}
          className="text-6xl mb-4"
        >
          🏆
        </motion.div>
        <h1 className="text-3xl font-bold text-gray-800 dark:text-white mb-2">
          {t('achievements')}
        </h1>
        <p className="text-gray-600 dark:text-gray-400">
          Your amazing progress and rewards!
        </p>
      </motion.div>

      {/* Stats Overview */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
      >
        <Card className="p-6" gradient>
          <div className="grid grid-cols-3 gap-4">
            <motion.div 
              className="text-center"
              whileHover={{ scale: 1.05 }}
            >
              <motion.div
                animate={{ rotate: [0, 360] }}
                transition={{ duration: 3, repeat: Infinity, ease: "linear" }}
                className="w-16 h-16 bg-yellow-100 dark:bg-yellow-900/30 rounded-full flex items-center justify-center mx-auto mb-2"
              >
                <Star className="w-8 h-8 text-yellow-500 fill-yellow-500" />
              </motion.div>
              <div className="text-2xl font-bold text-gray-800 dark:text-white">{totalStars}</div>
              <div className="text-sm text-gray-600 dark:text-gray-400">{t('stars')}</div>
            </motion.div>

            <motion.div 
              className="text-center"
              whileHover={{ scale: 1.05 }}
            >
              <motion.div
                animate={{ 
                  rotate: [0, 10, -10, 0],
                  scale: [1, 1.1, 1]
                }}
                transition={{ duration: 2, repeat: Infinity }}
                className="w-16 h-16 bg-orange-100 dark:bg-orange-900/30 rounded-full flex items-center justify-center mx-auto mb-2"
              >
                <Coins className="w-8 h-8 text-orange-500" />
              </motion.div>
              <div className="text-2xl font-bold text-gray-800 dark:text-white">{totalCoins}</div>
              <div className="text-sm text-gray-600 dark:text-gray-400">{t('coins')}</div>
            </motion.div>

            <motion.div 
              className="text-center"
              whileHover={{ scale: 1.05 }}
            >
              <motion.div
                animate={{ 
                  y: [0, -5, 0],
                }}
                transition={{ duration: 1.5, repeat: Infinity }}
                className="w-16 h-16 bg-purple-100 dark:bg-purple-900/30 rounded-full flex items-center justify-center mx-auto mb-2"
              >
                <Award className="w-8 h-8 text-purple-500" />
              </motion.div>
              <div className="text-2xl font-bold text-gray-800 dark:text-white">{totalBadges}</div>
              <div className="text-sm text-gray-600 dark:text-gray-400">{t('badges')}</div>
            </motion.div>
          </div>
        </Card>
      </motion.div>

      {/* Weekly Progress */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
      >
        <Card className="p-6">
          <div className="flex items-center gap-3 mb-4">
            <TrendingUp className="w-6 h-6 text-orange-500" />
            <h2 className="text-xl font-bold text-gray-800 dark:text-white">
              This Week's Activity
            </h2>
          </div>
          
          <div className="grid grid-cols-7 gap-2">
            {weeklyProgress.map((day, index) => (
              <motion.div
                key={day.day}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.3 + index * 0.1 }}
                className="text-center"
              >
                <div className="text-sm font-medium text-gray-600 dark:text-gray-400 mb-2">
                  {day.day}
                </div>
                
                {/* Activity bars */}
                <div className="space-y-1">
                  {/* Lessons bar */}
                  <motion.div 
                    className="bg-blue-200 dark:bg-blue-800 rounded"
                    style={{ height: `${Math.max(4, day.lessons * 8)}px` }}
                    initial={{ height: 0 }}
                    animate={{ height: `${Math.max(4, day.lessons * 8)}px` }}
                    transition={{ delay: 0.5 + index * 0.1 }}
                  />
                  
                  {/* Games bar */}
                  <motion.div 
                    className="bg-green-200 dark:bg-green-800 rounded"
                    style={{ height: `${Math.max(4, day.games * 8)}px` }}
                    initial={{ height: 0 }}
                    animate={{ height: `${Math.max(4, day.games * 8)}px` }}
                    transition={{ delay: 0.6 + index * 0.1 }}
                  />
                </div>
                
                <div className="text-xs text-gray-500 mt-2">
                  {day.lessons + day.games > 0 ? `${day.lessons + day.games}` : ''}
                </div>
              </motion.div>
            ))}
          </div>
          
          <div className="flex items-center justify-center gap-6 mt-4 pt-4 border-t border-gray-200 dark:border-gray-700">
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 bg-blue-200 dark:bg-blue-800 rounded"></div>
              <span className="text-sm text-gray-600 dark:text-gray-400">Lessons</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 bg-green-200 dark:bg-green-800 rounded"></div>
              <span className="text-sm text-gray-600 dark:text-gray-400">Games</span>
            </div>
          </div>
        </Card>
      </motion.div>

      {/* Achievements Grid */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3 }}
      >
        <div className="flex items-center gap-3 mb-4">
          <Trophy className="w-6 h-6 text-orange-500" />
          <h2 className="text-xl font-bold text-gray-800 dark:text-white">
            Achievements
          </h2>
        </div>

        <div className="grid md:grid-cols-2 gap-4">
          {achievements.map((achievement, index) => (
            <motion.div
              key={achievement.id}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.4 + index * 0.1 }}
              whileHover={{ y: -2 }}
            >
              <Card 
                className={`p-5 ${
                  achievement.earned 
                    ? 'bg-gradient-to-r from-orange-50 to-yellow-50 dark:from-orange-900/20 dark:to-yellow-900/20 border-orange-200 dark:border-orange-700' 
                    : 'bg-gray-50 dark:bg-gray-800 border-gray-200 dark:border-gray-700'
                }`}
              >
                <div className="flex items-start gap-4">
                  {/* Achievement Icon */}
                  <motion.div
                    animate={achievement.earned ? { 
                      rotate: [0, 10, -10, 0],
                      scale: [1, 1.1, 1]
                    } : {}}
                    transition={{ duration: 2, repeat: Infinity, repeatDelay: 3 }}
                    className={`text-4xl ${achievement.earned ? '' : 'grayscale opacity-50'}`}
                  >
                    {achievement.icon}
                  </motion.div>

                  <div className="flex-1">
                    <h4 className={`font-bold mb-1 ${
                      achievement.earned 
                        ? 'text-gray-800 dark:text-white' 
                        : 'text-gray-500 dark:text-gray-400'
                    }`}>
                      {achievement.title}
                    </h4>
                    <p className={`text-sm mb-3 ${
                      achievement.earned 
                        ? 'text-gray-600 dark:text-gray-300' 
                        : 'text-gray-400 dark:text-gray-500'
                    }`}>
                      {achievement.description}
                    </p>

                    {achievement.earned ? (
                      <div className="flex items-center gap-2">
                        <div className="flex items-center gap-1 text-green-600 dark:text-green-400">
                          <Award className="w-4 h-4" />
                          <span className="text-sm font-medium">Completed</span>
                        </div>
                        <span className="text-xs text-gray-500 dark:text-gray-400">
                          {new Date(achievement.earnedDate!).toLocaleDateString()}
                        </span>
                      </div>
                    ) : achievement.progress !== undefined ? (
                      <div className="space-y-2">
                        <div className="flex items-center justify-between text-sm">
                          <span className="text-gray-600 dark:text-gray-400">Progress</span>
                          <span className="font-medium text-gray-700 dark:text-gray-300">
                            {achievement.progress}/{achievement.maxProgress}
                          </span>
                        </div>
                        <div className="w-full h-2 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
                          <motion.div 
                            className="h-full bg-gradient-to-r from-orange-400 to-orange-600 rounded-full"
                            initial={{ width: 0 }}
                            animate={{ 
                              width: `${((achievement.progress || 0) / (achievement.maxProgress || 1)) * 100}%` 
                            }}
                            transition={{ delay: 0.5 + index * 0.1, duration: 0.8 }}
                          />
                        </div>
                      </div>
                    ) : (
                      <div className="flex items-center gap-1 text-gray-500 dark:text-gray-400">
                        <Target className="w-4 h-4" />
                        <span className="text-sm">Locked</span>
                      </div>
                    )}
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
