import 'package:ecommerce/page/Role_base_login/Admin/home_pageAdim/home_screen_admin.dart';
import 'package:ecommerce/page/Role_base_login/User/user_home_screen.dart';
import 'package:ecommerce/page/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvZXJmcHV1cGlrYm5jZXFjdmdvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NjIxOTMsImV4cCI6MjA2NjAzODE5M30.DsW5nbye4X0ZFJmrcjSLYqGNv05TP0ul3hWAfpAcqhQ",
    url: "https://poerfpuupikbnceqcvgo.supabase.co",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ECommercerApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const AuthStateHandler(),
      ),
    );
  }
}

class AuthStateHandler extends StatefulWidget {
  const AuthStateHandler({super.key});

  @override
  State<AuthStateHandler> createState() => _AuthStateHandlerState();
}

class _AuthStateHandlerState extends State<AuthStateHandler> {
  final _supabase = Supabase.instance.client;
  Session? _session;
  String? _userRole;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;

      if (session != null) {
        _session = session;
        _fetchUserRole(session.user.id);
      } else {
        setState(() {
          _session = null;
          _userRole = null;
          _loading = false;
        });
      }
    });

    final currentSession = _supabase.auth.currentSession;
    if (currentSession != null) {
      _session = currentSession;
      _fetchUserRole(currentSession.user.id);
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _fetchUserRole(String userId) async {
    setState(() {
      _loading = true;
    });

    try {
      final response =
          await _supabase
              .from('users')
              .select('role')
              .eq('id', userId)
              .single();

      setState(() {
        _userRole = response['role'] as String?;
        _loading = false;
      });
    } catch (e) {
      // Em caso de erro, desloga o usuário
      await _supabase.auth.signOut();
      setState(() {
        _session = null;
        _userRole = null;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_session == null) {
      return const LoginScreen();
    }

    if (_userRole == "Admin") {
      return const HomeScreenAdmin();
    } else {
      return const HomeScreen();
    }
  }
}
