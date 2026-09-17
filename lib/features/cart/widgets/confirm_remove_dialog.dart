import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';

class DialogOption<T> {
  const DialogOption({required this.label, required this.value, this.style});

  final String label;
  final T value;
  final TextStyle? style;
}

Future<T?> showConfirmationDialog<T>(
  BuildContext context, {
  required String content,
  required List<DialogOption<T>> options,
}) {
  return showDialog<T>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      content: Text(content, style: AppTextStyle.smallBlack),
      actions: [
        for (final option in options)
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, option.value),
            child: Text(option.label, style: option.style),
          ),
      ],
    ),
  );
}

Future<bool> confirmRemoveFromCart(
  BuildContext context,
  String productName,
) async {
  final confirmed = await showConfirmationDialog<bool>(
    context,
    content: 'Você gostaria de remover $productName do carrinho?',
    options: [
      DialogOption(
        label: 'Não',
        value: false,
        style: AppTextStyle.smallBlack,
      ),
      DialogOption(
        label: 'Sim',
        value: true,
        style: AppTextStyle.smallRed,
      ),
    ],
  );

  return confirmed ?? false;
}
