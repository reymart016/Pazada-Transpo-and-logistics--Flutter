import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/models/pazadaUserHistory.dart';
import 'package:pazada/travel_history/pazadaUserDesign.dart';
import 'package:pazada/widgets/shared/loading.dart';
import 'package:pazada/widgets/shared/text_widget_header.dart';


import 'package:provider/provider.dart';


class PazadaRideHistoryScreen extends StatefulWidget
{



  @override
  _PazadaRideHistoryScreenState createState() => _PazadaRideHistoryScreenState();
}

class _PazadaRideHistoryScreenState extends State<PazadaRideHistoryScreen> {
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
          "Travel History",
          //sharedPreferences!.getString("name")!,
          style: const TextStyle(fontSize: 25, fontFamily: "bolt-bold", color: Colors.white),
        ),//text
        centerTitle: true,
        automaticallyImplyLeading: true,


      ),
      body: CustomScrollView(
        slivers:[
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "See your latest Pazada Travel history here.")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("PazadaUsers")
                .doc(currentfirebaseUser.uid)
                .collection("History")
                .orderBy("created_at", descending: true)
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
                  PazadaUserHistoryModel model = PazadaUserHistoryModel.fromJson(
                    snapshot.data.docs[index].data() as Map<String, dynamic>,
                  );
                  return PazadaUserDesignWidget(
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