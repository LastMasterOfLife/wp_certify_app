import 'package:flutter/material.dart';
import 'package:wp_app/Widgets/neumorficWidget.dart';
import '../colors.dart';

class Settingsscreen extends StatefulWidget {
  const Settingsscreen({super.key});

  @override
  State<Settingsscreen> createState() => _SettingsscreenState();
}

class _SettingsscreenState extends State<Settingsscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                print(" Settings cliccato: Generali");
              },
              child: DropShadowWidget(
                width: double.infinity,
                height: 80,
                borderRadius: 10,
                blurRadius: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Generali", style: TextStyle(
                          color: terziary_color,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: terziary_color,)
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 15,),

            InkWell(
              onTap: (){
                print(" Settings cliccato: Gelocalizzazione");
              },
              child: DropShadowWidget(
                width: double.infinity,
                height: 80,
                borderRadius: 10,
                blurRadius: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Gelocalizzazione", style: TextStyle(
                          color: terziary_color,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: terziary_color,)
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 15,),

            InkWell(
              onTap: (){
                print(" Settings cliccato: camera");
              },
              child: DropShadowWidget(
                width: double.infinity,
                height: 80,
                borderRadius: 10,
                blurRadius: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Camera", style: TextStyle(
                          color: terziary_color,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: terziary_color,)
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 15,),

            InkWell(
              onTap: (){
                print(" Settings cliccato: Termini di servizio");
              },
              child: DropShadowWidget(
                width: double.infinity,
                height: 80,
                borderRadius: 10,
                blurRadius: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Termini di servizio", style: TextStyle(
                          color: terziary_color,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: terziary_color,)
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 15,),

            InkWell(
              onTap: (){
                print(" Settings cliccato: Permessi");
              },
              child: DropShadowWidget(
                width: double.infinity,
                height: 80,
                borderRadius: 10,
                blurRadius: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Permessi", style: TextStyle(
                          color: terziary_color,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: terziary_color,)
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 15,),

            InkWell(
              onTap: (){
                print(" Settings cliccato: privacy policy");
              },
              child: DropShadowWidget(
                width: double.infinity,
                height: 80,
                borderRadius: 10,
                blurRadius: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Privacy policy", style: TextStyle(
                          color: terziary_color,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: terziary_color,)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
