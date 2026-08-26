import 'package:flutter/widgets.dart';

enum CategoriesViewState { loading, success, error }

class HomeController extends ChangeNotifier {
  List<Category> categories = [];

  CategoriesViewState categoriesState = CategoriesViewState.loading;

  void changeCategoriesState(CategoriesViewState state) {
    categoriesState = state;
    notifyListeners();
  }

  Future<void> getCategories() async {
    changeCategoriesState(CategoriesViewState.loading);
    //simula o delay da API
    await Future.delayed(Duration(seconds: 3));
    try {
      //desserealza e popula a nossa lista de categorias
      categories = [
        for (var element in categoriesJson) Category.fromJson(element),
      ];
      changeCategoriesState(CategoriesViewState.success);
    } catch (e) {
      //caso der erro na deserialização, emite o erro para a tela tratar
      changeCategoriesState(CategoriesViewState.error);
    }
  }
}

class Category {
  final String name;
  final String imageUrl;

  Category({required this.name, required this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name'], imageUrl: json['imageUrl']);
  }
}

final List<Map<String, dynamic>> categoriesJson = [
  {'name': 'Frutas', 'imageUrl': 'https://i.postimg.cc/SNX7hc6F/Image.png'},
  {
    'name': 'Verduras',
    'imageUrl': 'https://i.postimg.cc/8PFBSLh2/Image-(1).png',
  },
  {'name': 'Padaria', 'imageUrl': 'https://i.postimg.cc/xTky2LvV/Image-1.png'},
  {
    'name': 'Importados',
    'imageUrl': 'https://i.postimg.cc/Yq4fHQ6w/Image-2.png',
  },
];
