import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/features/home/widgets/products_section.dart';

void main() {
  testWidgets('mouse wheel scrolls the products list horizontally', (
    tester,
  ) async {
    final products = List.generate(
      20,
      (i) => Product(
        category: 'cat',
        brand: 'brand',
        name: 'Product $i',
        imageUrl: '',
        price: 10,
        description: 'desc',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              ProductsSection(
                isLoading: false,
                hasError: false,
                products: products,
                onProductTap: (_) {},
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final scrollable = find.descendant(
      of: find.byType(ProductsSection),
      matching: find.byType(Scrollable),
    );
    final controller = tester
        .state<ScrollableState>(scrollable)
        .position;
    expect(controller.pixels, 0);
    expect(controller.maxScrollExtent, greaterThan(0));

    final center = tester.getCenter(find.text('Product 0'));
    final testPointer = TestPointer(1, PointerDeviceKind.mouse);
    testPointer.hover(center);
    await tester.sendEventToBinding(
      testPointer.scroll(const Offset(0, 300)),
    );
    await tester.pumpAndSettle();

    expect(controller.pixels, greaterThan(0));
  });
}
