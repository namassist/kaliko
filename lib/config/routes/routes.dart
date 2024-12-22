import 'package:flutter/material.dart';
import 'package:kaliko/screens/admin/dashboard.dart';
import 'package:kaliko/screens/admin/room_detail.dart';
import 'package:kaliko/screens/register/register_profile_screen.dart';
import 'package:kaliko/screens/register/register_screen.dart';
import 'package:kaliko/screens/splash_screen.dart';
import '../../screens/home/home_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/register-profile':
        return MaterialPageRoute(builder: (_) => const RegisterProfileScreen());
      case '/admin-dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardAdmin());
      case '/admin/room-detail':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => RoomDetail(
            kamarId: args['kamarId'],
            title: args['title'],
            residentName: args['residentName'],
          ),
        );
      case '/admin/invoice':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => RoomDetail(
            kamarId: args['kamarId'],
            title: args['title'],
            residentName: args['residentName'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
