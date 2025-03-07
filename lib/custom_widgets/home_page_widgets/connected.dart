import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';



class ConnectedPage extends StatelessWidget {
  
  const ConnectedPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    var state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 82, 113, 255),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/icon/icon_white.png'),
        ),
        title: const Text('Connecté'),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Vous êtes connecté en temps que :\n', textAlign: TextAlign.center,),
            Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircleAvatar(maxRadius: 80,backgroundImage : NetworkImage(state.userAvatarPath(),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(state.name, textAlign: TextAlign.center, style: TextStyle(fontSize:20),),
                  ),
                ],
              ),
            ),
            ElevatedButton(onPressed: () {state.disconnect();}, child: Text("Déconnecter"))
          ],
        )),
      ),
      );
  }
}