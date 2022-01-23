import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/models/pazabuyMenus.dart';
import 'package:pazada/models/pazadaSellers.dart';
import 'package:pazada/widgets/pazabuy_screen/pazabuy_screen.dart';
import 'package:pazada/widgets/pazabuy_screen/widgets/menus_design.dart';
import 'package:pazada/widgets/shared/loading.dart';
import 'package:pazada/widgets/shared/text_widget_header.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Menuscreen extends StatefulWidget {
  final PazadaSellers model;
  Menuscreen({this.model});
  @override
  _MenuscreenState createState() => _MenuscreenState();
}

class _MenuscreenState extends State<Menuscreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              clearCartNow(context);
              Fluttertoast.showToast(msg: "Cart has been cleared.");
              Navigator.push(context, MaterialPageRoute(builder: (c)=>  PazabuyScreen()));
            },
            child: Icon(Icons.keyboard_arrow_left, color: Colors.white,)
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [

                Colors.amber,
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

      ),//AppBar
      body: CustomScrollView(
        slivers:[
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: widget.model.userName.toString() +" Menus")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Pazabuy").doc(widget.model.uId)
                .collection("PazabuyMenus").orderBy("publishedDate", descending: true).snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                child: Center(child: Loading(),),
              )//SliverToBoxAdapter
                  : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => StaggeredTile.fit(1),
              itemBuilder: (constext, index)
              {
              PazabuyMenus model = PazabuyMenus.fromJson(
              snapshot.data.docs[index].data() as Map<String, dynamic>,
              );
              return MenuDesignWidget(
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
    );//
  }
}
