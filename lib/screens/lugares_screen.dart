import 'package:app/screens/mapa.dart';
import 'package:flutter/material.dart';
import 'package:app/controllers/lugares_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class LugaresScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LugaresScreen> createState() => _LugaresScreenState();
}

class _LugaresScreenState extends State<LugaresScreen> {
  final Map<int, String> _categorias = {
    1: "Praia",
    2: "Points",
    3: "Ilhas",
    4: "Gastronomia",
    5: "Dicas"
  };
  @override

  Widget build(BuildContext context) {

    return Consumer<LugaresController>(
      builder: (context, lugaresController, child) {
        return Scaffold(
      appBar: AppBar(
        title: Text(
          lugaresController.apenasFavoritos
          ? "Meus Favoritos"
          : "Lugares para visitar",
        ),
        actions: [
          IconButton(
            tooltip: lugaresController.apenasFavoritos
            ? "Mostrar Todos"
            : "Mostrar Favoritos",
            onPressed: lugaresController.alternarFiltroFavoritos,
            icon: Icon(
              lugaresController.apenasFavoritos
              ? Icons.favorite
              : Icons.favorite_border,
            color: lugaresController.apenasFavoritos ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildBarraCategorias(lugaresController),
          Expanded(
            child: _buildConteudo(lugaresController),
          )
        ],
      )
      
    );
  }
  );
}

Widget _buildBarraCategorias(LugaresController controller) {
    return SizedBox(
      height: 54,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text("Todas"),
              selected: controller.categoriaSelecionadaID == null,
              onSelected: (_) => controller.selecionarCategoria(null),
            ),
          ),
          ..._categorias.entries.map((entry) {
            final int id = entry.key;
            final String nome = entry.value;
            return Padding(
              padding: EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(nome),
                selected: controller.categoriaSelecionadaID == id,
                onSelected: (_) => controller.selecionarCategoria(id),
              ),
            );
          }),
        ],
      ),
    );
  }
      
Widget _buildConteudo(LugaresController lugaresController) {
    if (lugaresController.carregando) {
      return Center(child: CircularProgressIndicator());
    }
    if (lugaresController.erro != '') {
      return Center(child: Text(lugaresController.erro));
    }
    if (lugaresController.lugares.isEmpty) {
      return Center(
        child: Text(
          lugaresController.apenasFavoritos
              ? "Você ainda não favoritou nenhum lugar."
              : "Nenhum lugar encontrado!",
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: lugaresController.lugares.length,
      itemBuilder: (context, index) {
        final lugar = lugaresController.lugares[index];
        final bool favoritado = lugaresController.eFavorito(lugar.id);

        return Card(
          color: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapaScreen(lugarSelecionado: lugar),
                ),
              );
            },
            title: Text(
              lugar.nome,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              lugar.categoria.toString(),
              style: TextStyle(color: Colors.white70),
            ),
            leading: CircleAvatar(child: Icon(Icons.place)),
            trailing: IconButton(
              onPressed: () => lugaresController.alternarFavorito(lugar.id),
              icon: Icon(
                favoritado ? Icons.favorite : Icons.favorite_border,
                color: favoritado ? Colors.redAccent : Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}