import { motion } from 'framer-motion';
import { BookOpen, Users, TrendingUp, Calendar, Plus, Eye, Edit } from 'lucide-react';
import { useNavigate } from 'react-router';
import Card from '@/react-app/components/Card';
import Button from '@/react-app/components/Button';
import { useEffect, useState } from 'react';

interface TeacherHomeProps {
  userData: any;
}

export default function TeacherHome({ userData }: TeacherHomeProps) {
  const navigate = useNavigate();
  const [courses, setCourses] = useState<any[]>([]);
  const [stats, setStats] = useState({
    totalCourses: 0,
    totalStudents: 0,
    activeLessons: 0,
    completionRate: 0
  });

  useEffect(() => {
    // Fetch teacher's courses
    fetch('/api/courses')
      .then(res => res.json())
      .then(data => {
        setCourses(data);
        setStats(prev => ({
          ...prev,
          totalCourses: data.length,
          activeLessons: data.filter((c: any) => c.is_published).length
        }));
      })
      .catch(console.error);
  }, []);

  const recentActivity = [
    { 
      type: 'course_created', 
      title: 'New course "Basic Math" created', 
      time: '2 hours ago',
      icon: '📚'
    },
    { 
      type: 'student_progress', 
      title: '5 students completed "Animal Stories"', 
      time: '4 hours ago',
      icon: '🎉'
    },
    { 
      type: 'course_published', 
      title: 'Course "Colors & Shapes" published', 
      time: '1 day ago',
      icon: '✅'
    }
  ];

  const quickActions = [
    {
      title: 'Create Course',
      description: 'Start building a new course',
      icon: Plus,
      color: 'from-blue-400 to-blue-600',
      bgColor: 'bg-blue-100 dark:bg-blue-900/30',
      action: () => navigate('/teacher/courses'),
      emoji: '➕'
    },
    {
      title: 'View Analytics',
      description: 'Check student progress',
      icon: TrendingUp,
      color: 'from-green-400 to-green-600',
      bgColor: 'bg-green-100 dark:bg-green-900/30',
      action: () => navigate('/teacher/analytics'),
      emoji: '📊'
    },
    {
      title: 'My Courses',
      description: 'Manage existing courses',
      icon: BookOpen,
      color: 'from-purple-400 to-purple-600',
      bgColor: 'bg-purple-100 dark:bg-purple-900/30',
      action: () => navigate('/teacher/courses'),
      emoji: '📖'
    }
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
          👨‍🏫
        </motion.div>
        <h1 className="text-3xl font-bold text-gray-800 dark:text-white mb-2">
          Welcome back, {userData.name}!
        </h1>
        <p className="text-gray-600 dark:text-gray-400">
          Ready to inspire young minds today?
        </p>
      </motion.div>

      {/* Stats Overview */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
        className="grid grid-cols-2 md:grid-cols-4 gap-4"
      >
        {[
          { label: 'Total Courses', value: stats.totalCourses, icon: BookOpen, color: 'text-blue-500' },
          { label: 'Students', value: stats.totalStudents, icon: Users, color: 'text-green-500' },
          { label: 'Active Lessons', value: stats.activeLessons, icon: Calendar, color: 'text-purple-500' },
          { label: 'Completion Rate', value: `${stats.completionRate}%`, icon: TrendingUp, color: 'text-orange-500' }
        ].map((stat, index) => {
          const Icon = stat.icon;
          return (
            <motion.div
              key={stat.label}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 + index * 0.1 }}
            >
              <Card className="p-4 text-center">
                <Icon className={`w-8 h-8 ${stat.color} mx-auto mb-2`} />
                <div className="text-2xl font-bold text-gray-800 dark:text-white">
                  {stat.value}
                </div>
                <div className="text-sm text-gray-600 dark:text-gray-400">
                  {stat.label}
                </div>
              </Card>
            </motion.div>
          );
        })}
      </motion.div>

      {/* Quick Actions */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3 }}
      >
        <h2 className="text-2xl font-bold text-gray-800 dark:text-white mb-6">
          Quick Actions
        </h2>
        
        <div className="grid md:grid-cols-3 gap-4">
          {quickActions.map((action, index) => {
            return (
              <motion.div
                key={action.title}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.4 + index * 0.1 }}
              >
                <Card
                  onClick={action.action}
                  className="p-6 h-full cursor-pointer"
                  hover
                >
                  <div className="text-center space-y-4">
                    <motion.div
                      whileHover={{ rotate: [0, -10, 10, 0] }}
                      transition={{ duration: 0.5 }}
                      className={`w-16 h-16 ${action.bgColor} rounded-2xl flex items-center justify-center mx-auto`}
                    >
                      <div className="text-3xl">{action.emoji}</div>
                    </motion.div>
                    
                    <div>
                      <h3 className="text-lg font-bold text-gray-800 dark:text-white mb-1">
                        {action.title}
                      </h3>
                      <p className="text-sm text-gray-600 dark:text-gray-400">
                        {action.description}
                      </p>
                    </div>
                  </div>
                </Card>
              </motion.div>
            );
          })}
        </div>
      </motion.div>

      {/* Recent Courses */}
      {courses.length > 0 && (
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
        >
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-2xl font-bold text-gray-800 dark:text-white">
              Recent Courses
            </h2>
            <Button
              variant="ghost"
              onClick={() => navigate('/teacher/courses')}
            >
              View All
            </Button>
          </div>

          <div className="space-y-4">
            {courses.slice(0, 3).map((course, index) => (
              <motion.div
                key={course.id}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.6 + index * 0.1 }}
              >
                <Card className="p-4 hover:shadow-lg transition-all" hover>
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-4">
                      <div className="w-12 h-12 bg-gradient-to-r from-orange-400 to-pink-400 rounded-xl flex items-center justify-center text-white font-bold">
                        {course.title?.charAt(0)?.toUpperCase() || 'C'}
                      </div>
                      <div>
                        <h4 className="font-bold text-gray-800 dark:text-white">
                          {course.title}
                        </h4>
                        <p className="text-sm text-gray-600 dark:text-gray-400">
                          {course.is_published ? 'Published' : 'Draft'} • {course.language}
                        </p>
                      </div>
                    </div>

                    <div className="flex items-center gap-2">
                      <motion.button
                        whileHover={{ scale: 1.1 }}
                        whileTap={{ scale: 0.9 }}
                        className="p-2 text-gray-500 hover:text-orange-500 rounded-lg hover:bg-orange-50 dark:hover:bg-orange-900/20"
                      >
                        <Eye className="w-4 h-4" />
                      </motion.button>
                      <motion.button
                        whileHover={{ scale: 1.1 }}
                        whileTap={{ scale: 0.9 }}
                        className="p-2 text-gray-500 hover:text-orange-500 rounded-lg hover:bg-orange-50 dark:hover:bg-orange-900/20"
                      >
                        <Edit className="w-4 h-4" />
                      </motion.button>
                    </div>
                  </div>
                </Card>
              </motion.div>
            ))}
          </div>
        </motion.div>
      )}

      {/* Recent Activity */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.7 }}
      >
        <h2 className="text-2xl font-bold text-gray-800 dark:text-white mb-6">
          Recent Activity
        </h2>

        <div className="space-y-3">
          {recentActivity.map((activity, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.8 + index * 0.1 }}
            >
              <Card className="p-4">
                <div className="flex items-center gap-3">
                  <div className="text-2xl">{activity.icon}</div>
                  <div className="flex-1">
                    <p className="font-medium text-gray-800 dark:text-white">
                      {activity.title}
                    </p>
                    <p className="text-sm text-gray-600 dark:text-gray-400">
                      {activity.time}
                    </p>
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
