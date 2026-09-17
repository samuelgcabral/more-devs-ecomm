import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';

class AppDialogOption<T> {
  const AppDialogOption({
    required this.label,
    required this.value,
    this.isDestructive = false,
  });

  final String label;
  final T value;
  final bool isDestructive;
}

Future<T?> showAppConfirmationDialog<T>(
  BuildContext context, {
  String? title,
  required String content,
  required List<AppDialogOption<T>> options,
}) {
  return showDialog<T>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      title: title != null ? Text(title) : null,
      content: Text(content, style: AppTextStyle.smallBlack),
      actions: [
        for (final option in options)
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, option.value),
            child: Text(
              option.label,
              style: option.isDestructive
                  ? AppTextStyle.smallRed
                  : AppTextStyle.smallBlack,
            ),
          ),
      ],
    ),
  );
}
