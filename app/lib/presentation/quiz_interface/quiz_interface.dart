import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/answer_options_widget.dart';
import './widgets/feedback_widget.dart';
import './widgets/question_display_widget.dart';
import './widgets/quiz_header_widget.dart';
import './widgets/quiz_results_widget.dart';

class QuizInterface extends StatefulWidget {
  const QuizInterface({super.key});

  @override
  State<QuizInterface> createState() => _QuizInterfaceState();
}

class _QuizInterfaceState extends State<QuizInterface>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;

  int _currentQuestionIndex = 0;
  int _heartsRemaining = 5;
  int _timeRemaining = 30;
  int _selectedAnswerIndex = -1;
  bool _showFeedback = false;
  bool _showResults = false;
  bool _showHint = false;
  int _totalXP = 0;
  int _currentScore = 0;
  bool _streakMaintained = true;
  List<String> _unlockedBadges = [];

  // Mock quiz data
  final List<Map<String, dynamic>> _quizQuestions = [
    {
      "id": 1,
      "question": "What is the chemical formula for water?",
      "imageUrl":
          "https://images.unsplash.com/photo-1559827260-dc66d52bef19?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "options": ["H2O", "CO2", "NaCl", "CH4"],
      "correctIndex": 0,
      "explanation":
          "Water is composed of two hydrogen atoms and one oxygen atom, making its chemical formula H2O. This is one of the most fundamental compounds in chemistry and essential for all life on Earth.",
      "hint":
          "Think about the elements that make up water - hydrogen and oxygen. How many of each?",
      "xpReward": 10,
      "subject": "Chemistry",
      "difficulty": "Easy"
    },
    {
      "id": 2,
      "question": "Which planet is known as the 'Red Planet'?",
      "imageUrl":
          "https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "options": ["Venus", "Mars", "Jupiter", "Saturn"],
      "correctIndex": 1,
      "explanation":
          "Mars is called the 'Red Planet' because of its reddish appearance, which comes from iron oxide (rust) on its surface. This distinctive color has been observed by humans for thousands of years.",
      "hint":
          "This planet is named after the Roman god of war and appears reddish in the night sky.",
      "xpReward": 10,
      "subject": "Astronomy",
      "difficulty": "Easy"
    },
    {
      "id": 3,
      "question": "What is the speed of light in a vacuum?",
      "imageUrl":
          "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "options": [
        "300,000 km/s",
        "299,792,458 m/s",
        "150,000 km/s",
        "500,000 km/s"
      ],
      "correctIndex": 1,
      "explanation":
          "The speed of light in a vacuum is exactly 299,792,458 meters per second. This is a fundamental constant in physics and forms the basis of Einstein's theory of relativity.",
      "hint":
          "This is one of the most important constants in physics, approximately 300 million meters per second.",
      "xpReward": 15,
      "subject": "Physics",
      "difficulty": "Medium"
    },
    {
      "id": 4,
      "question": "What is the powerhouse of the cell?",
      "imageUrl":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "options": [
        "Nucleus",
        "Mitochondria",
        "Ribosome",
        "Endoplasmic Reticulum"
      ],
      "correctIndex": 1,
      "explanation":
          "Mitochondria are known as the powerhouse of the cell because they produce ATP (adenosine triphosphate), which is the main energy currency used by cells for various biological processes.",
      "hint":
          "This organelle is responsible for cellular respiration and energy production.",
      "xpReward": 10,
      "subject": "Biology",
      "difficulty": "Easy"
    },
    {
      "id": 5,
      "question": "What is the derivative of x² with respect to x?",
      "imageUrl":
          "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "options": ["x", "2x", "x²", "2x²"],
      "correctIndex": 1,
      "explanation":
          "Using the power rule of differentiation, the derivative of x² is 2x¹ = 2x. The power rule states that d/dx(xⁿ) = n·xⁿ⁻¹.",
      "hint":
          "Remember the power rule: bring down the exponent and reduce the power by 1.",
      "xpReward": 15,
      "subject": "Mathematics",
      "difficulty": "Medium"
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startTimer();
  }

  void _initializeControllers() {
    _pageController = PageController();
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heartAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _timeRemaining > 0 && !_showFeedback && !_showResults) {
        setState(() {
          _timeRemaining--;
        });
        _startTimer();
      } else if (_timeRemaining == 0 && !_showFeedback) {
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    if (_selectedAnswerIndex == -1) {
      _handleAnswerSelection(-1); // No answer selected
    }
  }

  void _handleAnswerSelection(int selectedIndex) {
    if (_showFeedback) return;

    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _showFeedback = true;
    });

    final currentQuestion = _quizQuestions[_currentQuestionIndex];
    final isCorrect = selectedIndex == currentQuestion["correctIndex"];

    if (isCorrect) {
      setState(() {
        _currentScore++;
        _totalXP += (currentQuestion["xpReward"] as int);
      });
      _checkForBadgeUnlocks();
    } else {
      _loseHeart();
    }

    // Provide haptic feedback
    if (isCorrect) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  void _loseHeart() {
    if (_heartsRemaining > 0) {
      setState(() {
        _heartsRemaining--;
      });
      _heartController.forward().then((_) {
        _heartController.reverse();
      });

      if (_heartsRemaining == 0) {
        _streakMaintained = false;
      }
    }
  }

  void _checkForBadgeUnlocks() {
    List<String> newBadges = [];

    if (_currentScore == 1) {
      newBadges.add("First Correct Answer");
    }
    if (_currentScore == 3) {
      newBadges.add("Triple Threat");
    }
    if (_currentScore == _quizQuestions.length) {
      newBadges.add("Perfect Score");
    }
    if (_heartsRemaining == 5 &&
        _currentQuestionIndex == _quizQuestions.length - 1) {
      newBadges.add("Flawless Victory");
    }

    setState(() {
      _unlockedBadges.addAll(newBadges);
    });
  }

  void _handleHintRequest() {
    if (_heartsRemaining > 0 && !_showHint) {
      setState(() {
        _heartsRemaining--;
        _showHint = true;
      });
      _heartController.forward().then((_) {
        _heartController.reverse();
      });
    }
  }

  void _handleContinue() {
    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = -1;
        _showFeedback = false;
        _showHint = false;
        _timeRemaining = 30;
      });
      _startTimer();
    } else {
      setState(() {
        _showResults = true;
      });
    }
  }

  void _handleBackPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Exit Quiz?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          content: Text(
            'Are you sure you want to exit? Your progress will be lost.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.primaryLight),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Exit',
                style: TextStyle(color: AppTheme.errorLight),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleRetakeQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _heartsRemaining = 5;
      _timeRemaining = 30;
      _selectedAnswerIndex = -1;
      _showFeedback = false;
      _showResults = false;
      _showHint = false;
      _totalXP = 0;
      _currentScore = 0;
      _streakMaintained = true;
      _unlockedBadges.clear();
    });
    _startTimer();
  }

  void _handleBackToDashboard() {
    Navigator.pushNamed(context, '/student-dashboard');
  }

  void _handleShareResults() {
    // Mock share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Results shared successfully!'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_showResults) {
      return Scaffold(
        body: QuizResultsWidget(
          score: _currentScore,
          totalQuestions: _quizQuestions.length,
          xpEarned: _totalXP,
          heartsRemaining: _heartsRemaining,
          streakMaintained: _streakMaintained,
          badgesUnlocked: _unlockedBadges,
          onRetakeQuiz: _handleRetakeQuiz,
          onBackToDashboard: _handleBackToDashboard,
          onShareResults: _handleShareResults,
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          Column(
            children: [
              QuizHeaderWidget(
                currentQuestion: _currentQuestionIndex + 1,
                totalQuestions: _quizQuestions.length,
                heartsRemaining: _heartsRemaining,
                timeRemaining: _timeRemaining,
                onBackPressed: _handleBackPressed,
                onHintPressed: _handleHintRequest,
                isHintAvailable: _heartsRemaining > 0 && !_showHint,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      QuestionDisplayWidget(
                        questionText: _quizQuestions[_currentQuestionIndex]
                            ["question"],
                        imageUrl: _quizQuestions[_currentQuestionIndex]
                            ["imageUrl"],
                        hint: _quizQuestions[_currentQuestionIndex]["hint"],
                        showHint: _showHint,
                      ),
                      SizedBox(height: 3.h),
                      AnswerOptionsWidget(
                        options: List<String>.from(
                            _quizQuestions[_currentQuestionIndex]["options"]),
                        selectedIndex: _selectedAnswerIndex,
                        correctIndex: _showFeedback
                            ? _quizQuestions[_currentQuestionIndex]
                                ["correctIndex"]
                            : null,
                        showResults: _showFeedback,
                        onOptionSelected: _handleAnswerSelection,
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_showFeedback)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: FeedbackWidget(
                    isCorrect: _selectedAnswerIndex ==
                        _quizQuestions[_currentQuestionIndex]["correctIndex"],
                    explanation: _quizQuestions[_currentQuestionIndex]
                        ["explanation"],
                    xpGained: _selectedAnswerIndex ==
                            _quizQuestions[_currentQuestionIndex]
                                ["correctIndex"]
                        ? _quizQuestions[_currentQuestionIndex]["xpReward"]
                        : 0,
                    onContinue: _handleContinue,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
