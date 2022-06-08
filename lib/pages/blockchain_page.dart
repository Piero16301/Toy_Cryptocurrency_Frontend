import 'package:fluent_ui/fluent_ui.dart';

class BlockchainPage extends StatelessWidget {
  const BlockchainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Blockchain')),
      children: const [],
    );
  }
}