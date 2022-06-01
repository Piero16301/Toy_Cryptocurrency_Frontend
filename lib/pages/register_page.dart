import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import 'package:toy_cryptocurrency_frontend/providers/providers.dart';
import 'package:toy_cryptocurrency_frontend/values/values.dart';
import 'package:toy_cryptocurrency_frontend/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return ScaffoldPage(
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
                  FirstNameForm(registerForm: registerForm),
                  const SizedBox(height: 10),
                  LastNameForm(registerForm: registerForm),
                  const SizedBox(height: 10),
                  CountryForm(registerForm: registerForm),
                  const SizedBox(height: 25),
                  RegisterEmailForm(registerForm: registerForm),
                  const SizedBox(height: 10),
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

class FirstNameForm extends StatelessWidget {
  const FirstNameForm({Key? key, required this.registerForm}) : super(key: key);

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

class LastNameForm extends StatelessWidget {
  const LastNameForm({Key? key, required this.registerForm}) : super(key: key);

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

class CountryForm extends StatelessWidget {
  const CountryForm({
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
        onChanged: (text) => widget.registerForm.password,
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
                if (!registerForm.isValidForm()) return;

                registerForm.isLoading = true;

                await Future.delayed(const Duration(seconds: 2));

                registerForm.isLoading = false;

                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, '/home');
              },
        child: Text(
          registerForm.isLoading ? 'Espere...' : 'Registrarse',
        ),
      ),
    );
  }
}
