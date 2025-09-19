import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AvatarCustomizationModal extends StatefulWidget {
  final Map<String, dynamic> currentAvatar;
  final Function(Map<String, dynamic>) onAvatarUpdated;

  const AvatarCustomizationModal({
    super.key,
    required this.currentAvatar,
    required this.onAvatarUpdated,
  });

  @override
  State<AvatarCustomizationModal> createState() =>
      _AvatarCustomizationModalState();
}

class _AvatarCustomizationModalState extends State<AvatarCustomizationModal>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> _selectedAvatar;

  final List<String> _categories = ['Accessories', 'Expressions', 'Themes'];

  final List<Map<String, dynamic>> _accessories = [
    {
      "id": "hat_1",
      "name": "Cool Cap",
      "icon": "sports_baseball",
      "isUnlocked": true,
      "requiredXP": 0,
    },
    {
      "id": "glasses_1",
      "name": "Smart Glasses",
      "icon": "visibility",
      "isUnlocked": true,
      "requiredXP": 500,
    },
    {
      "id": "crown_1",
      "name": "Achievement Crown",
      "icon": "workspace_premium",
      "isUnlocked": false,
      "requiredXP": 2000,
    },
    {
      "id": "headphones_1",
      "name": "Gaming Headset",
      "icon": "headphones",
      "isUnlocked": true,
      "requiredXP": 1000,
    },
  ];

  final List<Map<String, dynamic>> _expressions = [
    {
      "id": "happy",
      "name": "Happy",
      "icon": "sentiment_very_satisfied",
      "isUnlocked": true,
      "requiredXP": 0,
    },
    {
      "id": "excited",
      "name": "Excited",
      "icon": "sentiment_very_satisfied",
      "isUnlocked": true,
      "requiredXP": 100,
    },
    {
      "id": "focused",
      "name": "Focused",
      "icon": "psychology",
      "isUnlocked": false,
      "requiredXP": 800,
    },
    {
      "id": "cool",
      "name": "Cool",
      "icon": "sentiment_satisfied",
      "isUnlocked": true,
      "requiredXP": 300,
    },
  ];

  final List<Map<String, dynamic>> _themes = [
    {
      "id": "default",
      "name": "Default",
      "icon": "person",
      "isUnlocked": true,
      "requiredXP": 0,
      "color": AppTheme.primaryLight,
    },
    {
      "id": "space",
      "name": "Space Explorer",
      "icon": "rocket_launch",
      "isUnlocked": true,
      "requiredXP": 1500,
      "color": AppTheme.secondaryLight,
    },
    {
      "id": "scientist",
      "name": "Mad Scientist",
      "icon": "science",
      "isUnlocked": false,
      "requiredXP": 3000,
      "color": AppTheme.successLight,
    },
    {
      "id": "wizard",
      "name": "Math Wizard",
      "icon": "auto_fix_high",
      "isUnlocked": false,
      "requiredXP": 5000,
      "color": AppTheme.accentLight,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _selectedAvatar = Map<String, dynamic>.from(widget.currentAvatar);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 80.h,
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

                // Header with avatar preview
                Row(
                  children: [
                    // Avatar Preview
                    Container(
                      width: 20.w,
                      height: 20.w,
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
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomIconWidget(
                        iconName: 'person',
                        color: Colors.white,
                        size: 10.w,
                      ),
                    ),
                    SizedBox(width: 4.w),

                    // Title and close button
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Customize Avatar",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            "Unlock new items by earning XP!",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
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

          // Tab Bar
          Container(
            color: colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryLight,
              unselectedLabelColor:
                  colorScheme.onSurface.withValues(alpha: 0.6),
              indicatorColor: AppTheme.primaryLight,
              tabs: _categories.map((category) => Tab(text: category)).toList(),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAccessoriesTab(context, theme, colorScheme),
                _buildExpressionsTab(context, theme, colorScheme),
                _buildThemesTab(context, theme, colorScheme),
              ],
            ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onAvatarUpdated(_selectedAvatar);
                      Navigator.pop(context);
                    },
                    child: Text("Save Changes"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessoriesTab(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return _buildItemGrid(
        context, _accessories, theme, colorScheme, 'accessory');
  }

  Widget _buildExpressionsTab(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return _buildItemGrid(
        context, _expressions, theme, colorScheme, 'expression');
  }

  Widget _buildThemesTab(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return _buildItemGrid(context, _themes, theme, colorScheme, 'theme');
  }

  Widget _buildItemGrid(
    BuildContext context,
    List<Map<String, dynamic>> items,
    ThemeData theme,
    ColorScheme colorScheme,
    String itemType,
  ) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 3.h,
          childAspectRatio: 1.2,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isUnlocked = item["isUnlocked"] as bool? ?? false;
          final isSelected = _selectedAvatar[itemType] == item["id"];
          final requiredXP = item["requiredXP"] as int? ?? 0;

          return GestureDetector(
            onTap: isUnlocked
                ? () {
                    setState(() {
                      _selectedAvatar[itemType] = item["id"];
                    });
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryLight.withValues(alpha: 0.1)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryLight
                      : isUnlocked
                          ? colorScheme.outline.withValues(alpha: 0.3)
                          : colorScheme.outline.withValues(alpha: 0.1),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Item Icon
                  Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? (item["color"] as Color? ?? AppTheme.primaryLight)
                              .withValues(alpha: 0.1)
                          : colorScheme.outline.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: item["icon"] as String? ?? 'person',
                          color: isUnlocked
                              ? (item["color"] as Color? ??
                                  AppTheme.primaryLight)
                              : colorScheme.outline.withValues(alpha: 0.5),
                          size: 8.w,
                        ),
                        if (!isUnlocked)
                          CustomIconWidget(
                            iconName: 'lock',
                            color: colorScheme.outline,
                            size: 4.w,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Item Name
                  Text(
                    item["name"] as String? ?? "Item",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isUnlocked
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // XP Requirement
                  if (!isUnlocked) ...[
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.warningLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "$requiredXP XP needed",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.warningLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],

                  // Selected indicator
                  if (isSelected) ...[
                    SizedBox(height: 1.h),
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.successLight,
                      size: 4.w,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
