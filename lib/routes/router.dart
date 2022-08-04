
import 'package:flutter_routes/config/auth_provider.dart';
import 'package:flutter_routes/layouts/guest_layout.dart';
import 'package:flutter_routes/pages/login/login_page.dart';
import 'package:flutter_routes/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../layouts/app_layout.dart';
import '../pages/error_page.dart';
import '../pages/home_page.dart';


class RoutePath {
  static const String home = '/';
  static const String login = '/login';
  static const String loading = '/loading';
  static const String app = '/app';
}

final AuthProvider authProvider = AuthProvider();

final GoRouter router = GoRouter(
  routes : [
    GoRoute(
      path: RoutePath.home, 
      builder: (context, state) => const GuestLayout(child: HomePage()),
    ),
    GoRoute(
      path: RoutePath.login, 
      builder: (context, state) => const GuestLayout(child: LoginPage()),
    ),
    GoRoute(
      path: RoutePath.loading, 
      builder: (context, state) => const SplasScreen(),
    ),
         GoRoute(
        path: '/app/:fid',
        builder: (context, state) => FamilyTabsScreen(
          key: state.pageKey,
          selectedFamily: Families.family(state.params['fid']!),
        ),
        routes: [
          GoRoute(
            path: 'person/:pid',
            builder: (context, state) {
              final family = Families.family(state.params['fid']!);
              final person = family.person(state.params['pid']!);

              return PersonScreen(family: family, person: person);
            },
          ),
        ],
      ), 
  ],
  redirect: (state) {

    final loggedIn = authProvider.authStatus;
    final authLoading = authProvider.authLoading;

    final isLoggedIn = state.location == RoutePath.app;
    final isLoading = state.location == RoutePath.loading;

    print(loggedIn);
    print(authLoading);

    return null;
  
  },
  errorBuilder: (context, state) => ErrorScreen(state.error!),
  refreshListenable: authProvider,
  urlPathStrategy: UrlPathStrategy.path,
);