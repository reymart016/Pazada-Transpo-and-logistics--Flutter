import 'package:flutter/material.dart';

import 'package:pazada/models/pazabuyProduct.dart';


class CartItemDesign extends StatefulWidget
{
  final PazabuyProducts model;
  BuildContext context;
  final int quanNumber;

  CartItemDesign({
    this.model,
    this.context,
    this.quanNumber,
  });

  @override
  _CartItemDesignState createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.only(top: .5, left: 8, right: 8, bottom: 10),
        child: Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
          child: Column(

            children: [
              Row(
              children: [


                //image
                Image.network(widget.model.thumbnailUrl, width: 140, height: 100,),

                const SizedBox(width: 6,),

                //title
                //quantity number
                //price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    //title
                    Text(
                      widget.model.productName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "bolt-bold",
                      ),
                    ),
                    // const SizedBox(
                    //   height: 1,
                    // ),

                    //quantity number // x 7
                    Row(
                      children: [
                        const Text(
                          "x ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "bolt",
                          ),
                        ),
                        Text(
                          widget.quanNumber.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "bolt",
                          ),
                        ),
                      ],
                    ),

                    //price
                    Row(
                      children: [
                        const Text(
                          "Price: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontFamily: "bolt",
                          ),
                        ),
                        const Text(
                          "Php ",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                            fontFamily: "bolt",
                          ),
                        ),
                        Text(
                            widget.model.price.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontFamily: "bolt",
                            )
                        ),
                      ],
                    ),

                  ],
                ),


              ],
            ),

              Divider(thickness: 1,color: Colors.grey,),
        ]
          ),
        ),
      ),
    );
  }
}
