import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class TermsAndCondition extends StatelessWidget {
  static const String idScreen = "tnc";

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Condition"),
        backgroundColor: Colors.amber,

      ),
      body:  PDF(
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: false,
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onPageChanged: (int page, int total) {
          print('page change: $page/$total');
        },
      ).fromAsset('assets/pdf/TERMS-AND-CONDITION.pdf'),

    );
  }
}
