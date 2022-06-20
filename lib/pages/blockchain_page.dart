import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:toy_cryptocurrency_frontend/models/models.dart';
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
        return BlockListTile(block: blockService.blocks[index]);
      },
    );
  }
}

class BlockListTile extends StatelessWidget {
  const BlockListTile({
    Key? key,
    required this.block,
  }) : super(key: key);

  final BlockModel block;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7, bottom: 7, right: 20),
      child: Card(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BlockField(title: 'Id', content: block.id, titleWidth: 155),
                  BlockField(
                      title: 'Índice',
                      content: block.index.toString(),
                      titleWidth: 155),
                  BlockField(
                      title: 'Hash anterior',
                      content: block.previousHash,
                      titleWidth: 155),
                  BlockField(
                      title: 'Prueba de trabajo',
                      content: block.proof.toString(),
                      titleWidth: 155),
                  BlockField(
                      title: 'Fecha',
                      content: block.timestamp.toIso8601String(),
                      titleWidth: 155),
                  BlockField(
                      title: 'Minero', content: block.miner, titleWidth: 155),
                  BlockField(
                      title: 'Firma',
                      content: block.signature,
                      titleWidth: 155),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BlockField(
                      title: 'Emisario',
                      content: (block.transaction.from == null)
                          ? 'Null'
                          : block.transaction.from!,
                      titleWidth: 80),
                  BlockField(
                      title: 'Receptor',
                      content: (block.transaction.to == null)
                          ? 'Null'
                          : block.transaction.to!,
                      titleWidth: 80),
                  BlockField(
                      title: 'Cantidad',
                      content: (block.transaction.amount == null)
                          ? 'Null'
                          : block.transaction.amount.toString(),
                      titleWidth: 80),
                  BlockField(
                      title: 'Comisión',
                      content: (block.transaction.fee == null)
                          ? 'Null'
                          : block.transaction.fee.toString(),
                      titleWidth: 80),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlockField extends StatelessWidget {
  const BlockField({
    Key? key,
    required this.title,
    required this.content,
    required this.titleWidth,
  }) : super(key: key);

  final String title;
  final String content;
  final double titleWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: titleWidth,
            child: Text(title.toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'RobotoMono'))),
        Expanded(
            child: SelectableText(
          content,
          maxLines: 1,
          style: const TextStyle(fontFamily: 'RobotoMono'),
        )),
      ],
    );
  }
}
