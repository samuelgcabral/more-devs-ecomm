import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:more_devs_do_zero/features/cart/models/cart_item.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';

enum LoginFailureReason {
  invalidCredentials('invalid_credentials'),
  invalidForm('invalid_form'),
  network('network_error'),
  server('server_error');

  const LoginFailureReason(this.value);

  final String value;
}

// Único ponto do app que conhece o Firebase Analytics. Cada evento da jornada
// tem um método próprio; widgets e controllers nunca montam eventos na mão.
//
// Regra: nenhum dado pessoal (nome, e-mail, senha, telefone, CPF). Em erro,
// envia-se só o tipo do erro, nunca a mensagem.
class AppAnalytics {
  AppAnalytics([this._analytics]);

  static const String currency = 'BRL';
  static const String homeListName = 'home';
  static const String _emailMethod = 'email';

  FirebaseAnalytics? _analytics;

  // Resolvido só no primeiro evento, para que testes que não enviam eventos
  // não precisem do Firebase inicializado.
  FirebaseAnalytics get _firebase => _analytics ??= FirebaseAnalytics.instance;

  void logScreenView(String screenName) {
    final params = {'screen_name': screenName};
    send(
      'screen_view',
      params,
      (fa) => fa.logScreenView(screenName: screenName),
    );
  }

  // ---------------------------------------------------------------- auth

  void logLogin() {
    send('login', {
      'method': _emailMethod,
    }, (fa) => fa.logLogin(loginMethod: _emailMethod));
  }

  void logLoginFailed(LoginFailureReason reason) {
    _logCustom('login_failed', {'reason': reason.value});
  }

  void logPasswordResetRequest() {
    _logCustom('password_reset_request', {});
  }

  void logSignUp() {
    send('sign_up', {
      'method': _emailMethod,
    }, (fa) => fa.logSignUp(signUpMethod: _emailMethod));
  }

  void logSignUpFailed(String errorType) {
    _logCustom('sign_up_failed', {'error_type': errorType});
  }

  // ------------------------------------------------------------- catalog

  void logViewItemList(String listName) {
    send('view_item_list', {
      'item_list_name': listName,
    }, (fa) => fa.logViewItemList(itemListName: listName));
  }

  void logViewItem(Product product, String listName) {
    final params = {
      ..._productParams(product),
      'currency': currency,
      'item_list_name': listName,
    };
    send(
      'view_item',
      params,
      (fa) => fa.logViewItem(
        currency: currency,
        value: product.price,
        items: [_productItem(product, listName: listName)],
        parameters: params,
      ),
    );
  }

  void logSearch({
    required String searchTerm,
    required String listName,
    required int resultsCount,
  }) {
    final params = {
      'search_term': searchTerm,
      'item_list_name': listName,
      'results_count': resultsCount,
    };
    send(
      'search',
      params,
      (fa) => fa.logSearch(
        searchTerm: searchTerm,
        parameters: {'item_list_name': listName, 'results_count': resultsCount},
      ),
    );
  }

  void logFilterBrand({
    required String brand,
    required String listName,
    required int resultsCount,
  }) {
    _logCustom('filter_brand', {
      'item_brand': brand,
      'item_list_name': listName,
      'results_count': resultsCount,
    });
  }

  void logLoadError(String section) {
    _logCustom('load_error', {'section': section});
  }

  // ---------------------------------------------------------------- cart

  void logAddToCart(Product product) {
    const quantity = 1;
    final value = product.price * quantity;
    final params = {
      ..._productParams(product),
      'quantity': quantity,
      'value': value,
      'currency': currency,
    };
    send(
      'add_to_cart',
      params,
      (fa) => fa.logAddToCart(
        currency: currency,
        value: value,
        items: [_productItem(product, quantity: quantity)],
        parameters: params,
      ),
    );
  }

  void logRemoveFromCart(Product product, int quantity) {
    final value = product.price * quantity;
    final params = {
      ..._productParams(product),
      'quantity': quantity,
      'value': value,
      'currency': currency,
    };
    send(
      'remove_from_cart',
      params,
      (fa) => fa.logRemoveFromCart(
        currency: currency,
        value: value,
        items: [_productItem(product, quantity: quantity)],
        parameters: params,
      ),
    );
  }

  void logViewCart(List<CartItem> items, double total) {
    send(
      'view_cart',
      _cartParams(items, total),
      (fa) => fa.logViewCart(
        currency: currency,
        value: total,
        items: _cartItems(items),
      ),
    );
  }

  void logBeginCheckout(List<CartItem> items, double total) {
    send(
      'begin_checkout',
      _cartParams(items, total),
      (fa) => fa.logBeginCheckout(
        currency: currency,
        value: total,
        items: _cartItems(items),
      ),
    );
  }

  void logPurchase(
    List<CartItem> items,
    double total, {
    String? transactionId,
  }) {
    send(
      'purchase',
      {..._cartParams(items, total), 'transaction_id': ?transactionId},
      (fa) => fa.logPurchase(
        currency: currency,
        value: total,
        items: _cartItems(items),
        transactionId: transactionId,
      ),
    );
  }

  // ------------------------------------------------------------- helpers

  void _logCustom(String name, Map<String, Object> params) {
    send(name, params, (fa) => fa.logEvent(name: name, parameters: params));
  }

  Map<String, Object> _productParams(Product product) {
    return {
      'item_id': product.id,
      'item_name': product.name,
      'item_brand': product.brand,
      'item_category': product.category,
      'price': product.price,
    };
  }

  AnalyticsEventItem _productItem(
    Product product, {
    int? quantity,
    String? listName,
  }) {
    return AnalyticsEventItem(
      itemId: product.id,
      itemName: product.name,
      itemBrand: product.brand,
      itemCategory: product.category,
      price: product.price,
      quantity: quantity,
      itemListName: listName,
    );
  }

  List<AnalyticsEventItem> _cartItems(List<CartItem> items) {
    return [
      for (final item in items)
        AnalyticsEventItem(
          itemId: item.product.id,
          itemName: item.product.name,
          quantity: item.quantity,
          price: item.product.price,
          parameters: {'subtotal': item.product.price * item.quantity},
        ),
    ];
  }

  // Versão "plana" dos itens, usada só para inspeção (ex.: testes).
  Map<String, Object> _cartParams(List<CartItem> items, double total) {
    return {
      'currency': currency,
      'value': total,
      'items': [
        for (final item in items)
          {
            'item_id': item.product.id,
            'item_name': item.product.name,
            'quantity': item.quantity,
            'subtotal': item.product.price * item.quantity,
          },
      ],
    };
  }

  // Envia o evento sem bloquear a UI. Falha de analytics nunca pode quebrar o
  // fluxo do usuário, então o erro é só registrado no console.
  @protected
  void send(
    String name,
    Map<String, Object> parameters,
    Future<void> Function(FirebaseAnalytics analytics) firebaseCall,
  ) {
    unawaited(
      Future(() => firebaseCall(_firebase)).catchError((Object error) {
        debugPrint('AppAnalytics: falha ao enviar "$name": $error');
      }),
    );
  }
}
