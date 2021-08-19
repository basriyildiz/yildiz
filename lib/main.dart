import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yildiz_metal/screens/home_page.dart';
import 'package:yildiz_metal/screens/m.dart';
import 'package:yildiz_metal/screens/maliyet_hesaplama.dart';
import 'screens/analiz_hesaplama.dart';
import 'ui/helper/context_extension.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return FutureBuilder(
      // Replace the 3 second delay with your initialization code:
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Splash(),
          );
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: GoogleFonts.latoTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            home: HomePage(),
            title: "Analiz Ortalama Hesaplama",
            routes: {
              "/analizHesaplama": (context) => AnalizHesaplamaScreen(),
              "/maliyetHesaplama": (context) => MaliyetHesaplamaScreen(),
            },
          );
        }
      },
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/gif/logo.gif",
            width: context.dynamicWidth(0.9)),
      ),
    );
  }
}
