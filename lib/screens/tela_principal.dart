import 'package:app/screens/cadastro_lugar.dart';
import 'package:app/screens/lugares_screen.dart';
import 'package:app/screens/mapa.dart';
import 'package:flutter/material.dart';

class TelaPrincipal extends StatefulWidget {
  const new({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  // Índice da aba atualmente selecionada
  int _indiceAtual = 0;

  // Lista das telas que serão exibidas
  final List<Widget> _telas = const [
    CadastroLugar(),
    LugaresScreen(),
    MapaScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O IndexedStack preserva o estado das telas ao alternar entre elas
      body: IndexedStack(
        index: _indiceAtual,
        children: _telas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceAtual,
        onDestinationSelected: (int novoIndice) {
          setState(() {
            _indiceAtual = novoIndice;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.add),
            selectedIcon: Icon(Icons.add_rounded),
            label: 'Cadastrar',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Localidades',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
        ],
      ),
    );
  }
}