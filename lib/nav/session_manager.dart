import 'package:flutter/material.dart';
import '../ui/pages/draft_detail_page.dart';
import '../ui/pages/draft_manage_page.dart';
import '../ui/pages/draft_create_page.dart';
import '../ui/pages/authentication_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/action_page.dart';
import '../ui/pages/user_management_page.dart';
import 'routes.dart';

class SessionManager {
  static int? _currentUserId; // Track the logged-in user ID

  static int? get currentUserId => _currentUserId;

  static void login(int userId) {
    _currentUserId = userId; // Set the logged-in user ID
  }
  
  static void logout() {
    _currentUserId = null; // Reset the user ID
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => AuthenticationPage(
            onLoginSuccess: (userId) {
              login(userId);
              Navigator.pushReplacementNamed(_, AppRoutes.home);
            },
          ),
        );
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomePage(userId: _currentUserId!));

      case AppRoutes.action:
        return MaterialPageRoute(builder: (_) => const ActionPage());

      case AppRoutes.manage: //manage user 
        return MaterialPageRoute(builder: (_) => const UserManager());

      case AppRoutes.draftManage: //manage draft
        return MaterialPageRoute(builder: (_) => const DraftManager());

      case AppRoutes.draftDetail:
        final int draftId = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => DraftDetailPage(draftId: draftId));
      
      case AppRoutes.draftCreate:
        return MaterialPageRoute(builder: (_) => const DraftCreatePage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404: Page not found')),
          ),
        );
    }
  }
}
