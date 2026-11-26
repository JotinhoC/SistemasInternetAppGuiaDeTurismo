import 'package:app/models/lugares_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:app/controllers/lugares_controller.dart';
import 'package:app/controllers/gps_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapaScreen extends StatefulWidget {
  final LugaresModel? lugarSelecionado;

  const MapaScreen({super.key, this.lugarSelecionado});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final MapController _mapController = MapController();

  //converte latitude e longitude pata LatLng com segurança
  LatLng? _converterCoordenada(LugaresModel lugar){
    final lat = double.tryParse(lugar.latitude.toString());
    final lng = double.tryParse(lugar.longitude.toString());
    if (lat == null || lng == null) return null;
    return LatLng(lat, lng);
  }

  String calcularDistanciaFormatada(LatLng usuario, LatLng destino) {
  const Distance distance = Distance();
  
  // Calcula a distância em metros entre a posição atual e o ponto selecionado
  final double metros = distance.as(LengthUnit.Meter, usuario, destino);

  if (metros < 1000) {
    return '${metros.round()} m';
  } else {
    final double km = metros / 1000;
    return '${km.toStringAsFixed(1)} km';
  }
}
  @override

  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<GpsController>().buscarLocal();
    });
  }
  @override

  Widget build(BuildContext context) {
    return Consumer2<GpsController, LugaresController>(
      builder: (context, gpsController, lugaresController, child) {
        final LatLng? destino = widget.lugarSelecionado != null
            ? _converterCoordenada(widget.lugarSelecionado!)
            : null;

        final LatLng? centroInicial = destino ?? gpsController.atual;

        // Calcula o texto da distância se ambas as coordenadas existirem
        final String? textoDistancia =
            (gpsController.atual != null && destino != null)
                ? calcularDistanciaFormatada(gpsController.atual!, destino)
                : null;

        return Scaffold(
          appBar: widget.lugarSelecionado != null
              ? AppBar(title: Text(widget.lugarSelecionado!.nome))
              : null,
          body: SafeArea(
            child: Stack(
              children: [
                if (gpsController.carregando && centroInicial == null)
                  const Center(child: CircularProgressIndicator())
                else if (centroInicial == null)
                  const Center(child: Text("Localização não encontrada"))
                else
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialZoom: 15.0,
                      initialCenter: centroInicial,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: "com.example.app",
                      ),

                      // Linha ligando o usuário ao ponto selecionado
                      if (gpsController.atual != null && destino != null)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: [gpsController.atual!, destino],
                              color: Colors.blueAccent,
                              strokeWidth: 4.0,
                            ),
                          ],
                        ),

                      MarkerLayer(
                        markers: [
                          if (gpsController.atual != null)
                            Marker(
                              width: 40,
                              height: 40,
                              point: gpsController.atual!,
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),
                          ...lugaresController.lugares.map((lugar) {
                            final coord = _converterCoordenada(lugar);
                            if (coord == null) {
                              return const Marker(
                                point: LatLng(0, 0),
                                child: SizedBox.shrink(),
                              );
                            }
                            final bool selecionado =
                                widget.lugarSelecionado?.id == lugar.id;

                            return Marker(
                              width: 45,
                              height: 45,
                              point: coord,
                              child: Icon(
                                Icons.location_on,
                                color: selecionado ? Colors.green : Colors.red,
                                size: selecionado ? 44 : 36,
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),

                // Card flutuante exibindo a distância calculada
                if (textoDistancia != null && widget.lugarSelecionado != null)
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.directions_walk, color: Colors.teal),
                        title: Text(
                          widget.lugarSelecionado!.nome,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(textoDistancia),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await gpsController.buscarLocal();
              if (gpsController.atual != null) {
                _mapController.move(gpsController.atual!, 15.0);
              }
            },
            child: const Icon(Icons.person_pin_circle_rounded),
          ),
        );
      },
    );
  }
}