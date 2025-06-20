import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/page/Role_base_login/Admin/home_pageAdim/home_screen_admin.dart';
import 'package:ecommerce/page/Role_base_login/User/user_home_screen.dart';
import 'package:ecommerce/page/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ECommercerApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: AuthStateHandler(),
      ),
    );
  }
}

class AuthStateHandler extends StatefulWidget {
  AuthStateHandler({super.key});

  @override
  State<AuthStateHandler> createState() => _AuthStateHandlerState();
}

class _AuthStateHandlerState extends State<AuthStateHandler> {
  User? _currentUser; // guardar o usuario logado
  String? _userRole;
  @override
  void initState() {
    inicializeAuthState();
    super.initState();
  }

  void inicializeAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (!mounted) return;

      setState(() {
        _currentUser = user;
      });

      if (user != null) {
        final userDoc =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .get();

        if (userDoc.exists) {
          setState(() {
            _userRole = userDoc['role'];
          });
        }
      } else {
        setState(() {
          _userRole = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return LoginScreen();
    }
    if (_userRole == null) {
      return Center(child: CircularProgressIndicator());
    }
    return _userRole == "Admin" ? HomeScreenAdmin() : HomeScreen();
  }
}
