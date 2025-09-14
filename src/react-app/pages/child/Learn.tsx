import { motion } from 'framer-motion';
import { Book, Play, Clock, Star } from 'lucide-react';
import Card from '@/react-app/components/Card';
import StarRating from '@/react-app/components/StarRating';
import { useLanguage } from '@/react-app/hooks/useLanguage';

const categories = [
  {
    id: 'stories',
    title: 'Stories',
    emoji: '📚',
    color: 'from-blue-400 to-blue-600',
    bgColor: 'bg-blue-100 dark:bg-blue-900/30',
    lessons: [
      {
        id: 1,
        title: 'The Brave Little Lion',
        type: 'story',
        duration: '5 min',
        difficulty: 1,
        rating: 4,
        completed: true,
        emoji: '🦁'
      },
      {
        id: 2,
        title: 'Magic Forest Adventure',
        type: 'story',
        duration: '7 min',
        difficulty: 2,
        rating: 5,
        completed: false,
        emoji: '🌳'
      },
      {
        id: 3,
        title: 'The Friendly Dragon',
        type: 'story',
        duration: '6 min',
        difficulty: 1,
        rating: 4,
        completed: false,
        emoji: '🐉'
      }
    ]
  },
  {
    id: 'numbers',
    title: 'Numbers',
    emoji: '🔢',
    color: 'from-green-400 to-green-600',
    bgColor: 'bg-green-100 dark:bg-green-900/30',
    lessons: [
      {
        id: 4,
        title: 'Counting 1 to 10',
        type: 'lesson',
        duration: '4 min',
        difficulty: 1,
        rating: 5,
        completed: true,
        emoji: '1️⃣'
      },
      {
        id: 5,
        title: 'Simple Addition',
        type: 'lesson',
        duration: '8 min',
        difficulty: 2,
        rating: 4,
        completed: false,
        emoji: '➕'
      }
    ]
  },
  {
    id: 'animals',
    title: 'Animals',
    emoji: '🦄',
    color: 'from-purple-400 to-purple-600',
    bgColor: 'bg-purple-100 dark:bg-purple-900/30',
    lessons: [
      {
        id: 6,
        title: 'Farm Animals',
        type: 'lesson',
        duration: '5 min',
        difficulty: 1,
        rating: 5,
        completed: true,
        emoji: '🐄'
      },
      {
        id: 7,
        title: 'Wild Animals',
        type: 'lesson',
        duration: '6 min',
        difficulty: 2,
        rating: 4,
        completed: false,
        emoji: '🦒'
      }
    ]
  },
  {
    id: 'shapes',
    title: 'Shapes',
    emoji: '🔴',
    color: 'from-red-400 to-red-600',
    bgColor: 'bg-red-100 dark:bg-red-900/30',
    lessons: [
      {
        id: 8,
        title: 'Basic Shapes',
        type: 'lesson',
        duration: '4 min',
        difficulty: 1,
        rating: 5,
        completed: false,
        emoji: '⭐'
      }
    ]
  }
];

