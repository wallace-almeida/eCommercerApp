import 'package:ecommerce/contants/constans.dart';
import 'package:ecommerce/model/model.dart';
import 'package:flutter/material.dart';

class CuratedItems extends StatelessWidget {
  final AppModel eCommerceItems;
  final Size size;

  const CuratedItems({
    super.key,
    required this.eCommerceItems,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Container(
          width: size.width * 0.5,
          height: size.height * 0.25,

          decoration: BoxDecoration(
            color: backgroundColor2,
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(eCommerceItems.image),
              fit: BoxFit.contain, // ou BoxFit.contain conforme sua necessidade
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black26,
                child: Icon(Icons.favorite_border, color: Colors.white),
              ),
            ),
          ),
        ),

        SizedBox(height: 7),
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
            Text(eCommerceItems.rating.toString()),
            Text(
              "(${eCommerceItems.review})",
              style: TextStyle(color: Colors.black26),
            ),
          ],
        ),
        SizedBox(
          width: size.width * 0.5,
          child: Text(

            eCommerceItems.name,

            maxLines: 1,
            overflow: TextOverflow.ellipsis, // colocar ... no textp
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            Text(
              "\$${eCommerceItems.price.toString()}.00",

              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.pink,
                fontSize: 18,
                height: 1.5,
              ),
            ),
            SizedBox(width: 5),
            if (eCommerceItems.isCheck == true)
              Text(
                "\$${eCommerceItems.price + 200}.00",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black26,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.black26,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
