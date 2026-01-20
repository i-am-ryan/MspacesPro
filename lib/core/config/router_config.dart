import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';

import '../../presentation/screens/dashboard/provider_dashboard_screen.dart';
import '../../presentation/screens/jobs/job_requests_screen.dart';
import '../../presentation/screens/schedule/provider_calendar_screen.dart';
import '../../presentation/screens/earnings/provider_earnings_screen.dart';
import '../../presentation/screens/profile/provider_profile_screen.dart';

// Detail screens (outside shell)
import '../../presentation/screens/jobs/job_details_screen.dart';
import '../../presentation/screens/earnings/transaction_history_screen.dart';
import '../../presentation/screens/earnings/transaction_details_screen.dart';
import '../../presentation/screens/earnings/request_payout_screen.dart';
import '../../presentation/screens/services/services_management_screen.dart';
import '../../presentation/screens/services/add_service_screen.dart';
import '../../presentation/screens/services/edit_service_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Public routes
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/provider-register',
      name: 'provider-register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // App shell (persistent bottom nav)
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ProviderShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/provider-dashboard',
          name: 'provider-dashboard',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProviderDashboardScreen()),
        ),
        GoRoute(
          path: '/job-requests',
          name: 'job-requests',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: JobRequestsScreen()),
        ),
        GoRoute(
          path: '/provider-calendar',
          name: 'provider-calendar',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProviderCalendarScreen()),
        ),
        GoRoute(
          path: '/provider-earnings',
          name: 'provider-earnings',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProviderEarningsScreen()),
        ),
        GoRoute(
          path: '/provider-profile',
          name: 'provider-profile',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProviderProfileScreen()),
        ),
      ],
    ),

    // Detail routes (outside shell - opens above bottom nav)
    GoRoute(
      path: '/job-details',
      name: 'job-details',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final job = state.extra as Map<String, dynamic>;
        return JobDetailsScreen(job: job);
      },
    ),
    GoRoute(
      path: '/transaction-history',
      name: 'transaction-history',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TransactionHistoryScreen(),
    ),
    GoRoute(
      path: '/transaction-details',
      name: 'transaction-details',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final transaction = state.extra as Map<String, dynamic>;
        return TransactionDetailsScreen(transaction: transaction);
      },
    ),
    GoRoute(
      path: '/request-payout',
      name: 'request-payout',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RequestPayoutScreen(),
    ),
    GoRoute(
      path: '/services-management',
      name: 'services-management',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ServicesManagementScreen(),
    ),
    GoRoute(
      path: '/add-service',
      name: 'add-service',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AddServiceScreen(),
    ),
    GoRoute(
      path: '/edit-service',
      name: 'edit-service',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final service = state.extra as Map<String, dynamic>;
        return EditServiceScreen(service: service);
      },
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 20),
          const Text(
            'Page Not Found',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'The page "${state.matchedLocation}" does not exist.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => context.go('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Go to Login'),
          ),
        ],
      ),
    ),
  ),
);

/// Persistent bottom navbar wrapper
class ProviderShell extends StatelessWidget {
  final Widget child;
  const ProviderShell({super.key, required this.child});

  int _locationToTabIndex(String location) {
    if (location.startsWith('/provider-dashboard')) return 0;
    if (location.startsWith('/job-requests')) return 1;
    if (location.startsWith('/provider-calendar')) return 2;
    if (location.startsWith('/provider-earnings')) return 3;
    if (location.startsWith('/provider-profile')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/provider-dashboard');
        break;
      case 1:
        context.go('/job-requests');
        break;
      case 2:
        context.go('/provider-calendar');
        break;
      case 3:
        context.go('/provider-earnings');
        break;
      case 4:
        context.go('/provider-profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToTabIndex(location);

    return Scaffold(
      backgroundColor: Colors.white,
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => _onTap(context, i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0x99FFFFFF),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'Requests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet_outlined),
              activeIcon: Icon(Icons.wallet),
              label: 'Earnings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}