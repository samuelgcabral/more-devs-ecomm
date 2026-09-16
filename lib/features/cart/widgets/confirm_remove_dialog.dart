import 'package:flutter/material.dart';

Future<bool> confirmRemoveFromCart(
  BuildContext context,
  String productName,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Remover item'),
      content: Text('Remover $productName do carrinho?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Remover'),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}
