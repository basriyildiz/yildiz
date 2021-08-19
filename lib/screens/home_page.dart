import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  List<String> sayfalar = ["Analiz Hesaplayıcı", "Maliyet Hesaplayıcı"];
  List<String> sayfaRoutes = ["/analizHesaplama", "/maliyetHesaplama"];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa",
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Colors.white,
              ),
            )),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            cards(context, 0),
            cards(context, 1),
          ],
        ),
      ),
    );
  }

  Card cards(BuildContext context, int i) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, sayfaRoutes[i]);
        },
        leading: Text(
          sayfalar[i],
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        trailing: Icon(Ionicons.arrow_forward_sharp),
      ),
    );
  }
}
