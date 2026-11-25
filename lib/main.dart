import 'package:app/controllers/gps_controller.dart';
import 'package:app/screens/cadastro_lugar.dart';
import 'package:app/screens/lugares_screen.dart';
import 'package:app/screens/mapa.dart';
import 'package:app/screens/tela_principal.dart';
import 'package:flutter/material.dart';
import 'package:app/controllers/camera_controller.dart';
import 'package:app/controllers/lugares_controller.dart';
//import 'package:app/inicializar.dart';
//import 'package:app/screens/cadastro_lugar.dart';
//import 'package:app/screens/lugares_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Inicializar( ));
}

class Inicializar extends StatefulWidget {
  const new({super.key});

  @override
  State<Inicializar> createState() => _InicializarState();
}

class _InicializarState extends State<Inicializar> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LugaresController()),
        ChangeNotifierProvider(create: (_) => CameraController()),
        ChangeNotifierProvider(create: (_) => GpsController()),
      ],
        //child: Consumer<ThemeController>(
        //builder: (context, lugaresController, child) => 
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: 'home',
          routes: {
            'lugares': (context) => LugaresScreen(),
            'cadastro': (context) => CadastroLugar(),
            'mapa': (context) => MapaScreen(),
            'home': (context) => TelaPrincipal(),
          }
        ),
      );
  }
}