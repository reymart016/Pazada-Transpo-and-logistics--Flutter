import 'package:flutter/material.dart';
import 'package:pazada/models/pazadaSellers.dart';
import 'package:pazada/widgets/pazabuy_screen/menu_screen.dart';



class SellerDesignWidget extends StatefulWidget
{
    PazadaSellers model;
    BuildContext context;

    SellerDesignWidget({this.model, this.context});

    @override
    _SellerDesignWidgetState createState() =>  _SellerDesignWidgetState();
}

class _SellerDesignWidgetState extends State<SellerDesignWidget> {
    @override
    Widget build(BuildContext context) {
        return InkWell(
            onTap:()
            {
               // Navigator.push(context, MaterialPageRoute(builder: (c) => Menuscreen(model: widget.model)));
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
                            const SizedBox(height: 1.0,),
                            Text(
                                widget.model.userName,
                                style: TextStyle(
                                color: Colors.cyan,
                                fontSize: 20,
                                fontFamily: "Train",
                                ),//TextStyle
                            ),//Text
                            Text(
                                widget.model.userNumber,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                ),//TextStyle
                            ),//Text
                            Divider(
                                height: 4,
                                thickness: 3,
                                color: Colors.grey[300],
                            ),//Divider
                        ],
                    ),//column
                ),//container
            ),//padding
        );
    }
}