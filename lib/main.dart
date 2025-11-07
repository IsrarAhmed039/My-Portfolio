import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatefulWidget {
  const MyPortfolioApp({super.key});

  @override
  State<MyPortfolioApp> createState() => _MyPortfolioAppState();
}

class _MyPortfolioAppState extends State<MyPortfolioApp> {
  bool isDark = true;

  final Color neonBlue = const Color(0xFF2575FC);
  final Color neonPurple = const Color(0xFF6A11CB);
  final Color softBgLight = const Color(0xFFF4F7FF);
  final Color softBgDark = const Color(0xFF0B0C10);

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _certificationsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Israr Ahmed • Portfolio',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: softBgLight,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: softBgDark,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B0C10),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: PortfolioPage(
        neonBlue: neonBlue,
        neonPurple: neonPurple,
        isDark: isDark,
        onToggleTheme: () => setState(() => isDark = !isDark),
        scrollController: _scrollController,
        projectsKey: _projectsKey,
        certificationsKey: _certificationsKey,
      ),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  final Color neonBlue;
  final Color neonPurple;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final ScrollController scrollController;
  final GlobalKey projectsKey;
  final GlobalKey certificationsKey;

  const PortfolioPage({
    super.key,
    required this.neonBlue,
    required this.neonPurple,
    required this.isDark,
    required this.onToggleTheme,
    required this.scrollController,
    required this.projectsKey,
    required this.certificationsKey,
  });

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint("Cannot launch $url");
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
    }
  }

  Future<void> _email() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'israrahmedgabole@gmail.com',
      queryParameters: {'subject': 'Contact from Portfolio'},
    );
    try {
      if (!await launchUrl(emailUri)) {
        debugPrint("Cannot open email app");
      }
    } catch (e) {
      debugPrint("Error opening email: $e");
    }
  }

  Future<void> _openWhatsApp() async {
    const String phone = "923078340514";
    final String message = Uri.encodeComponent(
        "Hello Israr, I visited your portfolio and I would like to connect with you.");
    final Uri whatsappUri = Uri.parse("https://wa.me/$phone?text=$message");

    try {
      if (!await launchUrl(whatsappUri, mode: LaunchMode.externalApplication)) {
        final Uri fallback =
            Uri.parse("https://web.whatsapp.com/send?phone=$phone&text=$message");
        if (!await launchUrl(fallback, mode: LaunchMode.externalApplication)) {
          debugPrint("Cannot open WhatsApp");
        }
      }
    } catch (e) {
      debugPrint("Error opening WhatsApp: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Gradient mainGradient = LinearGradient(
      colors: [neonPurple, neonBlue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final Size size = MediaQuery.of(context).size;
    final bool isWide = size.width > 900;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Israr Ahmed',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final ctx = projectsKey.currentContext;
              if (ctx != null) {
                Scrollable.ensureVisible(
                  ctx,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
              }
            },
            child:
                Text('Projects', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          ),
          TextButton(
            onPressed: () {
              final ctx = certificationsKey.currentContext;
              if (ctx != null) {
                Scrollable.ensureVisible(
                  ctx,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Text('Certifications',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          ),
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: onToggleTheme,
            icon: Icon(isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined),
            color: isDark ? Colors.white : Colors.black87,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              neonPurple.withOpacity(0.10),
              neonBlue.withOpacity(0.04),
              (isDark ? const Color(0xFF050506) : const Color(0xFFF4F7FF)),
            ],
            center: const Alignment(-0.8, -0.6),
            radius: 1.5,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: isWide ? 72 : 20, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: _HeroArea(
                    neonBlue: neonBlue,
                    neonPurple: neonPurple,
                    mainGradient: mainGradient,
                    isWide: isWide,
                    openWhatsApp: _openWhatsApp,
                    isDark: isDark, // pass current theme
                  ),
                ),
                const SizedBox(height: 20),
                _sectionTitle('About Me', isDark),
                Text(
                  "Flutter Developer focused on performant, beautiful cross-platform experiences. I build apps with clean architecture, thoughtful UX, and production-ready code.",
                  style: TextStyle(fontSize: 14, height: 1.4, color: isDark ? Colors.white70 : Colors.black87),
                ),
                const SizedBox(height: 18),
                _sectionTitle('Skills', isDark),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _TechChip(label: 'Flutter', gradient: mainGradient),
                    _TechChip(label: 'Dart', gradient: mainGradient),
                    _TechChip(label: 'Firebase', gradient: mainGradient),
                    _TechChip(label: 'REST API', gradient: mainGradient),
                    _TechChip(label: 'API Integration', gradient: mainGradient),
                    _TechChip(label: 'OOP Concepts', gradient: mainGradient),
                    _TechChip(label: 'Git', gradient: mainGradient),
                  ],
                ),
                const SizedBox(height: 20),
                _sectionTitle('Contact', isDark),
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _contactRow(
                      icon: Icons.email_outlined,
                      label: 'israrahmedgabole@gmail.com',
                      color: isDark ? Colors.white70 : Colors.black87,
                      onTap: _email,
                    ),
                    const SizedBox(height: 6),
                    _contactRow(
                      icon: Icons.phone_android,
                      label: '+92 307 8340514',
                      color: isDark ? Colors.white70 : Colors.black87,
                      onTap: () => _openUrl('tel:+923078340514'),
                    ),
                    const SizedBox(height: 6),
                    _contactRow(
                      icon: FontAwesomeIcons.whatsapp,
                      label: 'Chat on WhatsApp',
                      color: isDark ? Colors.white70 : Colors.black87,
                      onTap: _openWhatsApp,
                      neon: true,
                    ),
                    const SizedBox(height: 6),
                    _contactRow(
                      icon: Icons.person,
                      label: 'LinkedIn Profile',
                      color: isDark ? Colors.white70 : Colors.black87,
                      onTap: () => _openUrl('https://www.linkedin.com/in/israrahmed039/'),
                    ),
                    const SizedBox(height: 6),
                    _contactRow(
                      icon: Icons.code,
                      label: 'GitHub Profile',
                      color: isDark ? Colors.white70 : Colors.black87,
                      onTap: () => _openUrl('https://github.com/IsrarAhmed039/'),
                    ),
                    const SizedBox(height: 10),
                    _NeonButton(
                      gradient: mainGradient,
                      onTap: _email,
                      child: const Text('Send Email', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _sectionTitle('Projects', isDark),
                const SizedBox(height: 10),
                _ProjectsGrid(
                  key: projectsKey,
                  gradient: mainGradient,
                  isDark: isDark,
                  openUrl: _openUrl,
                ),
                const SizedBox(height: 28),
                _sectionTitle('Certifications', isDark),
                const SizedBox(height: 10),
                _CertificationsGrid(
                  key: certificationsKey,
                  gradient: mainGradient,
                  isDark: isDark,
                  openUrl: _openUrl,
                ),
                const SizedBox(height: 28),
                Divider(color: isDark ? Colors.white12 : Colors.black12),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('© ${DateTime.now().year} Israr Ahmed',
                        style: TextStyle(color: isDark ? Colors.white60 : Colors.black54)),
                    Row(
                      children: [
                        _IconGlowButton(
                          icon: FontAwesomeIcons.whatsapp,
                          gradient: mainGradient,
                          onTap: _openWhatsApp,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 6),
                        _IconGlowButton(
                          icon: Icons.person,
                          gradient: mainGradient,
                          onTap: () => _openUrl('https://www.linkedin.com/in/israrahmed039/'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 6),
                        _IconGlowButton(
                          icon: Icons.code,
                          gradient: mainGradient,
                          onTap: () => _openUrl('https://github.com/IsrarAhmed039/'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 6),
                        _IconGlowButton(
                          icon: Icons.mail_outline,
                          gradient: mainGradient,
                          onTap: _email,
                          isDark: isDark,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contactRow({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
    bool neon = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          neon
              ? Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [neonPurple, neonBlue]),
                    boxShadow: [
                      BoxShadow(color: neonPurple.withOpacity(0.24), blurRadius: 16, spreadRadius: 3),
                      BoxShadow(color: neonBlue.withOpacity(0.18), blurRadius: 26, spreadRadius: 6),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 16),
                )
              : Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Flexible(child: Text(label, style: TextStyle(color: color, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}

// --------------------------
// HERO AREA
// --------------------------
class _HeroArea extends StatelessWidget {
  final Color neonBlue;
  final Color neonPurple;
  final Gradient mainGradient;
  final bool isWide;
  final Future<void> Function() openWhatsApp;
  final bool isDark;

  const _HeroArea({
    super.key,
    required this.neonBlue,
    required this.neonPurple,
    required this.mainGradient,
    required this.isWide,
    required this.openWhatsApp,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    const double glowBlur = 24;
    const double glowSpread = 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: mainGradient,
            boxShadow: [
              BoxShadow(color: neonPurple.withOpacity(0.22), blurRadius: glowBlur, spreadRadius: glowSpread),
              BoxShadow(color: neonBlue.withOpacity(0.16), blurRadius: glowBlur + 6, spreadRadius: glowSpread + 6),
            ],
          ),
          child: CircleAvatar(
            radius: isWide ? 60 : 50,
            backgroundColor: Colors.black,
            backgroundImage: const AssetImage('assets/images/profile.png'),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Hi, I'm Israr Ahmed",
          style: TextStyle(
            fontSize: isWide ? 28 : 20,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        DefaultTextStyle(
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontSize: isWide ? 16 : 13,
          ),
          child: AnimatedTextKit(
            isRepeatingAnimation: true,
            repeatForever: true,
            animatedTexts: [
              TypewriterAnimatedText('Flutter Developer', speed: const Duration(milliseconds: 70)),
              TypewriterAnimatedText('Mobile & Cross-platform Apps', speed: const Duration(milliseconds: 70)),
              TypewriterAnimatedText('Clean Architecture • UX-focused', speed: const Duration(milliseconds: 70)),
            ],
          ),
        ),
      ],
    );
  }
}

// --------------------------
// NEON BUTTON
// --------------------------
class _NeonButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final VoidCallback onTap;

  const _NeonButton({super.key, required this.child, required this.gradient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(26)),
        child: DefaultTextStyle(style: const TextStyle(color: Colors.white, fontSize: 13), child: child),
      ),
    );
  }
}

// --------------------------
// TECH CHIP
// --------------------------
class _TechChip extends StatelessWidget {
  final String label;
  final Gradient gradient;

  const _TechChip({super.key, required this.label, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), gradient: gradient),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}

// --------------------------
// PROJECTS GRID
// --------------------------
class _ProjectsGrid extends StatelessWidget {
  final Gradient gradient;
  final bool isDark;
  final Future<void> Function(String) openUrl;

  const _ProjectsGrid({super.key, required this.gradient, required this.isDark, required this.openUrl});

  @override
  Widget build(BuildContext context) {
    final projects = [
      {
        'title': 'Notepad App',
        'desc': 'A real-time note-taking app with CRUD functionality using Firebase. Built with Flutter, featuring a clean UI and smooth UX.',
        'url': 'https://github.com/IsrarAhmed039/Notepad-Application'
      },
      {
        'title': 'JazzCash App',
        'desc': 'A mobile payment app with real-time transactions, wallet management, and secure payments, built using Flutter with Firebase backend.',
        'url': 'https://github.com/IsrarAhmed039/Dummy-JazzCash-App'
      },
      {
        'title': 'Portfolio Web/App',
        'desc': 'Responsive Flutter web / App portfolio showcasing skills and projects.',
        'url': 'https://github.com/IsrarAhmed039/My-Portfolio'
      },
    ];

    final width = MediaQuery.of(context).size.width;
    int cross = 1;
    if (width >= 1200) {
      cross = 3;
    } else if (width >= 800) {
      cross = 2;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: projects.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cross,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, index) {
        final project = projects[index];
        return GestureDetector(
          onTap: () => openUrl(project['url']!),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: gradient,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(project['desc']!,
                      style: const TextStyle(color: Colors.white70, fontSize: 13), overflow: TextOverflow.fade),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --------------------------
// CERTIFICATIONS GRID
// --------------------------
class _CertificationsGrid extends StatelessWidget {
  final Gradient gradient;
  final bool isDark;
  final Future<void> Function(String) openUrl;

  const _CertificationsGrid({super.key, required this.gradient, required this.isDark, required this.openUrl});

  @override
  Widget build(BuildContext context) {
    final certs = [
      {
        'title': 'Flutter & Dart (6-Month Certificate)',
        'desc': 'Gained hands-on experience building cross-platform mobile apps with Flutter & Dart, including UI design, state management, and API integratio.',
        'url': 'https://www.linkedin.com/posts/israrahmed039_flutter-dart-mobileappdevelopment-share-7391189423088050176-DvIu?utm_source=share&utm_medium=member_desktop&rcm=ACoAADxfw5UBvQdJ1CQTYSAQj8lP0CcXsCsO0HU',
      },
      {
        'title': 'Flutter & Dart (institute of SMIT)',
        'desc': 'Completed a 6-month intensive Flutter & Dart program, mastering cross-platform app development and clean architecture',
        'url': 'https://www.linkedin.com/posts/israrahmed039_flutter-dart-mobileappdevelopment-share-7391189423088050176-DvIu?utm_source=share&utm_medium=member_desktop&rcm=ACoAADxfw5UBvQdJ1CQTYSAQj8lP0CcXsCsO0HU',
      },
    ];

    final width = MediaQuery.of(context).size.width;
    int cross = 1;
    if (width >= 1200) {
      cross = 3;
    } else if (width >= 800) {
      cross = 2;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: certs.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cross,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, index) {
        final cert = certs[index];
        return GestureDetector(
          onTap: () => openUrl(cert['url']!),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: gradient,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cert['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(cert['desc']!,
                      style: const TextStyle(color: Colors.white70, fontSize: 13), overflow: TextOverflow.fade),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --------------------------
// ICON GLOW BUTTON
// --------------------------
class _IconGlowButton extends StatelessWidget {
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;
  final bool isDark;

  const _IconGlowButton({super.key, required this.icon, required this.gradient, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient,
          boxShadow: [
            BoxShadow(color: isDark ? Colors.white12 : Colors.black26, blurRadius: 6, spreadRadius: 1),
          ],
        ),
        child: Icon(icon, size: 16, color: isDark ? Colors.white : Colors.black87),
      ),
    );
  }
}
