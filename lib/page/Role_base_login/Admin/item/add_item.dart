import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widget/text_field/text_field.dart';

class AddItem extends StatelessWidget {
  AddItem({super.key});
  TextEditingController sizeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descontoController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  height:
                      150, // Aumentar a altura para acomodar melhor a imagem e o ícone
                  width:
                      150, // Aumentar a largura para acomodar melhor a imagem e o ícone
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Adicionar uma cor de fundo suave
                    border: Border.all(
                      color: Colors.grey[400]!, // Cor da borda mais suave
                      width: 1.5, // Largura da borda
                    ),
                    borderRadius: BorderRadius.circular(
                      15,
                    ), // Bordas mais arredondadas
                    boxShadow: [
                      // Adicionar uma sombra para dar profundidade
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Posição da sombra
                      ),
                    ],
                  ),
                  child: InkWell(
                    // Usar InkWell para tornar a área clicável
                    onTap: () async {
                      // Lógica para selecionar a imagem
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      // ignore: unused_local_variable
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                    },
                    child: Column(
                      // Usar Column para centralizar o ícone e o texto
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.grey[600],
                        ), // Ícone de adicionar foto
                        SizedBox(
                          height: 10,
                        ), // Espaçamento entre o ícone e o texto
                        Text(
                          "Adicionar Foto",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ), // Texto indicativo
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              CustomTextField(controller: nameController, label: "Nome"),
              SizedBox(height: 15),
              CustomTextField(controller: priceController, label: "Preço"),
              SizedBox(height: 15),
              // DropdownButtonFormField(items: [], onChanged: (value) {}),
              CustomTextField(controller: sizeController, label: "Tamanho"),
              SizedBox(height: 15),
              CustomTextField(controller: colorController, label: "Cores"),
              SizedBox(height: 15),
              CustomTextField(
                controller: descontoController,
                label: "Desconto",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
