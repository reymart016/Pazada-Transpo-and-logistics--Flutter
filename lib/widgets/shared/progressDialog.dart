import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pazada/widgets/shared/loading.dart';

class ProgressDialog extends StatelessWidget {
  String message;
  ProgressDialog({this.message});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        margin: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),

        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              SizedBox(width: 6,),
              Container(
                height: 50,
                  child: SpinKitHourGlass(color: Colors.amber, )),
              SizedBox(width: 26,),
              Text(
                message,
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      ),



    );
  }
}
