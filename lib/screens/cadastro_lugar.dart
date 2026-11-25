import 'package:flutter/material.dart';
import 'package:app/controllers/camera_controller.dart';
import 'package:app/models/lugares_model.dart';
import 'package:app/services/lugares_service.dart';
import 'package:provider/provider.dart';

class CadastroLugar extends StatefulWidget {
  const new({super.key});

  @override
  State<CadastroLugar> createState() => _CadastroLugarState();
}

class _CadastroLugarState extends State<CadastroLugar> {
  //=====================================================
  final _nomeController = TextEditingController();
  final _descController = TextEditingController();
  final _latiController = TextEditingController();
  final _longiController = TextEditingController();
  final _categoriaIdController = TextEditingController();
  final _token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNzk1NjMxNjQ0LCJleHAiOjE3OTU3MTgwNDR9.d_Pl97BPL9eONMPdCF2p8kc_zLT7xjfokAx1oT6HLow";
  //=====================================================
  @override

  void _salvarDados () async {
    final novoLugar = LugaresModel(
      nome: _nomeController.text, 
      descricao: _descController.text,
      latitude: double.parse(_latiController.text), 
      longitude: double.parse(_longiController.text), 
      categoriaId: int.parse(_categoriaIdController.text)
      );

      LugaresService().cadastrarLugar(novoLugar, _token);

      _nomeController.clear();
      _descController.clear();
      _latiController.clear();
      _longiController.clear();
      _categoriaIdController.clear();
      Navigator.of(context).pop;
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CameraController>(
        builder: (context, controle, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(16),
                    image: exibirImagem(controle)

                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () => abrirModal(controle, context),
                    icon: Icon(Icons.camera_alt_rounded)
                  )
                ),
              ],
            ),
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black)
              ),
              child: Column(
                children: [
                TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  label: Text("Nome")
                ),
              ),
              SizedBox(height: 20,),

              TextField(
                controller: _descController,
                decoration: InputDecoration(
                  label: Text("Descrição")
                ),
              ),
              SizedBox(height: 20,),

              TextField(
                controller: _latiController,
                decoration: InputDecoration(
                  label: Text("Latitude")
                ),
              ),
              SizedBox(height: 20,),

              TextField(
                controller: _longiController,
                decoration: InputDecoration(
                  label: Text("Longitude")
                ),
              ),
              SizedBox(height: 20,),

              TextField(
                controller: _categoriaIdController,
                decoration: InputDecoration(
                  label: Text("Categoria ID")
                ),
              ),
              SizedBox(height: 20,),

              Row(
                children: [
                  TextButton(onPressed: (){
                  _salvarDados();
            }, child: Text("Salvar"))
                ],
              )
                ],
              ),
            ),
          ],
        ),
        ),
    );
  }
}

DecorationImage exibirImagem(CameraController controle) {
  if (controle.imagemSelecionada == null){
    return DecorationImage(image: NetworkImage('https://placehold.co/150x150.png'));
  } else {
    return DecorationImage(
      image: FileImage(controle.imagemSelecionada!)/*FileImage(controle.imagemSelecionada!)*/,
      fit: BoxFit.cover
      );
  }
}

void abrirModal(CameraController controle, context) {
  showModalBottomSheet(
    context: context, 
    builder: (context) =>
      SafeArea(
        bottom: true,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              onTap: () {
                controle.chamarCamera();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              onTap: (){
                controle.chamarGaleria();
                Navigator.pop(context);
              },
            )
          ],
        )
      ),
  );
}