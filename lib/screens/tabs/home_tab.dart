import 'package:flutter/material.dart';
import '../../services/user_progress_service.dart';
import '../../theme/app_theme.dart';

class ArticleItem {
  final String id;
  final String category;
  final String title;
  final String summary;
  final String content;
  final String readTime;

  const ArticleItem({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.content,
    required this.readTime,
  });
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final UserProgressService _progress = UserProgressService();

  int _selectedQuizAnswer = -1;
  bool _quizSubmitted = false;

  final List<ArticleItem> _articles = const [
    ArticleItem(
      id: 'yes_art_1',
      category: 'Спортивная тактика',
      title: 'Быстрые отрывы и позиционные розыгрыши в игровых видах',
      summary: 'Как слаженные действия связующих игроков меняют баланс сил на площадке.',
      content: 'Быстрый отрыв основывается на мгновенной передаче мяча вперед сразу после подбора или перехвата. Защитники не успевают выстроить зонную оборону, что дает нападающим численное преимущество 3 в 2 или 2 в 1.',
      readTime: '3 мин',
    ),
    ArticleItem(
      id: 'yes_art_2',
      category: 'Физиология спорта',
      title: 'Аэробная выносливость и интервальные спринты',
      summary: 'Тренировочные протоколы для поддержания максимальной скорости в концовке встреч.',
      content: 'Интервальный бег развивает максимальное потребление кислорода (VO2 max). Атлеты чередуют 30-секундные ускорения с 90 секундами легкого бега, моделируя реальные игровые сценарии матча.',
      readTime: '4 мин',
    ),
    ArticleItem(
      id: 'yes_art_3',
      category: 'Спортивный инвентарь',
      title: 'Эволюция обуви для бега и игровых покрытий',
      summary: 'Как амортизирующие пены и карбоновые пластины сохраняют суставы атлетов.',
      content: 'Современные подошвы кроссовок обеспечивают возврат до 85% энергии удара о покрытие, снижая утомляемость мышц голени и снижая риск микротравм ахиллова сухожилия.',
      readTime: '2 мин',
    ),
  ];

  final List<String> _facts = [
    'Футбольный мяч при ударе деформируется почти на 20% своего объема на доли секунды.',
    'Профессиональный секундомер фиксирует время с точностью до одной тысячной доли секунды.',
    'Вес стандартного баскетбольного мяча составляет от 567 до 650 граммов.',
  ];

  void _openArticleDetails(ArticleItem article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.cardRadius)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isSaved = _progress.savedArticleIds.contains(article.id);
            return Container(
              padding: const EdgeInsets.all(AppTheme.screenPadding),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceSection,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            article.category,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textAccent,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            color: AppTheme.primary,
                          ),
                          onPressed: () {
                            _progress.toggleSaveArticle(article.id);
                            setModalState(() {});
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkNavy,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Время чтения: ${article.readTime}',
                      style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppTheme.border),
                    const SizedBox(height: 16),
                    Text(
                      article.content,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppTheme.darkNavy,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: AppTheme.buttonHeight,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Понятно'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    'Главная',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkNavy,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceSection,
                      borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: AppTheme.primary, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          '${_progress.points} баллов',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Спортивная информация, события и достижения',
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 18),

              // 1. Тёмно-синий баннер с оранжевыми полосами
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.darkNavy,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  boxShadow: AppTheme.cardShadow,
                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.darkNavy,
                      AppTheme.navyPattern,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.flash_on_rounded, color: AppTheme.darkNavy, size: 22),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'ВИКТОРИНА ДНЯ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '+30 баллов',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkNavy),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Какова стандартная высота баскетбольного кольца от пола?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...[
                      '2.90 метра',
                      '3.05 метра',
                      '3.20 метра',
                    ].asMap().entries.map((entry) {
                      final idx = entry.key;
                      final optionText = entry.value;
                      final isSelected = _selectedQuizAnswer == idx;
                      final isCorrect = (idx == 1);

                      Color btnColor = Colors.white.withAlpha(20);
                      if (_quizSubmitted) {
                        if (isCorrect) btnColor = const Color(0xFF5F9E38);
                        if (isSelected && !isCorrect) btnColor = const Color(0xFFD32F2F);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: _quizSubmitted
                              ? null
                              : () {
                                  setState(() {
                                    _selectedQuizAnswer = idx;
                                    _quizSubmitted = true;
                                    if (isCorrect) {
                                      _progress.recordQuizCompleted(30);
                                    }
                                  });
                                },
                          borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: btnColor,
                              borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                              border: Border.all(
                                color: isSelected ? AppTheme.primary : Colors.white24,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  optionText,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                if (_quizSubmitted && isCorrect)
                                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20)
                                else if (_quizSubmitted && isSelected && !isCorrect)
                                  const Icon(Icons.cancel_rounded, color: Colors.white70, size: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. Статьи в белых карточках (#FFFFFF)
              const Text(
                'Спортивные статьи',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkNavy,
                ),
              ),
              const SizedBox(height: 12),
              ..._articles.map((art) {
                final isSaved = _progress.savedArticleIds.contains(art.id);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    border: Border.all(color: AppTheme.border),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: InkWell(
                    onTap: () => _openArticleDetails(art),
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceSection,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                art.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textAccent,
                                ),
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                color: isSaved ? AppTheme.primary : AppTheme.textSecondary,
                                size: 22,
                              ),
                              onPressed: () => _progress.toggleSaveArticle(art.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          art.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkNavy,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          art.summary,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),

              // 3. Факты дня
              const Text(
                'Спортивный факт',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkNavy,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceSection,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppTheme.primary, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _facts[DateTime.now().minute % _facts.length],
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

