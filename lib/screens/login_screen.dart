import 'dart:math';
import 'package:attendance_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _starController;
  late AnimationController _meteorController;
  late AnimationController _scanController;
  late AnimationController _logoController;

  static const cyan = Color(0xFF00E5FF);
  static const accentBlue = Color(0xFF2979FF);
  static const green = Color(0xFF00E676);
  static const amber = Color(0xFFFFC400);

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _meteorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _starController.dispose();
    _meteorController.dispose();
    _scanController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------
  // DIALOGS
  // ------------------------------------------------------------------

  void _showTeacherLoginDialog(BuildContext context) {
    final teacherIdController = TextEditingController();
    final passwordController = TextEditingController();
    bool obscurePassword = true;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Teacher Login",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Center(
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: 380,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: const Color(0xFF071018).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: cyan.withOpacity(0.35),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: cyan.withOpacity(0.25),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: cyan, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: cyan.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Icon(Icons.school_rounded,
                                size: 32, color: cyan),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "TEACHER LOGIN",
                            style: GoogleFonts.orbitron(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Access your mission dashboard",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _glassTextField(
                            controller: teacherIdController,
                            label: "TEACHER ID",
                            icon: Icons.badge_outlined,
                          ),
                          const SizedBox(height: 16),
                          _glassTextField(
                            controller: passwordController,
                            label: "PASSWORD",
                            icon: Icons.lock_outline_rounded,
                            obscureText: obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              onPressed: () {
                                setStateDialog(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 28),
                          _gradientButton(
                            label: "LOGIN",
                            icon: Icons.arrow_forward_rounded,
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/teacher-dashboard',
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "CANCEL",
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 12,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim1.value),
          child: Opacity(
            opacity: anim1.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
    );
  }

  void _showStudentLoginDialog(BuildContext context) {
    final studentIdController = TextEditingController();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Student Login",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 380,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF071018).withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: cyan.withOpacity(0.35),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cyan.withOpacity(0.25),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: cyan, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: cyan.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(Icons.face_retouching_natural_rounded,
                            size: 32, color: cyan),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "STUDENT LOGIN",
                        style: GoogleFonts.orbitron(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Enter your student ID to continue",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _glassTextField(
                        controller: studentIdController,
                        label: "STUDENT ID",
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 28),
                      _gradientButton(
                        label: "CONTINUE",
                        icon: Icons.arrow_forward_rounded,
                        onTap: () async {

  final studentId =
      studentIdController.text.trim();

  if (studentId.isEmpty) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Enter Student ID",
        ),
      ),
    );

    return;
  }

  try {

    final api = ApiService();

    final student =
        await api.getStudentProfile(
      studentId,
    );

    if (student["error"] != null) {

      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Student Not Found",
          ),
        ),
      );

      return;
    }

    if (!context.mounted) return;

    Navigator.pop(context);

    Navigator.pushNamed(
      context,
      '/student-profile',
      arguments: studentId,
    );

  } catch (e) {

    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );
  }
},
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "CANCEL",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim1.value),
          child: Opacity(
            opacity: anim1.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------------
  // SHARED WIDGETS
  // ------------------------------------------------------------------

  Widget _glassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cyan.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
        cursorColor: cyan,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: cyan.withOpacity(0.7), size: 20),
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.4),
            fontSize: 11,
            letterSpacing: 1.2,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _gradientButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return _PressableScale(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [cyan, accentBlue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: cyan.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.orbitron(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.black, size: 18),
          ],
        ),
      ),
    );
  }

  /// Main menu button styled like the dashboard reference image
  Widget _menuButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return _PressableScale(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              cyan.withOpacity(0.18),
              accentBlue.withOpacity(0.06),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: cyan.withOpacity(0.45), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: cyan.withOpacity(0.25),
              blurRadius: 25,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: cyan.withOpacity(0.6)),
              ),
              child: Icon(icon, color: cyan, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: cyan, size: 22),
          ],
        ),
      ),
    );
  }

  /// Small status chip e.g. "FACE ENGINE READY"
  Widget _statusChip({required String label, required Color dotColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withOpacity(0.8),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(
                duration: 900.ms,
              ).then().fadeOut(duration: 900.ms),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.75),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Corner HUD panel like "MISSION STATUS" / "LIVE TELEMETRY"
  Widget _hudPanel({
    required String title,
    required Color titleColor,
    required List<Widget> children,
  }) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.orbitron(
              color: titleColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _hudLine(String label, {Color dotColor = const Color(0xFF00E676)}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
              boxShadow: [
                BoxShadow(
                    color: dotColor.withOpacity(0.7),
                    blurRadius: 6,
                    spreadRadius: 1),
              ],
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(
                duration: 800.ms,
              ).then().fadeOut(duration: 800.ms),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.75),
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _hudStat(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.55),
              fontSize: 11,
              letterSpacing: 0.6,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: valueColor ?? Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 1000;

    return Scaffold(
      backgroundColor: const Color(0xFF03050C),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF03050C),
                  Color(0xFF071026),
                  Color(0xFF0A1530),
                ],
              ),
            ),
          ),

          // Stars layers
          AnimatedBuilder(
            animation: _starController,
            builder: (context, child) => CustomPaint(
              size: size,
              painter: StarFieldPainter(
                animationValue: _starController.value,
                starCount: 180,
                speedFactor: 0.4,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _starController,
            builder: (context, child) => CustomPaint(
              size: size,
              painter: StarFieldPainter(
                animationValue: _starController.value,
                starCount: 100,
                speedFactor: 1.0,
                seedOffset: 999,
              ),
            ),
          ),

          // Grid overlay for HUD feel
          CustomPaint(
            size: size,
            painter: GridPainter(),
          ),

          // Meteor shower
          AnimatedBuilder(
            animation: _meteorController,
            builder: (context, child) => CustomPaint(
              size: size,
              painter: MeteorPainter(animationValue: _meteorController.value),
            ),
          ),

          // Glow blobs
          Positioned(
            top: -100,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [cyan.withOpacity(0.18), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -100,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [accentBlue.withOpacity(0.18), Colors.transparent],
                ),
              ),
            ),
          ),

          // Top HUD bar
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "MISSION CONTROL TERMINAL",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.orbitron(
                        color: cyan.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 4,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 100.ms),

          // Corner HUD panels — only on wide screens
          if (isWide) ...[
            Positioned(
              top: 70,
              left: 30,
              child: _hudPanel(
                title: "MISSION STATUS",
                titleColor: cyan,
                children: [
                  _hudLine("SYSTEM ONLINE", dotColor: green),
                  _hudLine("FACE AI ACTIVE", dotColor: green),
                  _hudLine("CAMERA READY", dotColor: amber),
                  _hudLine("DATABASE CONNECTED", dotColor: cyan),
                  const SizedBox(height: 4),
                  Text(
                    "UPTIME 02:45:31",
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 10,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 900.ms, delay: 200.ms).slideX(
                begin: -0.2, end: 0, curve: Curves.easeOut),

            Positioned(
              top: 70,
              right: 30,
              child: _hudPanel(
                title: "LIVE TELEMETRY",
                titleColor: amber,
                children: [
                  _hudStat("RECOGNITION ACCURACY", "99.8%", valueColor: cyan),
                  _hudStat("ACTIVE USERS", "1285"),
                  _hudStat("TODAY ATTENDANCE", "458"),
                  _hudStat("AI ENGINE STATUS", "OPTIMAL", valueColor: green),
                  const SizedBox(height: 4),
                  Text(
                    "TIME 10:24:36 AM",
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 10,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 900.ms, delay: 300.ms).slideX(
                begin: 0.2, end: 0, curve: Curves.easeOut),

            // Bottom-left AI core panel
            Positioned(
              bottom: 30,
              left: 30,
              child: _hudPanel(
                title: "AI CORE v3.0",
                titleColor: cyan,
                children: [
                  Icon(Icons.memory_rounded, color: cyan.withOpacity(0.6), size: 28),
                  const SizedBox(height: 10),
                  Text(
                    "COORDINATES\n28.6139° N, 77.2090° E",
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 10,
                      letterSpacing: 0.6,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 900.ms, delay: 400.ms).slideY(
                begin: 0.2, end: 0, curve: Curves.easeOut),

            // Bottom-right secure link panel
            Positioned(
              bottom: 30,
              right: 30,
              child: _hudPanel(
                title: "DATA STREAM",
                titleColor: amber,
                children: [
                  SizedBox(
                    height: 36,
                    child: CustomPaint(
                      size: const Size(double.infinity, 36),
                      painter: SparklinePainter(color: cyan),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.lock_rounded, color: green, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        "SECURE LINK · ENCRYPTED",
                        style: GoogleFonts.poppins(
                          color: green.withOpacity(0.8),
                          fontSize: 10,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 900.ms, delay: 400.ms).slideY(
                begin: 0.2, end: 0, curve: Curves.easeOut),
          ],

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 100),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 44),
                        decoration: BoxDecoration(
                          color: const Color(0xFF071026).withOpacity(0.35),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: cyan.withOpacity(0.3),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cyan.withOpacity(0.15),
                              blurRadius: 50,
                              spreadRadius: 4,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 30,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Animated face scan icon
                            ScaleTransition(
                              scale: CurvedAnimation(
                                parent: _logoController,
                                curve: Curves.elasticOut,
                              ),
                              child: SizedBox(
                                width: 130,
                                height: 130,
                                child: AnimatedBuilder(
                                  animation: _scanController,
                                  builder: (context, child) {
                                    return CustomPaint(
                                      painter: FaceScanPainter(
                                        progress: _scanController.value,
                                        color: cyan,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.face_6_rounded,
                                          color: cyan,
                                          size: 52,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Title
                            Text(
                              "ATTENDANCE AI",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.orbitron(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 3,
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 800.ms, delay: 200.ms)
                                .slideY(
                                    begin: 0.2, end: 0, curve: Curves.easeOut),

                            const SizedBox(height: 8),

                            // Subtitle
                            Text(
                              "FACE RECOGNITION ATTENDANCE SYSTEM",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: cyan.withOpacity(0.7),
                                letterSpacing: 2,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 800.ms, delay: 400.ms)
                                .slideY(
                                    begin: 0.2, end: 0, curve: Curves.easeOut),

                            const SizedBox(height: 8),

                            // Mission control terminal label
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chevron_left_rounded,
                                    color: Colors.white.withOpacity(0.2),
                                    size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  "MISSION CONTROL TERMINAL",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white.withOpacity(0.3),
                                    fontSize: 10,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.chevron_right_rounded,
                                    color: Colors.white.withOpacity(0.2),
                                    size: 16),
                              ],
                            ).animate().fadeIn(duration: 800.ms, delay: 500.ms),

                            const SizedBox(height: 28),

                            // Status chip grid
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final chipWidth =
                                    (constraints.maxWidth - 12) / 2;
                                return Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    SizedBox(
                                      width: chipWidth,
                                      child: _statusChip(
                                        label: "FACE ENGINE READY",
                                        dotColor: green,
                                      ),
                                    ),
                                    SizedBox(
                                      width: chipWidth,
                                      child: _statusChip(
                                        label: "CLOUD CONNECTED",
                                        dotColor: green,
                                      ),
                                    ),
                                    SizedBox(
                                      width: chipWidth,
                                      child: _statusChip(
                                        label: "AI MODEL LOADED",
                                        dotColor: green,
                                      ),
                                    ),
                                    SizedBox(
                                      width: chipWidth,
                                      child: _statusChip(
                                        label: "CAMERA STANDBY",
                                        dotColor: amber,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                                .animate()
                                .fadeIn(duration: 700.ms, delay: 600.ms)
                                .slideY(
                                    begin: 0.15, end: 0, curve: Curves.easeOut),

                            const SizedBox(height: 28),

                            // Teacher Login Button
                            _menuButton(
                              label: "TEACHER LOGIN",
                              icon: Icons.person_rounded,
                              onTap: () => _showTeacherLoginDialog(context),
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 800.ms)
                                .slideX(
                                    begin: -0.3, end: 0, curve: Curves.easeOut),

                            const SizedBox(height: 16),

                            // Student Login Button
                            _menuButton(
                              label: "STUDENT LOGIN",
                              icon: Icons.school_rounded,
                              onTap: () => _showStudentLoginDialog(context),
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 950.ms)
                                .slideX(
                                    begin: 0.3, end: 0, curve: Curves.easeOut),

                            const SizedBox(height: 28),

                            // Footer
                            Column(
                              children: [
                                Container(
                                  height: 1,
                                  width: 80,
                                  color: cyan.withOpacity(0.2),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "NEURAL RECOGNITION ENGINE",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.orbitron(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.35),
                                    letterSpacing: 3,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "POWERED BY ATTENDANCE AI · ALL SYSTEMS OPERATIONAL",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    color: Colors.white.withOpacity(0.25),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ).animate().fadeIn(duration: 800.ms, delay: 1100.ms),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// PRESSABLE SCALE WRAPPER
// ----------------------------------------------------------------------

class _PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PressableScale({required this.child, required this.onTap});

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  double _scale = 1.0;

  void _setScale(double value) {
    setState(() => _scale = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setScale(0.97),
      onTapUp: (_) {
        _setScale(1.0);
        widget.onTap();
      },
      onTapCancel: () => _setScale(1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

// ----------------------------------------------------------------------
// FACE SCAN PAINTER — animated scanning brackets + sweeping line
// ----------------------------------------------------------------------

class FaceScanPainter extends CustomPainter {
  final double progress; // 0..1 animated back and forth
  final Color color;

  FaceScanPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer rotating dashed circle
    final outerPaint = Paint()
      ..color = color.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 4, outerPaint);

    // Inner glowing circle
    final innerPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, radius - 18, innerPaint);

    // Corner brackets
    final bracketPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final inset = radius - 12;
    final bracketLen = radius * 0.28;

    final corners = [
      Offset(center.dx - inset, center.dy - inset), // top-left
      Offset(center.dx + inset, center.dy - inset), // top-right
      Offset(center.dx - inset, center.dy + inset), // bottom-left
      Offset(center.dx + inset, center.dy + inset), // bottom-right
    ];

    for (int i = 0; i < corners.length; i++) {
      final c = corners[i];
      final dx = (i % 2 == 0) ? 1.0 : -1.0;
      final dy = (i < 2) ? 1.0 : -1.0;

      canvas.drawLine(c, Offset(c.dx + bracketLen * dx, c.dy), bracketPaint);
      canvas.drawLine(c, Offset(c.dx, c.dy + bracketLen * dy), bracketPaint);
    }

    // Sweeping scan line
    final scanY = (radius - 16) * 2 * (progress - 0.5).abs() * -1 +
        (radius - 16); // bounces top to bottom
    final lineY = center.dy - (radius - 16) + (progress * (radius - 16) * 2);

    final scanPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withOpacity(0.0),
          color.withOpacity(0.9),
          color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(
          center.dx - radius + 14, lineY - 1, (radius - 14) * 2, 2));

    canvas.drawRect(
      Rect.fromLTWH(center.dx - radius + 14, lineY - 1, (radius - 14) * 2, 2),
      scanPaint,
    );

    // Glow dot trailing the scan line
    final glowPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(center.dx, lineY), 3, glowPaint);
  }

  @override
  bool shouldRepaint(covariant FaceScanPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// ----------------------------------------------------------------------
// GRID PAINTER — subtle HUD grid overlay
// ----------------------------------------------------------------------

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.025)
      ..strokeWidth = 1;

    const spacing = 60.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) => false;
}

// ----------------------------------------------------------------------
// SPARKLINE PAINTER — for "DATA STREAM" panel
// ----------------------------------------------------------------------

class SparklinePainter extends CustomPainter {
  final Color color;

  SparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(11);
    final points = <Offset>[];
    final pointCount = 12;

    for (int i = 0; i < pointCount; i++) {
      final x = size.width * (i / (pointCount - 1));
      final y = size.height * (0.2 + random.nextDouble() * 0.6);
      points.add(Offset(x, y));
    }

    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, paint);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.25), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) => false;
}

// ----------------------------------------------------------------------
// STAR FIELD PAINTER
// ----------------------------------------------------------------------

class StarFieldPainter extends CustomPainter {
  final double animationValue;
  final int starCount;
  final double speedFactor;
  final int seedOffset;

  StarFieldPainter({
    required this.animationValue,
    required this.starCount,
    this.speedFactor = 1.0,
    this.seedOffset = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42 + seedOffset);

    for (int i = 0; i < starCount; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final baseRadius = random.nextDouble() * 1.6 + 0.4;
      final phase = random.nextDouble() * 2 * pi;

      final twinkle =
          (sin((animationValue * 2 * pi * speedFactor) + phase) + 1) / 2;
      final opacity = 0.2 + twinkle * 0.8;

      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
          Offset(dx, dy), baseRadius * (0.6 + twinkle * 0.6), paint);

      if (baseRadius > 1.4) {
        final glowPaint = Paint()
          ..color = Colors.white.withOpacity(opacity * 0.15)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(Offset(dx, dy), baseRadius * 3, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant StarFieldPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// ----------------------------------------------------------------------
// METEOR PAINTER
// ----------------------------------------------------------------------

class MeteorPainter extends CustomPainter {
  final double animationValue;
  final int meteorCount;

  MeteorPainter({required this.animationValue, this.meteorCount = 5});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(7);

    for (int i = 0; i < meteorCount; i++) {
      final progressOffset = random.nextDouble();
      double progress = (animationValue + progressOffset) % 1.0;

      final startX =
          random.nextDouble() * size.width * 1.4 - size.width * 0.2;
      final startY = -50.0 - random.nextDouble() * 100;

      final travel = size.height * 1.6;
      final angle = pi / 4;

      final currentX = startX + cos(angle) * travel * progress;
      final currentY = startY + sin(angle) * travel * progress;

      double opacity;
      if (progress < 0.1) {
        opacity = progress / 0.1;
      } else if (progress > 0.85) {
        opacity = (1.0 - progress) / 0.15;
      } else {
        opacity = 1.0;
      }
      opacity = opacity.clamp(0.0, 1.0);

      if (opacity <= 0) continue;

      const tailLength = 80.0;
      final tailX = currentX - cos(angle) * tailLength;
      final tailY = currentY - sin(angle) * tailLength;

      final gradient = LinearGradient(
        colors: [
          Colors.white.withOpacity(opacity),
          const Color(0xFF00E5FF).withOpacity(opacity * 0.5),
          Colors.transparent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

      final rect = Rect.fromPoints(
        Offset(tailX, tailY),
        Offset(currentX, currentY),
      );

      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(Offset(tailX, tailY), Offset(currentX, currentY), paint);

      final headPaint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(Offset(currentX, currentY), 2.5, headPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MeteorPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}