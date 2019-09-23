import 'package:flutter/material.dart';
import 'package:flutter_lector_qr/src/pages/home_page.dart';
import 'package:flutter_lector_qr/src/pages/mapa_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR reader',
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext context) => HomePage(),
        'mapa' : (BuildContext context) => MapaPage()
      },
    );
  }
}