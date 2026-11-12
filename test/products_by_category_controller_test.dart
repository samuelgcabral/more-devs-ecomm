import 'package:flutter_test/flutter_test.dart';
import 'package:more_devs_do_zero/features/home/controllers/products_by_category_controller.dart';
import 'package:more_devs_do_zero/features/home/models/category_model.dart';
import 'package:more_devs_do_zero/features/home/services/catalog_service.dart';

import 'fake_app_analytics.dart';
import 'fake_http_client_adapter.dart';

void main() {
  late FakeAppAnalytics analytics;
  late ProductsByCategoryController controller;

  final frutas = Category(id: 'f7616dbe', name: 'Frutas', imageUrl: '');

  Map<String, dynamic> product(String id, String name, String brand) {
    return {...productJson(id: id, name: name), 'brand': brand};
  }

  setUp(() async {
    final adapter = FakeHttpClientAdapter(200, {
      'data': [
        product('1', 'Abacaxi', 'Sítio do Vale'),
        product('2', 'Acerola', 'Natural da Terra'),
        product('3', 'Banana', 'Sítio do Vale'),
      ],
    });
    analytics = FakeAppAnalytics();
    controller = ProductsByCategoryController(
      CatalogService(fakeApiClient(adapter)),
      analytics,
    );
    await controller.getProductsByCategory(frutas);
    analytics.events.clear();
  });

  tearDown(() => controller.dispose());

  test('brands are unique and sorted', () {
    expect(controller.brands, ['Natural da Terra', 'Sítio do Vale']);
  });

  test('selecting a brand filters the products and logs filter_brand', () {
    controller.setSelectedBrand('Sítio do Vale');

    expect(controller.products.map((p) => p.name), ['Abacaxi', 'Banana']);
    final event = analytics.events.single;
    expect(event.name, 'filter_brand');
    expect(event.parameters, {
      'item_brand': 'Sítio do Vale',
      'item_list_name': 'Frutas',
      'results_count': 2,
    });
  });

  test('the brand filter combines with the search', () {
    controller
      ..setSelectedBrand('Sítio do Vale')
      ..search('ban');

    expect(controller.products.map((p) => p.name), ['Banana']);
  });

  test('going back to all brands clears the filter and logs "all"', () {
    controller.setSelectedBrand('Sítio do Vale');
    analytics.events.clear();

    controller.setSelectedBrand(null);

    expect(controller.products, hasLength(3));
    final event = analytics.events.single;
    expect(event.name, 'filter_brand');
    expect(event.parameters, {
      'item_brand': 'all',
      'item_list_name': 'Frutas',
      'results_count': 3,
    });
  });

  test('re-selecting the current brand logs nothing', () {
    controller.setSelectedBrand(null);

    expect(analytics.events, isEmpty);
  });

  test('loading a category resets the selected brand', () async {
    controller.setSelectedBrand('Sítio do Vale');

    await controller.getProductsByCategory(frutas);

    expect(controller.selectedBrand, isNull);
    expect(controller.products, hasLength(3));
  });
}
