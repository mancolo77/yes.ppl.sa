import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sports_model.dart';

class SportsDataService extends ChangeNotifier {
  static final SportsDataService _instance = SportsDataService._internal();
  factory SportsDataService() => _instance;
  SportsDataService._internal();

  int _points = 25;
  String _lastCheckinDate = '';
  Set<String> _favoriteArticleIds = {};
  Set<String> _favoriteEventIds = {};
  Set<String> _answeredQuestionIds = {};
  Set<String> _correctQuestionIds = {};

  int get points => _points;
  String get lastCheckinDate => _lastCheckinDate;
  Set<String> get favoriteArticleIds => _favoriteArticleIds;
  Set<String> get favoriteEventIds => _favoriteEventIds;
  Set<String> get answeredQuestionIds => _answeredQuestionIds;

  bool get canCheckinToday {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return _lastCheckinDate != today;
  }

  String get tierName {
    if (_points >= 300) return 'Master';
    if (_points >= 100) return 'Pro';
    return 'Rookie';
  }

  double get tierProgress {
    if (_points >= 300) return 1.0;
    if (_points >= 100) return (_points - 100) / 200.0;
    return _points / 100.0;
  }

  int get nextTierTarget {
    if (_points >= 300) return 300;
    if (_points >= 100) return 300;
    return 100;
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _points = prefs.getInt('sp_user_points') ?? 25;
    _lastCheckinDate = prefs.getString('sp_last_checkin_date') ?? '';
    _favoriteArticleIds = (prefs.getStringList('sp_fav_articles') ?? []).toSet();
    _favoriteEventIds = (prefs.getStringList('sp_fav_events') ?? []).toSet();
    _answeredQuestionIds = (prefs.getStringList('sp_answered_questions') ?? []).toSet();
    _correctQuestionIds = (prefs.getStringList('sp_correct_questions') ?? []).toSet();
    notifyListeners();
  }

  Future<bool> dailyCheckin() async {
    if (!canCheckinToday) return false;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    _lastCheckinDate = today;
    _points += 10;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sp_user_points', _points);
    await prefs.setString('sp_last_checkin_date', today);
    notifyListeners();
    return true;
  }

  Future<bool> submitQuizAnswer(String questionId, int selectedIndex, int correctIndex) async {
    _answeredQuestionIds.add(questionId);
    final isCorrect = selectedIndex == correctIndex;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('sp_answered_questions', _answeredQuestionIds.toList());

    if (isCorrect && !_correctQuestionIds.contains(questionId)) {
      _correctQuestionIds.add(questionId);
      _points += 15;
      await prefs.setInt('sp_user_points', _points);
      await prefs.setStringList('sp_correct_questions', _correctQuestionIds.toList());
    }

    notifyListeners();
    return isCorrect;
  }

  bool isQuestionAnswered(String questionId) => _answeredQuestionIds.contains(questionId);

