import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/custom_widgets/alert_dialog.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';
import 'package:collection/collection.dart';
import 'package:sylcpn_io/data_structures/fetching_report.dart';

class PathNavigator extends StatefulWidget {
  const PathNavigator({super.key});

  @override
  State<PathNavigator> createState() => _PathNavigatorState();
}

class _PathNavigatorState extends State<PathNavigator> {
  int selectedIndex = -1;

  void setSelectedIndex(int selected) {
    setState(() {
      selectedIndex = selected;
    });
  }

  void resetSelectedIndex() {
    setState(() {
      selectedIndex = -1;
    });
  }

  List<String> dirs(String path) {
    final result = path.split('/');
    result.removeLast();
    return result;
  }

  String constructPath(List<String> dirs, int level) {
    String result = "";

    for (int i = 0; i < level + 1; i++) {
      result += "${dirs[i]}/";
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();

    final path = state.currentPath;
    final splitedPath = dirs(path);

    final List<Widget> wids =
        splitedPath
            .mapIndexed(
              (index, elem) => GestureDetector(
                onSecondaryTap: resetSelectedIndex,
                onTapCancel: resetSelectedIndex,
                onTap: () {
                  setSelectedIndex(index);
                },
                onDoubleTap: () async {
                  final report = await state.getNextDir(
                    constructPath(splitedPath, index),
                  );
                  if (report == FetchingReport.refused) {
                    // ignore: use_build_context_synchronously
                    showSnackBarRefused(context);
                  } else if (report == FetchingReport.networkFail) {
                    // ignore: use_build_context_synchronously
                    showSnackBarNetworkFail(context);
                  }
                  resetSelectedIndex();
                },
                child:
                    (selectedIndex == index)
                        ? Text(
                          style: TextStyle(
                            color: state.appColor,
                          ),
                          "$elem/",
                        )
                        : Text("$elem/"),
              ),
            )
            .toList();

    return Row(mainAxisSize: MainAxisSize.min, children: wids);
  }
}
