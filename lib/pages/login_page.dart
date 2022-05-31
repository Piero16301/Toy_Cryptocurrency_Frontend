import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:toy_cryptocurrency_frontend/preferences/preferences.dart';
import 'package:toy_cryptocurrency_frontend/providers/providers.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return ScaffoldPage(
      content: Stack(
        children: [
          const SwitcherTheme(),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LogoAndTitle(themeProvider: themeProvider),
                const SizedBox(height: 20),
                const EmailForm(),
                const SizedBox(height: 10),
                const PasswordForm(),
                const SizedBox(height: 10),
                const ButtonForm(),
                const SizedBox(height: 40),
                const ButtonRegister(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SwitcherTheme extends StatefulWidget {
  const SwitcherTheme({Key? key}) : super(key: key);

  @override
  State<SwitcherTheme> createState() => _SwitcherThemeState();
}

class _SwitcherThemeState extends State<SwitcherTheme> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      child: ToggleSwitch(
        checked: Preferences.isDarkMode,
        onChanged: (value) {
          setState(() {
            Preferences.isDarkMode = value;
            final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
            value ? themeProvider.setDarkMode() : themeProvider.setLightMode();
          });
        },
        content: const Text('Modo oscuro'),
      ),
    );
  }
}

class LogoAndTitle extends StatelessWidget {
  const LogoAndTitle({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);

  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/bitcoin-logo.svg',
          color: (themeProvider.currentThemeName == 'light') 
            ? Colors.black 
            : Colors.white,
          height: 80,
        ),
        const SizedBox(height: 10),
        DefaultTextStyle(
          style: FluentTheme.of(context).typography.title!,
          child: const Text('Toy Cryptocurrency'),
        ),
      ],
    );
  }
}

class EmailForm extends StatelessWidget {
  const EmailForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormBox(
        header: 'Correo electrónico',
        placeholder: 'Ingresa tu correo electrónico',
        maxLines: 1,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (text) {
          if (text == null || text.isEmpty) return 'Ingresa tu correo electrónico';
          
          String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regExp  = RegExp(pattern);
          return regExp.hasMatch(text)
            ? null
            : 'Correo electrónico no válido';
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

class PasswordForm extends StatefulWidget {
  const PasswordForm({Key? key}) : super(key: key);

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
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
        // suffixMode: OverlayVisibilityMode.always,
        suffix: IconButton(
          icon: Icon(!_showPassword ? FluentIcons.lock : FluentIcons.unlock),
          onPressed: () => setState(() => _showPassword = !_showPassword),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
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

class ButtonForm extends StatelessWidget {
  const ButtonForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: FilledButton(
        child: const Text('Iniciar sesión'),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
      ),
    );
  }
}

class ButtonRegister extends StatelessWidget {
  const ButtonRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Button(
        child: const Text('Registrarse'),
        onPressed: () {},
      ),
    );
  }
}
