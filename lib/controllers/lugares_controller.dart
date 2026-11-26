import 'package:flutter/material.dart';
import 'package:app/models/lugares_model.dart';
import 'package:app/services/lugares_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LugaresController extends ChangeNotifier{
  bool carregando = false;
  String erro = '';
  List<LugaresModel> _lugares = [];
  List<LugaresModel> get lugares {
    return _lugares.where((lugar) {
      final bool passaFavorito =
          !_apenasFavoritos || _favoritosIds.contains(lugar.id.toString());

      final bool passaCategoria = _categoriaSelecionadaID == null ||
          lugar.categoriaId.toString() == _categoriaSelecionadaID.toString();

      return passaFavorito && passaCategoria;
    }).toList();
  }

  //Inicializar 
  LugaresController() {
    _carregarFavoritosLocais();
    listarLugares();
  }


  //controlando os favoritos
  final Set<String> _favoritosIds = {};
  bool _apenasFavoritos = false;
  int? _categoriaSelecionadaID;

  bool get apenasFavoritos => _apenasFavoritos;
  int? get categoriaSelecionadaID => _categoriaSelecionadaID;


  // Filtro da categoria
  void selecionarCategoria(int? categoriaID) {
    // Se tocar novamente na categoria já ativa, limpa o filtro
    if (_categoriaSelecionadaID == categoriaID) {
      _categoriaSelecionadaID = null;
    } else {
      _categoriaSelecionadaID = categoriaID;
    }
    notifyListeners();
  }
  // Retorna todos os lugares ou apenas os favoritados conforme o filtro ativo
  bool eFavorito(dynamic id) => _favoritosIds.contains(id.toString());

  Future<void> alternarFavorito(dynamic id) async {
    final idStr = id.toString();
    if (_favoritosIds.contains(idStr)) {
      _favoritosIds.remove(idStr);
    } else {
      _favoritosIds.add(idStr);
    }
    notifyListeners();
    await _salvarFavoritosLocais();
  }

  void alternarFiltroFavoritos() {
    _apenasFavoritos = !_apenasFavoritos;
    notifyListeners();
  }

  Future<void> _carregarFavoritosLocais() async {
    final prefs = await SharedPreferences.getInstance();
    final salvos = prefs.getStringList('lugares_favoritos') ?? [];
    _favoritosIds.addAll(salvos);
    notifyListeners();
  }

  Future<void> _salvarFavoritosLocais() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('lugares_favoritos', _favoritosIds.toList());
  }

  Future<void> listarLugares() async {
    carregando = true;
    notifyListeners();
    try{
      final lugaresService = LugaresService();
      final listaLugares = await lugaresService.buscarLugares();
      _lugares = listaLugares; 
    } catch(error){
      erro = "Erro ao listar: ${error.toString()}";

    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<String> cadastrarLugar(LugaresModel dados) async {
    //final token = await SessionService().pegarToken() ?? '';
    carregando = true;
    erro = "";
    notifyListeners();
    try {
      final lugaresService = LugaresService();
      final resposta = await lugaresService.cadastrarLugar(dados, "");
      await listarLugares();
      return resposta;
    }catch(e){
      erro = "Erro ao cadastrar: $e";
      return erro;
    }finally{
      carregando = false;
      notifyListeners();
    }
  }
}