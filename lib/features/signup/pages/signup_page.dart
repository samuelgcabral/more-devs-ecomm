import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/signup/controllers/signup_controller.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/widgets/app_check_box.dart';
import 'package:more_devs_do_zero/shared/widgets/app_elevated_button.dart';
import 'package:more_devs_do_zero/shared/widgets/app_required_password.dart';
import 'package:more_devs_do_zero/shared/widgets/app_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  static const String route = '/signup';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupController signupController = SignupController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24),
              Center(
                child: Text(
                  'Criar uma conta',
                  style: AppTextStyle.title,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  'Insira seus dados para iniciar suas compras',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              AppTextField(
                hintText: 'email@dominio.com',
                onChanged: (value) {
                  setState(() {
                    signupController.setEmail(value);
                  });
                },
              ),
              SizedBox(height: 16),
              AppTextField(
                hintText: 'nome',
                onChanged: (value) {
                  setState(() {
                    signupController.setNome(value);
                  });
                },
              ),
              SizedBox(height: 16),
              AppTextField(
                hintText: 'senha',
                onChanged: (value) {
                  setState(() {
                    signupController.setSenha(value);
                  });
                },
                obscureText: true,
              ),
              SizedBox(height: 16),
              AppTextField(
                hintText: 'confirmar senha',
                onChanged: (value) {
                  setState(() {
                    signupController.setConfirmarSenha(value);
                  });
                },
                obscureText: true,
              ),
              for (var requiremnt in signupController.getPasswordRequirements())
                AppRequiredPassword(
                  atendido: requiremnt.values.first,
                  text: requiremnt.keys.first,
                ),

              Spacer(),
              Row(
                children: [
                  AppCheckBox(
                    value: signupController.isActiveCheckBox,
                    onChanged: (value) {
                      setState(() {
                        signupController.changeActiveCheckBox();
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        print('CLIQUEI NA LINHA');
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                              text:
                                  'Ao clicar em continuar, você concorda com os nossos',
                            ),
                            TextSpan(
                              text: 'Termos de Serviço ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(text: 'e com a '),
                            TextSpan(
                              text: 'Politica de Privacidade',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              AppElevatedButton(
                label: 'Continuar',
                isLoading: signupController.isLoading,
                onPressed: signupController.isActiveButton
                    ? () async {
                        setState(() {
                          signupController.isLoading = true;
                        });

                        await signupController.signUp();

                        setState(() {
                          signupController.isLoading = false;
                        });
                      }
                    : null,
                type: ButtonType.filled,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
