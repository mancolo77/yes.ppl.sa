import 'package:flutter/material.dart';
import '../../services/sports_data_service.dart';
import '../../theme/app_theme.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  final _service = SportsDataService();
  String _selectedSport = 'All';
  String _selectedStatus = 'All';
  String _searchQuery = '';

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

  IconData _iconForSport(String sport) {
    switch (sport.toLowerCase()) {
      case 'football':
        return Icons.sports_soccer_rounded;
      case 'rugby':
        return Icons.sports_rugby_rounded;
      case 'cricket':
        return Icons.sports_cricket_rounded;
      case 'tennis':
        return Icons.sports_tennis_rounded;
      default:
        return Icons.sports_basketball_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sports = ['All', 'Football', 'Rugby', 'Cricket', 'Tennis'];
    final statuses = ['All', 'Live', 'Upcoming', 'Finished'];

    final filtered = _service.events.where((e) {
      final matchesSport = _selectedSport == 'All' || e.sport == _selectedSport;
      final matchesStatus = _selectedStatus == 'All' || e.status == _selectedStatus;
      final query = _searchQuery.toLowerCase();
      final matchesQuery = query.isEmpty ||
          e.teamA.toLowerCase().contains(query) ||
          e.teamB.toLowerCase().contains(query) ||
          e.tournament.toLowerCase().contains(query);
      return matchesSport && matchesStatus && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sports Events',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkNavy,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Fixtures, results and live updates',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.sectionBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: const Text(
                      'DEMO MODE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search teams or tournaments...',
                  hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  prefixIcon: const Icon(Icons.search, size: 20, color: AppTheme.textSecondary),
                  filled: true,
                  fillColor: AppTheme.sectionBg,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Sport Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: sports.map((sport) {
                  final isSelected = sport == _selectedSport;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(sport),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedSport = sport),
                      selectedColor: AppTheme.darkNavy,
                      backgroundColor: AppTheme.sectionBg,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppTheme.darkNavy,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppTheme.darkNavy : AppTheme.border,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 6),

            // Status Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: statuses.map((status) {
                  final isSelected = status == _selectedStatus;
                  return Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedStatus = status),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.orangeAccent : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? AppTheme.darkNavy : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 20, color: AppTheme.border),

            // Event Cards List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy_rounded, size: 48, color: AppTheme.textSecondary.withAlpha(100)),
                          const SizedBox(height: 10),
                          const Text(
                            'No events found',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkNavy),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Try adjusting your search or filters.',
                            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final event = filtered[index];
                        final isFav = _service.isEventFavorite(event.id);
                        final isLive = event.status == 'Live';

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceCard,
                            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                            border: Border.all(
                              color: isLive ? AppTheme.orangeAccent.withAlpha(150) : AppTheme.border,
                              width: isLive ? 1.5 : 1,
                            ),
                            boxShadow: AppTheme.cardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Tag Row
                              Row(
                                children: [
                                  Icon(_iconForSport(event.sport), size: 16, color: AppTheme.orangeAccent),
                                  const SizedBox(width: 6),
                                  Text(
                                    event.tournament,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  const Spacer(),
                                  // Required "Example" Demo Label
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.sectionBg,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: AppTheme.border),
                                    ),
                                    child: const Text(
                                      'Example',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Status Indicator
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isLive
                                          ? AppTheme.orangeAccent
                                          : (event.status == 'Finished'
                                              ? AppTheme.sectionBg
                                              : AppTheme.secondaryBlue.withAlpha(20)),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      event.status.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isLive
                                            ? AppTheme.darkNavy
                                            : (event.status == 'Finished'
                                                ? AppTheme.textSecondary
                                                : AppTheme.darkNavy),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => _service.toggleEventFavorite(event.id),
                                    child: Icon(
                                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                      color: isFav ? Colors.red : AppTheme.textSecondary,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Match Teams & Score
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.teamA,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.darkNavy,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          event.teamB,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.darkNavy,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (event.score != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.sectionBg,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppTheme.border),
                                      ),
                                      child: Text(
                                        event.score!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isLive ? AppTheme.orangeAccent : AppTheme.darkNavy,
                                        ),
                                      ),
                                    )
                                  else
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          event.time,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.darkNavy,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          event.date,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
