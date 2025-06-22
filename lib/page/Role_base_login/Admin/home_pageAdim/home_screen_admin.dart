import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/page/Role_base_login/Admin/item/add_item.dart';
import 'package:ecommerce/page/login/login_screen.dart';
import 'package:ecommerce/service/auth_service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controller/ItemsListNotifier.dart';

class HomeScreenAdmin extends ConsumerStatefulWidget {
  const HomeScreenAdmin({super.key});

  @override
  ConsumerState<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends ConsumerState<HomeScreenAdmin> {
  final AuthService _authService = AuthService();

  String? selectedCategory;
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final supabase = Supabase.instance.client;
    final result = await supabase.from('categories').select('id, name');
    setState(() {
      categories = List<Map<String, dynamic>>.from(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    final itemsState = ref.watch(itemsListProvider);
    final itemsController = ref.read(itemsListProvider.notifier);

    if (user == null) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Administrador"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "Seus Itens Carregados",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                DropdownButton<String>(
                  hint: const Text("Categoria"),
                  value: selectedCategory,
                  items:
                      categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category['id'].toString(),
                          child: Text(category['name']),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                    ref
                        .read(itemsListProvider.notifier)
                        .filterByCategory(newValue);
                  },
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: itemsState.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(child: Text('Nenhum item encontrado.'));
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: item['image_url'] ?? '',
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) =>
                                        const CircularProgressIndicator(),
                                errorWidget:
                                    (context, url, error) =>
                                        const Icon(Icons.error),
                              ),
                            ),
                            title: Text(
                              item['name'] ?? "N/A",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  "Preço: R\$ ${item['price'] != null ? (item['price'] as num).toStringAsFixed(2) : "N/A"}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                Text(
                                  "Categoria: ${item['category_id'] != null ? item['category_id']['name'] : "N/A"}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text("Confirmar exclusão"),
                                        content: const Text(
                                          "Tem certeza que deseja deletar este item?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                            child: const Text("Cancelar"),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  true,
                                                ),
                                            child: const Text(
                                              "Deletar",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirm == true) {
                                  try {
                                    await itemsController.deleteItem(
                                      item['id'].toString(),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Item deletado com sucesso!',
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Erro ao deletar item: ${e.toString()}',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stack) => Center(
                      child: Text('Erro ao carregar os itens: $error'),
                    ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddItem()));
          ref.read(itemsListProvider.notifier).refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
