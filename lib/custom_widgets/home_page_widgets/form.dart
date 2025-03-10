import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';
import 'package:sylcpn_io/data_structures/fetching_report.dart';
import 'package:sylcpn_io/custom_widgets/alert_dialog.dart';

// ignore: must_be_immutable
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {

    var state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: Text('Connexion'),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/icon/icon_white.png'),
      ),
      backgroundColor: state.appColor,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 250,
                        child: TextField(
                          controller: nameController,
                          obscureText: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nom Utilisateur',
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                    width: 250,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mot de Passe',
                      ),
                    ),
                              ),
                  ),],
                ),
              ),
              
             Padding(
               padding: const EdgeInsets.all(20.0),
               child: ElevatedButton(onPressed: () async {
                
                final report = await state.checkUser(nameController.text.trim(), passwordController.text.trim());
                if (report == FetchingReport.refused) {
                  // ignore: use_build_context_synchronously
                  showAlertDialogRefused(context);
                }
        
                else if (report == FetchingReport.networkFail) {
                  // ignore: use_build_context_synchronously
                  showAlertDialogNetworkFail(context);
                }
                
               }, child: Text("Soumettre")),
             )
            ],
          ),
        ),
      ),
    );
  }
}