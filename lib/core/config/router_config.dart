import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/dashboard/provider_dashboard_screen.dart';
import '../../presentation/screens/jobs/active_jobs_screen.dart';
import '../../presentation/screens/jobs/job_requests_screen.dart';
import '../../presentation/screens/earnings/provider_earnings_screen.dart';
import '../../presentation/screens/schedule/provider_calendar_screen.dart';
import '../../presentation/screens/services/services_management_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
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
    GoRoute(
      path: '/provider-dashboard',
      name: 'provider-dashboard',
      builder: (context, state) => const ProviderDashboardScreen(),
    ),
    // Jobs routes
    GoRoute(
      path: '/active-jobs',
      name: 'active-jobs',
      builder: (context, state) => const ActiveJobsScreen(),
    ),
    GoRoute(
      path: '/job-requests',
      name: 'job-requests',
      builder: (context, state) => const JobRequestsScreen(),
    ),
    // Earnings routes
    GoRoute(
      path: '/provider-earnings',
      name: 'provider-earnings',
      builder: (context, state) => const ProviderEarningsScreen(),
    ),
    // Schedule routes
    GoRoute(
      path: '/provider-calendar',
      name: 'provider-calendar',
      builder: (context, state) => const ProviderCalendarScreen(),
    ),
    // Services routes
    GoRoute(
      path: '/services-management',
      name: 'services-management',
      builder: (context, state) => const ServicesManagementScreen(),
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