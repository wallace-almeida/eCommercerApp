import 'package:ecommerce/model/category.dart';
import 'package:ecommerce/model/model.dart';
import 'package:ecommerce/page/home_user/widgets/banner.dart';
import 'package:ecommerce/page/home_user/widgets/curated_items.dart';
import 'package:ecommerce/page/itens_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../contants/constans.dart';
import '../../../service/auth_service/auth_service.dart';
import '../../login/login_screen.dart';

AuthService _authService = AuthService();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),

            // Topo com logo e ícone do carrinho
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset("assets/image/logo.png", height: 40),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Iconsax.shopping_bag),
                      Positioned(
                        right: -3,
                        top: -3,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              "3",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Banner principal
            const AppBanner(),

            // Título "Escolha por categoria"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Escolha por categoria",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Ver todas",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),

            // Lista horizontal de categorias
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(Category.categories.length, (index) {
                  final category = Category.categories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        // ação ao tocar em categoria
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: backgroundColor1,
                            backgroundImage: AssetImage(category.image),
                          ),
                          const SizedBox(height: 10),
                          Text(category.nome),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Título "Recomendações para você"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recomendações para você",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Ver todas",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),

            // Lista horizontal de produtos recomendados
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(AppModel.fashionEcommerceApp.length, (
                  index,
                ) {
                  final eCommerceItem = AppModel.fashionEcommerceApp[index];
                  return Padding(
                    padding:
                        index == 0
                            ? const EdgeInsets.symmetric(horizontal: 20)
                            : const EdgeInsets.only(right: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ItensDetailScreen(
                                  eCommerceApp: eCommerceItem,
                                ),
                          ),
                        );
                      },
                      child: CuratedItems(
                        eCommerceItems: eCommerceItem,
                        size: size,
                      ),
                    ),
                  );
                }),
              ),
            ),
            ElevatedButton(
              child: Text("Sair"),
              onPressed: () {
                _authService.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
