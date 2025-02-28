import 'package:flutter/material.dart';

void showAlertDialogRefused(BuildContext context) {
    AlertDialog alert = AlertDialog(
                  title: const Text('Une erreur est survenue'),
                  content: const Text("Votre identifiant ou votre mot de passe est peut-être erroné. Veuillez réessayer."),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );

    showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) {return alert;});
  }


  void showAlertDialogNoFilesSelected(BuildContext context) {
    AlertDialog alert = AlertDialog(
                  title: const Text('Aucun fichier sélectionné'),
                  content: const Text("Choissisez des fichiers à stocker sur le serveur"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );

    showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) {return alert;});
  }

  void showAlertDialogEmptyDirName(BuildContext context) {
    AlertDialog alert = AlertDialog(
                  title: const Text('Aucun nom choissi'),
                  content: const Text("Aucun nom n'a été choissis pour le dossier a créer"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );

    showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) {return alert;});
  }

void showAlertDialogNetworkFail(BuildContext context) {
    AlertDialog alert = AlertDialog(
                  title: const Text('Une erreur est survenue'),
                  content: const Text("Impossible d'accéder au serveur. Vérifier votre connexion internet."),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );

    showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) {return alert;});
  }

void showSnackBarRefused(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Vous n'avez pas access à cette source")),
            );
}

void showSnackBarSuccessFileSend(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Fichier(s) envoyé(s) avec succès")),
            );
}


void showSnackBarFailFileSend(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur : Le serveur n'autorise pas la création de fichier(s) ou n'a pas pu écrire tous les fichiers")),
            );
}

void showSnackBarSuccessDirAdd(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Dossier crée avec succès")),
            );
}


void showSnackBarFailDirAdd(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur : Le serveur n'autorise pas la création de dossier ou n'a pas pu écrire le dossier")),
            );
}

void showSnackBarNetworkFail(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Une erreur réseau est survenue. Vérifier votre connexion internet et réessayez.")),
            );
}