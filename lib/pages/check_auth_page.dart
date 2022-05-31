import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import 'package:toy_cryptocurrency_frontend/pages/pages.dart';
import 'package:toy_cryptocurrency_frontend/services/services.dart';

class CheckAuthPage extends StatelessWidget {
  const CheckAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Center(
      child: FutureBuilder(
        future: authService.readPrivateKey(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) {
            return const Text('');
          }

          if (snapshot.data == '') {
            Future.microtask(() {
              Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: (_, __, ___) => const LoginPage(),
                transitionDuration: const Duration(seconds: 0),
              ));
            });
            // Future.microtask(() {
            //   Navigator.pushReplacement(context, PageRouteBuilder(
            //     pageBuilder: (_, __, ___) => const HomePage(),
            //     transitionDuration: const Duration(seconds: 0),
            //   ));
            // });
          } else {
            Future.microtask(() {
              Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomePage(),
                transitionDuration: const Duration(seconds: 0),
              ));
            });
          }

          return Container();
        },
      ),
    );
  }
}
