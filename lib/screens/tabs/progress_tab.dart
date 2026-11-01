import 'package:flutter/material.dart';
import '../../services/sports_data_service.dart';
import '../../theme/app_theme.dart';

class ProgressTab extends StatefulWidget {
  const ProgressTab({super.key});

  @override
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
  final _service = SportsDataService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onChanged);
  }

  @override
  void dispose() {
    _service.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  IconData _iconForBadge(String name) {
    switch (name) {
      case 'check_circle':
        return Icons.check_circle_outline_rounded;
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'stars':
        return Icons.stars_rounded;
      case 'sports_score':
        return Icons.sports_score_rounded;
      default:
        return Icons.military_tech_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final canCheckin = _service.canCheckinToday;
    final currentPoints = _service.points;
    final tier = _service.tierName;
    final progress = _service.tierProgress;
    final nextTarget = _service.nextTierTarget;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Progress',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkNavy,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Daily check-ins, trivia points and badges',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tier & Points Card with Diagonal Pattern
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.darkNavy,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  boxShadow: AppTheme.cardShadow,
                ),
                clipBehavior: Clip.antiAlias,
                child: CustomPaint(
                  painter: DiagonalStripesPainter(
                    stripeColor: AppTheme.secondaryBlue,
                    stripeWidth: 6,
                    gap: 14,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CURRENT TIER',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                    color: AppTheme.orangeAccent,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$tier Level',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.orangeAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$currentPoints PTS',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkNavy,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.orangeAccent),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tier == 'Master' ? 'Maximum Tier Achieved' : 'Next Tier Goal: $nextTarget pts',
                              style: const TextStyle(fontSize: 12, color: Colors.white70),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Daily Check-in Action Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.sectionBg,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: canCheckin
                            ? AppTheme.orangeAccent.withAlpha(25)
                            : AppTheme.statusGreen.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        canCheckin ? Icons.calendar_today_rounded : Icons.check_circle_rounded,
                        color: canCheckin ? AppTheme.orangeAccent : AppTheme.statusGreen,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            canCheckin ? 'Daily Visit Bonus' : 'Checked In Today',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkNavy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            canCheckin
                                ? 'Claim +10 pts for opening the app today'
                                : 'Come back tomorrow for your next bonus',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: canCheckin ? () => _service.dailyCheckin() : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canCheckin ? AppTheme.orangeAccent : AppTheme.border,
                        foregroundColor: AppTheme.darkNavy,
                        minimumSize: const Size(0, 42),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        canCheckin ? '+10 PTS' : 'Claimed',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Strictly Required Non-commercial Notice
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 18, color: AppTheme.textSecondary),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Points serve strictly for personal motivation and progress tracking. They have no monetary value and cannot be purchased, transferred or exchanged.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Virtual Badges Collection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
              child: const Text(
                'Virtual Badges Collection',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkNavy,
                ),
              ),
            ),
            const SizedBox(height: 12),

            ...List.generate(_service.badges.length, (index) {
              final badge = _service.badges[index];
              final isUnlocked = currentPoints >= badge.requiredPoints;

              return Padding(
                padding: const EdgeInsets.fromLTRB(AppTheme.screenPadding, 0, AppTheme.screenPadding, 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUnlocked ? AppTheme.surfaceCard : AppTheme.sectionBg,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    border: Border.all(
                      color: isUnlocked ? AppTheme.orangeAccent.withAlpha(120) : AppTheme.border,
                    ),
                    boxShadow: isUnlocked ? AppTheme.cardShadow : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? AppTheme.orangeAccent.withAlpha(25)
                              : AppTheme.border.withAlpha(50),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _iconForBadge(badge.iconName),
                          color: isUnlocked ? AppTheme.orangeAccent : AppTheme.textSecondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              badge.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isUnlocked ? AppTheme.darkNavy : AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              badge.description,
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? AppTheme.statusGreen.withAlpha(25)
                              : AppTheme.border.withAlpha(60),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isUnlocked ? 'Unlocked' : '${badge.requiredPoints} pts',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? AppTheme.statusGreen : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),

            // Bookmarked Items Counter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.sectionBg,
                        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${_service.favoriteArticleIds.length}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.orangeAccent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Saved Articles',
                            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.sectionBg,
                        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${_service.favoriteEventIds.length}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.orangeAccent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Saved Events',
                            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

