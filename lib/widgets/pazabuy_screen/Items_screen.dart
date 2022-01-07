import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pazada/assistants/pazabuy/cart_item_counter.dart';

import 'package:pazada/models/pazabuyMenus.dart';
import 'package:pazada/models/pazabuyProduct.dart';
import 'package:pazada/models/pazabuyusers.dart';

import 'package:pazada/widgets/pazabuy_screen/widgets/items_design.dart';
import 'package:pazada/widgets/shared/loading.dart';
import 'package:pazada/widgets/shared/text_widget_header.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pazada/widgets/shared/under_construction.dart';
import 'package:provider/provider.dart';


class ItemScreen extends StatefulWidget
{

    final PazabuyMenus model;
    ItemScreen({this.model});


    @override
    _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                flexibleSpace: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                                Colors.amberAccent,
                                Colors.amber,
                            ],
                            begin: FractionalOffset(0.0, 0.0),
                            end: FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp,
                        ),//LinearGradient
                    ),//BoxDecoration
                ),//Container
                title: Text(
                    "Pazabuy",
                    //sharedPreferences!.getString("name")!,
                    style: const TextStyle(fontSize: 25, fontFamily: "bolt-bold", color: Colors.white),
                ),//text
                centerTitle: true,
                automaticallyImplyLeading: true,
                // actions: [
                //     Stack(
                //         children: [
                //             IconButton(
                //                 icon: Icon(Icons.shopping_cart, color: Colors.white,),
                //                 onPressed: ()
                //                 {
                //                     Route route = MaterialPageRoute(builder: (c) => UnderConstruction());
                //                     Navigator.pushReplacement(context, route);
                //                 },
                //             ),
                //             Positioned(
                //                 child: Stack(
                //                     children: [
                //                         Icon(
                //                             Icons.circle,
                //                             size: 20.0,
                //                             color: Colors.green,
                //                         ),
                //                         Positioned(
                //                             top: 3.0,
                //                             bottom: 4.0,
                //                             left: 5.0,
                //                             child: Center(
                //                                 child: Consumer<CartItemCounter>(
                //                                     builder: (context, counter, c){
                //                                         return Text(counter.count.toString()
                //                                         );
                //                                     },
                //                                 ),
                //                             )
                //
                //
                //
                //
                //                         ),
                //                     ],
                //                 ),
                //             ),
                //         ],
                //     ),
                // ],

            ),
            body: CustomScrollView(
                slivers:[
                    SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "Items of " + widget.model.menuName + "'s Menu")),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Pazabuy")
                            .doc(widget.model.sellerUID)
                            .collection("PazabuyMenus")
                            .doc(widget.model.menuID)
                            .collection("PazabuyProducts")
                            .orderBy("publishedDate", descending: true)
                            .snapshots(),
                        builder: (context, snapshot)
                        {
                            return !snapshot.hasData
                                ?SliverToBoxAdapter(
                                child: Center(child: Loading(),),
                            )//SliverToBoxAdapter
                            : SliverStaggeredGrid.countBuilder(
                                crossAxisCount: 1,
                                staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                                itemBuilder: (constext, index)
                                {
                                    PazabuyProducts model = PazabuyProducts.fromJson(
                                        snapshot.data.docs[index].data() as Map<String, dynamic>,
                                    );
                                    return ItemDesignWidget(
                                        model: model,
                                        context: context,
                                    );
                                },
                                itemCount: snapshot.data.docs.length,
                            );//sliverStraggeredGrid.countbuilder
                        },
                    ),//streamBuilder
                ],
            ),//cuntomscrollview
        );//Scaffold
    }
}