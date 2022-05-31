import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: SvgPicture.asset('assets/bitcoin-logo.svg'),
        ),
      ),
      pane: NavigationPane(
        header: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: DefaultTextStyle(
            style: FluentTheme.of(context).typography.bodyLarge!,
            child: const Text('Piero Morales'),
          ),
        ),
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('Inicio'),
          ),
        ],
      ),
    );
  }
}
