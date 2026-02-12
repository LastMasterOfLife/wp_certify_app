import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../Widgets/Neumorfic_widget.dart';
import '../api_urls.dart';

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


  late var token = "";
  late var url = "";

  void postData(String user, String pass, BuildContext context) async {
    var dio = Dio();

    try {
      Response response = await dio.post(url_login, data: {
        "username": user,
        "password": pass
      });

      if (response.statusCode == 200) {
        setState(() => _error_login = false);
        final String urlOttenuta = response.data['url'];

        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/web', arguments: {'url': urlOttenuta});
        }
      }
    } on DioException catch (e) {
      setState(() => _error_login = true);

      String messaggio = "Errore di connessione";
      if (e.response?.statusCode == 401) {
        messaggio = "Username o Password errati";
      }

      //if (context.mounted) {
      //  ScaffoldMessenger.of(context).showSnackBar(
      //    SnackBar(content: Text(messaggio), backgroundColor: Colors.redAccent),
      //  );
      //}
    } catch (e) {
      setState(() => _error_login = true);
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;


    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() => _locationMessage = 'Servizio posizione disabilitato');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _locationMessage = 'Permessi negati');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _locationMessage = 'Permessi negati permanentemente');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _locationMessage =
      "Lat: ${position.latitude}, Long: ${position.longitude}";
      print("Lat: ${position.latitude}, Long: ${position.longitude}");
    });


  }


  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF0F3),
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
                        backgroundColor: const Color(0xFFECF0F3),
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
                          color: Color(0xFF7C8DB5),
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
                  backgroundColor: const Color(0xFFECF0F3),
                  shadowColor: const Color(0xFFD1D9E6).withOpacity(0.7),
                  blurRadius: 8,
                  offset: const Offset(4, 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _usernameController,
                      style: const TextStyle(
                        color: Color(0xFF7C8DB5),
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(
                          color: Color(0xFFADB5C7),
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.person_outline,
                          color: Color(0xFF9BA4B4),
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
                  backgroundColor: const Color(0xFFECF0F3),
                  shadowColor: const Color(0xFFD1D9E6).withOpacity(0.7),
                  blurRadius: 8,
                  offset: const Offset(4, 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                        color: Color(0xFF7C8DB5),
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: Color(0xFFADB5C7),
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        icon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF9BA4B4),
                          size: 22,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF9BA4B4),
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
                        backgroundColor: const Color(0xFFECF0F3),
                        isPressed: _rememberMe,
                        child: _rememberMe
                            ? const Center(
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: Color(0xFF7C8DB5),
                          ),
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        color: Color(0xFF9BA4B4),
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
                  backgroundColor: const Color(0xFFECF0F3),
                  onTap: () {
                    String user = _usernameController.text.trim();
                    String pass = _passwordController.text.trim();
                    if (user.isNotEmpty && pass.isNotEmpty) {
                      postData(user, pass, context);
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7C8DB5),
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
                        color: const Color(0xFFD1D9E6).withOpacity(0.5),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Color(0xFF9BA4B4),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFD1D9E6).withOpacity(0.5),
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
                      color: const Color(0xFF000000),
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
                          color: Color(0xFF9BA4B4),
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          print('Sign Up pressed');
                          //Navigator.pushNamed(context, "/geo");
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
      backgroundColor: const Color(0xFFECF0F3),
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

