import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { Users, TrendingUp, Award, Eye, BookOpen } from 'lucide-react';
import Card from '@/react-app/components/Card';

interface StudentProgress {
  id: string;
  name: string;
  avatar: string;
  coursesCompleted: number;
  totalStars: number;
  lastActive: string;
  streakDays: number;
}

interface CourseAnalytics {
  id: string;
  title: string;
  enrollments: number;
  completionRate: number;
  averageStars: number;
  totalViews: number;
}

export default function TeacherAnalytics() {
  const [loading, setLoading] = useState(true);
  const [timeRange, setTimeRange] = useState('week'); // week, month, all
  const [students] = useState<StudentProgress[]>([
    {
      id: '1',
      name: 'Aarav Kumar',
      avatar: '👦',
      coursesCompleted: 3,
      totalStars: 45,
      lastActive: '2 hours ago',
      streakDays: 7
    },
    {
      id: '2',
      name: 'Priya Sharma',
      avatar: '👧',
      coursesCompleted: 5,
      totalStars: 67,
      lastActive: '1 day ago',
      streakDays: 12
    },
    {
      id: '3',
      name: 'Rohit Singh',
      avatar: '🧒',
      coursesCompleted: 2,
      totalStars: 28,
      lastActive: '3 hours ago',
      streakDays: 4
    }
  ]);

  const [courseStats] = useState<CourseAnalytics[]>([
    {
      id: '1',
      title: 'Animal Stories',
      enrollments: 15,
      completionRate: 78,
      averageStars: 4.2,
      totalViews: 124
    },
    {
      id: '2',
      title: 'Basic Math',
      enrollments: 12,
      completionRate: 65,
      averageStars: 3.8,
      totalViews: 89
    },
    {
      id: '3',
      title: 'Colors & Shapes',
      enrollments: 18,
      completionRate: 85,
      averageStars: 4.5,
      totalViews: 156
    }
  ]);

  useEffect(() => {
    // Simulate loading
    setTimeout(() => setLoading(false), 1000);
  }, []);

  const overallStats = {
    totalStudents: students.length,
    activeStudents: students.filter(s => s.lastActive.includes('hours')).length,
    averageCompletion: Math.round(courseStats.reduce((acc, course) => acc + course.completionRate, 0) / courseStats.length),
    totalViews: courseStats.reduce((acc, course) => acc + course.totalViews, 0)
  };

  if (loading) {
    return (
      <div className="p-6 flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="animate-spin mb-4">
            <div className="w-12 h-12 border-4 border-orange-500 border-t-transparent rounded-full"></div>
          </div>
          <p className="text-gray-600 dark:text-gray-300">Loading analytics...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-800 dark:text-white">
            Analytics
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Track student progress and course performance
          </p>
        </div>

        {/* Time Range Selector */}
        <div className="flex bg-gray-100 dark:bg-gray-700 rounded-lg p-1">
          {[
            { value: 'week', label: 'Week' },
            { value: 'month', label: 'Month' },
            { value: 'all', label: 'All Time' }
          ].map((range) => (
            <button
              key={range.value}
              onClick={() => setTimeRange(range.value)}
              className={`px-3 py-1.5 text-sm font-medium rounded-md transition-all ${
                timeRange === range.value
                  ? 'bg-orange-500 text-white shadow-sm'
                  : 'text-gray-600 dark:text-gray-300 hover:text-orange-500'
              }`}
            >
              {range.label}
            </button>
          ))}
        </div>
      </div>

      {/* Overview Stats */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="grid grid-cols-2 md:grid-cols-4 gap-4"
      >
        {[
          { 
            label: 'Total Students', 
            value: overallStats.totalStudents, 
            icon: Users, 
            color: 'text-blue-500',
            bgColor: 'bg-blue-100 dark:bg-blue-900/30'
          },
          { 
            label: 'Active Today', 
            value: overallStats.activeStudents, 
            icon: TrendingUp, 
            color: 'text-green-500',
            bgColor: 'bg-green-100 dark:bg-green-900/30'
          },
          { 
            label: 'Avg Completion', 
            value: `${overallStats.averageCompletion}%`, 
            icon: Award, 
            color: 'text-purple-500',
            bgColor: 'bg-purple-100 dark:bg-purple-900/30'
          },
          { 
            label: 'Total Views', 
            value: overallStats.totalViews, 
            icon: Eye, 
            color: 'text-orange-500',
            bgColor: 'bg-orange-100 dark:bg-orange-900/30'
          }
        ].map((stat, index) => {
          const Icon = stat.icon;
          return (
            <motion.div
              key={stat.label}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.1 }}
            >
              <Card className="p-4 text-center">
                <div className={`w-12 h-12 ${stat.bgColor} rounded-full flex items-center justify-center mx-auto mb-3`}>
                  <Icon className={`w-6 h-6 ${stat.color}`} />
                </div>
                <div className="text-2xl font-bold text-gray-800 dark:text-white mb-1">
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

      {/* Course Performance */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3 }}
      >
        <div className="flex items-center gap-3 mb-4">
          <BookOpen className="w-6 h-6 text-orange-500" />
          <h2 className="text-xl font-bold text-gray-800 dark:text-white">
            Course Performance
          </h2>
        </div>

        <div className="space-y-4">
          {courseStats.map((course, index) => (
            <motion.div
              key={course.id}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.4 + index * 0.1 }}
            >
              <Card className="p-6">
                <div className="flex items-center justify-between mb-4">
                  <div>
                    <h3 className="text-lg font-bold text-gray-800 dark:text-white">
                      {course.title}
                    </h3>
                    <p className="text-sm text-gray-600 dark:text-gray-400">
                      {course.enrollments} students enrolled
                    </p>
                  </div>
                  <div className="text-right">
                    <div className="text-2xl font-bold text-orange-500">
                      {course.completionRate}%
                    </div>
                    <div className="text-sm text-gray-600 dark:text-gray-400">
                      completion rate
                    </div>
                  </div>
                </div>

                {/* Progress Bar */}
                <div className="mb-4">
                  <div className="w-full h-3 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
                    <motion.div 
                      className="h-full bg-gradient-to-r from-orange-400 to-orange-600 rounded-full"
                      initial={{ width: 0 }}
                      animate={{ width: `${course.completionRate}%` }}
                      transition={{ delay: 0.5 + index * 0.1, duration: 0.8 }}
                    />
                  </div>
                </div>

                {/* Additional Stats */}
                <div className="grid grid-cols-2 gap-4">
                  <div className="flex items-center gap-2">
                    <Award className="w-4 h-4 text-yellow-500" />
                    <span className="text-sm text-gray-600 dark:text-gray-400">
                      {course.averageStars} avg stars
                    </span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Eye className="w-4 h-4 text-blue-500" />
                    <span className="text-sm text-gray-600 dark:text-gray-400">
                      {course.totalViews} views
                    </span>
                  </div>
                </div>
              </Card>
            </motion.div>
          ))}
        </div>
      </motion.div>

      {/* Student Progress */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5 }}
      >
        <div className="flex items-center gap-3 mb-4">
          <Users className="w-6 h-6 text-orange-500" />
          <h2 className="text-xl font-bold text-gray-800 dark:text-white">
            Student Progress
          </h2>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
          {students.map((student, index) => (
            <motion.div
              key={student.id}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.6 + index * 0.1 }}
            >
              <Card className="p-5" hover>
                <div className="flex items-center gap-3 mb-4">
                  <div className="text-3xl">{student.avatar}</div>
                  <div>
                    <h4 className="font-bold text-gray-800 dark:text-white">
                      {student.name}
                    </h4>
                    <p className="text-sm text-gray-600 dark:text-gray-400">
                      {student.lastActive}
                    </p>
                  </div>
                </div>

                <div className="space-y-3">
                  <div className="flex justify-between items-center">
                    <span className="text-sm text-gray-600 dark:text-gray-400">Courses</span>
                    <span className="font-bold text-gray-800 dark:text-white">
                      {student.coursesCompleted}
                    </span>
                  </div>
                  
                  <div className="flex justify-between items-center">
                    <span className="text-sm text-gray-600 dark:text-gray-400">Stars</span>
                    <div className="flex items-center gap-1">
                      <span className="font-bold text-yellow-500">{student.totalStars}</span>
                      <span className="text-yellow-500">⭐</span>
                    </div>
                  </div>
                  
                  <div className="flex justify-between items-center">
                    <span className="text-sm text-gray-600 dark:text-gray-400">Streak</span>
                    <div className="flex items-center gap-1">
                      <span className="font-bold text-orange-500">{student.streakDays}</span>
                      <span className="text-orange-500">🔥</span>
                    </div>
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
