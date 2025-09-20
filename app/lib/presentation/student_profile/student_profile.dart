import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_card_widget.dart';
import './widgets/avatar_customization_modal.dart';
import './widgets/learning_statistics_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/streak_calendar_widget.dart';
import './widgets/xp_progress_widget.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  // Mock student data
  final Map<String, dynamic> _studentData = {
    "id": "student_001",
    "username": "Bhavya Kumar",
    "class": "Class 10",
    "school": "Dav Public School",
    "totalXP": 15420,
    "currentLevel": 15,
    "xpForNextLevel": 580,
    "totalXPForNextLevel": 1000,
    "currentStreak": 12,
    "bestStreak": 28,
    "coinsEarned": 2340,
    "heartsRemaining": 4,
    "maxHearts": 5,
    "joinDate": "2024-01-15",
    "lastActive": "2025-09-16 10:30:00",
  };

  Map<String, dynamic> _currentAvatar = {
    "accessory": "hat_1",
    "expression": "happy",
    "theme": "default",
  };

  // Mock achievements data
  final List<Map<String, dynamic>> _achievements = [
    {
      "id": "first_quiz",
      "title": "First Steps",
      "description": "Complete your first quiz",
      "icon": "quiz",
      "xpReward": 50,
      "isEarned": true,
      "isNew": false,
      "earnedDate": "2024-01-16",
    },
    {
      "id": "streak_7",
      "title": "Week Warrior",
      "description": "Maintain a 7-day streak",
      "icon": "local_fire_department",
      "xpReward": 200,
      "isEarned": true,
      "isNew": true,
      "earnedDate": "2025-09-10",
    },
    {
      "id": "math_master",
      "title": "Math Master",
      "description": "Score 100% in 5 math quizzes",
      "icon": "calculate",
      "xpReward": 300,
      "isEarned": true,
      "isNew": false,
      "earnedDate": "2025-08-22",
    },
    {
      "id": "science_genius",
      "title": "Science Genius",
      "description": "Complete all physics chapters",
      "icon": "science",
      "xpReward": 500,
      "isEarned": false,
      "isNew": false
    },
    {
      "id": "speed_demon",
      "title": "Speed Demon",
      "description": "Answer 10 questions in under 30 seconds",
      "icon": "speed",
      "xpReward": 150,
      "isEarned": true,
      "isNew": false,
      "earnedDate": "2025-07-15",
    },
    {
      "id": "perfectionist",
      "title": "Perfectionist",
      "description": "Get 100% on 10 consecutive quizzes",
      "icon": "workspace_premium",
      "xpReward": 1000,
      "isEarned": false,
      "isNew": false,
    },
  ];

  // Mock subjects data
  final List<Map<String, dynamic>> _subjects = [
    {
      "name": "Mathematics",
      "progress": 85.0,
      "nextMilestone": "Complete Algebra II",
      "chaptersCompleted": 12,
      "totalChapters": 15,
    },
    {
      "name": "Physics",
      "progress": 72.0,
      "nextMilestone": "Finish Mechanics",
      "chaptersCompleted": 8,
      "totalChapters": 11,
    },
    {
      "name": "Chemistry",
      "progress": 91.0,
      "nextMilestone": "Start Organic Chemistry",
      "chaptersCompleted": 10,
      "totalChapters": 11,
    },
    {
      "name": "Biology",
      "progress": 68.0,
      "nextMilestone": "Complete Cell Biology",
      "chaptersCompleted": 7,
      "totalChapters": 10,
    },
  ];

  // Mock recent activities
  final List<Map<String, dynamic>> _recentActivities = [
    {
      "id": "activity_001",
      "type": "quiz",
      "title": "Physics Quiz Completed",
      "description": "Scored 95% on Motion and Forces quiz",
      "timestamp": "2 hours ago",
      "xpGained": 85,
      "isPositive": true,
    },
    {
      "id": "activity_002",
      "type": "achievement",
      "title": "New Achievement Unlocked!",
      "description": "Earned 'Week Warrior' badge for 7-day streak",
      "timestamp": "1 day ago",
      "xpGained": 200,
      "isPositive": true,
    },
    {
      "id": "activity_003",
      "type": "streak",
      "title": "Streak Extended",
      "description": "Current learning streak: 12 days",
      "timestamp": "1 day ago",
      "xpGained": 25,
      "isPositive": true,
    },
    {
      "id": "activity_004",
      "type": "quiz",
      "title": "Chemistry Quiz",
      "description": "Scored 78% on Atomic Structure",
      "timestamp": "2 days ago",
      "xpGained": 65,
      "isPositive": true,
    },
    {
      "id": "activity_005",
      "type": "level_up",
      "title": "Level Up!",
      "description": "Reached Level 15 - Keep going!",
      "timestamp": "3 days ago",
      "xpGained": 500,
      "isPositive": true,
    },
  ];

  // Mock streak calendar data
  final List<DateTime> _streakDates = [
    DateTime.now().subtract(const Duration(days: 0)),
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now().subtract(const Duration(days: 2)),
    DateTime.now().subtract(const Duration(days: 3)),
    DateTime.now().subtract(const Duration(days: 4)),
    DateTime.now().subtract(const Duration(days: 5)),
    DateTime.now().subtract(const Duration(days: 6)),
    DateTime.now().subtract(const Duration(days: 7)),
    DateTime.now().subtract(const Duration(days: 8)),
    DateTime.now().subtract(const Duration(days: 9)),
    DateTime.now().subtract(const Duration(days: 10)),
    DateTime.now().subtract(const Duration(days: 11)),
  ];

  final List<DateTime> _missedDates = [
    DateTime.now().subtract(const Duration(days: 12)),
    DateTime.now().subtract(const Duration(days: 15)),
    DateTime.now().subtract(const Duration(days: 18)),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Handle scroll events for potential animations or loading
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Update achievement data and avatar assets
    setState(() {
      _isRefreshing = false;
      // Mark new achievements as viewed
      for (var achievement in _achievements) {
        if (achievement["isNew"] == true) {
          achievement["isNew"] = false;
        }
      }
    });
  }

  void _showAvatarCustomization() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AvatarCustomizationModal(
        currentAvatar: _currentAvatar,
        onAvatarUpdated: (updatedAvatar) {
          setState(() {
            _currentAvatar = updatedAvatar;
          });
        },
      ),
    );
  }

  void _showAchievementDetails(Map<String, dynamic> achievement) {
    showDialog(
      context: context,
      builder: (context) => _buildAchievementDialog(achievement),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSettingsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "My Profile",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          // Notification badge
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // Handle notifications
                },
                icon: CustomIconWidget(
                  iconName: 'notifications_outlined',
                  color: colorScheme.onSurface,
                  size: 6.w,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: AppTheme.errorLight,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          // Settings
          IconButton(
            onPressed: _showSettings,
            icon: CustomIconWidget(
              iconName: 'settings',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.primaryLight,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header with 3D Avatar
              _buildProfileHeader(context, theme, colorScheme),
              SizedBox(height: 4.h),

              // XP Progress Section
              XpProgressWidget(
                currentXP: _studentData["totalXP"] as int,
                currentLevel: _studentData["currentLevel"] as int,
                xpForNextLevel: _studentData["xpForNextLevel"] as int,
                totalXPForNextLevel: _studentData["totalXPForNextLevel"] as int,
              ),
              SizedBox(height: 4.h),

              // Achievement Gallery Section
              _buildAchievementGallery(context, theme, colorScheme),
              SizedBox(height: 4.h),

              // Learning Statistics Section
              LearningStatisticsWidget(subjects: _subjects),
              SizedBox(height: 4.h),

              // Streak Calendar Section
              StreakCalendarWidget(
                streakDates: _streakDates,
                missedDates: _missedDates,
                currentStreak: _studentData["currentStreak"] as int,
              ),
              SizedBox(height: 4.h),

              // Recent Activity Section
              RecentActivityWidget(activities: _recentActivities),
              SizedBox(height: 8.h), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryLight.withValues(alpha: 0.1),
            AppTheme.secondaryLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Avatar and Basic Info
          Row(
            children: [
              // 3D Animated Avatar
              GestureDetector(
                onTap: _showAvatarCustomization,
                child: Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryLight,
                        AppTheme.primaryVariantLight,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryLight.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'person',
                        color: Colors.white,
                        size: 12.w,
                      ),
                      // Customization indicator
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: AppTheme.accentLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'edit',
                            color: Colors.white,
                            size: 3.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 4.w),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _studentData["username"] as String,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      "${_studentData["class"]} • ${_studentData["school"]}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Quick Stats Row
                    Row(
                      children: [
                        _buildQuickStat(
                          context,
                          "Level",
                          "${_studentData["currentLevel"]}",
                          'military_tech',
                          AppTheme.primaryLight,
                          theme,
                        ),
                        SizedBox(width: 4.w),
                        _buildQuickStat(
                          context,
                          "Streak",
                          "${_studentData["currentStreak"]}d",
                          'local_fire_department',
                          AppTheme.errorLight,
                          theme,
                        ),
                        SizedBox(width: 4.w),
                        _buildQuickStat(
                          context,
                          "Coins",
                          "${_studentData["coinsEarned"]}",
                          'monetization_on',
                          AppTheme.warningLight,
                          theme,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Hearts/Lives System
          _buildHeartsSystem(context, theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    BuildContext context,
    String label,
    String value,
    String iconName,
    Color color,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 5.w,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildHeartsSystem(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final heartsRemaining = _studentData["heartsRemaining"] as int;
    final maxHearts = _studentData["maxHearts"] as int;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.errorLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'favorite',
                color: AppTheme.errorLight,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                "Hearts",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          // Hearts Display
          Row(
            children: List.generate(maxHearts, (index) {
              final isFilled = index < heartsRemaining;
              return Padding(
                padding: EdgeInsets.only(left: index > 0 ? 1.w : 0),
                child: CustomIconWidget(
                  iconName: isFilled ? 'favorite' : 'favorite_border',
                  color: isFilled
                      ? AppTheme.errorLight
                      : colorScheme.outline.withValues(alpha: 0.5),
                  size: 4.w,
                ),
              );
            }),
          ),

          // Regeneration Timer
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.successLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Next in 15m",
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.successLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementGallery(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'emoji_events',
                  color: AppTheme.primaryLight,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  "Achievement Gallery",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // Navigate to full achievements page
              },
              child: Text(
                "View All",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.primaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Achievement Cards Grid
        SizedBox(
          height: 32.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _achievements.length,
            itemBuilder: (context, index) {
              final achievement = _achievements[index];
              return AchievementCardWidget(
                achievement: achievement,
                onTap: () => _showAchievementDetails(achievement),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementDialog(Map<String, dynamic> achievement) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEarned = achievement["isEarned"] as bool? ?? false;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Achievement Icon
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                gradient: isEarned
                    ? LinearGradient(
                        colors: [
                          AppTheme.primaryLight,
                          AppTheme.primaryVariantLight,
                        ],
                      )
                    : null,
                color: isEarned
                    ? null
                    : colorScheme.outline.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                boxShadow: isEarned
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryLight.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: CustomIconWidget(
                iconName: achievement["icon"] as String? ?? 'emoji_events',
                color: isEarned ? Colors.white : colorScheme.outline,
                size: 10.w,
              ),
            ),
            SizedBox(height: 3.h),

            // Achievement Title
            Text(
              achievement["title"] as String? ?? "Achievement",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),

            // Achievement Description
            Text(
              achievement["description"] as String? ?? "Complete to unlock",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 3.h),

            // XP Reward and Status
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isEarned
                    ? AppTheme.successLight.withValues(alpha: 0.1)
                    : AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: isEarned ? 'check_circle' : 'stars',
                    color: isEarned
                        ? AppTheme.successLight
                        : AppTheme.warningLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    isEarned
                        ? "Earned ${achievement["xpReward"]} XP"
                        : "Reward: ${achievement["xpReward"]} XP",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isEarned
                          ? AppTheme.successLight
                          : AppTheme.warningLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            if (isEarned && achievement["earnedDate"] != null) ...[
              SizedBox(height: 2.h),
              Text(
                "Earned on ${achievement["earnedDate"]}",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],

            SizedBox(height: 4.h),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsModal() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Modal Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Settings",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Settings Options
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(4.w),
              children: [
                _buildSettingsItem(
                  context,
                  "Notifications",
                  "Manage your notification preferences",
                  'notifications',
                  () {
                    // Handle notifications settings
                  },
                  theme,
                  colorScheme,
                ),
                _buildSettingsItem(
                  context,
                  "Privacy",
                  "Control your privacy settings",
                  'privacy_tip',
                  () {
                    // Handle privacy settings
                  },
                  theme,
                  colorScheme,
                ),
                _buildSettingsItem(
                  context,
                  "Account Management",
                  "Update your account information",
                  'manage_accounts',
                  () {
                    // Handle account management
                  },
                  theme,
                  colorScheme,
                ),
                _buildSettingsItem(
                  context,
                  "Help & Support",
                  "Get help and contact support",
                  'help',
                  () {
                    // Handle help and support
                  },
                  theme,
                  colorScheme,
                ),
                SizedBox(height: 2.h),

                // Logout Button
                Container(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showLogoutConfirmation();
                    },
                    icon: CustomIconWidget(
                      iconName: 'logout',
                      color: AppTheme.errorLight,
                      size: 5.w,
                    ),
                    label: Text(
                      "Logout",
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.errorLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.errorLight),
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    VoidCallback onTap,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        leading: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: AppTheme.primaryLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.primaryLight,
            size: 6.w,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: colorScheme.onSurface.withValues(alpha: 0.5),
          size: 5.w,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: colorScheme.surface,
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Logout Confirmation",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          content: Text(
            "Are you sure you want to logout? Your progress will be saved.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/authentication-screen',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorLight,
              ),
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
