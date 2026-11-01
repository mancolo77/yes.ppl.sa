class SportsArticle {
  final String id;
  final String title;
  final String summary;
  final String fullContent;
  final String category;
  final String readTime;
  final String date;

  const SportsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.fullContent,
    required this.category,
    required this.readTime,
    required this.date,
  });
}

class SportMatchEvent {
  final String id;
  final String sport;
  final String tournament;
  final String teamA;
  final String teamB;
  final String time;
  final String date;
  final String status; // 'Live', 'Upcoming', 'Finished'
  final String? score;
  final bool isExample;

  const SportMatchEvent({
    required this.id,
    required this.sport,
    required this.tournament,
    required this.teamA,
    required this.teamB,
    required this.time,
    required this.date,
    required this.status,
    this.score,
    this.isExample = true,
  });
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class BadgeItem {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final int requiredPoints;

  const BadgeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.requiredPoints,
  });
}

