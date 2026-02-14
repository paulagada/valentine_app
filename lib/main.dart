import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ValentineApp());
}

class ValentineApp extends StatelessWidget {
  const ValentineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'For My Elizabeth ❤️',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pinkAccent,
          primary: Colors.pink,
          secondary: Colors.pinkAccent,
        ),
        textTheme: GoogleFonts.dancingScriptTextTheme(),
        useMaterial3: true,
      ),
      home: const ValentineHome(),
    );
  }
}

class ValentineHome extends StatefulWidget {
  const ValentineHome({super.key});

  @override
  State<ValentineHome> createState() => _ValentineHomeState();
}

class _ValentineHomeState extends State<ValentineHome> {
  bool _isAccepted = false;
  late ConfettiController _confettiController;

  // Position for the dodge button
  double? _noBtnTop;
  double? _noBtnLeft;

  final List<String> _images = [
    'assets/images/elizabeth_1.jpg',
    'assets/images/elizabeth_2.jpg',
    'assets/images/elizabeth_3.jpg',
    'assets/images/elizabeth_4.jpg',
    'assets/images/elizabeth_5.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 10),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _onNoButtonHovered() {
    setState(() {
      final size = MediaQuery.of(context).size;
      final random = Random();

      // Make sure the button stays within screen bounds
      // Assuming button size is roughly 100x50
      _noBtnTop = random.nextDouble() * (size.height - 100);
      _noBtnLeft = random.nextDouble() * (size.width - 100);
    });
  }

  void _accept() {
    setState(() {
      _isAccepted = true;
    });
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAccepted) {
      return _buildSuccessScreen();
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink[50]!, Colors.white],
          ),
        ),
        child: Stack(
          children: [
            // Floating Hearts Decoration
            ...List.generate(6, (index) {
              final random = Random();
              return Positioned(
                top: random.nextDouble() * MediaQuery.of(context).size.height,
                left: random.nextDouble() * MediaQuery.of(context).size.width,
                child: Icon(
                  Icons.favorite,
                  color: Colors.pink.withOpacity(0.2),
                  size: 40 + random.nextDouble() * 40,
                ),
              );
            }),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Hey Elizabeth... 💖',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Will you be my Valentine?',
                        style: TextStyle(fontSize: 36, color: Colors.pink[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _accept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          elevation: 10,
                        ),
                        child: const Text('Yes! 💍'),
                      ),
                      const SizedBox(width: 40),
                      // The sneaky No button
                    ],
                  ),
                ],
              ),
            ),

            // The Dodging No Button
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: _noBtnTop ?? MediaQuery.of(context).size.height / 2 + 50,
              left: _noBtnLeft ?? MediaQuery.of(context).size.width / 2 + 80,
              child: MouseRegion(
                onEnter: (_) => _onNoButtonHovered(),
                child: ElevatedButton(
                  onPressed: _onNoButtonHovered,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('No 😜'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink[100]!, Colors.pink[300]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 60),
              Text(
                'I KNEW YOU WOULD SAY YES! 😍',
                style: GoogleFonts.dancingScript(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    const Shadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'I love you so much Elizabeth ❤️',
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
              const SizedBox(height: 30),

              // Image Gallery
              Expanded(
                child: PageView.builder(
                  itemCount: _images.length,
                  controller: PageController(viewportFraction: 0.8),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(_images[index], fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),
              const Text(
                'Scroll to see more of you... 😘',
                style: TextStyle(fontSize: 24, color: Colors.white70),
              ),
              const SizedBox(height: 60),
            ],
          ),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
              colors: const [
                Colors.red,
                Colors.pink,
                Colors.white,
                Colors.orange,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
