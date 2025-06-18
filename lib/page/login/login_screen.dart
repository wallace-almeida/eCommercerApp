import 'package:flutter/material.dart';

import '../../service/auth_service/auth_service.dart';
import '../Role_base_login/Admin/home_pageAdim/home_screen_admin.dart';
import '../Role_base_login/User/user_home_screen.dart';
import '../signup_screen/signup_screen.dart';
import '../widget/custom_buttom/custom_buttom.dart';
import '../widget/text_field/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });
    final _authService = AuthService();
    String? result = await _authService.login(
      email: emailController.text,
      senha: senhaController.text,
    );
    setState(() {
      isLoading = false;
    });
    if (result == "Admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreenAdmin()),
      );
    } else if (result == "User") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao tentar acessar a conta $result!"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset("assets/image/login.png"),
              SizedBox(height: 15),
              CustomTextField(
                controller: emailController,
                label: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 15),
              CustomTextField(
                controller: senhaController,
                label: "Senha",
                obscureText: !isPasswordVisible,
                icon: Icons.lock,
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),

              SizedBox(height: 15),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(text: "Login", onPressed: login),
              SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Nao tem uma conta?", style: TextStyle(fontSize: 18)),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignupScreen()),
                      );
                    },
                    child: Text(
                      " Criar conta",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
