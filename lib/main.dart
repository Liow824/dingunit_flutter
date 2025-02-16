import 'package:flutter/material.dart';
import 'nav/session_manager.dart';
import 'nav/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionManager.loadSession();

  runApp(MaterialApp(
    initialRoute: AppRoutes.login,
    onGenerateRoute: SessionManager.generateRoute,
  ));
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
      
//       // Force the app to always start at AuthenticationPage
//       home: const AuthenticationPage(),
      
//       // Commented out the session-based navigation
//       /*
//       home: SessionManager.currentUserGuid == null
//           ? const AuthenticationPage()
//           : HomePage(userGuid: SessionManager.currentUserGuid!),
//       */
//     );
//   }
// }
