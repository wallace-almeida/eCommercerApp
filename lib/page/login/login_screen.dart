import 'package:flutter/material.dart';

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
              CustomButton(
                text: "Login",
                onPressed: () {
                  // Sua lógica de login
                },
              ),
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
