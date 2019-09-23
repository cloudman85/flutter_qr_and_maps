import 'package:flutter/material.dart';
import 'package:flutter_lector_qr/src/bloc/scans_bloc.dart';
import 'package:flutter_lector_qr/src/models/scan_model.dart';
import 'package:flutter_lector_qr/src/pages/direcciones_page.dart';
import 'package:flutter_lector_qr/src/utils/utils.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

import 'mapas_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              scansBloc.borrarTodosScan();
            },
          ),
        ],
      ),
      body: Center(
        child: _callPage(currentIndex),
      ),
      bottomNavigationBar: _crearBottomNavigatorBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: _scanQR,
      ),
    );
  }

  _scanQR() async {
    //https://www.as.com
    //geo:40.703414587757806,-73.97435560664064
    String futureString;
    try {
      futureString = await new QRCodeReader().scan();
    } catch (e) {
      print('hay error');
      futureString = e.toString();
    }
    print('futureString: $futureString');

    if (futureString != null) {
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);

      Utils.abrirScan(scan, context);

    }
  }

  Widget _crearBottomNavigatorBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        print('has pulsado ' + index.toString());
        setState(() {
          currentIndex = index;
        });
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones'),
        ),
      ],
    );
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();

      default:
        return MapasPage();
    }
  }
}
