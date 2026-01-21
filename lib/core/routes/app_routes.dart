import 'package:go_router/go_router.dart';
import 'package:real_time_watchlist/features/auth/presentation/login_screen.dart';
import 'package:real_time_watchlist/features/auth/presentation/register_screen.dart';
import 'package:real_time_watchlist/features/home/presentation/home_page.dart';
import 'package:real_time_watchlist/features/watchlist/presentation/watchlist_screen.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
  GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
  GoRoute(path: '/signup', builder: (context, state) => const RegisterScreen()),
  GoRoute(path: '/home', builder: (context, state) => const HomePage()),
  GoRoute(path: '/watchlist', builder: (context, state) => const WatchlistScreen()),
]);