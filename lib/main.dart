import 'package:flutter/material.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
// import 'features/resident/presentation/screens/create_repair_screen.dart'; // REMOVED
import 'features/resident/presentation/screens/model_view_screen.dart'; // Import
import 'features/admin/presentation/screens/juristic_view_screen.dart';
import 'features/technician/presentation/screens/technician_view_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bypass auth check — always show login
  runApp(const FcmApp(initialRoute: '/login'));
}

class FcmApp extends StatelessWidget {
  final String initialRoute;
  const FcmApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light, // Switch to light to match Zeta V5.0
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
          secondary: const Color(0xFF64748B),
          surface: Colors.white,
        ),
        useMaterial3: true,
        fontFamily: 'Outfit', // Update to Outfit
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/3d_model': (context) => const ModelViewScreen(),
        '/juristic': (context) => const JuristicViewScreen(),
        '/technician': (context) => const TechnicianViewScreen(),
      },
    );
  }
}
