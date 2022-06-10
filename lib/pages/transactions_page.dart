import 'package:encrypt/encrypt.dart' as crypto;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:toy_cryptocurrency_frontend/models/models.dart';
import 'package:toy_cryptocurrency_frontend/preferences/preferences.dart';
import 'package:toy_cryptocurrency_frontend/providers/providers.dart';
import 'package:toy_cryptocurrency_frontend/services/services.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<BlockService>(context, listen: false).getAvailableUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final blockService = Provider.of<BlockService>(context);

    if (blockService.isLoadingUsers) {
      return ScaffoldPage(
        header: const PageHeader(title: Text('Transacciones')),
        content: Center(
          child: ProgressRing(activeColor: Colors.green),
        ),
      );
    }

    if (blockService.availableUsers.isEmpty) {
      return const ScaffoldPage(
        header: PageHeader(title: Text('Transacciones')),
        content: Center(
          child: Text('No hay más usuarios registrados'),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => TransactionFormProvider(),
      child: ScaffoldPage(
        header: const PageHeader(title: Text('Transacciones')),
        content: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                AvailableBalance(),
                SizedBox(height: 10),
                AvailableUsersTitle(),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: AvailableUsersList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AvailableUsersTitle extends StatelessWidget {
  const AvailableUsersTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: FluentTheme.of(context).typography.subtitle!,
      child: const Text('Usuarios disponibles'),
    );
  }
}

class AvailableBalance extends StatelessWidget {
  const AvailableBalance({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DefaultTextStyle(
            style: FluentTheme.of(context).typography.subtitle!,
            child: const Text('Saldo disponible'),
          ),
          DefaultTextStyle(
            style: FluentTheme.of(context).typography.display!,
            child: const Text('100.00'),
          ),
        ],
      ),
    );
  }
}

class AvailableUsersList extends StatelessWidget {
  const AvailableUsersList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blockService = Provider.of<BlockService>(context);

    return ListView.builder(
      itemCount: blockService.availableUsers.length,
      itemBuilder: (context, index) {
        final title =
            '${blockService.availableUsers[index].firstName} ${blockService.availableUsers[index].lastName}';
        final subtitle = blockService.availableUsers[index].email;
        return AvailableUserListTile(
          title: title,
          subtitle: subtitle!,
          index: index,
          listLength: blockService.availableUsers.length,
          user: blockService.availableUsers[index],
        );
      },
    );
  }
}

class AvailableUserListTile extends StatelessWidget {
  const AvailableUserListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.index,
    required this.listLength,
    required this.user,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final int index;
  final int listLength;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final blockService = Provider.of<BlockService>(context);
    final transactionForm = Provider.of<TransactionFormProvider>(context);

    return Column(
      children: [
        SizedBox(
          height: 80,
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 20,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: DefaultTextStyle(
                        style: FluentTheme.of(context).typography.title!,
                        child: Text(
                          title[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                  title: Text(title),
                  subtitle: Text(subtitle),
                ),
              ),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 40,
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: ButtonState.all<Color>(Colors.green),
                      shape: ButtonState.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      blockService.selectedUser = user;
                      _showInsertAmount(context, transactionForm);
                    },
                    child: const Center(
                      child: Text('Transferir',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          ),
        ),
        (index != listLength - 1) ? const Divider() : Container(),
      ],
    );
  }

  void _showInsertAmount(
      BuildContext context, TransactionFormProvider transactionForm) {
    showDialog(
        context: context,
        builder: (_) => ContentDialog(
              title: const Text('Nueva transacción'),
              content: Form(
                key: transactionForm.formKey,
                child: SizedBox(
                  height: 125,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Ingrese el monto a transferir',
                        style: TextStyle(fontSize: 16),
                      ),
                      AmountInput(transactionForm: transactionForm),
                      const Align(
                          alignment: Alignment.centerRight,
                          child: Text('Use "." para separar decimales')),
                    ],
                  ),
                ),
              ),
              actions: [
                Button(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.pop(context),
                ),
                FilledButton(
                    child: const Text('Confirmar'),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();

                      if (!transactionForm.isValidForm()) return;

                      // Comenzar a cargar el loading
                      final blockService =
                          Provider.of<BlockService>(context, listen: false);
                      transactionForm.isLoading = true;

                      // Cerrar dialog
                      Navigator.pop(context);

                      // Crear objeto de transacción (comisión 5%)
                      TransactionModel transactionModel = TransactionModel(
                        from: Preferences.userEmail,
                        to: blockService.selectedUser.email!,
                        amount: transactionForm.ammount,
                        fee: transactionForm.ammount * 0.05,
                      );

                      // Crear firma de transacción
                      RsaKeyHelper rsaKeyHelper = RsaKeyHelper();
                      final publicKey = rsaKeyHelper.parsePublicKeyFromPem(
                          """-----BEGIN RSA PUBLIC KEY-----
${Preferences.userPublicKey}
-----END RSA PUBLIC KEY-----""");
                      final privateKey = rsaKeyHelper.parsePrivateKeyFromPem(
                          """-----BEGIN RSA PRIVATE KEY-----
${Preferences.userPrivateKey}
-----END RSA PRIVATE KEY-----""");
                      final signer = crypto.Signer(crypto.RSASigner(
                          crypto.RSASignDigest.SHA256,
                          publicKey: publicKey,
                          privateKey: privateKey));
                      String signature = signer.sign('bloque firmado').base64;
                      debugPrint('signature: $signature');

                      // Enviar transacción al servidor
                      final String? errorMessage = await blockService
                          .newTransaction(transactionModel, signature);

                      if (errorMessage != null) {
                        transactionForm.isLoading = false;
                        debugPrint('Bloque no insertado $errorMessage');
                      } else {
                        transactionForm.isLoading = false;
                        debugPrint('Bloque insertado');
                      }
                    }),
              ],
            ));
  }
}

class AmountInput extends StatelessWidget {
  const AmountInput({
    Key? key,
    required this.transactionForm,
  }) : super(key: key);

  final TransactionFormProvider transactionForm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormBox(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (text) {
          transactionForm.ammount = double.tryParse(text) ?? 0;
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
        ],
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Ingrese un monto';
          }
          if (double.tryParse(text) == null || double.tryParse(text)! <= 0) {
            return 'Ingrese un monto válido';
          }
          return null;
        },
      ),
    );
  }
}
