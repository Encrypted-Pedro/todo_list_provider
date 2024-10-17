import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_field.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_logo.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: context.read<LoginController>())
        .listener(
            context: context,
            everCallback: (notifier, listenerInstance) {
              if (notifier is LoginController) {
                if (notifier.hasInfo) {
                  Messages.of(context).showInfo(notifier.infoMessage!);
                }
              }
            },
            successVoidCallback: (notifier, listenerInstance) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const TodoListLogo(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TodoListField(
                                controller: _emailEC,
                                validator: Validatorless.multiple([
                                  Validatorless.required('E-mail obrigatório'),
                                  Validatorless.email('E-mail inválido')
                                ]),
                                focusNode: _emailFocus,
                                label: 'E-mail',
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TodoListField(
                                controller: _passwordEC,
                                validator: Validatorless.multiple([
                                  Validatorless.required('Senha obrigatória'),
                                  Validatorless.min(6,
                                      'Senha deve conter no mínimo 6 caracteres')
                                ]),
                                label: 'Senha',
                                obscureText: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        if (_emailEC.text.isNotEmpty) {
                                          context
                                              .read<LoginController>()
                                              .forgotPassword(_emailEC.text);
                                        } else {
                                          _emailFocus.requestFocus();
                                          Messages.of(context).showError(
                                              'Digite um e-mail para recuperar a senha');
                                        }
                                      },
                                      child: const Text('Esqueceu a senha?')),
                                  ElevatedButton(
                                    onPressed: () {
                                      final formValid =
                                          _formKey.currentState?.validate() ??
                                              false;
                                      if (formValid) {
                                        final email = _emailEC.text;
                                        final password = _passwordEC.text;
                                        context
                                            .read<LoginController>()
                                            .login(email, password);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F3F7),
                          border: Border(
                            top: BorderSide(
                              width: 2,
                              color: Colors.grey.withAlpha(50),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 39,
                            ),
                            SignInButton(Buttons.Google,
                                padding: const EdgeInsets.all(5),
                                text: 'Continue com o Google',
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none),
                                onPressed: () {
                              context.read<LoginController>().googleLogin();
                            }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Não tem conta?'),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/register');
                                    },
                                    child: const Text('Cadastre-se'))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
