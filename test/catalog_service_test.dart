import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:more_devs_do_zero/features/home/services/catalog_service.dart';
import 'package:more_devs_do_zero/shared/exceptions/api_exception.dart';

import 'fake_http_client_adapter.dart';

void main() {
  late FakeHttpClientAdapter adapter;
  late CatalogService service;

  setUp(() {
    adapter = FakeHttpClientAdapter(200, {});
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test/api/v1'))
      ..httpClientAdapter = adapter;
    service = CatalogService(dio);
  });

  test('categories are deserialized from the data envelope', () async {
    adapter.body = {
      'data': [
        {
          'id': 'f7616dbe-9cbb-4dde-93b6-0a8c2eda5cfa',
          'name': 'Frutas',
          'imageUrl': 'https://i.postimg.cc/SNX7hc6F/Image.png',
        },
      ],
    };

    final categories = await service.getCategories();

    expect(adapter.lastRequest?.path, '/categories');
    expect(categories.single.id, 'f7616dbe-9cbb-4dde-93b6-0a8c2eda5cfa');
    expect(categories.single.name, 'Frutas');
  });

  test('products are filtered by category id', () async {
    adapter.body = {
      'data': [productJson()],
    };

    final products = await service.getProducts(categoryId: 'category-id');

    expect(adapter.lastRequest?.path, '/products');
    expect(adapter.lastRequest?.queryParameters, {'categoryId': 'category-id'});
    expect(products.single.name, 'Abacaxi pérola');
    expect(products.single.price, 11.5);
    expect(products.single.categoryId, 'f7616dbe-9cbb-4dde-93b6-0a8c2eda5cfa');
  });

  test('all products are requested without filters', () async {
    adapter.body = {'data': []};

    await service.getProducts();

    expect(adapter.lastRequest?.queryParameters, isEmpty);
  });

  test('server errors become an ApiException with the API message', () async {
    adapter
      ..statusCode = 500
      ..body = {
        'code': 'INTERNAL_ERROR',
        'message': 'Erro interno, tente novamente mais tarde',
      };

    expect(
      service.getCategories(),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Erro interno, tente novamente mais tarde',
        ),
      ),
    );
  });
}
