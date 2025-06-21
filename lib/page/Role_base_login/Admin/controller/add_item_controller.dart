import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/add_item_model.dart';

final addProvider = StateNotifierProvider<AddItemNotifier, AddItemState>((ref) {
  return AddItemNotifier();
});

class AddItemNotifier extends StateNotifier<AddItemState> {
  AddItemNotifier() : super(AddItemState()) {
    fetchCategories();
  }

  final SupabaseClient supabase = Supabase.instance.client;

  void pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        state = state.copyWith(imagePath: pickedFile.path);
      }
    } catch (e) {
      print(e);
      throw Exception("Erro ao escolher a imagem: $e");
    }
  }

  void setSelectCategory(Map<String, dynamic>? category) {
    state = state.copyWith(selectCategory: category);
  }

  void addSize(String? size) {
    if (size != null) {
      state = state.copyWith(size: [...state.size, size]);
    }
  }

  void removeSize(String size) {
    state = state.copyWith(size: state.size.where((e) => e != size).toList());
  }

  void addColor(String? color) {
    if (color != null) {
      state = state.copyWith(color: [...state.color, color]);
    }
  }

  void removeColor(String color) {
    state = state.copyWith(
      color: state.color.where((e) => e != color).toList(),
    );
  }

  void toggleDiscouted(bool? isDiscouted) {
    state = state.copyWith(isDiscouted: isDiscouted);
  }

  void setDiscoutedPercentage(String discoutedPercentage) {
    state = state.copyWith(discoutedPercentage: discoutedPercentage);
  }

  void setLoader(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  Future<void> fetchCategories() async {
    try {
      final response = await supabase.from('categories').select('id, name');
      final categories =
          (response as List)
              .map<Map<String, dynamic>>(
                (item) => {
                  'id': item['id'] as String,
                  'name': item['name'] as String,
                },
              )
              .toList();

      // Atualiza o estado com a lista de mapas (id + name)
      state = state.copyWith(categories: categories);
      print("Categorias carregadas: $categories");
    } catch (e) {
      throw Exception("Erro ao buscar as categorias: $e");
    }
  }

  Future<void> uploadAndSaveItem(String name, String price) async {
    if (state.imagePath == null ||
        name.isEmpty ||
        price.isEmpty ||
        state.selectCategory == null ||
        state.size.isEmpty ||
        state.color.isEmpty ||
        (state.isDiscouted &&
            (state.discoutedPercentage == null ||
                state.discoutedPercentage!.isEmpty))) {
      throw Exception("Todos os campos devem ser preenchidos");
    }

    state = state.copyWith(isLoading: true);
    try {
      print("🚀 Iniciando upload do item...");
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final file = File(state.imagePath!);
      print("📷 Caminho da imagem original: ${file.path}");

      // Comprimir a imagem
      print("🔧 Comprimindo imagem...");
      final compressedFile = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 800,
        minHeight: 800,
        quality: 60,
        format: CompressFormat.jpeg,
      );

      if (compressedFile == null) {
        print("❌ Erro: compressWithFile retornou null");
        throw Exception("Erro ao comprimir a imagem");
      }

      print("✅ Imagem comprimida. Tamanho: ${compressedFile.length} bytes");

      // Upload no Supabase Storage
      print("📤 Fazendo upload para Supabase Storage...");
      final storageResponse = await supabase.storage
          .from('items-images')
          .uploadBinary(
            fileName,
            compressedFile,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      print("✅ Upload concluído. storageResponse: $storageResponse");

      final imageUrl = supabase.storage
          .from('items-images')
          .getPublicUrl(fileName);

      print("🌐 URL pública da imagem: $imageUrl");

      final user = supabase.auth.currentUser;
      if (user == null) {
        print("❌ Usuário não autenticado");
        throw Exception("Usuário não autenticado");
      }
      print("👤 Usuário autenticado: ${user.id}");

      // Criar o item para salvar no banco
      final itemToInsert = {
        "name": name,
        "price": int.parse(price),
        "image_url": imageUrl,
        "uploaded_by": user.id,
        "is_discouted": state.isDiscouted ? 1 : 0,
        "discouted_percentage":
            state.isDiscouted ? state.discoutedPercentage : null,
        "category_id": state.selectCategory?['id'],
        "size": state.size,
        "color": state.color,
      };

      print("📦 Item a ser salvo no banco: $itemToInsert");

      // Salvar no banco
      print("💾 Inserindo item no banco...");

      try {
        final insertResponse = await supabase
            .from('items')
            .insert(itemToInsert);
        print("🎉 Item salvo com sucesso no banco: $insertResponse");
      } catch (e) {
        print("❌ Erro no insert: $e");
        throw Exception("Erro ao salvar no banco: $e");
      }

      print("🎉 Item salvo com sucesso no banco");
      state = AddItemState();
    } catch (e) {
      print("⚠ Erro no uploadAndSaveItem: $e");
      throw Exception("Erro ao salvar o item: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
