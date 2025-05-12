import 'package:flutter/material.dart';

class DefaultFilesPage extends StatelessWidget {
  const DefaultFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          Text('En attente de données...'),
        ],
      ),
    );
  }
}
