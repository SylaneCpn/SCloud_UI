// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';
import 'package:sylcpn_io/data_structures/fetching_report.dart';

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
                  content: const Text("Choissisez des fichiers à stocker sur le serveur."),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );

    showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) {return alert;});
  }

  void showAlertDialogEmptyName(BuildContext context) {
    AlertDialog alert = AlertDialog(
                  title: const Text('Aucun nom choissi'),
                  content: const Text("Aucun nom n'a été choissi."),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );

    showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) {return alert;});
  }

  void showAlertDialogInvalidString(BuildContext context) {
    AlertDialog alert = AlertDialog(
                  title: const Text('Nom invalide'),
                  content: const Text("Les caractères spéciaux ne sont pas autorisés."),
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
                  content: const Text("Impossible d'accéder au serveur. Vérifiez votre connexion internet."),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );

    showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) {return alert;});
  }

  void showConfirmRmDialog(BuildContext context , int index) {
    final state = context.read<AppState>();

    final fullPath = state.filesInPath[index].full_path;
    final name = state.filesInPath[index].name;
    
    final continueCallBack = () async {

      Navigator.pop(context);
      final report = await state.rmRessource(fullPath);

      if (report == FetchingReport.success) {
        ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Ressource $name supprimée avec succès !")),
            );
      }

      else if (report == FetchingReport.refused) {

        ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("La ressource $name n'a pas pu être supprimée.")),
            );

      }

      else {
        ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur de réseau, la ressource n'a pas été supprimée.")),
            );
      }

      state.refreshDir();

    };


    AlertDialog alert = AlertDialog(
                  title: const Text("Continuer l'action ?"),
                  content: Text("Vous êtes sur le point de supprimer la ressource : $name. Poursuivre l'opération ?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: continueCallBack,
                      child: const Text('Continuer'),
                    ),
                  ],
                );

    showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) {return alert;});
  }


  void showNotConnectedDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
                  title: const Text('Vous devez vous connecter'),
                  content: const Text("Vous devez être connecté pour pouvoir réaliser cette action."),
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
              SnackBar(content: Text("Vous n'avez pas access à cette source.")),
            );
}

void showSnackBarSuccessFileSend(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Fichier(s) envoyé(s) avec succès.")),
            );
}


void showSnackBarFailFileSend(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur : Le serveur n'autorise pas la création de fichier(s) ou n'a pas pu écrire tous les fichiers.")),
            );
}

void showSnackBarSuccessDirAdd(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Dossier créé avec succès.")),
            );
}




void showSnackBarFailDirAdd(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur : Le serveur n'autorise pas la création de dossier ou n'a pas pu écrire le dossier.")),
            );
}

void showSnackBarSuccessRename(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Ressource renommée avec succès.")),
            );
}

void showSnackBarFailRename(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur : Le serveur n'autorise pas ou n'a pas pu renommer la ressource.")),
            );
}

void showSnackBarNetworkFail(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Une erreur réseau est survenue. Vérifier votre connexion internet et réessayez.")),
            );
}


void showSnackBarInvalidInput(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Un ou plusieurs fichiers contiennent un format interdit. Il n'ont pas pu être envoyés")),
            );
}