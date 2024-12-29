import 'package:flutter/material.dart';
import 'package:kaliko/screens/admin/dashboard.dart';
import 'package:kaliko/screens/admin/invoice.dart';
import 'package:kaliko/screens/admin/detail_room.dart';
import 'package:kaliko/screens/auth/sign_in/sign_in_screen.dart';
import 'package:kaliko/screens/auth/sign_up/sign_up_profile_screen.dart';
import 'package:kaliko/screens/auth/sign_up/sign_up_screen.dart';
import 'package:kaliko/screens/splash_screen.dart';
import 'package:kaliko/screens/user/dashboard.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/auth/sign-in':
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case '/auth/sign-up':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/auth/sign-up-profile':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SignUpProfileScreen(
            email: args['email'],
            password: args['password'],
          ),
        );
      case '/admin-dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardAdminScreen());
      case '/admin/detail-room':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DetailRoomAdminScreen(
            kamarId: args['kamarId'],
            title: args['title'],
            residentName: args['residentName'],
          ),
        );
      case '/admin/invoice':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => InvoiceAdmin(
            kamarId: args['kamarId'],
          ),
        );
      case '/user/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardUserScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
    }
  }
}
