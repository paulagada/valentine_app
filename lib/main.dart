import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

void main() {
  runApp(const ValentineApp());
}

class ValentineApp extends StatelessWidget {
  const ValentineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'For My Queen Elizabeth ❤️',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          primary: const Color(0xFFD81B60),
          secondary: const Color(0xFFF06292),
          surface: Colors.white.withOpacity(0.9),
        ),
        textTheme: GoogleFonts.dancingScriptTextTheme(),
        useMaterial3: true,
      ),
      home: const ExperienceToggle(),
    );
  }
}

// Browser policy requires user interaction for audio/video
class ExperienceToggle extends StatefulWidget {
  const ExperienceToggle({super.key});

  @override
  State<ExperienceToggle> createState() => _ExperienceToggleState();
}

class _ExperienceToggleState extends State<ExperienceToggle> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    if (_started) return const ValentineHome();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF1F1), Color(0xFFFFE4E1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, color: Colors.pink, size: 80)
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(duration: 1.seconds, curve: Curves.easeInOut)
                  .then()
                  .scale(duration: 1.seconds, curve: Curves.easeInOut),
              const SizedBox(height: 30),
              Text(
                    "A Special Message for Elizabeth",
                    style: GoogleFonts.dancingScript(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[800],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 1.seconds)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => setState(() => _started = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
                child: const Text(
                  "Start Experience ✨",
                  style: TextStyle(fontSize: 20),
                ),
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
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
  late AudioPlayer _audioPlayer;

  // Potential Video/Music paths
  static const String musicPath =
      'audio/audio.mp3'; // User should place file here
  static const String videoPath =
      'video/romance.mp4'; // User should place file here

  double? _noBtnTop;
  double? _noBtnLeft;

  final List<String> _images = [
    'assets/images/elizabeth_1.jpg',
    'assets/images/elizabeth_2.jpg',
    'assets/images/elizabeth_3.jpg',
    'assets/images/elizabeth_4.jpg',
    'assets/images/elizabeth_5.jpg',
    'assets/images/elizabeth_6.jpg',
    'assets/images/elizabeth_7.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 15),
    );
    _audioPlayer = AudioPlayer();
    _playBackgroundMusic();
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      // We check if asset exists in a real scenario, but here we assume path
      await _audioPlayer.play(AssetSource(musicPath));
    } catch (e) {
      debugPrint("Music autoplay failed (expected if file missing): $e");
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onNoButtonHovered() {
    setState(() {
      final size = MediaQuery.of(context).size;
      final random = Random();
      _noBtnTop = random.nextDouble() * (size.height - 120) + 60;
      _noBtnLeft = random.nextDouble() * (size.width - 120) + 60;
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
      return SuccessScreen(
        images: _images,
        confettiController: _confettiController,
        videoUrl: videoPath,
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFAF0), Color(0xFFFFF0F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background Animation (Hearts)
            ...List.generate(12, (index) {
              final random = Random();
              return Positioned(
                top:
                    random.nextDouble() *
                    1000 %
                    MediaQuery.of(context).size.height,
                left:
                    random.nextDouble() *
                    1000 %
                    MediaQuery.of(context).size.width,
                child:
                    Icon(
                          Icons.favorite,
                          color: Colors.pink.withOpacity(0.1),
                          size: 20 + random.nextDouble() * 60,
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveY(
                          begin: 0,
                          end: -100,
                          duration: (3 + random.nextInt(3)).seconds,
                          curve: Curves.easeInOut,
                        )
                        .fadeIn(duration: 1.seconds)
                        .then()
                        .fadeOut(duration: 1.seconds),
              );
            }),

            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: min(500, MediaQuery.of(context).size.width * 0.9),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                              'Dear Elizabeth...',
                              style: GoogleFonts.dancingScript(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink[900],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .slideX(begin: -0.2, end: 0),
                        const SizedBox(height: 15),
                        Text(
                          'In you, I found my world. 🌎✨',
                          style: GoogleFonts.dancingScript(
                            fontSize: 24,
                            color: Colors.pink[700],
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 500.ms),
                        const SizedBox(height: 30),
                        Text(
                          'Will you be my Valentine?',
                          style: GoogleFonts.dancingScript(
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink[800],
                          ),
                          textAlign: TextAlign.center,
                        ).animate().scale(
                          delay: 1.seconds,
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                  onPressed: _accept,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink[600],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 8,
                                  ),
                                  child: const Text(
                                    'YES! ❤️',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .scale(
                                  begin: const Offset(1, 1),
                                  end: const Offset(1.1, 1.1),
                                  duration: 1.seconds,
                                ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Sneaky No Button
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              top: _noBtnTop ?? MediaQuery.of(context).size.height / 2 + 150,
              left: _noBtnLeft ?? MediaQuery.of(context).size.width / 2 + 50,
              child: MouseRegion(
                onEnter: (_) => _onNoButtonHovered(),
                child: GestureDetector(
                  onTap: _onNoButtonHovered,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Text(
                      'No 🙈',
                      style: TextStyle(color: Colors.pink, fontSize: 16),
                    ),
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

class SuccessScreen extends StatefulWidget {
  final List<String> images;
  final ConfettiController confettiController;
  final String videoUrl;

  const SuccessScreen({
    super.key,
    required this.images,
    required this.confettiController,
    required this.videoUrl,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() {
    _videoController = VideoPlayerController.asset("assets/${widget.videoUrl}")
      ..initialize()
          .then((_) {
            setState(() {
              _isVideoInitialized = true;
            });
            _videoController.setLooping(true);
          })
          .catchError((e) {
            debugPrint("Video init failed: $e");
          });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFB6C1),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text(
                  'YAY! I AM THE HAPPIEST! 😍',
                  style: GoogleFonts.dancingScript(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ).animate().shimmer(duration: 2.seconds),
                const SizedBox(height: 10),
                Text(
                  'My Queen, Elizabeth ❤️',
                  style: GoogleFonts.dancingScript(
                    fontSize: 32,
                    color: Colors.white70,
                  ),
                ).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: 30),

                // Video Section
                if (_isVideoInitialized)
                  Container(
                    width: min(600, MediaQuery.of(context).size.width * 0.9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_videoController),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: IconButton(
                              icon: Icon(
                                _videoController.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () => setState(
                                () => _videoController.value.isPlaying
                                    ? _videoController.pause()
                                    : _videoController.play(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().scale(duration: 800.ms, curve: Curves.elasticOut)
                else
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "(Video will appear here once you add romance.mp4 to assets/video/)",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                const SizedBox(height: 40),
                const Text(
                  "YOUR BEAUTIFUL FACES",
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Enhanced Gallery
                SizedBox(
                  height: 450,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.images.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Hero(
                          tag: 'img-$index',
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                image: AssetImage(widget.images[index]),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pink.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: (200 * index).ms).scale();
                    },
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'I Love You Forever... 😘',
                  style: TextStyle(fontSize: 30, color: Colors.white70),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: widget.confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              colors: const [
                Colors.red,
                Colors.pink,
                Colors.white,
                Colors.orange,
                Color(0xFFFFD700),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
