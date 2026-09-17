import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/shared/widgets/app_confirmation_dialog.dart';

Future<bool> confirmRemoveFromCart(
  BuildContext context,
  String productName,
) async {
  final confirmed = await showAppConfirmationDialog<bool>(
    context,
    content: 'Você gostaria de remover $productName do carrinho?',
    options: [
      AppDialogOption(label: 'Não', value: false),
      AppDialogOption(label: 'Sim', value: true, isDestructive: true),
    ],
  );

  return confirmed ?? false;
}
