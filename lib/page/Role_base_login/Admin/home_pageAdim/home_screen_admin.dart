import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/page/Role_base_login/Admin/item/add_item.dart';
import 'package:ecommerce/page/login/login_screen.dart';
import 'package:ecommerce/service/auth_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

AuthService _authService = AuthService();

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({super.key});

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  final CollectionReference items = FirebaseFirestore.instance.collection(
    'items',
  );
  String? selectedCategory;
  List<String> categories = [];
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Administrador"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SEUS ITENS CARREGADOS",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                ],
              ),

              SizedBox(
                height:
                    MediaQuery.of(context).size.height *
                    0.7, // Defina uma altura para o StreamBuilder
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      (selectedCategory == null || selectedCategory == "All")
                          ? items
                              .where("uploadedBy", isEqualTo: uid)
                              .snapshots()
                          : items
                              .where("uploadedBy", isEqualTo: uid)
                              .where('Category', isEqualTo: selectedCategory)
                              .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar os itens.'));
                    }
                    final document = snapshot.data?.docs ?? [];
                    if (document.isEmpty) {
                      return Center(child: Text('Nenhum item encontrado.'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('Nenhum item encontrado.'));
                    }

                    return ListView.builder(
                      itemCount: document.length,
                      itemBuilder: (context, index) {
                        final item =
                            document[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: 8,
                          ), // coloque o padding que quiser
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(15),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: item['image'],
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                item['name'] ?? "N/A",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Preço: R\$ ${item['price'] != null ? (item['price'] as num).toStringAsFixed(2) : "N/A"}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      letterSpacing: -1,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text("${item['Category'] ?? "N/A"}"),
                                  SizedBox(width: 5),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.blue,
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddItem()));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
