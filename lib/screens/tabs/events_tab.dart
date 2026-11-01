import 'package:flutter/material.dart';
import '../../services/user_progress_service.dart';
import '../../theme/app_theme.dart';

class EventData {
  final String id;
  final String sport;
  final String tournament;
  final String date;
  final String time;
  final String teamA;
  final String teamB;
  final String? score;
  final bool isLive;

  const EventData({
    required this.id,
    required this.sport,
    required this.tournament,
    required this.date,
    required this.time,
    required this.teamA,
    required this.teamB,
    this.score,
    this.isLive = false,
  });
}

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  final UserProgressService _progress = UserProgressService();
  String _selectedSport = 'Все';
  final List<String> _sports = ['Все', 'Футбол', 'Баскетбол', 'Регби'];

  final List<EventData> _events = const [
    EventData(
      id: 'yes_e_1',
      sport: 'Футбол',
      tournament: 'Премьер-Лига',
      date: 'Сегодня',
      time: '19:00',
      teamA: 'Кайзер Чифс',
      teamB: 'Орландо Пайретс',
      score: '1 : 0',
      isLive: true,
    ),
    EventData(
      id: 'yes_e_2',
      sport: 'Регби',
      tournament: 'Чемпионат Содружества',
      date: 'Сегодня',
      time: '20:30',
      teamA: 'Спрингбокс',
      teamB: 'Олл Блэкс',
      score: '24 : 18',
      isLive: false,
    ),
    EventData(
      id: 'yes_e_3',
      sport: 'Баскетбол',
      tournament: 'Национальная Лига',
      date: 'Завтра',
      time: '17:30',
      teamA: 'Кейптаун Тайгерс',
      teamB: 'Йоханнесбург Джайентс',
      score: null,
      isLive: false,
    ),
    EventData(
      id: 'yes_e_4',
      sport: 'Футбол',
      tournament: 'Кубок Страны',
      date: 'Завтра',
      time: '20:00',
      teamA: 'Мамелоди Сандаунз',
      teamB: 'Суперспорт Юнайтед',
      score: null,
      isLive: false,
    ),
    EventData(
      id: 'yes_e_5',
      sport: 'Регби',
      tournament: 'Супер Кубок',
      date: 'Вчера',
      time: '18:00',
      teamA: 'Штормерс',
      teamB: 'Буллз',
      score: '19 : 22',
      isLive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _events.where((e) {
      if (_selectedSport == 'Все') return true;
      return e.sport == _selectedSport;
    }).toList();

    return AnimatedBuilder(
      animation: _progress,
      builder: (context, _) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'События',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkNavy,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceSection,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: const Text(
                      'Пример',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Календарь встреч и спортивные результаты',
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 18),

              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _sports.map((sport) {
                    final isSelected = _selectedSport == sport;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(sport),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setState(() => _selectedSport = sport);
                        },
                        selectedColor: AppTheme.primary,
                        backgroundColor: AppTheme.surfaceSection,
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppTheme.darkNavy : AppTheme.textSecondary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                          side: BorderSide(
                            color: isSelected ? AppTheme.primary : AppTheme.border,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),

              // List of events
              if (filtered.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: const [
                      Icon(Icons.event_busy_rounded, size: 48, color: AppTheme.textSecondary),
                      SizedBox(height: 12),
                      Text(
                        'Нет событий в выбранной категории',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                )
              else
                ...filtered.map((event) {
                  final isFav = _progress.favoriteMatchIds.contains(event.id);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                      border: Border.all(
                        color: event.isLive ? AppTheme.primary : AppTheme.border,
                        width: event.isLive ? 1.5 : 1.0,
                      ),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  event.tournament,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceSection,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Пример',
                                    style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                isFav ? Icons.star_rounded : Icons.star_border_rounded,
                                color: isFav ? AppTheme.primary : AppTheme.textSecondary,
                                size: 22,
                              ),
                              onPressed: () => _progress.toggleFavoriteMatch(event.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                event.teamA,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkNavy,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  if (event.score != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: event.isLive ? AppTheme.primary : AppTheme.surfaceSection,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        event.score!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: event.isLive ? AppTheme.darkNavy : AppTheme.darkNavy,
                                        ),
                                      ),
                                    )
                                  else
                                    Text(
                                      event.time,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.darkNavy,
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    event.isLive ? 'LIVE' : event.date,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: event.isLive ? AppTheme.statusGreen : AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                event.teamB,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkNavy,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

