import 'dart:math';

import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/home/controllers/home_controller.dart';
import 'package:more_devs_do_zero/features/home/models/category_model.dart';
import 'package:more_devs_do_zero/features/login/controllers/login_controller.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/widgets/app_elevated_button.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HomeController>().getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<LoginController>(
          builder: (context, loginController, child) {
            return Text(
              'Olá ${loginController.user!.nome}',
              style: AppTextStyle.title,
            );
          },
        ),
      ),
      body: Consumer<HomeController>(
        builder: (context, homeController, child) {
          return Column(
            children: [
              SizedBox(
                child: switch (homeController.categoriesState) {
                  CategoriesViewState.loading => Center(
                    child: CircularProgressIndicator(),
                  ),
                  CategoriesViewState.error => Text(
                    'Problema ao resgatar categorias',
                  ),
                  CategoriesViewState.success => SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: homeController.categories.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        Category category = homeController.categories[index];
                        return Container(
                          margin: EdgeInsets.all(10),
                          // height: 50,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 76,
                                child: Image.network(category.imageUrl),
                              ),
                              Text(category.name, style: AppTextStyle.title),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
