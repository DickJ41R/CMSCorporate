import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/utils/custom_error_handler.dart';
import 'package:cms_web/features/shared/utils/app_color_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cms_web/features/authentication/views/pages/login/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart'; //show defaultTargetPlatform, kIsWeb;
import 'package:cms_web/features/shared/services/routes.dart';
import 'package:cms_web/features/authentication//services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


//import 'package:window_manager/window_manager.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  var orgId = dotenv.env['ASM_DB1'];
  debugPrint('line 16: $orgId $kIsWeb');
  // Turn off all debugPrint outputs if the app is built for release
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyADMwZd1vHPE4MLn-ozYq0eZ-lM9yPBa1A",
          projectId: "cmsproject-8e245",
          messagingSenderId: "146420810693",
          appId: "1:146420810693:web:3187590d8adf8ba26001ac",
          storageBucket: 'cmsproject-8e245.appspot.com'));
  debugPrint('line 25: $orgId $kIsWeb');
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    runApp(ErrorWidgetClass(details));
  };
  if (FirebaseAuth.instance.currentUser != null) {
    await FirebaseAuth.instance.signOut();
  }
  // await windowManager.ensureInitialized();
  //
  // WindowOptions windowOptions = WindowOptions(
  //   size: Size(800, 1200), // Optional: Set initial window size
  //   minimumSize: Size(800, 1200), // Optional: Set minimum size
  //   maximumSize: Size(800, 1200), // Optional: Set maximum size
  //   center: true,
  //   backgroundColor: Colors.transparent,
  //   skipTaskbar: false,
  //   titleBarStyle: TitleBarStyle.normal,
  // );
  //
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  //   await windowManager.setResizable(false); // This line prevents resizing
  // });

  //   ShowError showError = ShowError('line 47')
  debugPrint('line 41');
  ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    extensions: [
      // Add theme extensions here...
      AppColorTheme(),
    ],
  );
  debugPrint('line 53');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'CMS Web App';
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: MyRoutes.generateRoute,
      initialRoute: '/',
      // home: Scaffold(
      //   appBar: AppBar(title: const Text(appTitle)),
      //   // #docregion centered-text
      //   body: Login(flagGetAPNS: false),
      //   // #docregion text
      //   // child: LandingPageWeb(),
      //   // #enddocregion text
      // ),
      // #enddocregion centered-text
    );
  }
}

// routes: {
//   // When navigating to the "/" route, build the FirstScreen widget.
//   // When navigating to the "/second" route, build the SecondScreen widget.
//   '/': (context) => LandingPageWeb(),
// },
//         debugShowCheckedModeBanner: false,
//         onGenerateRoute: (settings) => Routes.generateRoute(settings),
//         initialRoute: '/',
//         theme: AppTheme.lightTheme, // <-- Light theme value
//         darkTheme: AppTheme.darkTheme, // <-- Dark theme value
//
//         home: AdaptiveLogin(),
//         // home: Container(height: 32, child: Text('got to 99')),
//       ),
//     ));
//   });
// }
