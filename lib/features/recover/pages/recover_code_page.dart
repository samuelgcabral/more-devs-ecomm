import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/recover/controllers/recover_code_controller.dart';
import 'package:more_devs_do_zero/features/recover/pages/reset_password_page.dart';
import 'package:more_devs_do_zero/features/recover/services/recover_service.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/exceptions/api_exception.dart';
import 'package:more_devs_do_zero/shared/widgets/app_elevated_button.dart';
import 'package:more_devs_do_zero/shared/widgets/app_snack_bar.dart';
import 'package:more_devs_do_zero/shared/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class RecoverCodePage extends StatefulWidget {
  const RecoverCodePage({super.key, required this.email});

  static const String route = '/recover/code';

  final String email;

  @override
  State<RecoverCodePage> createState() => _RecoverCodePageState();
}

class _RecoverCodePageState extends State<RecoverCodePage> {
  late final RecoverCodeController codeController;
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    codeController = RecoverCodeController(
      context.read<RecoverService>(),
      email: widget.email,
    );
  }

  Future<void> _verifyCode() async {
    if (!key.currentState!.validate()) return;

    setState(() => codeController.isLoading = true);

    try {
      final resetToken = await codeController.verifyCode();
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        ResetPasswordPage.route,
        arguments: resetToken,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, e.message);
    } finally {
      if (mounted) setState(() => codeController.isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    setState(() => codeController.isResending = true);

    try {
      final message = await codeController.resendCode();
      if (!mounted) return;
      showSuccessSnackBar(context, message);
    } on ApiException catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, e.message);
    } finally {
      if (mounted) setState(() => codeController.isResending = false);
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar senha')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Digite o código',
                  style: AppTextStyle.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enviamos um código de 6 dígitos para ${widget.email}',
                  style: AppTextStyle.smallGrey,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AppTextField(
                  controller: codeController.codeController,
                  hintText: '000000',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: codeController.validateCode,
                  onFieldSubmitted: (_) => _verifyCode(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: codeController.isResending ? null : _resendCode,
                    child: Text(
                      'Reenviar código',
                      style: AppTextStyle.smallBlack,
                    ),
                  ),
                ),
                const Spacer(),
                AppElevatedButton(
                  label: 'Continuar',
                  type: ButtonType.filled,
                  isLoading: codeController.isLoading,
                  onPressed: _verifyCode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
