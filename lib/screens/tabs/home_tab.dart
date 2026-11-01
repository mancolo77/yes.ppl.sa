import 'package:flutter/material.dart';
import '../../models/sports_model.dart';
import '../../services/sports_data_service.dart';
import '../../theme/app_theme.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _service = SportsDataService();
  String _selectedCategory = 'All';
  int _activeFactIndex = 0;
  int? _selectedOption;
  bool _submittedQuiz = false;

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

  void _openArticleSheet(SportsArticle article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.cardRadius)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          final isFav = _service.isArticleFavorite(article.id);
          return DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (_, scrollController) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppTheme.border,
                        borderRadius: BorderRadius.circular(3),
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
                          color: AppTheme.sectionBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Text(
                          article.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.orangeAccent,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: isFav ? AppTheme.orangeAccent : AppTheme.textSecondary,
                        ),
                        onPressed: () {
                          _service.toggleArticleFavorite(article.id);
                          setSheetState(() {});
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
                    '${article.readTime} • ${article.date}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const Divider(height: 28, color: AppTheme.border),
                  Text(
                    article.fullContent,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: AppTheme.darkNavy,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Football', 'Rugby', 'Cricket', 'Running'];
    final filteredArticles = _selectedCategory == 'All'
        ? _service.articles
        : _service.articles.where((a) => a.category == _selectedCategory).toList();

    final dailyQuestion = _service.quizQuestions.first;
    final isAlreadyAnswered = _service.isQuestionAnswered(dailyQuestion.id);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // Top Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sports Hub',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkNavy,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Articles, trivia and sport highlights',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.sectionBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stars_rounded, color: AppTheme.orangeAccent, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${_service.points} pts',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Did You Know? Diagonal Decorated Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
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
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.lightbulb_outline_rounded, color: AppTheme.orangeAccent, size: 18),
                                const SizedBox(width: 6),
                                const Text(
                                  'SPORT FACT OF THE DAY',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.9,
                                    color: AppTheme.orangeAccent,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _activeFactIndex = (_activeFactIndex + 1) % _service.funFacts.length;
                                    });
                                  },
                                  child: const Text(
                                    'Next →',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _service.funFacts[_activeFactIndex],
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Daily Quiz Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.sectionBg,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.orangeAccent.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.quiz_rounded, color: AppTheme.orangeAccent, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daily Quiz Challenge',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkNavy,
                                ),
                              ),
                              Text(
                                '+15 pts for first correct answer',
                                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        if (isAlreadyAnswered)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.statusGreen.withAlpha(25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Answered',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.statusGreen,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      dailyQuestion.question,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkNavy,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(dailyQuestion.options.length, (idx) {
                      final isSelected = _selectedOption == idx;
                      Color itemBg = AppTheme.background;
                      Color itemBorder = AppTheme.border;
                      Color textColor = AppTheme.darkNavy;

                      if (_submittedQuiz || isAlreadyAnswered) {
                        if (idx == dailyQuestion.correctIndex) {
                          itemBg = AppTheme.statusGreen.withAlpha(20);
                          itemBorder = AppTheme.statusGreen;
                          textColor = AppTheme.statusGreen;
                        } else if (isSelected) {
                          itemBg = Colors.red.withAlpha(20);
                          itemBorder = Colors.red;
                          textColor = Colors.red;
                        }
                      } else if (isSelected) {
                        itemBg = AppTheme.orangeAccent.withAlpha(20);
                        itemBorder = AppTheme.orangeAccent;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: (_submittedQuiz || isAlreadyAnswered)
                              ? null
                              : () => setState(() => _selectedOption = idx),
                          borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: itemBg,
                              borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                              border: Border.all(color: itemBorder, width: isSelected ? 1.5 : 1),
                            ),
                            child: Text(
                              dailyQuestion.options[idx],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    if (!isAlreadyAnswered && !_submittedQuiz) ...[
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        height: AppTheme.buttonHeight,
                        child: ElevatedButton(
                          onPressed: _selectedOption == null
                              ? null
                              : () async {
                                  setState(() => _submittedQuiz = true);
                                  await _service.submitQuizAnswer(
                                    dailyQuestion.id,
                                    _selectedOption!,
                                    dailyQuestion.correctIndex,
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.orangeAccent,
                            foregroundColor: AppTheme.darkNavy,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                            ),
                          ),
                          child: const Text('Submit Answer'),
                        ),
                      ),
                    ],
                    if (_submittedQuiz || isAlreadyAnswered) ...[
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Text(
                          dailyQuestion.explanation,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Articles Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
              child: const Text(
                'Articles & Insights',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkNavy,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
              child: Row(
                children: categories.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
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
            const SizedBox(height: 14),

            // Articles List
            ...filteredArticles.map((art) {
              final isFav = _service.isArticleFavorite(art.id);
              return Padding(
                padding: const EdgeInsets.fromLTRB(AppTheme.screenPadding, 0, AppTheme.screenPadding, 12),
                child: InkWell(
                  onTap: () => _openArticleSheet(art),
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                      border: Border.all(color: AppTheme.border),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.sectionBg,
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
                            Row(
                              children: [
                                Text(
                                  art.readTime,
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () => _service.toggleArticleFavorite(art.id),
                                  child: Icon(
                                    isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                    size: 20,
                                    color: isFav ? AppTheme.orangeAccent : AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
