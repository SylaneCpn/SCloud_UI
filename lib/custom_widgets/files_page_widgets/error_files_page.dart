import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';

class ErrorFilesPage extends StatelessWidget {
  const ErrorFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Une erreur est survenue.'),
          ),
          ElevatedButton(
            onPressed: state.resetFileInPath,
            child: Text("Réessayez"),
          ),
        ],
      ),
    );
  }
}
