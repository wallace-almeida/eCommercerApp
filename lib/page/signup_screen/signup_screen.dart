import 'package:ecommerce/page/login/login_screen.dart';
import 'package:ecommerce/page/widget/text_field/text_field.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController nameController = TextEditingController();

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
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: "Perfil",
                border: OutlineInputBorder(),
              ),
              items:
                  ["Admin", "User"].map((role) {
                    return DropdownMenuItem(child: Text(role), value: role);
                  }).toList(),
              onChanged: (String? newValue) {},
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Criar Conta "),
              ),
            ),
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
