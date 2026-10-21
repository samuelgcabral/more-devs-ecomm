import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/login/pages/login_page.dart';
import 'package:more_devs_do_zero/features/recover/controllers/reset_password_controller.dart';
import 'package:more_devs_do_zero/features/recover/services/recover_service.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/exceptions/auth_exception.dart';
import 'package:more_devs_do_zero/shared/widgets/app_elevated_button.dart';
import 'package:more_devs_do_zero/shared/widgets/app_required_password.dart';
import 'package:more_devs_do_zero/shared/widgets/app_snack_bar.dart';
import 'package:more_devs_do_zero/shared/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.resetToken});

  static const String route = '/recover/reset';

  final String resetToken;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final ResetPasswordController resetController;
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    resetController = ResetPasswordController(
      context.read<RecoverService>(),
      resetToken: widget.resetToken,
    );
  }

  Future<void> _resetPassword() async {
    if (!key.currentState!.validate()) return;

    setState(() => resetController.isLoading = true);

    try {
      await resetController.resetPassword();
      if (!mounted) return;
      showSuccessSnackBar(
        context,
        'Senha alterada com sucesso. Faça login com a nova senha.',
      );
      Navigator.popUntil(context, ModalRoute.withName(LoginPage.route));
    } on AuthException catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, e.message);
    } finally {
      if (mounted) setState(() => resetController.isLoading = false);
    }
  }

  @override
  void dispose() {
    resetController.dispose();
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
                  'Crie uma nova senha',
                  style: AppTextStyle.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AppTextField(
                  controller: resetController.senhaController,
                  hintText: 'nova senha',
                  onChanged: (value) => setState(() {}),
                  validator: resetController.validateSenha,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: resetController.confirmarSenhaController,
                  hintText: 'confirmar nova senha',
                  onChanged: (value) => setState(() {}),
                  validator: resetController.validateConfirmarSenha,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                for (final requirement
                    in resetController.getPasswordRequirements())
                  AppRequiredPassword(
                    atendido: requirement.values.first,
                    text: requirement.keys.first,
                  ),
                const Spacer(),
                AppElevatedButton(
                  label: 'Salvar nova senha',
                  type: ButtonType.filled,
                  isLoading: resetController.isLoading,
                  onPressed: _resetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
