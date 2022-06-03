import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:toy_cryptocurrency_frontend/models/models.dart';
import 'package:toy_cryptocurrency_frontend/providers/providers.dart';
import 'package:toy_cryptocurrency_frontend/services/services.dart';
import 'package:toy_cryptocurrency_frontend/widgets/widgets.dart';

class VerificationLoginPage extends StatelessWidget {
  const VerificationLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final verificationForm = Provider.of<VerificationFormProvider>(context);
    final userModel = ModalRoute.of(context)!.settings.arguments as UserModel;

    return ScaffoldPage(
      content: Stack(
        children: [
          SwitcherTheme(themeProvider: themeProvider),
          Center(
            child: Form(
              key: verificationForm.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoAndTitle(themeProvider: themeProvider),
                  const SizedBox(height: 20),
                  const Text(
                      'Ingresa el código enviado por correo electrónico'),
                  const SizedBox(height: 20),
                  LoginCodeInput(verificationForm: verificationForm),
                  const SizedBox(height: 20),
                  LoginSendCodeButton(userModel: userModel),
                  const SizedBox(height: 40),
                  const LoginCancelButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginCodeInput extends StatelessWidget {
  const LoginCodeInput({
    Key? key,
    required this.verificationForm,
  }) : super(key: key);

  final VerificationFormProvider verificationForm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 60,
            child: TextFormBox(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (text) {
                verificationForm.firstDigit = text;
                if (text.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (text) {
                return (text != null && text.length == 1) ? null : 'Falta';
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: TextFormBox(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (text) {
                verificationForm.secondDigit = text;
                if (text.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (text) {
                return (text != null && text.length == 1) ? null : 'Falta';
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: TextFormBox(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (text) {
                verificationForm.thirdDigit = text;
                if (text.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (text) {
                return (text != null && text.length == 1) ? null : 'Falta';
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: TextFormBox(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (text) {
                verificationForm.fourthDigit = text;
                if (text.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (text) {
                return (text != null && text.length == 1) ? null : 'Falta';
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LoginSendCodeButton extends StatelessWidget {
  const LoginSendCodeButton({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    final verificationForm = Provider.of<VerificationFormProvider>(context);

    return SizedBox(
      width: 400,
      child: FilledButton(
        onPressed: verificationForm.isLoading
            ? null
            : () async {
                // Exit keyboard
                FocusScope.of(context).unfocus();

                // Enviar código a backend
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                if (!verificationForm.isValidForm()) return;
                verificationForm.isLoading = true;

                // Recibir objeto UserModel y enviar POST
                final String? errorMessage =
                    await authService.verifySecurityCodeLogin(userModel,
                        '${verificationForm.firstDigit}${verificationForm.secondDigit}${verificationForm.thirdDigit}${verificationForm.fourthDigit}');
                if (errorMessage != null) {
                  // ignore: use_build_context_synchronously
                  _showErrorDialog(context, errorMessage);
                  verificationForm.isLoading = false;
                } else {
                  verificationForm.isLoading = false;
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
        child: Text(verificationForm.isLoading ? 'Espere...' : 'Enviar código'),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
        context: context,
        builder: (_) => ContentDialog(
              title: const Text('Error'),
              content: Text(errorMessage),
              actions: [
                FilledButton(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ));
  }
}

class LoginCancelButton extends StatelessWidget {
  const LoginCancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Button(
        child: const Text('Cancelar'),
        onPressed: () => _showCancelOptions(context),
      ),
    );
  }

  void _showCancelOptions(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => ContentDialog(
              title: const Text('Salir'),
              content: const Text('¿Seguro que desea cancelar la operación?'),
              actions: [
                Button(
                  child: const Text('No'),
                  onPressed: () => Navigator.pop(context),
                ),
                FilledButton(
                  child: const Text('Sí'),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                ),
              ],
            ));
  }
}
