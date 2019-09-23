import 'package:flutter/material.dart';
import 'package:flutter_lector_qr/src/models/scan_model.dart';
import 'package:flutter_map/flutter_map.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final MapController map = new MapController();

  int indexTipoMapa = 0;

  List<String> tipoMapa = ['streets', 'dark', 'light', 'outdoors', 'satellite'];

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    print("estoy dentro");
    print('mapbox.${tipoMapa[indexTipoMapa]}');
    return Scaffold(
      appBar: AppBar(
        title: Text("Coordenadas QR"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              map.move(scan.getLatLng(), 15);
            },
          ),
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
        urlTemplate:
            'https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiY2xvdWRtYW44NSIsImEiOiJjazB0ZmNrMjMwYnM5M25wNWswb3h0cnc2In0.OGyYYDtgEwTykd17V2S4RQ',
          'id': 'mapbox.${tipoMapa[indexTipoMapa]}',
        });
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
                child: Icon(
                  Icons.location_on,
                  size: 60.0,
                  color: Theme.of(context).primaryColor,
                ),
              )),
    ]);
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        setState(() {
          if (indexTipoMapa == 4) {
            indexTipoMapa = 0;
          } else {
            indexTipoMapa++;
          }
        });
      },
    );
  }
}
