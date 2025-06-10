import 'package:ecommerce/contants/constans.dart';
import 'package:ecommerce/model/model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ItensDetailScreen extends StatefulWidget {
  final AppModel eCommerceApp;

  const ItensDetailScreen({super.key, required this.eCommerceApp});

  @override
  State<ItensDetailScreen> createState() => _ItensDetailScreenState();
}

class _ItensDetailScreenState extends State<ItensDetailScreen> {
  int currentIndex = 0;
  int selectColorIndex = 1;
  int selectSizeIndex = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroundColor2,
        title: Text("Detalhes do Produtos"),
        actions: [
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
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: backgroundColor2,
            height: size.height * 0.46,
            width: size.width,
            child: PageView.builder(
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Image.asset(
                      widget.eCommerceApp.image,
                      height: size.height * 0.4,
                      width: size.width * 0.85,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                          3,
                          (index) => AnimatedContainer(
                            duration: Duration(microseconds: 300),
                            margin: EdgeInsets.only(right: 4),
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  index == currentIndex
                                      ? Colors.blue
                                      : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(18),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "H&M",

                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black26,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.star, color: Colors.amber, size: 17),
                    Text(widget.eCommerceApp.rating.toString()),
                    Text(
                      "(${widget.eCommerceApp.review})",
                      style: TextStyle(color: Colors.black26),
                    ),
                    Spacer(), // empurrar o favorito
                    Icon(Icons.favorite_border),
                  ],
                ),
                Text(
                  widget.eCommerceApp.name,

                  maxLines: 1,

                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "\$${widget.eCommerceApp.price.toString()}.00",

                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.pink,
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(width: 5),
                    if (widget.eCommerceApp.isCheck == true)
                      Text(
                        "\$${widget.eCommerceApp.price + 200}.00",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.black26,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  "${widget.eCommerceApp.description}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width / 2.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cor",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  widget.eCommerceApp.color.asMap().entries.map(
                                    (entry) {
                                      final int index = entry.key;
                                      final color = entry.value;
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                          right: 10,
                                        ),
                                        child: CircleAvatar(
                                          radius: 18,
                                          backgroundColor: color,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectColorIndex = index;
                                              });
                                            },
                                            child: Icon(
                                              Icons.check,
                                              color:
                                                  selectColorIndex == index
                                                      ? Colors.white
                                                      : Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width / 2.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tamanho",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  widget.eCommerceApp.size.asMap().entries.map((
                                    entry,
                                  ) {
                                    final int index = entry.key;
                                    final String size = entry.value;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectSizeIndex = index;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              selectSizeIndex == index
                                                  ? Colors.black
                                                  : Colors.white,
                                          border: Border.all(
                                            color:
                                                selectSizeIndex == index
                                                    ? Colors.black
                                                    : Colors.black12,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            size,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  selectSizeIndex == index
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        elevation: 0,
        backgroundColor: Colors.white,
        label: SizedBox(
          width: size.width * 0.9,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.shopping_bag, color: Colors.black),
                      SizedBox(width: 5),
                      Text(
                        "ADD NO CARINHO",
                        style: TextStyle(
                          letterSpacing: -1,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  color: Colors.black,
                  child: Center(
                    child:  Text(
                            "COMPRAR AGORA",
                            style: TextStyle(
                              letterSpacing: -1,
                              color: Colors.white,
                            ),
                          ),

                      ),
                    ),
                  ),


            ],
          ),
        ),
      ),
    );
  }
}
