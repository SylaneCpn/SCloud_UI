import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:sylcpn_io/main_page.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(ChangeNotifierProvider(create: (context) => AppState(), child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return MaterialApp(
      title: 'SCloud',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        fontFamily: "Rubik",
        colorScheme: ColorScheme.fromSeed(seedColor: state.appColor),
        appBarTheme: AppBarTheme(
          color: state.appColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: state.appColor,
        ),
        useMaterial3: true,
      ),
      home: MainPage(),
    );
  }
}
