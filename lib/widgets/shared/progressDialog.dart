import 'package:flutter/material.dart';
import 'package:pazada/widgets/shared/loading.dart';

class ProgressDialog extends StatelessWidget {
  String message;
  ProgressDialog({this.message});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.amber,
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
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
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
