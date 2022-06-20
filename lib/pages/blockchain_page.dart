import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:toy_cryptocurrency_frontend/services/services.dart';

class BlockchainPage extends StatefulWidget {
  const BlockchainPage({Key? key}) : super(key: key);

  @override
  State<BlockchainPage> createState() => _BlockchainPageState();
}

class _BlockchainPageState extends State<BlockchainPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<BlockService>(context, listen: false).getBlockchain();
    });
  }

  @override
  Widget build(BuildContext context) {
    final blockService = Provider.of<BlockService>(context);

    if (blockService.isLoadingBlockchain) {
      return ScaffoldPage(
        header: const PageHeader(title: Text('Blockchain')),
        content: Center(
          child: ProgressRing(activeColor: Colors.green),
        ),
      );
    }

    return ScaffoldPage(
      header: const PageHeader(title: Text('Blockchain')),
      content: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ListOfBlocks(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListOfBlocks extends StatelessWidget {
  const ListOfBlocks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blockService = Provider.of<BlockService>(context);

    return ListView.builder(
      itemCount: blockService.blocks.length,
      itemBuilder: (context, index) {
        return Text(blockService.blocks[index].id);
      },
    );
  }
}
