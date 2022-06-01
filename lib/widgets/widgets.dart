import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:toy_cryptocurrency_frontend/preferences/preferences.dart';
import 'package:toy_cryptocurrency_frontend/providers/providers.dart';

class SwitcherTheme extends StatefulWidget {
  const SwitcherTheme({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);

  final ThemeProvider themeProvider;

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
            value
                ? widget.themeProvider.setDarkMode()
                : widget.themeProvider.setLightMode();
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

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      child: IconButton(
        icon: const Icon(FluentIcons.back),
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
    );
  }
}
