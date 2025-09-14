import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'dart:math';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // Controllers login
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Controllers signup
  final signUpEmailController = TextEditingController();
  final signUpPhoneController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  bool _obscureSignUpPassword = true;

  // Dummy credentials simulasi penyimpanan pengguna
  String savedEmail = "faeyzayudistira07@gmail.com";
  String savedPhone = "085776497495";
  String savedPassword = "11111111";

  // Untuk animasi latar belakang
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    idController.dispose();
    passwordController.dispose();
    signUpEmailController.dispose();
    signUpPhoneController.dispose();
    signUpPasswordController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    if (isLoggedIn && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    }
  }

  Future<void> login() async {
    if ((idController.text == savedEmail || idController.text == savedPhone) &&
        passwordController.text == savedPassword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email/Nomor Telepon atau Password salah"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      );
    }
  }

  Future<void> showSignUpDialog() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GlassmorphicContainer(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 480,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 24),
            borderRadius: 25,
            blur: 25,
            border: 2,
            linearGradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderGradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.4),
                Colors.white.withOpacity(0.15),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Daftar Akun Baru",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          blurRadius: 5,
                          color: Colors.black38,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildTextField(
                    controller: signUpEmailController,
                    labelText: "Email",
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: signUpPhoneController,
                    labelText: "Nomor Telepon",
                    icon: Icons.phone_android_outlined,
                  ),
                  const SizedBox(height: 20),
                  _buildSignUpPasswordTextField(),
                  const SizedBox(height: 30),
                  _buildSignUpButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> signUp() async {
    final email = signUpEmailController.text.trim();
    final phone = signUpPhoneController.text.trim();
    final password = signUpPasswordController.text;

    if (email.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua kolom harus diisi"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      );
      return;
    }

    // Simulasi simpan data pengguna baru
    setState(() {
      savedEmail = email;
      savedPhone = phone;
      savedPassword = password;
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pendaftaran berhasil! Silakan login."),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );

    signUpEmailController.clear();
    signUpPhoneController.clear();
    signUpPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Latar Belakang Gradien yang lebih menarik
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6B58E9), Color(0xFFE2749E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Animasi "Gelembung" pada latar belakang
          if (_animationController != null)
            AnimatedBuilder(
              animation: _animationController!,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: height *
                          (0.2 + 0.1 * sin(pi * 2 * _animation!.value)),
                      left:
                          width * (0.1 + 0.1 * cos(pi * 2 * _animation!.value)),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: height *
                          (0.3 - 0.1 * cos(pi * 2 * _animation!.value)),
                      right:
                          width * (0.2 + 0.1 * sin(pi * 2 * _animation!.value)),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          Center(
            child: GlassmorphicContainer(
              width: width * 0.85,
              height: height * 0.68,
              borderRadius: 25,
              blur: 25,
              alignment: Alignment.center,
              border: 2,
              linearGradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderGradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.4),
                  Colors.white.withOpacity(0.15),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Selamat Datang Kembali",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black45,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Silakan masuk untuk melanjutkan",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 38),
                    _buildTextField(
                      controller: idController,
                      labelText: "Email atau Nomor Telepon",
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordTextField(),
                    const SizedBox(height: 35),
                    _buildLoginButton(),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: showSignUpDialog,
                      child: const Text(
                        "Belum punya akun? Daftar",
                        style: TextStyle(
                          color: Colors.white70,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      controller: passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSignUpPasswordTextField() {
    return TextField(
      controller: signUpPasswordController,
      obscureText: _obscureSignUpPassword,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
              _obscureSignUpPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70),
          onPressed: () {
            setState(() {
              _obscureSignUpPassword = !_obscureSignUpPassword;
            });
          },
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Material(
      borderRadius: BorderRadius.circular(18),
      elevation: 14,
      shadowColor: Colors.black.withOpacity(0.3),
      child: InkWell(
        onTap: login,
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.white24,
        highlightColor: Colors.white12,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF0053A6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          height: 60,
          width: double.infinity,
          child: const Center(
            child: Text(
              "Masuk",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black26,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Material(
      borderRadius: BorderRadius.circular(18),
      elevation: 14,
      shadowColor: Colors.black.withOpacity(0.3),
      child: InkWell(
        onTap: signUp,
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.white24,
        highlightColor: Colors.white12,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF3F51B5), Color(0xFF283593)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          height: 55,
          width: double.infinity,
          child: const Center(
            child: Text(
              "Daftar",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
