import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toy_cryptocurrency_frontend/providers/providers.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              children: [
                const AvailableBalance(),
                const SizedBox(height: 10),
                const AvailableUsersTitle(),
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
            child: const Text('\$0.00'),
          ),
        ],
      ),
    );
  }
}

class AvailableUsersList extends StatelessWidget {
  AvailableUsersList({
    Key? key,
  }) : super(key: key);

  final _usuarios = [
    'Piero UTEC',
    'Pedro UTEC',
    'Piero UTEC',
    'Pedro UTEC',
    'Piero UTEC',
    'Pedro UTEC',
    'Piero UTEC',
    'Pedro UTEC',
    'Piero UTEC',
    'Pedro UTEC',
    'Piero UTEC',
    'Pedro UTEC',
  ];

  final _emails = [
    'piero.morales@utec.ed',
    'juan.utec@utec.edu.pe',
    'piero.morales@utec.ed',
    'juan.utec@utec.edu.pe',
    'piero.morales@utec.ed',
    'juan.utec@utec.edu.pe',
    'piero.morales@utec.ed',
    'juan.utec@utec.edu.pe',
    'piero.morales@utec.ed',
    'juan.utec@utec.edu.pe',
    'piero.morales@utec.ed',
    'juan.utec@utec.edu.pe',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _usuarios.length,
      itemBuilder: (context, index) {
        final title = _usuarios.elementAt(index);
        final subtitle = _emails.elementAt(index);
        return AvailableUserListTile(
            title: title,
            subtitle: subtitle,
            index: index,
            usuarios: _usuarios);
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
    required List<String> usuarios,
  })  : _usuarios = usuarios,
        super(key: key);

  final String title;
  final String subtitle;
  final int index;
  final List<String> _usuarios;

  @override
  Widget build(BuildContext context) {
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
                        child: const Text(
                          'P',
                          style: TextStyle(color: Colors.white),
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
                    onPressed: () => _showInsertAmount(context),
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
        (index != _usuarios.length - 1) ? const Divider() : Container(),
      ],
    );
  }

  void _showInsertAmount(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => ContentDialog(
              title: const Text('Nueva transacción'),
              content: Form(
                key: Provider.of<TransactionFormProvider>(context).formKey,
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
                      AmountInput(
                          transactionForm:
                              Provider.of<TransactionFormProvider>(context)),
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
                FilledButton(child: const Text('Confirmar'), onPressed: () {}),
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
