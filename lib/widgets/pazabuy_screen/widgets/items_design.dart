import 'package:flutter/material.dart';
import 'package:pazada/configs/Universal_Variable.dart';

import 'package:pazada/models/pazabuyProduct.dart';
import 'package:pazada/widgets/pazabuy_screen/item_detail_screen.dart';

class ItemDesignWidget extends StatefulWidget
{
    PazabuyProducts model;
    BuildContext context;

    ItemDesignWidget({this.model, this.context});

    @override
    _ItemDesignWidgetState createState() =>  _ItemDesignWidgetState();
}

class _ItemDesignWidgetState extends State<ItemDesignWidget> {
    @override
    Widget build(BuildContext context) {
        return InkWell(
            onTap:()
            {
                Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemDetailScreen(model: widget.model)));
                setState(() {
                  sellerUID = widget.model.sellerUID;
                });
            },
            splashColor: Colors.amber,
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    height: 280,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        children:[
                            Divider(
                                height:4,
                                thickness: 3,
                                color: Colors.grey[300],
                            ),//divisor
                            Image.network(
                                widget.model.thumbnailUrl,
                                height: 220.0,
                                fit: BoxFit.cover,
                            ),//image.network
                            SizedBox(height: 1.0,),
                            Text(
                                widget.model.productName,
                                style: TextStyle(
                                color: Colors.cyan,
                                fontSize: 20,
                                fontFamily: "Train",
                                ),//TextStyle
                            ),
                            Text(
                                widget.model.productDetails,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                ),
                            ),
                            Divider(
                                height: 4,
                                thickness: 3,
                                color: Colors.grey[300],
                            ),
                        ],
                    ),//column
                ),//container
            ),//padding
        );
    }
}