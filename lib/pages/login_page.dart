import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:toy_cryptocurrency_frontend/models/models.dart';

import 'package:toy_cryptocurrency_frontend/providers/providers.dart';
import 'package:toy_cryptocurrency_frontend/services/services.dart';
import 'package:toy_cryptocurrency_frontend/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final loginForm = Provider.of<LoginFormProvider>(context);

    return ScaffoldPage(
      header: const PageHeader(title: Text('Iniciar sesión')),
      content: Stack(
        children: [
          SwitcherTheme(themeProvider: themeProvider),
          Center(
            child: Form(
              key: loginForm.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoAndTitle(themeProvider: themeProvider),
                  const SizedBox(height: 20),
                  LoginEmailForm(loginForm: loginForm),
                  const SizedBox(height: 10),
                  LoginPasswordForm(loginForm: loginForm),
                  const SizedBox(height: 10),
                  const LoginButtonForm(),
                  const SizedBox(height: 40),
                  const RegisterButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginEmailForm extends StatelessWidget {
  const LoginEmailForm({
    Key? key,
    required this.loginForm,
  }) : super(key: key);

  final LoginFormProvider loginForm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormBox(
        header: 'Correo electrónico',
        placeholder: 'Ingresa tu correo electrónico',
        maxLines: 1,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (text) => loginForm.email = text,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Ingresa tu correo electrónico';
          }

          String pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regExp = RegExp(pattern);
          return regExp.hasMatch(text) ? null : 'Correo electrónico no válido';
        },
        textInputAction: TextInputAction.next,
        prefix: const Padding(
          padding: EdgeInsetsDirectional.only(start: 8.0),
          child: Icon(FluentIcons.mail),
        ),
      ),
    );
  }
}

class LoginPasswordForm extends StatefulWidget {
  const LoginPasswordForm({Key? key, required this.loginForm})
      : super(key: key);

  final LoginFormProvider loginForm;

  @override
  State<LoginPasswordForm> createState() => _LoginPasswordFormState();
}

class _LoginPasswordFormState extends State<LoginPasswordForm> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormBox(
        header: 'Contraseña',
        placeholder: 'Ingresa tu contraseña',
        obscureText: !_showPassword,
        maxLines: 1,
        suffix: IconButton(
          icon: Icon(!_showPassword ? FluentIcons.lock : FluentIcons.unlock),
          onPressed: () => setState(() => _showPassword = !_showPassword),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (text) => widget.loginForm.password = text,
        validator: (text) {
          if (text == null || text.isEmpty) return 'Ingresa tu contraseña';

          return (text.length >= 8)
              ? null
              : 'La contraseña debe tener al menos 8 caracteres';
        },
        textInputAction: TextInputAction.next,
        prefix: const Padding(
          padding: EdgeInsetsDirectional.only(start: 8.0),
          child: Icon(FluentIcons.password_field),
        ),
      ),
    );
  }
}

class LoginButtonForm extends StatelessWidget {
  const LoginButtonForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return SizedBox(
      width: 400,
      child: FilledButton(
        onPressed: loginForm.isLoading
            ? null
            : () async {
                FocusScope.of(context).unfocus();

                // Navigator.pushReplacementNamed(context, '/verification_login');

                if (!loginForm.isValidForm()) return;

                // Enviar solicitud de código a backend
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                loginForm.isLoading = true;

                // Crear objeto UserModel y enviar POST
                UserModel userModel = UserModel(
                  email: loginForm.email,
                  password: loginForm.password,
                );
                final String? errorMessage =
                    await authService.sendSecurityCodeLogin(userModel);
                if (errorMessage != null) {
                  loginForm.isLoading = false;
                  // ignore: use_build_context_synchronously
                  _showErrorDialog(context, errorMessage);
                } else {
                  loginForm.isLoading = false;
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/verification_login',
                      arguments: userModel);
                }
              },
        child: Text(
          loginForm.isLoading ? 'Espere...' : 'Iniciar sesión',
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
        context: context,
        builder: (_) => ContentDialog(
              title: const Text('Error'),
              content: Text(errorMessage),
              actions: [
                FilledButton(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ));
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Button(
        child: const Text('Registrarse'),
        onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
      ),
    );
  }
}
