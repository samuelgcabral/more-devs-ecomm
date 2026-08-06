import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/widgets/app_elevated_button.dart';
import 'package:more_devs_do_zero/shared/widgets/app_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  static const String route = '/signup';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
                onChanged: (value) {},
              ),
              SizedBox(height: 16),
              AppTextField(hintText: 'nome'),
              SizedBox(height: 16),
              AppTextField(hintText: 'senha', obscureText: true),
              SizedBox(height: 16),
              AppTextField(hintText: 'confirmar senha', obscureText: true),
              Spacer(),
              GestureDetector(
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
                            'Ao clicar em continuar, você concorda com os nossos\n',
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
              SizedBox(height: 16),
              AppElevatedButton(
                label: 'Continuar',
                onPressed: () => {print('cliquei em continuar')},
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
