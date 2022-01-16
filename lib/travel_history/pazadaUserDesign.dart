import 'package:flutter/material.dart';
import 'package:pazada/models/pazadaUserHistory.dart';
import 'package:pazada/travel_history/pazadaHistoryDetails.dart';



class PazadaUserDesignWidget extends StatefulWidget
{
  PazadaUserHistoryModel model;
  BuildContext context;

  PazadaUserDesignWidget({this.model, this.context});

  @override
  _PazadaUserDesignWidgetState createState() =>  _PazadaUserDesignWidgetState();
}

class _PazadaUserDesignWidgetState extends State<PazadaUserDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:()
      {
        showDialog(context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => PazadaUserHistoryDetails(models: widget.model,)
        );
        //Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemDetailScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children:[
              // Divider(
              //   height:4,
              //   thickness: 3,
              //   color: Colors.grey[300],
              // ),
              // Image.network(
              //   widget.model.thumbnailUrl,
              //   height: 220.0,
              //   fit: BoxFit.cover,
              // ),//image.network
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber)
                ),

                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.model.service_type,
                            style: TextStyle(
                              color: Colors.cyan,
                              fontSize: 20,
                              fontFamily: "bolt-bold",
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            widget.model.created_at.toDate().toString(),// parse this
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: "bolt"
                            ),//TextStyle
                          ),

                        ],

                      ),
                      Column(
                        children: [
                          Text("Php "+
                            widget.model.price,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: "bolt"
                            ),
                          ),
                          Text("details", style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontFamily: "bolt"),)
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1.0,),


              // Divider(
              //   height: 4,
              //   thickness: 3,
              //   color: Colors.grey[300],
              // ),//Divider
            ],
          ),//column
        ),//container
      ),//padding
    );
  }
}