import 'package:flutter/material.dart';

class AppModel {
  final String name, image, description, category;
  final double rating;
  final int review, price;
  List<Color> color;
  List<String> size;
  bool isCheck;

  AppModel({
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.rating,
    required this.review,
    required this.price,
    required this.color,
    required this.size,
    required this.isCheck,
  });

  static final List<AppModel> fashionEcommerceApp = [
    AppModel(
      name: "10° Uniforme da forca aerea brasileira",
      image: "assets/image/10_uniforme.png",
      description: "10° Uniforme da forca aerea brasileira, uniforme usado para pratica de educacao fisica",
      category: "10° Uniforme",
      rating: 4.9,
      review: 136,
      price: 295,
      color: [
        Colors.black,
        Colors.blue,
        Colors.blue[100]!,
      ],
      size: [
        "P",
        "M",
        "G",],
      isCheck: true,),
    AppModel(
      name: "9° Uniforme da forca aerea brasileira",
      image: "assets/image/9_uniforme-.png",
      description: "9° Uniforme da forca aerea brasileira, uniforme usado para pratica de educacao fisica",
      category: "9° Uniforme",
      rating: 4.9,
      review: 136,
      price: 295,
      color: [
        Colors.black,
        Colors.blue,
        Colors.blue[100]!,
      ],
      size: [
        "P",
        "M",
        "G",],
      isCheck: true,),
    AppModel(
      name: "7° Uniforme da forca aerea brasileira",
      image: "assets/image/7Uniforme.png",
      description: "7° Uniforme da forca aerea brasileira",
      category: "7° Uniforme",
      rating: 4.9,
      review: 136,
      price: 295,
      color: [
        Colors.green,
        Colors.black,
        Colors.blue[100]!,
      ],
      size: [
        "P",
        "M",
        "G",],
      isCheck: true,),
    AppModel(
      name: "Acessorios da forca aerea brasileira",
      image: "assets/image/acessorios.png",
      description: "Todos os acessorios da Forca aerea brasileira ",
      category: "Acessorios",
      rating: 4.9,
      review: 136,
      price: 295,
      color: [
        Colors.black,
        Colors.blue,
        Colors.blue[100]!,
      ],
      size: [
        "P",
        "M",
        "G",],
      isCheck: true,)
  ];

}
