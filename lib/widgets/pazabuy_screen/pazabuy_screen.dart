import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pazada/Config/config.dart';

import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/models/pazadaSellers.dart';
import 'package:pazada/models/products.dart';
import 'package:pazada/widgets/pazabuy_screen/widgets/info_design.dart';
import 'package:pazada/widgets/pazabuy_screen/widgets/searchBox.dart';
import 'package:pazada/widgets/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/widgets/framework.dart';

class PazabuyScreen extends StatefulWidget {
  static const String idScreen = "PazabuyScreen";
  @override
  _PazabuyScreenState createState() => _PazabuyScreenState();
}

class _PazabuyScreenState extends State<PazabuyScreen> {

  final items = [
    "slider/0.jpg","slider/1.jpg","slider/2.jpg","slider/3.jpg","slider/0.jpg","slider/4.jpg",
    "slider/5.jpg","slider/6.jpg","slider/7.jpg","slider/8.jpg","slider/9.jpg","slider/10.jpg",
    "slider/11.jpg","slider/12.jpg","slider/13.jpg","slider/14.jpg","slider/15.jpg","slider/16.jpg",
    "slider/17.jpg","slider/18.jpg","slider/19.jpg","slider/20.jpg","slider/21.jpg","slider/22.jpg",
    "slider/23.jpg","slider/24.jpg","slider/25.jpg","slider/26.jpg","slider/27.jpg",
  ];
  double width;
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Pazabuy",
          style: TextStyle(fontSize: 25.0, color: Colors.white, fontFamily: "bolt-bold"),
        ),
        centerTitle: true,
        actions: [
          // Stack(
          //   children: [
          //     IconButton(
          //       icon: Icon(Icons.shopping_cart, color: Colors.white,),
          //       onPressed: ()
          //       {
          //         //Route route = MaterialPageRoute(builder: (c) => CartPage());
          //        // Navigator.pushReplacement(context, route);
          //       },
          //     ),
          //     Positioned(
          //       child: Stack(
          //         children: [
          //           Icon(
          //             Icons.circle,
          //             size: 300.0,
          //             color: Colors.green,
          //           ),
          //           Positioned(
          //             top: 3.0,
          //             bottom: 4.0,
          //             left: 5.0,
          //             child: Consumer<CartItemCounter>(
          //               builder: (context, counter, _)
          //               {
          //                 return Text(
          //                   counter.count.toString(),
          //                   style: TextStyle(color: Colors.white, fontSize:15.0,),
          //                 );
          //               },
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),

      body: CustomScrollView(
        slivers: [
          // SliverPersistentHeader(pinned: true,delegate: SearchBoxDelegate()),
          // StreamBuilder(
          //   stream: Firestore.instance.collection("items").limit(15).orderBy("publishedDate", descending: true).snapshots(), //onValue is the counterpart of snapshot in firestore
          //   builder: (context, dataSnapshot){
          //     return !dataSnapshot.hasData? SliverToBoxAdapter(child: Center(child: circularProgress(),),) :
          //         SliverStaggeredGrid.countBuilder(
          //           crossAxisCount: 1,
          //           staggeredTileBuilder: (c)=> StaggeredTile.fit(1),
          //           itemBuilder: (context, index){
          //             ProductModel productmodel = ProductModel.fromJson(dataSnapshot.data.documents[index].data);
          //             return sourceInfo(productmodel, context);
          //           },
          //           itemCount: dataSnapshot.data.documents.length,
          //         );
          //   },
          // )
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 400,
                    aspectRatio: 16/9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: items.map((index){
                    return Builder(builder: (BuildContext context){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin:  const EdgeInsets.symmetric(horizontal: 1),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Image.asset(index,
                          fit: BoxFit.fill,),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("PazadaSellers").snapshots(),
            builder: (context, snapshot){
              return !snapshot.hasData ? SliverToBoxAdapter(
                child: Center(child:  Loading(),),
              )
                  : SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,
                staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                itemBuilder: (context, index){
                  PazadaSellers model = PazadaSellers.fromJson(snapshot.data.docs[index].data() as Map<String, dynamic>);
                  return InfoDesignWidget(
                    model: model,
                    context: context,
                  );
                },
                itemCount: snapshot.data.docs.length,
              );

            },
          )
        ],
      )

    );
  }

  Widget sourceInfo(ProductModel productmodel, BuildContext context,
      {Color background, removeCartFunction}) {
    return InkWell(
      onTap: ()
      {
        // Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
        // Navigator.pushReplacement(context, route);
      },
      splashColor: Colors.pink,
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Container(
          height: 190.0,
          width: width,
          child: Row(
            children: [
              Image.network(productmodel.thumbnailUrl, width: 140.0, height: 140.0,),
              SizedBox(width: 4.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.0,),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(productmodel.title, style: TextStyle(color: Colors.black, fontSize: 14.0),),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(productmodel.shortInfo, style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.pink,
                          ),
                          alignment: Alignment.topLeft,
                          width: 40.0,
                          height: 43.0,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "50%", style: TextStyle(fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  "OFF", style: TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: Row(
                                children: [
                                  Text(
                                    r"Origional Price: € ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  Text(
                                    (productmodel.price + productmodel.price).toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    r"New Price: ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "€ ",
                                    style: TextStyle(color: Colors.red, fontSize: 16.0),
                                  ),
                                  Text(
                                    (productmodel.price).toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),

                    Flexible(
                      child: Container(),
                    ),

                    //to implement the cart item aad/remove feature


                    Divider(
                      height: 5.0,
                      color: Colors.pink,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  circularProgress() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 12.0),
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.green),),
    );
  }
}
