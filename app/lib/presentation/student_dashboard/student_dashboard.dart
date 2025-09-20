import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import for GoogleFonts

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/class_filter_chips_widget.dart';
import './widgets/daily_challenge_card_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/quiz_result_card_widget.dart';
import './widgets/subject_card_widget.dart';
import './widgets/trending_quiz_card_widget.dart';
import 'widgets/class_filter_chips_widget.dart';
import 'widgets/daily_challenge_card_widget.dart';
import 'widgets/dashboard_header_widget.dart';
import 'widgets/quiz_result_card_widget.dart';
import 'widgets/subject_card_widget.dart';
import 'widgets/trending_quiz_card_widget.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with TickerProviderStateMixin {
  late AnimationController _refreshAnimationController;
  late Animation<double> _refreshRotationAnimation;

  bool _isRefreshing = false;
  bool _showClassFilter = false;
  int _selectedClass = 10;
  int _currentBottomNavIndex = 0;

  // Mock data
  final List<Map<String, dynamic>> _subjectData = [
    {
      "name": "Mathematics",
      "description": "Algebra, Geometry, and Calculus fundamentals",
      "progress": 0.75,
      "totalQuizzes": 24,
      "completedQuizzes": 18,
      "isLocked": false,
    },
    {
      "name": "Science",
      "description": "Physics, Chemistry, and Biology concepts",
      "progress": 0.60,
      "totalQuizzes": 20,
      "completedQuizzes": 12,
      "isLocked": false,
    },
    {
      "name": "Technology",
      "description": "Computer Science and Programming basics",
      "progress": 0.45,
      "totalQuizzes": 16,
      "completedQuizzes": 7,
      "isLocked": false,
    },
    {
      "name": "Engineering",
      "description": "Mechanical and Electrical Engineering principles",
      "progress": 0.0,
      "totalQuizzes": 18,
      "completedQuizzes": 0,
      "isLocked": true,
    },
  ];

  final List<Map<String, dynamic>> _recentQuizResults = [
    {
      "title": "Quadratic Equations Quiz",
      "subject": "Mathematics",
      "score": 8,
      "totalQuestions": 10,
      "xpGained": 80,
      "coinsGained": 15,
      "completedAt": DateTime.now().subtract(const Duration(hours: 2)),
      "difficulty": "Medium",
    },
    {
      "title": "Chemical Bonding Test",
      "subject": "Science",
      "score": 9,
      "totalQuestions": 10,
      "xpGained": 95,
      "coinsGained": 20,
      "completedAt": DateTime.now().subtract(const Duration(days: 1)),
      "difficulty": "Hard",
    },
    {
      "title": "Basic Programming Logic",
      "subject": "Technology",
      "score": 7,
      "totalQuestions": 10,
      "xpGained": 70,
      "coinsGained": 12,
      "completedAt": DateTime.now().subtract(const Duration(days: 2)),
      "difficulty": "Easy",
    },
  ];

  final List<Map<String, dynamic>> _trendingQuizzes = [
    {
      "title": "Advanced Calculus Challenge",
      "subject": "Mathematics",
      "difficulty": "Hard",
      "questions": 15,
      "participants": 1247,
      "rating": 4.8,
      "duration": 25,
      "imageUrl":
          "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "title": "Organic Chemistry Mastery",
      "subject": "Science",
      "difficulty": "Medium",
      "questions": 20,
      "participants": 892,
      "rating": 4.6,
      "duration": 30,
      "imageUrl":
          "https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "title": "Python Programming Basics",
      "subject": "Technology",
      "difficulty": "Easy",
      "questions": 12,
      "participants": 2156,
      "rating": 4.9,
      "duration": 20,
      "imageUrl":
          "https://images.unsplash.com/photo-1515879218367-8466d910aaa4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  final Map<String, dynamic> _dailyChallengeData = {
    "title": "Trigonometry Master Challenge",
    "description":
        "Solve complex trigonometric equations and prove your mastery!",
    "subject": "Mathematics",
    "xpReward": 100,
    "coinReward": 25,
    "progress": 0.3,
    "isCompleted": false,
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _refreshRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _refreshAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    _refreshAnimationController.repeat();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isRefreshing = false);
    _refreshAnimationController.stop();
    _refreshAnimationController.reset();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dashboard updated successfully!'),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
        ),
      );
    }
  }

  void _toggleClassFilter() {
    setState(() {
      _showClassFilter = !_showClassFilter;
    });
  }

  void _onClassSelected(int classNumber) {
    setState(() {
      _selectedClass = classNumber;
      _showClassFilter = false;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/quiz-interface');
        break;
      case 2:
        Navigator.pushNamed(context, '/leaderboard');
        break;
      case 3:
        Navigator.pushNamed(context, '/student-profile');
        break;
    }
  }

  void _startLearning() {
    Navigator.pushNamed(context, '/quiz-interface');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header with greeting and stats
            DashboardHeaderWidget(
              studentName: "Bhavya Kumar",
              currentStreak: 12,
              heartsCount: 4,
              maxHearts: 5,
              heartRegenTime: const Duration(minutes: 12, seconds: 45),
            ),

            // Class filter chips (animated)
            ClassFilterChipsWidget(
              selectedClass: _selectedClass,
              onClassSelected: _onClassSelected,
              isVisible: _showClassFilter,
            ),

            // Main scrollable content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.primaryLight,
                backgroundColor: colorScheme.surface,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),

                      // Filter button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Row(
                          children: [
                            Text(
                              'Class $_selectedClass Content',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _toggleClassFilter,
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: _showClassFilter
                                      ? AppTheme.primaryLight
                                      : colorScheme.surface,
                                  borderRadius: BorderRadius.circular(2.w),
                                  border: Border.all(
                                    color: AppTheme.primaryLight
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: AnimatedBuilder(
                                  animation: _refreshRotationAnimation,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _isRefreshing
                                          ? _refreshRotationAnimation.value *
                                              2 *
                                              3.14159
                                          : 0,
                                      child: CustomIconWidget(
                                        iconName: 'tune',
                                        color: _showClassFilter
                                            ? Colors.white
                                            : AppTheme.primaryLight,
                                        size: 5.w,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Daily Challenge Card
                      DailyChallengeCardWidget(
                        challengeData: _dailyChallengeData,
                        onTap: () =>
                            Navigator.pushNamed(context, '/quiz-interface'),
                      ),

                      SizedBox(height: 3.h),

                      // Subject Categories
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          'STEM Subjects',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      SizedBox(height: 1.5.h),

                      SizedBox(
                        height: 35.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(left: 4.w),
                          itemCount: _subjectData.length,
                          itemBuilder: (context, index) {
                            return SubjectCardWidget(
                              subjectData: _subjectData[index],
                              onTap: () => Navigator.pushNamed(
                                  context, '/quiz-interface'),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Recent Quiz Results
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Row(
                          children: [
                            Text(
                              'Recent Results',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, '/student-profile'),
                              child: Text(
                                'View All',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.primaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 1.h),

                      ...(_recentQuizResults
                          .take(2)
                          .map((result) => QuizResultCardWidget(
                                quizResult: result,
                                onTap: () => Navigator.pushNamed(
                                    context, '/quiz-interface'),
                              ))
                          .toList()),

                      SizedBox(height: 3.h),

                      // Trending Quizzes
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          'Trending Quizzes',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),

                      SizedBox(height: 1.5.h),

                      SizedBox(
                        height: 35.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(left: 4.w),
                          itemCount: _trendingQuizzes.length,
                          itemBuilder: (context, index) {
                            return TrendingQuizCardWidget(
                              quizData: _trendingQuizzes[index],
                              onTap: () => Navigator.pushNamed(
                                  context, '/quiz-interface'),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 10.h), // Bottom padding for FAB
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startLearning,
        backgroundColor: AppTheme.primaryLight,
        foregroundColor: Colors.white,
        elevation: 8.0,
        icon: CustomIconWidget(
          iconName: 'play_arrow',
          color: Colors.white,
          size: 6.w,
        ),
        label: Text(
          'Start Learning',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: AppTheme.primaryLight,
        unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
        elevation: 8.0,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            activeIcon: Icon(Icons.quiz),
            label: 'Quizzes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined),
            activeIcon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}