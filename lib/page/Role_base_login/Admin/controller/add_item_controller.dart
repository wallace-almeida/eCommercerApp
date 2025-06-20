import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../model/add_item_model.dart';

final addProvider = StateNotifierProvider<AddItemNotifier, AddItemState>((ref) {
  return AddItemNotifier();
});

class AddItemNotifier extends StateNotifier<AddItemState> {
  AddItemNotifier() : super(AddItemState()) {
    fetchCategories();
  }

  final CollectionReference items = FirebaseFirestore.instance.collection(
    "items",
  );

  final CollectionReference categoriesCollection = FirebaseFirestore.instance
      .collection("Category");

  void pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        state = state.copyWith(imagePath: pickedFile.path);
      }
    } catch (e) {
      print(e);
      throw Exception("Erro ao salvar o item $e");
    }
  }

  void setSelectCategory(String? category) {
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
      QuerySnapshot snapshot = await categoriesCollection.get();
      List<String> categories =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      state = state.copyWith(categories: categories);
      print("Categorias carregadas: $categories");
    } catch (e) {
      throw Exception("Erro ao buscar as categorias $e");
    }
  }

  // upload and save item
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
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final referencia = FirebaseStorage.instance.ref().child(
        "image/$fileName",
      );
      await referencia.putFile(File(state.imagePath!));
      final imageUrl = await referencia.getDownloadURL();

      // salvar item no firestore

      final String uid = FirebaseAuth.instance.currentUser!.uid;
      await items.add({
        "name": name,
        "price": int.parse(price),
        "imageUrl": imageUrl,
        "uploadedBy": uid,
        "isDiscouted":
            state.isDiscouted ? int.parse(state.discoutedPercentage!) : 0,
        "discoutedPercentage": state.discoutedPercentage,
        "category": state.selectCategory,
        "size": state.size,
        "color": state.color,
      });
      state = AddItemState();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      throw Exception("Erro ao salvar o item $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
