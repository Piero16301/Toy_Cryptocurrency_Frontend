import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import 'package:toy_cryptocurrency_frontend/pages/pages.dart';
import 'package:toy_cryptocurrency_frontend/providers/providers.dart';
import 'package:toy_cryptocurrency_frontend/services/services.dart';
import 'package:toy_cryptocurrency_frontend/shared_preferences/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => ThemeProvider(isDarkMode: Preferences.isDarkMode)),
        ChangeNotifierProvider(create: ( _ ) => AuthService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'Toy Cryptocurrency',
      initialRoute: '/check_auth',
      routes: {
        '/check_auth': ( _ ) => const CheckAuthPage(),
        '/login': ( _ ) => const LoginPage(),
        '/home': ( _ ) => const HomePage(),
      },
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}
