import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:app/services/gps_service.dart';


class GpsController extends ChangeNotifier{
  final GpsService _servico = GpsService();

  LatLng? atual;
  List<LatLng> pontos = [];
  bool carregando = false;
  String erro = "";

  //Metodo construtor 
  GpsController() {
    buscarLocal();
  }
  Future<void> buscarLocal() async {
    notifyListeners();
    try{
      atual = await _servico.obterLocal();
      if(atual == null){
        erro = "Erro ao buscar local";
      } else {
        pontos.add(atual!);
      }
    } catch(e){
      erro = e.toString();
      debugPrint("Erro: $erro");
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}