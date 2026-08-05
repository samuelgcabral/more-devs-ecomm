import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/pages/signup_page.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/widgets/app_elevated_button.dart';
import 'package:more_devs_do_zero/shared/widgets/app_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String route = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Safearea desconta espaços do disposito ex: barra superior
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),

              Image.asset('assets/images/logo.png', height: 120),

              Center(child: Text('+DevsEcomm', style: AppTextStyle.title)),
              Spacer(flex: 2),
              AppTextField(hintText: 'email@dominio.com'),
              SizedBox(height: 16),
              AppTextField(hintText: '****************'),
              Align(
                alignment: AlignmentGeometry.centerRight,
                child: TextButton(
                  onPressed: () => {},
                  child: Text(
                    'Esqueci minha senha',
                    style: AppTextStyle.smallBlack,
                  ),
                ),
              ),
              AppElevatedButton(
                label: 'Entrar',
                onPressed: () => {},
                type: ButtonType.filled,
              ),
              SizedBox(height: 12),
              AppElevatedButton(
                label: 'Cadastrar',
                onPressed: () => {
                  Navigator.pushNamed(context, SignupPage.route),
                },
                type: ButtonType.outlined,
              ),
              Spacer(flex: 2),
              //GestureDetector adiciona métodos de interação com usuario ex: onTap
              GestureDetector(
                onTap: () {
                  print('CLIQUEI NA LINHA');
                },
                //RichText - Aninhar textos e modificar seu alinhamento
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Termos de Serviço ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'e ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: 'Politicas de Privacidade',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
