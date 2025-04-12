import 'package:flutter/material.dart';


class GuestPage extends StatelessWidget{


  final Function() formCallback;

  const GuestPage({super.key , required this.formCallback});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/icon/icon_white.png'),
        ),
        title: const Text('Utilisateur'),
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
                    child: CircleAvatar(backgroundColor: Theme.of(context).cardColor , maxRadius: 80,backgroundImage : AssetImage('assets/icon/icon.png')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Invité", textAlign: TextAlign.center, style: TextStyle(fontSize:20),),
                  ),
                ],
              ),
            ),
            ElevatedButton(onPressed: formCallback , child: Text("Se connecter"))
          ],
        )),
      ),
      );
  }
}