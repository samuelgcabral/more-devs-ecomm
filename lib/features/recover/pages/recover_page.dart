import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/recover/controllers/recover_controller.dart';
import 'package:more_devs_do_zero/features/recover/pages/recover_code_page.dart';
import 'package:more_devs_do_zero/features/recover/services/recover_service.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/exceptions/api_exception.dart';
import 'package:more_devs_do_zero/shared/widgets/app_elevated_button.dart';
import 'package:more_devs_do_zero/shared/widgets/app_snack_bar.dart';
import 'package:more_devs_do_zero/shared/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class RecoverPage extends StatefulWidget {
  const RecoverPage({super.key});

  static const String route = '/recover';

  @override
  State<RecoverPage> createState() => _RecoverPageState();
}

class _RecoverPageState extends State<RecoverPage> {
  late final RecoverController recoverController;

  @override
  void initState() {
    super.initState();
    recoverController = RecoverController(context.read<RecoverService>());
  }

  Future<void> _sendCode() async {
    setState(() => recoverController.isLoading = true);

    try {
      final message = await recoverController.sendCode();
      if (!mounted) return;
      showSuccessSnackBar(context, message);
      Navigator.pushNamed(
        context,
        RecoverCodePage.route,
        arguments: recoverController.email.trim(),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, e.message);
    } finally {
      if (mounted) setState(() => recoverController.isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar senha')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text('Digite seu e-mail', style: AppTextStyle.title),
                  AppTextField(
                    hintText: 'email@dominio.com',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        recoverController.setEmail(value);
                      });
                    },
                  ),
                  Spacer(),
                  AppElevatedButton(
                    label: 'Continuar',
                    type: ButtonType.filled,
                    isLoading: recoverController.isLoading,
                    onPressed: recoverController.isActiveButton
                        ? _sendCode
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
