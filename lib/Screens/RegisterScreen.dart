import 'package:flutter/material.dart';
import '../Widgets/neumorficWidget.dart';
import '../colors.dart';
import '../Services/AuthService.dart';



///
/// Schermata di registrazione dell'utente
///
class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

///
/// _usernameController e _passwordController vengono uasti per ottenere l'imput dell'utente
///
/// _obscurePassword viene usato per mostrare o nascondere la password inserita.
///
class _RegisterscreenState extends State<Registerscreen> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late var token = "";
  late var url = "";


  ///
  /// Funzione per la registrazione dell'utente
  ///
  void registerUser(String user, String pass, BuildContext context) async {
    AuthService autenticate = new AuthService();
    var ceck = autenticate.registerUser(user, pass);
    if (await ceck){
      if (context.mounted) {
        Navigator.pushNamed(context, '/');
      }
      var messaggio = "Utente creato con successo";
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(messaggio), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
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
                            Icons.person_add_alt_rounded,
                            size: 50,
                            color: Colors.blue.shade300,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: header_color,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 90),

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

                const SizedBox(height: 30),

                // Sign Up Button
                NeumorphicButton(
                  width: double.infinity,
                  height: 55,
                  borderRadius: 12,
                  backgroundColor: background_color,
                  onTap: () {
                    String user = _usernameController.text.trim();
                    String pass = _passwordController.text.trim();
                    if (user.isNotEmpty && pass.isNotEmpty) {
                      registerUser(user, pass, context);
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Sign Up',
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

                const SizedBox(height: 60),

                // Login link
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "You already have an account! ",
                        style: TextStyle(
                          color: imput_border,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          print('Login pressed');
                          Navigator.pushNamed(context, "/");
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Login',
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