export default function ChildLearn() {
  const { t } = useLanguage();

  const handleLessonClick = (lesson: any) => {
    // In a real app, this would navigate to the lesson content
    console.log('Opening lesson:', lesson.title);
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
          {t('learn')}
        </h1>
        <p className="text-gray-600 dark:text-gray-400">
          Choose a topic to start learning!
        </p>
      </motion.div>

      {/* Categories */}
      <div className="space-y-6">
        {categories.map((category, categoryIndex) => (
          <motion.div
            key={category.id}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: categoryIndex * 0.1 }}
          >
            <Card className="p-6">
              {/* Category Header */}
              <div className="flex items-center gap-4 mb-4">
                <motion.div
                  whileHover={{ rotate: [0, -10, 10, 0] }}
                  transition={{ duration: 0.5 }}
                  className={`w-12 h-12 ${category.bgColor} rounded-xl flex items-center justify-center`}
                >
                  <span className="text-2xl">{category.emoji}</span>
                </motion.div>
                <div>
                  <h2 className="text-xl font-bold text-gray-800 dark:text-white">
                    {category.title}
                  </h2>
                  <p className="text-sm text-gray-600 dark:text-gray-400">
                    {category.lessons.length} lessons
                  </p>
                </div>
              </div>

              {/* Lessons Grid */}
              <div className="space-y-3">
                {category.lessons.map((lesson, lessonIndex) => (
                  <motion.div
                    key={lesson.id}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: categoryIndex * 0.1 + lessonIndex * 0.05 }}
                    whileHover={{ x: 5 }}
                    onClick={() => handleLessonClick(lesson)}
                    className="cursor-pointer"
                  >
                    <div className={`p-4 rounded-xl border border-gray-200 dark:border-gray-700 hover:border-orange-300 dark:hover:border-orange-600 transition-all ${
                      lesson.completed 
                        ? 'bg-green-50 dark:bg-green-900/20 border-green-300 dark:border-green-700' 
                        : 'bg-white dark:bg-gray-800 hover:bg-orange-50 dark:hover:bg-orange-900/20'
                    }`}>
                      <div className="flex items-center justify-between">
                        <div className="flex items-center gap-3">
                          {/* Lesson Icon */}
                          <div className="relative">
                            <div className="text-2xl">{lesson.emoji}</div>
                            {lesson.completed && (
                              <motion.div
                                initial={{ scale: 0 }}
                                animate={{ scale: 1 }}
                                className="absolute -top-1 -right-1 w-5 h-5 bg-green-500 rounded-full flex items-center justify-center"
                              >
                                <span className="text-white text-xs">✓</span>
                              </motion.div>
                            )}
                          </div>

                          {/* Lesson Info */}
                          <div>
                            <h4 className="font-semibold text-gray-800 dark:text-white">
                              {lesson.title}
                            </h4>
                            <div className="flex items-center gap-4 mt-1">
                              <div className="flex items-center gap-1 text-sm text-gray-600 dark:text-gray-400">
                                <Clock className="w-4 h-4" />
                                {lesson.duration}
                              </div>
                              <StarRating rating={lesson.rating} size="sm" animate={false} />
                            </div>
                          </div>
                        </div>

                        {/* Action Button */}
                        <motion.div
                          whileHover={{ scale: 1.1 }}
                          whileTap={{ scale: 0.9 }}
                          className={`w-10 h-10 rounded-full flex items-center justify-center ${
                            lesson.completed 
                              ? 'bg-green-500 text-white' 
                              : 'bg-orange-500 text-white hover:bg-orange-600'
                          }`}
                        >
                          {lesson.completed ? (
                            <Star className="w-5 h-5 fill-current" />
                          ) : (
                            <Play className="w-5 h-5 ml-1" />
                          )}
                        </motion.div>
                      </div>

                      {/* Progress Bar for incomplete lessons */}
                      {!lesson.completed && (
                        <div className="mt-3">
                          <div className="w-full h-2 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
                            <motion.div 
                              className="h-full bg-gradient-to-r from-orange-400 to-orange-600 rounded-full"
                              initial={{ width: 0 }}
                              animate={{ width: '0%' }}
                            />
                          </div>
                        </div>
                      )}
                    </div>
                  </motion.div>
                ))}
              </div>
            </Card>
          </motion.div>
        ))}
      </div>

      {/* Floating Action Hint */}
      <motion.div
        initial={{ opacity: 0, scale: 0 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ delay: 1 }}
        className="fixed bottom-24 right-6 z-40"
      >
        <div className="bg-orange-500 text-white p-3 rounded-full shadow-lg">
          <motion.div
            animate={{ 
              rotate: [0, 10, -10, 0],
              scale: [1, 1.1, 1]
            }}
            transition={{ 
              duration: 2, 
              repeat: Infinity 
            }}
          >
            <Book className="w-6 h-6" />
          </motion.div>
        </div>
      </motion.div>
    </div>
  );
}
