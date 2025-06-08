class Category {
  final String nome;
  final String image;
  Category({required this.nome, required this.image});
  static final List<Category> categories = [
    Category(nome: "Masculino", image: "assets/image/banner_1.png"),
    Category(nome: "Feminino", image: "assets/image/mulher_fab.png"),
    Category(nome: "10° Uniforme", image: "assets/image/10_uniforme.png"),
    Category(nome: "9° Uniforme", image: "assets/image/9_uniforme-.png"),
    Category(nome: "7° Uniforme", image: "assets/image/7Uniforme.png"),
    Category(nome: "Acessorios", image: "assets/image/acessorios.png"),
  ];
}
