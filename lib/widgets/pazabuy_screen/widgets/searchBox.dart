import 'package:flutter/material.dart';

class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent) =>
      InkWell(
        onTap: (){
          print("tap");
        },
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.amber
          ),

          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: InkWell(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              height: 50,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),

              ),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.search,
                    color: Colors.amberAccent,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 8),
                    child: Text("Search Product",

                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      );

  @override
  double get maxExtent => 80;
  @override
  double get minExtent => 80;


  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate)=> true;

}