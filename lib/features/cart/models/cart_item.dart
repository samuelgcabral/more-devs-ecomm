import 'package:more_devs_do_zero/features/home/models/product_model.dart';

class ProductCart extends Product {
  int quantity;

  ProductCart({
    required super.category,
    required super.brand,
    required super.name,
    required super.imageUrl,
    required super.price,
    required super.description,
    required super.id,
    this.quantity = 1,
  });

  factory ProductCart.fromProduct(Product product, {int quantity = 1}) {
    return ProductCart(
      id: product.id,
      category: product.category,
      brand: product.brand,
      name: product.name,
      imageUrl: product.imageUrl,
      price: product.price,
      description: product.description,
      quantity: quantity,
    );
  }

  double get subtotal => price * quantity;
}
