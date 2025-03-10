// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/custom_widgets/alert_dialog.dart';
import 'package:sylcpn_io/custom_widgets/file_list_widget.dart';
import 'package:sylcpn_io/data_structures/add_ressource_state.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';
import 'package:sylcpn_io/data_structures/fetching_report.dart';
import 'package:sylcpn_io/data_structures/ressource_type.dart';
import 'package:sylcpn_io/utils.dart';

class AddRessourceDialog extends StatefulWidget {
  

  const AddRessourceDialog({super.key});

  @override
  State<AddRessourceDialog> createState() => _AddRessourceDialogState();
}

class _AddRessourceDialogState extends State<AddRessourceDialog> {
  

  AddRessourceState widgetState = AddRessourceState.init ;
  var nameController = TextEditingController();
  RessourceType? selectedType = RessourceType.file;
  List<String> filesPaths = [];
 

  void setRessourceState(AddRessourceState newState) {
    setState(() {
      widgetState = newState;
    });
  }

  void resetRessourceState() {
    filesPaths = [];
    setRessourceState(AddRessourceState.init);
    
  }
  
  AddRessourceState mapSelectedRessource() {
    return switch (selectedType) {
      null => widgetState,
      RessourceType.file => AddRessourceState.files,
      RessourceType.directory => AddRessourceState.directory,
    };
  }

  void updateRessourceState() {
    setRessourceState(mapSelectedRessource());
  }

  Future<void> addFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
     
      setState(() {
        filesPaths = result.paths.map((p) => p!).toList();
      });
    } 
    else {
      
      setState(() {
        filesPaths = [];
      });
    }

  }


  Future<void> sendFiles(BuildContext context) async {

    try {

      if (filesPaths.isEmpty) {
        showAlertDialogNoFilesSelected(context);
        return;
      }

      List<FetchingReport> results = [];
      final state = context.read<AppState>();
      for (final path in filesPaths) {
        results.add(await state.sendFile(path));
      }

      if (results.any((elem) => elem != FetchingReport.success)) {
        Navigator.pop(context);
        showSnackBarFailFileSend(context);
      }

      Navigator.pop(context);
      showSnackBarSuccessFileSend(context);
      final fetchingReport = await state.refreshDir();

      if (fetchingReport == FetchingReport.networkFail)  showSnackBarNetworkFail(context);
      if (fetchingReport == FetchingReport.refused) showSnackBarRefused(context);




    }

    catch(e) {
  
      showSnackBarNetworkFail(context);
    }
    
  }


  Future<void> createDir(BuildContext context) async {


    if (nameController.text.isEmpty) {
      showAlertDialogEmptyDirName(context);
      return;
    }

    if (nameController.text.codeUnits.any((b) => b > 127)) {
      showAlertDialogInvalidString(context);
      return;
    }
    
    try {

      final state = context.read<AppState>();
      final result = await state.addDir( makeValidDirname(nameController.text));

      if (result != FetchingReport.success) {
        Navigator.pop(context);
        showSnackBarFailDirAdd(context);
        return;
      }


      Navigator.pop(context);
      showSnackBarSuccessDirAdd(context);
      final fetchingReport = await state.refreshDir();

      if (fetchingReport == FetchingReport.networkFail)  showSnackBarNetworkFail(context);
      if (fetchingReport == FetchingReport.refused) showSnackBarRefused(context);
      
    }

    catch(e) {
      showSnackBarNetworkFail(context);
    }

  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    final Widget title = switch (widgetState) {

      
      AddRessourceState.init =>  Text("Ajouter une ressource"),
  
      AddRessourceState.files => Text("Selection de fichiers"),
    
      AddRessourceState.directory =>Text("Création de dossier"),
    };
    
    final wid = switch(widgetState) {

      
      AddRessourceState.init => 


      AlertDialog(title: title, content: Column( mainAxisSize: MainAxisSize.min, children: [
      ListTile(title : Text('Fichier'), leading : Radio<RessourceType>(value: RessourceType.file, groupValue: selectedType, onChanged: (RessourceType? value){
        setState(() {
          selectedType = value;
        });
      },),),
      ListTile( title: Text('Dossier'), leading : Radio<RessourceType>(value: RessourceType.directory, groupValue: selectedType, onChanged: (RessourceType? value){
        setState(() {
          selectedType = value;
        });
      },),)
      ],),
        actions: [TextButton(onPressed: () => Navigator.pop(context , 'Retour'), child: Text('Retour')),
                 TextButton(onPressed: updateRessourceState, child: Text('Ok'))],
        )
      ,
    
      AddRessourceState.files => AlertDialog(title: title, actions: [TextButton(onPressed: resetRessourceState, child: Text('Retour'))],content: 
      Column( mainAxisSize: MainAxisSize.min, children : [ FileListWidget(paths: filesPaths) , TextButton(onPressed: addFiles, child: Text("Sélectionner des fichiers")) , TextButton(onPressed: () { sendFiles(context);} , child: Text('Envoyer'))],
        ),
      ),

      AddRessourceState.directory => AlertDialog(title: title, actions: [TextButton(onPressed: resetRessourceState, child: Text('Retour'))], content: Column( mainAxisSize: MainAxisSize.min,
        children: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
                        controller: nameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nom du dossier',
                        ),
                      ),
        ),
                    TextButton(onPressed: () {createDir(context);}, child: Text('Créer un dossier'))],
      ),),
    };

    return wid;
  }
}