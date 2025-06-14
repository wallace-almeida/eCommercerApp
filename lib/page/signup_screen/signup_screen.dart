import 'package:ecommerce/page/login/login_screen.dart';
import 'package:ecommerce/page/widget/text_field/text_field.dart';
import 'package:ecommerce/service/auth_service/auth_service.dart';
import 'package:flutter/material.dart';

import '../widget/custom_buttom/custom_buttom.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String selctedRole = "User";

  // funcao para criar o usuario
  void _signup() async {
    final _authService = AuthService();
    String? result = await _authService.signup(
      name: nameController.text,
      email: emailController.text,
      senha: senhaController.text,
      role: selctedRole,
    );
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Usuário criado com sucesso!"),
          behavior: SnackBarBehavior.floating, // opcional: faz ele flutuar
          backgroundColor: Colors.green, // opcional: cor de sucesso
          duration: Duration(seconds: 3), // opcional: tempo na tela
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao tentar criar o usuario $result!"),
          behavior: SnackBarBehavior.floating, // opcional: faz ele flutuar
          backgroundColor: Colors.red, // opcional: cor de sucesso
          duration: Duration(seconds: 3), // opcional: tempo na tela
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset("assets/image/signup.png"),
            SizedBox(height: 15),
            CustomTextField(
              controller: nameController,
              label: "Nome",
              keyboardType: TextInputType.text,
            ),
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
              keyboardType: TextInputType.text,
            ),

            SizedBox(height: 15),
            //UserRoles
            DropdownButtonFormField<String>(
              value: selctedRole,
              decoration: InputDecoration(
                labelText: "Perfil",
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey,
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              items:
                  ["Admin", "User"].map((role) {
                    return DropdownMenuItem(value: role, child: Text(role));
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selctedRole = newValue!; // update role selecionadas
                });
              },
            ),

            SizedBox(height: 15),
            CustomButton(text: "Criar Conta ", onPressed: _signup),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Já tem uma conta?", style: TextStyle(fontSize: 18)),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                  child: Text(
                    " Login",
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
    );
  }
}
