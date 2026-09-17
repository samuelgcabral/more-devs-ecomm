import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';

Future<bool> confirmRemoveFromCart(
  BuildContext context,
  String productName,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      content: Text(
        'Você gostaria de remover $productName do carrinho?',
        style: AppTextStyle.smallBlack,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text('Não', style: AppTextStyle.smallBlack),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text('Sim', style: AppTextStyle.smallRed),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}
