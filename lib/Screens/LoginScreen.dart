import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../Services/AuthService.dart';
import '../Services/LocationService.dart';
import '../Util/LoginResponse.dart';
import '../Widgets/Neumorfic_widget.dart';
import '../api_urls.dart';
import 'package:wp_app/colors.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String _locationMessage = "Posizione non rilevata";
  bool _error_login = false;
  StreamSubscription<Position>? _positionSubscription;
  Position? _currentPosition;
  Timer? positionTimer;
  var token = "";
  var url = "";

  void postDataloginprova(String user, String pass, BuildContext context) async {
    AuthService autenticate = new AuthService();
    LoginResponse? result = await autenticate.loginUser(user, pass);

    if (result != null){
      token = result.token;
      url = result.redirectUrl;
      print("Token ottenuto: $token");
      print("URL ottenuto: $url");
      setState(() => _error_login = false);
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/web', arguments: {'url': result.redirectUrl+token});
      }
    }
    else {
      print("Token ottenuto: $token");
    }
  }

  void _startListening() async {

    bool hasPermission = await LocationService().checkPermissions();

    if (hasPermission) {

      Position? position = await Geolocator.getLastKnownPosition();

      positionTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
        print("timer -> Lat: ${position!.latitude}, Lon: ${position
            .longitude}, alt: ${position.altitude}, accuracy: ${position
            .accuracy}");
      });
    }
  }

  @override
  void initState() {
    _startListening();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _positionSubscription?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_color,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Header con logo
                Center(
                  child: Column(
                    children: [
                      DropShadowWidget(
                        width: 100,
                        height: 100,
                        borderRadius: 50,
                        backgroundColor: background_color,
                        blurRadius: 20,
                        offset: const Offset(10, 10),
                        child: Center(
                          child: Icon(
                            Icons.fingerprint,
                            size: 50,
                            color: Colors.blue.shade300,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: header_color,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Username Field
                InnerShadowWidget1(
                  width: double.infinity,
                  height: 55,
                  borderRadius: 12,
                  backgroundColor: background_color,
                  shadowColor: shadow_color.withOpacity(0.7),
                  blurRadius: 8,
                  offset: const Offset(4, 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _usernameController,
                      style: const TextStyle(
                        color: header_color,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(
                          color: hint_text_color,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.person_outline,
                          color: imput_border,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Password Field
                InnerShadowWidget1(
                  width: double.infinity,
                  height: 55,
                  borderRadius: 12,
                  backgroundColor: background_color,
                  shadowColor: shadow_color.withOpacity(0.7),
                  blurRadius: 8,
                  offset: const Offset(4, 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                        color: header_color,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: hint_text_color,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        icon: const Icon(
                          Icons.lock_outline,
                          color: imput_border,
                          size: 22,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: imput_border,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                if (_error_login)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 8.0),
                    child: Text(
                      "Credenziali non valide",
                      style: TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  ),

                SizedBox(height: 15),

                // Remember me checkbox
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _rememberMe = !_rememberMe;
                        });
                      },
                      child: NeumorphicWidget(
                        width: 24,
                        height: 24,
                        borderRadius: 6,
                        backgroundColor: background_color,
                        isPressed: _rememberMe,
                        child: _rememberMe
                            ? const Center(
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: header_color,
                          ),
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        color: imput_border,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        print('Forgot password');
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.blue.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // Login Button
                NeumorphicButton(
                  width: double.infinity,
                  height: 55,
                  borderRadius: 12,
                  backgroundColor: background_color,
                  onTap: () {
                    String user = _usernameController.text.trim();
                    String pass = _passwordController.text.trim();
                    if (user.isNotEmpty && pass.isNotEmpty) {
                      postDataloginprova(user, pass, context);
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: header_color,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: shadow_color.withOpacity(0.5),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: imput_border,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: shadow_color.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Social buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      icon: Icons.g_mobiledata,
                      color: Colors.red.shade400,
                      size: 38,
                      onTap: () => print('Google login'),
                    ),
                    const SizedBox(width: 15),
                    _buildSocialButton(
                      icon: Icons.facebook,
                      color: Colors.blue.shade700,
                      size: 32,
                      onTap: () => print('Facebook login'),
                    ),
                    const SizedBox(width: 15),
                    _buildSocialButton(
                      icon: Icons.apple,
                      color: apple_social_color,
                      size: 32,
                      onTap: () => print('Apple login'),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Sign up link
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: imput_border,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          print('Sign Up pressed');
                          Navigator.pushNamed(context, "/signup");
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.blue.shade400,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onTap,
  }) {
    return NeumorphicButton(
      width: 55,
      height: 55,
      isCircular: true,
      backgroundColor: background_color,
      onTap: onTap,
      child: Center(
        child: Icon(
          icon,
          size: size,
          color: color,
        ),
      ),
    );
  }
}

