import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/leaderboard_header.dart';
import './widgets/podium_widget.dart';
import './widgets/ranking_card.dart';
import './widgets/user_profile_modal.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard>
    with TickerProviderStateMixin {
  String _selectedClass = 'All';
  String _selectedSubject = 'All';
  String _selectedPeriod = 'Weekly';
  bool _isLoading = false;
  bool _isRefreshing = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final ScrollController _scrollController = ScrollController();

  // Mock data for leaderboard
  final List<Map<String, dynamic>> _leaderboardData = [
    {
      "id": 1,
      "name": "Emma Thompson",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "class": "10",
      "school": "Neha Sharma",
      "totalXP": 2850,
      "streak": 15,
      "weeklyProgress": 420,
      "rank": 1,
      "badges": ["Math Genius", "Streak Master", "Quiz Champion"],
      "quizzesCompleted": 45,
      "achievements": [
        {
          "icon": "emoji_events",
          "title": "Quiz Master",
          "description": "Completed 50 quizzes with 90%+ accuracy"
        },
        {
          "icon": "local_fire_department",
          "title": "Streak Legend",
          "description": "Maintained 15-day learning streak"
        }
      ]
    },
    {
      "id": 2,
      "name": "Bhanu Singh",
      "avatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "class": "11",
      "school": "Tech Academy",
      "totalXP": 2720,
      "streak": 12,
      "weeklyProgress": 380,
      "rank": 2,
      "badges": ["Physics Pro", "Fast Learner"],
      "quizzesCompleted": 38,
      "achievements": [
        {
          "icon": "science",
          "title": "Physics Expert",
          "description": "Scored perfect in 10 physics quizzes"
        }
      ]
    },
    {
      "id": 3,
      "name": "Sana Sen",
      "avatar":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
      "class": "9",
      "school": "Innovation School",
      "totalXP": 2650,
      "streak": 18,
      "weeklyProgress": 350,
      "rank": 3,
      "badges": ["Chemistry Star", "Consistent"],
      "quizzesCompleted": 42,
      "achievements": [
        {
          "icon": "biotech",
          "title": "Chemistry Champion",
          "description": "Mastered all chemistry topics"
        }
      ]
    },
    {
      "id": 4,
      "name": "Nikhil Chaudhary",
      "avatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
      "class": "12",
      "school": "Elite Academy",
      "totalXP": 2580,
      "streak": 8,
      "weeklyProgress": 320,
      "rank": 4,
      "badges": ["Biology Expert"],
      "quizzesCompleted": 35,
      "achievements": []
    },
    {
      "id": 5,
      "name": "Jiya ",
      "avatar":
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face",
      "class": "10",
      "school": "Future School",
      "totalXP": 2450,
      "streak": 22,
      "weeklyProgress": 290,
      "rank": 5,
      "badges": ["Streak King", "Dedicated"],
      "quizzesCompleted": 40,
      "achievements": [
        {
          "icon": "local_fire_department",
          "title": "Streak Master",
          "description": "Longest streak of 22 days"
        }
      ]
    },
    {
      "id": 6,
      "name": "Dhruv Gupta",
      "avatar":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face",
      "class": "11",
      "school": "Science High",
      "totalXP": 2380,
      "streak": 5,
      "weeklyProgress": 280,
      "rank": 6,
      "badges": ["Math Wizard"],
      "quizzesCompleted": 32,
      "achievements": []
    },
    {
      "id": 7,
      "name": "Nikita Sinha",
      "avatar":
          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face",
      "class": "9",
      "school": "Bright Academy",
      "totalXP": 2320,
      "streak": 14,
      "weeklyProgress": 260,
      "rank": 7,
      "badges": ["Rising Star"],
      "quizzesCompleted": 28,
      "achievements": []
    },
    {
      "id": 8,
      "name": "You",
      "avatar":
          "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&h=150&fit=crop&crop=face",
      "class": "10",
      "school": "Your School",
      "totalXP": 2250,
      "streak": 7,
      "weeklyProgress": 240,
      "rank": 8,
      "badges": ["Newcomer"],
      "quizzesCompleted": 25,
      "achievements": [
        {
          "icon": "school",
          "title": "First Steps",
          "description": "Completed your first quiz"
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _scrollToCurrentUser();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentUser() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUserIndex =
          _leaderboardData.indexWhere((user) => user['name'] == 'You');
      if (currentUserIndex != -1 && _scrollController.hasClients) {
        final position =
            (currentUserIndex - 3) * 100.0; // Approximate card height
        _scrollController.animateTo(
          position.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _refreshLeaderboard() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    // Show refresh feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'refresh',
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 2.w),
              const Text('Leaderboard updated!'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _onFilterChanged() {
    setState(() {
      _isLoading = true;
    });

    // Simulate filter loading
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _showUserProfile(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UserProfileModal(
        user: user,
        onChallenge: () {
          Navigator.pop(context);
          _challengeUser(user);
        },
        onAddFriend: () {
          Navigator.pop(context);
          _addFriend(user);
        },
      ),
    );
  }

  void _challengeUser(Map<String, dynamic> user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'sports_esports',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text('Challenge sent to ${user['name']}!'),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _addFriend(Map<String, dynamic> user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'person_add',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text('Friend request sent to ${user['name']}!'),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _challengeFriends() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'group',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text('Challenge Friends'),
          ],
        ),
        content: const Text('Select friends to challenge in a quiz battle!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/quiz-interface');
            },
            child: const Text('Start Challenge'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredData {
    return _leaderboardData.where((user) {
      if (_selectedClass != 'All' && user['class'] != _selectedClass) {
        return false;
      }
      // Note: In a real app, you would filter by subject based on quiz history
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> get _topThree {
    final filtered = _filteredData;
    return filtered.length >= 3 ? filtered.take(3).toList() : filtered;
  }

  List<Map<String, dynamic>> get _remainingUsers {
    final filtered = _filteredData;
    return filtered.length > 3 ? filtered.skip(3).toList() : [];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              LeaderboardHeader(
                selectedClass: _selectedClass,
                selectedSubject: _selectedSubject,
                selectedPeriod: _selectedPeriod,
                onClassChanged: (value) {
                  setState(() {
                    _selectedClass = value;
                  });
                  _onFilterChanged();
                },
                onSubjectChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                  _onFilterChanged();
                },
                onPeriodChanged: (value) {
                  setState(() {
                    _selectedPeriod = value;
                  });
                  _onFilterChanged();
                },
              ),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Loading rankings...',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                            ),
                          ],
                        ),
                      )
                    : _filteredData.isEmpty
                        ? EmptyStateWidget(
                            onStartQuiz: () {
                              Navigator.pushNamed(context, '/quiz-interface');
                            },
                          )
                        : RefreshIndicator(
                            onRefresh: _refreshLeaderboard,
                            color: colorScheme.primary,
                            child: CustomScrollView(
                              controller: _scrollController,
                              slivers: [
                                if (_topThree.isNotEmpty) ...[
                                  SliverToBoxAdapter(
                                    child: PodiumWidget(
                                      topThree: _topThree,
                                      onUserTap: _showUserProfile,
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                        vertical: 2.h,
                                      ),
                                      child: Text(
                                        'All Rankings',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: colorScheme.onSurface,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final user = _filteredData[index];
                                      final isCurrentUser =
                                          user['name'] == 'You';

                                      return RankingCard(
                                        student: user,
                                        rank: user['rank'] as int,
                                        isCurrentUser: isCurrentUser,
                                        isTopThree: index < 3,
                                        onTap: () => _showUserProfile(user),
                                      );
                                    },
                                    childCount: _filteredData.length,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(height: 10.h),
                                ),
                              ],
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _filteredData.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _challengeFriends,
              backgroundColor: colorScheme.tertiary,
              foregroundColor: colorScheme.onTertiary,
              icon: CustomIconWidget(
                iconName: 'group',
                color: colorScheme.onTertiary,
                size: 20,
              ),
              label: const Text('Challenge Friends'),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
          currentIndex: 2, // Leaderboard tab
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/student-dashboard');
                break;
              case 1:
                Navigator.pushNamed(context, '/quiz-interface');
                break;
              case 2:
                // Already on leaderboard
                break;
              case 3:
                Navigator.pushNamed(context, '/student-profile');
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'dashboard',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'dashboard',
                color: colorScheme.primary,
                size: 24,
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                backgroundColor: colorScheme.error,
                smallSize: 8,
                child: CustomIconWidget(
                  iconName: 'quiz',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
              activeIcon: Badge(
                backgroundColor: colorScheme.error,
                smallSize: 8,
                child: CustomIconWidget(
                  iconName: 'quiz',
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              label: 'Quiz',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                label: const Text('3'),
                backgroundColor: colorScheme.tertiary,
                textColor: colorScheme.onTertiary,
                child: CustomIconWidget(
                  iconName: 'leaderboard',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
              activeIcon: Badge(
                label: const Text('3'),
                backgroundColor: colorScheme.tertiary,
                textColor: colorScheme.onTertiary,
                child: CustomIconWidget(
                  iconName: 'leaderboard',
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              label: 'Leaderboard',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'person',
                color: colorScheme.primary,
                size: 24,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
