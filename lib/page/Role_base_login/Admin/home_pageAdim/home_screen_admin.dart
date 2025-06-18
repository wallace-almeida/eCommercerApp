import 'package:ecommerce/page/Role_base_login/Admin/item/add_item.dart';
import 'package:ecommerce/page/login/login_screen.dart';
import 'package:ecommerce/service/auth_service/auth_service.dart';
import 'package:flutter/material.dart';

AuthService _authService = AuthService();

class HomeScreenAdmin extends StatelessWidget {
  const HomeScreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Administrador"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bem vindo ao painel administrativo"),
            ElevatedButton(
              onPressed: () {
                _authService.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              child: Text("Sair"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddItem()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
