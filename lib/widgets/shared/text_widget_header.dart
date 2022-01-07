import 'package:flutter/material.dart';

class TextWidgetHeader extends SliverPersistentHeaderDelegate {
  String title;
  TextWidgetHeader({this.title});

  @override
  Widget build(BuildContext context, double shrinkOffset,bool overlapseContent) {
    return InkWell(
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.amberAccent
        ),
        child: InkWell(
          child: Text(title,
            maxLines: 2,
            style: TextStyle(fontFamily: 'bolt-bold', color: Colors.white, ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 50;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
