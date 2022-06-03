import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:toy_cryptocurrency_frontend/pages/pages.dart';
import 'package:toy_cryptocurrency_frontend/preferences/preferences.dart';
import 'package:toy_cryptocurrency_frontend/providers/providers.dart';
import 'package:toy_cryptocurrency_frontend/services/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NavigationView(
      appBar: NavigationAppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: DefaultTextStyle(
            style: FluentTheme.of(context).typography.title!,
            child: const Text('Toy Cryptocurrency'),
          ),
        ),
        leading: Center(
          child: SvgPicture.asset(
            'assets/bitcoin-logo.svg',
            color: (themeProvider.currentThemeName == 'light')
                ? Colors.black
                : Colors.white,
            fit: BoxFit.fitHeight,
          ),
        ),
        actions: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: FluentTheme.of(context)
                        .typography
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    child: Text(
                        '${Preferences.userFirstName} ${Preferences.userLastName}'),
                  ),
                  DefaultTextStyle(
                    style: FluentTheme.of(context).typography.body!,
                    child: Text(
                        '${Preferences.userEmail} - ${Preferences.userCountry}'),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              IconButton(
                  icon: const Icon(FluentIcons.close_pane, size: 30),
                  onPressed: () => _showLogoutOptions(context)),
            ],
          ),
        ),
      ),
      pane: NavigationPane(
        header: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: DefaultTextStyle(
            style: FluentTheme.of(context).typography.bodyStrong!,
            child: Text('ID: ${Preferences.userId}'),
          ),
        ),
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.money),
            title: const Text('Saldo'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.all_apps),
            title: const Text('Transacciones'),
          ),
        ],
        selected: _currentPage,
        displayMode: PaneDisplayMode.auto,
        onChanged: (i) {
          setState(() {
            _currentPage = i;
          });
        },
        footerItems: [
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Ajustes'),
          ),
        ],
      ),
      content: NavigationBody(
        index: _currentPage,
        children: const [
          BalancePage(),
          TransactionsPage(),
          SettingsPage(),
        ],
      ),
    );
  }

  void _showLogoutOptions(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => ContentDialog(
              title: const Text('Cerrar sesión'),
              content: const Text('¿Seguro que desea cerrar la sesión?'),
              actions: [
                Button(
                  child: const Text('No'),
                  onPressed: () => Navigator.pop(context),
                ),
                FilledButton(
                    child: const Text('Sí'),
                    onPressed: () async {
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      await authService.logout();
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, '/login');
                    }),
              ],
            ));
  }
}
