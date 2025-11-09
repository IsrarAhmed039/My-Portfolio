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

  Future<void> _openCV() async {
    const String cvUrl =
         "https://github.com/IsrarAhmed039/Personal-CV/raw/main/Israr_Ahmed_cv.pdf";

    await _openUrl(cvUrl);
  }

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
        openCV: _openCV,
        openWhatsApp: _openWhatsApp,
        openEmail: _email,
        openUrl: _openUrl,
      ),
    );
  }
}

// --------------------------
// PORTFOLIO PAGE
// --------------------------
class PortfolioPage extends StatelessWidget {
  final Color neonBlue;
  final Color neonPurple;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final ScrollController scrollController;
  final GlobalKey projectsKey;
  final GlobalKey certificationsKey;
  final Future<void> Function() openCV;
  final Future<void> Function() openWhatsApp;
  final Future<void> Function() openEmail;
  final Future<void> Function(String) openUrl;

  const PortfolioPage({
    super.key,
    required this.neonBlue,
    required this.neonPurple,
    required this.isDark,
    required this.onToggleTheme,
    required this.scrollController,
    required this.projectsKey,
    required this.certificationsKey,
    required this.openCV,
    required this.openWhatsApp,
    required this.openEmail,
    required this.openUrl,
  });

  Widget _sectionTitle(String text) {
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

  Widget _contactRow(
      {required IconData icon,
      required String label,
      required Color color,
      VoidCallback? onTap,
      bool neon = false}) {
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
                      BoxShadow(
                          color: neonPurple.withOpacity(0.24),
                          blurRadius: 16,
                          spreadRadius: 3),
                      BoxShadow(
                          color: neonBlue.withOpacity(0.18),
                          blurRadius: 26,
                          spreadRadius: 6),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 16),
                )
              : Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Flexible(
              child: Text(label, style: TextStyle(color: color, fontSize: 13))),
        ],
      ),
    );
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
            child: Text('Projects',
                style:
                    TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
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
                style:
                    TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          ),
          IconButton(
            tooltip: 'Download CV',
            onPressed: openCV,
            icon: const Icon(Icons.download_rounded),
            color: isDark ? Colors.white : Colors.black87,
          ),
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: onToggleTheme,
            icon: Icon(
                isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined),
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
            padding:
                EdgeInsets.symmetric(horizontal: isWide ? 72 : 20, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: _HeroArea(
                    neonBlue: neonBlue,
                    neonPurple: neonPurple,
                    mainGradient: mainGradient,
                    isWide: isWide,
                    openWhatsApp: openWhatsApp,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(height: 20),
                _sectionTitle('About Me'),
                Text(
                  "Flutter Developer focused on performant, beautiful cross-platform experiences. I build apps with clean architecture, thoughtful UX, and production-ready code.",
                  style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: isDark ? Colors.white70 : Colors.black87),
                ),
                const SizedBox(height: 18),
                _sectionTitle('Skills'),
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
                _sectionTitle('Contact'),
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _contactRow(
                      icon: Icons.email_outlined,
                      label: 'israrahmedgabole@gmail.com',
                      color: isDark ? Colors.white70 : Colors.black87,
                      onTap: openEmail,
                    ),
                    const SizedBox(height: 6),
                    _contactRow(
                      icon: Icons.phone_android,
                      label: '+92 307 8340514',
                      color: isDark ? Colors.white70 : Colors.black87,
                      onTap: () => openUrl('tel:+923078340514'),
                    ),
                    const SizedBox(height: 6),
                    _contactRow(
                      icon: FontAwesomeIcons.whatsapp,
                      label: 'Chat on WhatsApp',
                      color: isDark ? Colors.white70 : Colors.black87,
                      onTap: openWhatsApp,
                      neon: true,
                    ),
                    const SizedBox(height: 6),
                    _contactRow(
                      icon: Icons.person,
                      label: 'LinkedIn Profile',
                      color: isDark ? Colors.white70 : Colors.black87,
                      onTap: () => openUrl('https://www.linkedin.com/in/israrahmed039/'),
                    ),
                    const SizedBox(height: 6),
                    _contactRow(
                      icon: Icons.code,
                      label: 'GitHub Profile',
                      color: isDark ? Colors.white70 : Colors.black87,
                      onTap: () => openUrl('https://github.com/IsrarAhmed039/'),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                const SizedBox(height: 28),
                _sectionTitle('Projects'),
                const SizedBox(height: 10),
                _ProjectsGrid(
                    gradient: mainGradient, isDark: isDark, openUrl: openUrl, key: projectsKey),
                const SizedBox(height: 28),
                _sectionTitle('Certifications'),
                const SizedBox(height: 10),
                _CertificationsGrid(
                    gradient: mainGradient,
                    isDark: isDark,
                    openUrl: openUrl,
                    key: certificationsKey),
                
                // --------------------------
                // FOOTER START (with WhatsApp)
                // --------------------------
                const SizedBox(height: 40),
                Divider(color: Colors.white24, thickness: 1),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      Text(
                        '© ${DateTime.now().year} Israr Ahmed',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        children: [
                          _FooterIcon(
                              icon: FontAwesomeIcons.linkedin,
                              label: 'LinkedIn',
                              color: Colors.blueAccent,
                              onTap: () => openUrl('https://www.linkedin.com/in/israrahmed039/')),
                          _FooterIcon(
                              icon: FontAwesomeIcons.github,
                              label: 'GitHub',
                              color: Colors.white,
                              onTap: () => openUrl('https://github.com/IsrarAhmed039/')),
                          _FooterIcon(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              color: Colors.redAccent,
                              onTap: openEmail),
                          _FooterIcon(
                              icon: FontAwesomeIcons.whatsapp,
                              label: 'WhatsApp',
                              color: Colors.greenAccent,
                              onTap: openWhatsApp),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                // --------------------------
                // FOOTER END
                // --------------------------

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------
// FOOTER ICON WITH HOVER
// --------------------------
class _FooterIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FooterIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_FooterIcon> createState() => _FooterIconState();
}

class _FooterIconState extends State<_FooterIcon> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool isWeb = (Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.macOS ||
        Theme.of(context).platform == TargetPlatform.linux ||
        Theme.of(context).platform == TargetPlatform.fuchsia);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: _hovering && isWeb
              ? BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ],
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16, color: widget.color),
              const SizedBox(width: 4),
              Text(
                widget.label,
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          ),
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
                Text(project['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(project['desc']!, style: const TextStyle(fontSize: 13, color: Colors.white70)),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Visit Project', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 16)
                    ],
                  ),
                )
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
        'title': 'Flutter & Dart 6 Months Certificate',
        'desc': 'Completed a 6-month intensive course in Flutter & Dart development.',
        'url': 'https://drive.google.com/file/d/1AabcXYZ/view?usp=sharing'
      },
      {
        'title': 'Firebase Development Certificate',
        'desc': 'Certificate of Firebase backend integration with Flutter apps.',
        'url': 'https://drive.google.com/file/d/2BxyzABC/view?usp=sharing'
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
                Text(cert['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(cert['desc']!, style: const TextStyle(fontSize: 13, color: Colors.white70)),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View Certificate', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 16)
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
