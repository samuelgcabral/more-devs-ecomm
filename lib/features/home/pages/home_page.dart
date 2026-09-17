import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/cart/widgets/cart_icon_button.dart';
import 'package:more_devs_do_zero/features/home/controllers/home_controller.dart';
import 'package:more_devs_do_zero/features/home/widgets/banner_section.dart';
import 'package:more_devs_do_zero/features/home/widgets/categories_section.dart';
import 'package:more_devs_do_zero/features/home/widgets/product_details_modal.dart';
import 'package:more_devs_do_zero/features/home/widgets/products_section.dart';
import 'package:more_devs_do_zero/features/login/controllers/login_controller.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/widgets/app_confirmation_dialog.dart';
import 'package:provider/provider.dart';
import 'package:more_devs_do_zero/features/login/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HomeController>()
        ..getCategories()
        ..getProducts();
    });
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showAppConfirmationDialog<bool>(
      context,
      title: 'Sair',
      content: 'Deseja realmente sair da sua conta?',
      options: [
        AppDialogOption(label: 'Sair', value: true, isDestructive: true),
        AppDialogOption(label: 'Cancelar', value: false),
      ],
    );

    if (shouldLogout == true && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPage.route,
        (route) => false,
      ).then((value) {
        if (mounted) {
          context.read<LoginController>().logout();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<LoginController>(
          builder: (context, loginController, child) {
            return Text(
              'Olá ${loginController.user!.nome}',
              style: AppTextStyle.subTitle,
            );
          },
        ),
        actions: [
          const CartIconButton(),
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: Consumer<HomeController>(
        builder: (context, homeController, child) {
          return ListView(
            children: [
              const BannerSection(),
              CategoriesSection(
                state: homeController.categoriesState,
                categories: homeController.categories,
              ),
              ProductsSection(
                isLoading:
                    homeController.productsState == ProductsViewState.loading,
                hasError:
                    homeController.productsState == ProductsViewState.error,
                products: homeController.products,
                onProductTap: (product) {
                  ProductDetailsModal.show(context, product);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