  Future<void> toggleArticleFavorite(String id) async {
    if (_favoriteArticleIds.contains(id)) {
      _favoriteArticleIds.remove(id);
    } else {
      _favoriteArticleIds.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('sp_fav_articles', _favoriteArticleIds.toList());
    notifyListeners();
  }

  bool isArticleFavorite(String id) => _favoriteArticleIds.contains(id);

  Future<void> toggleEventFavorite(String id) async {
    if (_favoriteEventIds.contains(id)) {
      _favoriteEventIds.remove(id);
    } else {
      _favoriteEventIds.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('sp_fav_events', _favoriteEventIds.toList());
    notifyListeners();
  }

  bool isEventFavorite(String id) => _favoriteEventIds.contains(id);

  // Predefined Badges
  final List<BadgeItem> badges = const [
    BadgeItem(
      id: 'b_welcome',
      title: 'Starter Fan',
      description: 'Awarded on your first visit to the Sports Hub.',
      iconName: 'check_circle',
      requiredPoints: 10,
    ),
    BadgeItem(
      id: 'b_enthusiast',
      title: 'Active Reader',
      description: 'Explore sport news and analysis articles.',
      iconName: 'menu_book',
      requiredPoints: 50,
    ),
    BadgeItem(
      id: 'b_quiz_pro',
      title: 'Trivia Whiz',
      description: 'Score correct answers in daily sports quizzes.',
      iconName: 'stars',
      requiredPoints: 100,
    ),
    BadgeItem(
      id: 'b_tracker',
      title: 'Match Tracker',
      description: 'Save exciting match fixtures into favorites.',
      iconName: 'sports_score',
      requiredPoints: 200,
    ),
    BadgeItem(
      id: 'b_champion',
      title: 'Master Legend',
      description: 'Reach the highest community tier with 300+ points.',
      iconName: 'military_tech',
      requiredPoints: 300,
    ),
  ];

  // Predefined Articles
  final List<SportsArticle> articles = const [
    SportsArticle(
      id: 'art_1',
      title: 'High-Pressing Tactics: How Football Midfielders Dictate the Tempo',
      summary: 'Explore spatial awareness, coordinated pressing triggers, and transition acceleration.',
      fullContent:
          'Modern football demands peak athletic fitness combined with elite tactical awareness. A high-pressing unit does not simply sprint at the ball carrier; instead, the frontline cuts off primary passing channels to trap the opponent in low-probability zones.\n\nKey principles include:\n1. Compact defensive lines keeping distance under 30 meters.\n2. Rapid secondary recovery after losing possession.\n3. Dynamic rotation of box-to-box central midfielders.\n\nBy executing these synchronized movements, clubs force rushed decisions and turn defensive phases into rapid counter-attacking opportunities.',
      category: 'Football',
      readTime: '4 min read',
      date: 'Today',
    ),
    SportsArticle(
      id: 'art_2',
      title: 'Rugby Union Scrum Dynamics and Front Row Physics',
      summary: 'Understanding the immense biomechanical forces generated in professional set-pieces.',
      fullContent:
          'In rugby union, the scrum represents one of the most intense tests of strength and technical discipline in team sports. Over 1,500 kilograms of combined pack force meet at the engagement line.\n\nProps and hookers must lock their spines in a neutral posture, drive from their quads, and maintain binding discipline to prevent collapses. Proper timing between the halfback feed and the pack drive determines which team secures clean ball distribution for backline runners.',
      category: 'Rugby',
      readTime: '3 min read',
      date: 'Today',
    ),
    SportsArticle(
      id: 'art_3',
      title: 'The Evolution of T20 Cricket Bowling: Pace Variations and Yorkers',
      summary: 'Why deceptive slower balls and wide yorkers dominate death-over bowling plans.',
      fullContent:
          'As batter scoring rates exceed 10 runs per over in T20 tournaments, bowlers have evolved sophisticated arsenals. Knuckleballs, off-cutter grips, and pinpoint wide yorkers force batters to generate power without relying on the bowler pace.\n\nData analytics now map batter swing trajectories, allowing captains to place boundary riders at calculated release angles.',
      category: 'Cricket',
      readTime: '5 min read',
      date: 'Yesterday',
    ),
    SportsArticle(
      id: 'art_4',
      title: 'Aerobic Pacing Strategies for Distance Runners',
      summary: 'Optimizing carbohydrate utilization and lactate threshold management for marathons.',
      fullContent:
          'Endurance performance relies on metabolic pacing. Starting just 2% faster than target race pace can exhaust glycogen stores 15 kilometers early.\n\nElite runners monitor heart rate zones and cadence, ensuring smooth fuel burn and reserving high-intensity kick speed for the final 5 kilometers.',
      category: 'Running',
      readTime: '4 min read',
      date: '2 days ago',
    ),
  ];

  // Predefined Fun Facts
  final List<String> funFacts = const [
    'The fastest tennis serve on record was struck at 263.4 km/h (163.7 mph) by Sam Groth in 2012.',
    'A standard rugby union match sees players average between 6.5 and 7.5 kilometers of total distance run.',
    'The highest individual score in a test cricket innings is 400 not out by Brian Lara in 2004.',
    'FIFA World Cup balls have evolved from heavy leather stitched spheres to thermally bonded seamless spheres.',
  ];

  // Predefined Events (All labeled Example)
  final List<SportMatchEvent> events = const [
    SportMatchEvent(
      id: 'ev_1',
      sport: 'Football',
      tournament: 'South Africa Premiership',
      teamA: 'Mamelodi Sundowns',
      teamB: 'Orlando Pirates',
      time: '19:30',
      date: 'Today',
      status: 'Live',
      score: '2 - 1 (68\')',
      isExample: true,
    ),
    SportMatchEvent(
      id: 'ev_2',
      sport: 'Rugby',
      tournament: 'United Rugby Championship',
      teamA: 'Stormers',
      teamB: 'Bulls',
      time: '17:00',
      date: 'Today',
      status: 'Finished',
      score: '24 - 19',
      isExample: true,
    ),
    SportMatchEvent(
      id: 'ev_3',
      sport: 'Cricket',
      tournament: 'T20 International Cup',
      teamA: 'South Africa',
      teamB: 'India',
      time: '18:00',
      date: 'Tomorrow',
      status: 'Upcoming',
      score: null,
      isExample: true,
    ),
    SportMatchEvent(
      id: 'ev_4',
      sport: 'Football',
      tournament: 'Cape Town Derby',
      teamA: 'Cape Town City',
      teamB: 'Stellenbosch FC',
      time: '15:30',
      date: 'Tomorrow',
      status: 'Upcoming',
      score: null,
      isExample: true,
    ),
    SportMatchEvent(
      id: 'ev_5',
      sport: 'Rugby',
      tournament: 'URC Shield',
      teamA: 'Sharks',
      teamB: 'Lions',
      time: '20:15',
      date: 'Nov 3',
      status: 'Upcoming',
      score: null,
      isExample: true,
    ),
    SportMatchEvent(
      id: 'ev_6',
      sport: 'Tennis',
      tournament: 'Global Open Finals',
      teamA: 'C. Alcaraz',
      teamB: 'J. Sinner',
      time: '14:00',
      date: 'Nov 4',
      status: 'Upcoming',
      score: null,
      isExample: true,
    ),
  ];

  // Daily Quiz Questions
  final List<QuizQuestion> quizQuestions = const [
    QuizQuestion(
      id: 'q_1',
      question: 'Which country won the 2023 Rugby World Cup held in France?',
      options: ['South Africa', 'New Zealand', 'England', 'France'],
      correctIndex: 0,
      explanation: 'South Africa defeated New Zealand 12-11 in the final to lift the Webb Ellis Cup.',
    ),
    QuizQuestion(
      id: 'q_2',
      question: 'How many players are on the field for one team in a standard rugby union match?',
      options: ['11', '13', '15', '18'],
      correctIndex: 2,
      explanation: 'A standard rugby union squad fields 15 active players on the pitch.',
    ),
    QuizQuestion(
      id: 'q_3',
      question: 'What is the standard length of a marathon in kilometers?',
      options: ['40.00 km', '42.195 km', '44.50 km', '50.00 km'],
      correctIndex: 1,
      explanation: 'An official marathon distance is 42.195 kilometers (26 miles 385 yards).',
    ),
    QuizQuestion(
      id: 'q_4',
      question: 'Which surface is the Wimbledon Grand Slam tournament played on?',
      options: ['Clay', 'Hard Court', 'Grass', 'Carpet'],
      correctIndex: 2,
      explanation: 'Wimbledon is the world only major Grand Slam tournament played on traditional grass courts.',
    ),
  ];
}
