import 'package:more_devs_do_zero/features/home/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;
}

class ProductCart extends Product {
  int quantity;

  ProductCart({
    required String category,
    required String brand,
    required String name,
    required String imageUrl,
    required double price,
    required String description,
    this.quantity = 1,
  }) : super(
         category: category,
         brand: brand,
         name: name,
         imageUrl: imageUrl,
         price: price,
         description: description,
       );

  double get subtotal => price * quantity;
}
