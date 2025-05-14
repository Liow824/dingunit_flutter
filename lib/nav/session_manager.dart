import 'package:flutter_application/ui/pages/draft_create_page.dart';
import 'package:flutter_application/ui/pages/draft_detail_page.dart';
import 'package:flutter_application/ui/pages/draft_edit_page.dart';
import 'package:flutter_application/ui/pages/draft_manage_page.dart';
import 'package:flutter_application/ui/pages/reservation_select.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../ui/pages/authentication_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/action_page.dart';
import '../ui/pages/user_management_page.dart';
import '../ui/pages/registration_page.dart';
import '../ui/pages/profile_page.dart';
import '../ui/pages/user_inform_page.dart';
import 'routes.dart';

class SessionManager {
  static String? _currentUserGuid;
  static String? _currentUserRole;

  static String? get currentUserGuid => _currentUserGuid;
  static String? get currentUserRole => _currentUserRole;

  /// Save the user's GUID and Role to local storage
  static Future<void> login(String userGuid, String userRole) async {
    _currentUserGuid = userGuid;
    _currentUserRole = userRole;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_guid', userGuid);
    await prefs.setString('user_role', userRole);
  }

  /// Clear the session
  static Future<void> logout() async {
    _currentUserGuid = null;
    _currentUserRole = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_guid');
    await prefs.remove('user_role');
  }

  /// Load the session data from local storage
  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserGuid = prefs.getString('user_guid');
    _currentUserRole = prefs.getString('user_role');
  }

  /// Check if the session is valid
  static bool isSessionValid() {
    return _currentUserGuid != null && _currentUserGuid!.isNotEmpty;
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const AuthenticationPage());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomePage());

      case AppRoutes.action:
        return MaterialPageRoute(builder: (_) => const ActionPage());

      case AppRoutes.manage:
        return MaterialPageRoute(builder: (_) => const UserManager());

      case AppRoutes.inform:
        final String? userGuid = settings.arguments as String?;
        if (userGuid != null) {
          return MaterialPageRoute(
            builder: (_) => UserInformPage(userGuid: userGuid),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Error: Missing User GUID')),
          ),
        );

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegistrationPage());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case AppRoutes.draftManage:
        return MaterialPageRoute(builder: (_) => const DraftManager());

      case AppRoutes.draftDetail:
        final String draftGuid = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => DraftDetailPage(draftGuid: draftGuid));

      case AppRoutes.draftCreate:
        return MaterialPageRoute(builder: (_) => const DraftCreatePage());

      case AppRoutes.draftEdit:
        final Map<String, dynamic>? draftData =
            settings.arguments as Map<String, dynamic>?;
        if (draftData != null) {
          return MaterialPageRoute(
              builder: (_) => DraftEditPage(draftData: draftData));
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Error: Missing Draft Data')),
          ),
        );

      case AppRoutes.reservationSelect:
        return MaterialPageRoute(
            builder: (_) => const ReservationSelectDialog());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404: Page not found')),
          ),
        );
    }
  }
}
