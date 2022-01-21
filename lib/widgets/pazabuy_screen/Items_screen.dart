import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pazada/assistants/pazabuy/cart_item_counter.dart';

import 'package:pazada/models/pazabuyMenus.dart';
import 'package:pazada/models/pazabuyProduct.dart';
import 'package:pazada/models/pazabuyusers.dart';

import 'package:pazada/widgets/pazabuy_screen/widgets/items_design.dart';
import 'package:pazada/widgets/shared/app_bar.dart';
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
            appBar: MyAppBar(),
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