import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileViewScreen extends StatefulWidget {
  const MobileViewScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MobileViewScreenState();
  }
}

class _MobileViewScreenState extends State<MobileViewScreen> with TickerProviderStateMixin {
  String currentImage = "";
  Offset targetPosition = const Offset(180, 160);
  int score = 0;
  int timeLeft = 0;
  bool gameStart = false;
  bool showWellDoneText = false;
  late Timer gameTimer;
  late AnimationController _controller;
  late AnimationController _fadeController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _fadeAnimation;

  void _startGame() {
    setState(() {
      score = 0;
      timeLeft = 60;
      gameStart = true;
      currentImage = "assets/images/target1.png";
      targetPosition = Offset(180, 160);
    });

    _fadeController.forward(); // Start fade animation

    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          gameStart = false;
          _showGameOverDialog();
        }
      });
    });
  }

  void _moveTarget() {
    final random = Random();
    int randomNumber = random.nextInt(3) + 1;
    final screenSize = MediaQuery.of(context).size;

    final x = random.nextDouble() * (screenSize.width - 180).clamp(0, screenSize.width - 180);
    final y = max(170.0, random.nextDouble() * (screenSize.height - 180).clamp(0, screenSize.height - 180));

    setState(() {
      currentImage = "assets/images/target$randomNumber.png";
      targetPosition = Offset(x, y);
    });
    _fadeController.forward();
  }

  void updateImageAndIncreaseScore() {
    setState(() {
      _increaseScore();
      _fadeController.reverse().then((_) => _moveTarget());
    });
  }

  void _increaseScore() {
    score++;
    if (score % 10 == 0) {
      _showWellDoneAnimation();
    }
  }

  void _showWellDoneAnimation() {
    setState(() {
      showWellDoneText = true;
    });
    _controller.forward();

    Future.delayed(const Duration(seconds: 1), () {
      _controller.reverse().then((_) {
        setState(() {
          showWellDoneText = false;
        });
      });
    });
  }

  void _showDialog(BuildContext context, String title, String message, String buttonText, Function onButtonPressed) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 310,
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/popup.png'),
                  fit: BoxFit.cover
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lilitaOne(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      message,
                      style: GoogleFonts.lilitaOne(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        onButtonPressed();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.restart_alt,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            buttonText,
                            style: GoogleFonts.lilitaOne(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showGameOverDialog() {
    _showDialog(
      context,
      "Game Over",
      "Your score is $score",
      "Restart",
      _startGame,
    );
  }

  @override
  void initState() {
    super.initState();

    // Initialize the animation controllers before starting the game
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    _controller.addListener(() {
      setState(() {});
    });

    _fadeController.addListener(() {
      setState(() {});
    });

    // Now call the start game function after controllers are initialized
    _startGame();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    gameTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg.jpg"), fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 0,
              right: 25,
              left: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Score ',
                          style: GoogleFonts.lilitaOne(
                            textStyle: const TextStyle(
                                color: Colors.black, fontSize: 35),
                          ),
                        ),
                        TextSpan(
                          text: '$score',
                          style: GoogleFonts.lilitaOne(
                            textStyle: const TextStyle(
                                color: Color(0xFFAD975E), fontSize: 35),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Time ',
                          style: GoogleFonts.lilitaOne(
                            textStyle: const TextStyle(
                                color: Colors.black, fontSize: 35),
                          ),
                        ),
                        TextSpan(
                          text: '$timeLeft',
                          style: GoogleFonts.lilitaOne(
                            textStyle: const TextStyle(
                                color: Color(0xFFAD975E), fontSize: 35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (gameStart)
              Positioned(
                left: targetPosition.dx,
                top: targetPosition.dy,
                child: GestureDetector(
                  onTap: updateImageAndIncreaseScore,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Image.asset(
                      currentImage,
                      width: 180,
                      height: 180,
                    ),
                  ),
                ),
              ),
            if (showWellDoneText)
              IgnorePointer(
                child: Center(
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Stack(
                      children: [
                        Text(
                          "Well Done!",
                          style: GoogleFonts.lilitaOne(
                            textStyle: TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          "Well Done!",
                          style: GoogleFonts.lilitaOne(
                            textStyle: const TextStyle(
                              color: Color(0xFFFFE135),
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                            ),
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
    );
  }
}
