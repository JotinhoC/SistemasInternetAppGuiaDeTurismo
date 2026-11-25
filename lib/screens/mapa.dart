import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:app/controllers/gps_controller.dart';
import 'package:provider/provider.dart';

class MapaScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GpsController>(
      builder: (context, mapaController, child) => Scaffold(
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:  MainAxisAlignment.center,
            children: [
              mapaController.carregando 
              ? Center(child: CircularProgressIndicator()) //se o mapa estiver carregando, mostrar indicador de loading
              : mapaController.atual == null 
              ? Center(child: Text("Não Encontrado")) //se nã o estiver carregando nada, mostrar texto indicando erro
              : Expanded(child: FlutterMap(
                options:  MapOptions(
                  initialZoom: 15.0,
                  initialCenter: mapaController.atual!
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/%7Bz%7D/%7Bx%7D/%7By%7D.png",
                    userAgentPackageName: "br.com.guiaturismo.maps",
                  ),

                  MarkerLayer(
                    markers: mapaController.pontos.map((ponto) => Marker(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        rotate: true,
                        point: ponto,
                        child: Icon(Icons.location_on),
                      ),
                    ).toList(),
                  )
                ],
              ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => mapaController.buscarLocal(),
          child: Icon(Icons.person_pin_circle_rounded),
        ),
      )
    );
  }
}