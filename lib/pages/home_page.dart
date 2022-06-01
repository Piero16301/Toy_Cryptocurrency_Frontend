import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:toy_cryptocurrency_frontend/pages/pages.dart';
import 'package:toy_cryptocurrency_frontend/providers/providers.dart';

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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DefaultTextStyle(
                    style: FluentTheme.of(context)
                        .typography
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    child: const Text('Piero Morales'),
                  ),
                  DefaultTextStyle(
                    style: FluentTheme.of(context).typography.body!,
                    child: const Text('piero.morales@utec.edu.pe'),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(FluentIcons.close_pane, size: 30),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
              ),
            ],
          ),
        ),
      ),
      pane: NavigationPane(
        header: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: DefaultTextStyle(
            style: FluentTheme.of(context).typography.bodyStrong!,
            child: const Text('ID: 26816381637193234'),
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
}
