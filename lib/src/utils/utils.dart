import 'package:flutter/cupertino.dart';
import 'package:flutter_lector_qr/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static abrirScan(ScanModel scan, BuildContext context) async {
    if (scan.tipo.startsWith('http')) {
      if (await canLaunch(scan.valor)) {
        await launch(scan.valor);
      } else {
        throw 'Could not launch ${scan.valor}';
      }
    } else {
      Navigator.pushNamed(context, 'mapa', arguments: scan);
    }
  }
}
