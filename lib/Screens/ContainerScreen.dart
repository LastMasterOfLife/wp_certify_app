import 'package:flutter/material.dart';
import 'package:wp_app/Screens/CameraScreen.dart';
import 'package:wp_app/Screens/SettingsScreen.dart';
import 'package:wp_app/Screens/WebScreen.dart';

import '../colors.dart';

class Containerscreen extends StatefulWidget {
  const Containerscreen({super.key});

  @override
  State<Containerscreen> createState() => _ContainerscreenState();
}

class _ContainerscreenState extends State<Containerscreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String loadUrl = args?['url'] ?? 'https://www.google.com';

    final List<Widget> pages = [
      CameraScreen(url: loadUrl,),
      Webscreen(loadUrl: loadUrl),
      Settingsscreen(),
    ];

    final List<IconData> icons = [
      Icons.camera_alt,
      Icons.home,
      Icons.settings,
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final bool isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => _onItemTapped(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? primary_color : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icons[index],
                    color: isSelected ? background_color : secondary_color,
                    size: 26,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}