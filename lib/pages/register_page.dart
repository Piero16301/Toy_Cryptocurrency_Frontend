import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/pointycastle.dart' as crypto;

import 'package:toy_cryptocurrency_frontend/models/models.dart';
import 'package:toy_cryptocurrency_frontend/providers/providers.dart';
import 'package:toy_cryptocurrency_frontend/services/services.dart';
import 'package:toy_cryptocurrency_frontend/values/values.dart';
import 'package:toy_cryptocurrency_frontend/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return ScaffoldPage(
      header: const PageHeader(title: Text('Registrarse')),
      content: Stack(
        children: [
          SwitcherTheme(themeProvider: themeProvider),
          const BackButton(),
          Center(
            child: Form(
              key: registerForm.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoAndTitle(themeProvider: themeProvider),
                  const SizedBox(height: 20),
                  RegisterFirstNameForm(registerForm: registerForm),
                  // const SizedBox(height: 5),
                  RegisterLastNameForm(registerForm: registerForm),
                  // const SizedBox(height: 5),
                  RegisterCountryForm(registerForm: registerForm),
                  const SizedBox(height: 15),
                  RegisterEmailForm(registerForm: registerForm),
                  // const SizedBox(height: 10),
                  RegisterPasswordForm(registerForm: registerForm),
                  const SizedBox(height: 10),
                  const RegisterButtonForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterFirstNameForm extends StatelessWidget {
  const RegisterFirstNameForm({Key? key, required this.registerForm})
      : super(key: key);

  final RegisterFormProvider registerForm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormBox(
        header: 'Nombre',
        placeholder: 'Ingresa tu nombre',
        maxLines: 1,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (text) => registerForm.firstName = text,
        validator: (text) {
          if (text == null || text.isEmpty) return 'Ingresa tu nombre';

          return (text.length >= 4) ? null : 'Nombre no válido';
        },
        textInputAction: TextInputAction.next,
        prefix: const Padding(
          padding: EdgeInsetsDirectional.only(start: 8.0),
          child: Icon(FluentIcons.follow_user),
        ),
      ),
    );
  }
}

class RegisterLastNameForm extends StatelessWidget {
  const RegisterLastNameForm({Key? key, required this.registerForm})
      : super(key: key);

  final RegisterFormProvider registerForm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormBox(
        header: 'Apellido',
        placeholder: 'Ingresa tu apellido',
        maxLines: 1,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (text) => registerForm.lastName = text,
        validator: (text) {
          if (text == null || text.isEmpty) return 'Ingresa tu apellido';

          return (text.length >= 4) ? null : 'Apellido no válido';
        },
        textInputAction: TextInputAction.next,
        prefix: const Padding(
          padding: EdgeInsetsDirectional.only(start: 8.0),
          child: Icon(FluentIcons.follow_user),
        ),
      ),
    );
  }
}

class RegisterCountryForm extends StatelessWidget {
  const RegisterCountryForm({
    Key? key,
    required this.registerForm,
  }) : super(key: key);

  final RegisterFormProvider registerForm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: InfoLabel(
        label: 'País',
        child: AutoSuggestBox(
          items: Values.countryValues,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          // validator: (text) {
          //   if (text == null || text.isEmpty) return 'Ingresa tu país';
          //   return null;
          // },
          placeholder: 'Ingresa tu país',
          onSelected: (text) => registerForm.country = text,
          leadingIcon: const Padding(
            padding: EdgeInsetsDirectional.only(start: 8.0),
            child: Icon(FluentIcons.flag),
          ),
        ),
      ),
    );
  }
}

class RegisterEmailForm extends StatelessWidget {
  const RegisterEmailForm({
    Key? key,
    required this.registerForm,
  }) : super(key: key);

  final RegisterFormProvider registerForm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormBox(
        header: 'Correo electrónico',
        placeholder: 'Ingresa tu correo electrónico',
        maxLines: 1,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (text) => registerForm.email = text,
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

class RegisterPasswordForm extends StatefulWidget {
  const RegisterPasswordForm({
    Key? key,
    required this.registerForm,
  }) : super(key: key);

  final RegisterFormProvider registerForm;

  @override
  State<RegisterPasswordForm> createState() => _RegisterPasswordFormState();
}

class _RegisterPasswordFormState extends State<RegisterPasswordForm> {
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
        onChanged: (text) => widget.registerForm.password = text,
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

class RegisterButtonForm extends StatelessWidget {
  const RegisterButtonForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return SizedBox(
      width: 400,
      child: FilledButton(
        onPressed: registerForm.isLoading
            ? null
            : () async {
                FocusScope.of(context).unfocus();

                // Navigator.pushReplacementNamed(context, '/verification_login');

                if (!registerForm.isValidForm()) return;

                // Enviar solicitud de código a backend
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                registerForm.isLoading = true;

                // Crear objeto UserModel y enviar POST
                UserModel userModel = UserModel(
                  firstName: registerForm.firstName,
                  lastName: registerForm.lastName,
                  country: registerForm.country,
                  email: registerForm.email,
                  password: registerForm.password,
                );
                final String? errorMessage =
                    await authService.sendSecurityCodeRegister(userModel);
                if (errorMessage != null) {
                  registerForm.isLoading = false;
                  // ignore: use_build_context_synchronously
                  _showErrorDialog(context, errorMessage);
                } else {
                  registerForm.isLoading = false;
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(
                      context, '/verification_register',
                      arguments: userModel);
                }
              },
        child: Text(
          registerForm.isLoading ? 'Espere...' : 'Registrarse',
        ),
      ),
    );
  }

  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
      generateKeyPair() {
    var helper = RsaKeyHelper();
    return helper.computeRSAKeyPair(helper.getSecureRandom());
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
