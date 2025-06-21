import 'dart:io';

import 'package:ecommerce/page/widget/custom_buttom/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../widget/show_snackbar.dart';
import '../../../widget/text_field/text_field.dart';
import '../controller/add_item_controller.dart';

class AddItem extends ConsumerWidget {
  AddItem({super.key});
  TextEditingController sizeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descontoController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addProvider);
    final notifier = ref.read(addProvider.notifier);

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Adicionar itens a loja")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey[400]!, width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child:
                      state.imagePath != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              File(state.imagePath!),
                              fit: BoxFit.cover,
                            ),
                          )
                          : state.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : GestureDetector(
                            onTap: () {
                              _showPickOptions(context, notifier);
                            },
                            child: Icon(
                              Icons.add_a_photo,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                ),
              ),
              SizedBox(height: 15),
              CustomTextField(controller: nameController, label: "Nome"),
              SizedBox(height: 15),
              CustomTextField(controller: priceController, label: "Preço"),
              SizedBox(
                height: 20,
              ), // Aumentar o espaçamento para melhor legibilidade
              DropdownButtonFormField<Map<String, dynamic>>(
                isExpanded: true,
                value: state.selectCategory,
                onChanged: notifier.setSelectCategory,
                decoration: InputDecoration(
                  labelText: "Categoria do Produto",
                  hintText: "Escolha a categoria",
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                  prefixIcon: Icon(
                    Icons.category_outlined,
                    color: Colors.grey[600],
                  ),
                ),
                items:
                    state.categories.map((category) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: category,
                        child: Text(
                          category['name'],
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      );
                    }).toList(),
                style: TextStyle(fontSize: 16, color: Colors.black87),
                icon: Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: 15),
              CustomTextField(
                controller: sizeController,
                label: "Tamanho",
                onSubmitted: (value) {
                  notifier.addSize(value);
                  sizeController.clear();
                },
              ),
              Wrap(
                spacing: 8,
                children:
                    state.size
                        .map(
                          (size) => Chip(
                            label: Text(size),
                            onDeleted: () {
                              notifier.removeSize(size);
                            },
                          ),
                        )
                        .toList(),
              ),
              SizedBox(
                height: 15,
              ), // Esta linha estava causando o erro, pois estava dentro da lista de children do Wrap.

              CustomTextField(
                controller: colorController,
                label: "Cores",
                onSubmitted: (value) {
                  notifier.addColor(value);
                  colorController.clear();
                },
              ),
              Wrap(
                spacing: 8,
                children:
                    state.color
                        .map(
                          (color) => Chip(
                            label: Text(color),
                            onDeleted: () {
                              notifier.removeColor(color);
                            },
                          ),
                        )
                        .toList(),
              ),
              Row(
                children: [
                  Checkbox(
                    value: state.isDiscouted,
                    onChanged: notifier.toggleDiscouted,
                  ),
                  Text("Aplicar Desconto"),
                ],
              ),
              if (state.isDiscouted == true)
                Column(
                  children: [
                    CustomTextField(
                      controller: descontoController,
                      label: "Desconto",
                      onChanged: (value) {
                        notifier.setDiscoutedPercentage(value);
                      },
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              state.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                    child: CustomButton(
                      text: "Salvar Item",
                      onPressed: () async {
                        try {
                          await notifier.uploadAndSaveItem(
                            nameController.text,
                            priceController.text,
                          );
                          showSnackBar(context, "Item salvo com sucesso");
                          Navigator.pop(context);
                        } catch (e) {
                          showSnackBar(context, "Erro ao salvar o item $e");
                        }
                      },
                    ),
                  ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  void _showPickOptions(BuildContext context, AddItemNotifier notifier) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Câmera"),
                onTap: () {
                  Navigator.of(context).pop();
                  notifier.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Galeria"),
                onTap: () {
                  Navigator.of(context).pop();
                  notifier.pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
