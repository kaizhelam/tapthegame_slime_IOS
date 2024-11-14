import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tapthetarget_fantasy/mobile_screen.dart';

class StartGame extends StatefulWidget {
  const StartGame({super.key});

  @override
  _StartGameState createState() => _StartGameState();
}

class _StartGameState extends State<StartGame> {
  double _opacity1 = 1.0;
  double _opacity2 = 1.0;
  double _opacity3 = 1.0;
  final Random _random = Random();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        int selectedImage = _random.nextInt(3);
        if (selectedImage == 0) {
          _opacity1 = _opacity1 == 1.0 ? 0.0 : 1.0;
        } else if (selectedImage == 1) {
          _opacity2 = _opacity2 == 1.0 ? 0.0 : 1.0;
        } else {
          _opacity3 = _opacity3 == 1.0 ? 0.0 : 1.0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/menu-bg.png"),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: 0,
            left: 0,
              child: Center(
                child: Image.asset(
                  width: 380,
                  'assets/images/logo-menu.png',
                  fit: BoxFit.cover,
                ),
              ),
          ),
          // Start button
          Positioned(
            top: (MediaQuery.of(context).size.height - 100) / 1.35,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MobileViewScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(4, 4),
                            blurRadius: 8,
                          ),
                        ],
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFA8E6A1),
                            Color(0xFF388E3C),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Start",
                            style: GoogleFonts.lilitaOne(
                              textStyle: const TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                                letterSpacing: 2,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height - 100) / 1.15,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AnimatedOpacity(
                    opacity: _opacity1,
                    duration: const Duration(seconds: 1),
                    child: Image.asset("assets/images/target1.png"),
                  ),
                ),
                Expanded(
                  child: AnimatedOpacity(
                    opacity: _opacity2,
                    duration: const Duration(seconds: 1),
                    child: Image.asset("assets/images/target2.png"),
                  ),
                ),
                Expanded(
                  child: AnimatedOpacity(
                    opacity: _opacity3,
                    duration: const Duration(seconds: 1),
                    child: Image.asset("assets/images/target3.png"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
