import 'package:flutter/material.dart';
import 'package:pazada/widgets/dropOff_screen/dropOff_screen.dart';
import 'package:pazada/widgets/login/login_screen.dart';
import 'package:pazada/widgets/pazabuy_screen/pazabuy_screen.dart';
import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/widgets/pazinga/pazinga_screen.dart';
import 'package:pazada/widgets/pazship/pazShip_screen.dart';
import 'package:pazada/widgets/shared/divider.dart';
import 'package:pazada/widgets/shared/navbar.dart';

class ScreenStatus extends StatefulWidget {
  static const String idScreen = "screenStatus";
  @override
  _ScreenStatusState createState() => _ScreenStatusState();
}
var scaffoldKey = GlobalKey<ScaffoldState>();
class _ScreenStatusState extends State<ScreenStatus> {
  int _currentIndex = 0;
  final List <Widget> _children = [
    PazadaScreen(),
    Pazabuy(),
    PazShip(),
    Pazinga()

  ];
  void onTappedBar(int index){
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Pazada", style: TextStyle( color: Colors.white),),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.menu_rounded, color: Colors.white,),onPressed: (){
          scaffoldKey.currentState.openDrawer();
        },),
      ),

      drawer: Container(

        color: Colors.red,
        width: 255,
        child: Drawer(


          child: ListView(
            children: [
              Container(
                height: 165,
                child: DrawerHeader(

                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(

                    children: [
                      Image.asset("images/pazada-logo.png", height: 65,width: 65,),
                      SizedBox(width: 116,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 16,),
                          Text("Profile Name", style: TextStyle(fontFamily: "bolt-bold", fontSize: 15),),
                          SizedBox(height: 12,),
                          Text("Visit Profile", style: TextStyle(fontFamily: "bolt", fontSize: 12),),

                        ],

                      ),

                    ],

                  ),
                ),
              ),

              DividerWidget(),
              SizedBox(height: 12,),
              ListTile(
                leading: Icon(Icons.track_changes_outlined),
                title: Text("PazTracking", style: TextStyle(fontSize: 15, fontFamily: "bolt"),),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text("History", style: TextStyle(fontSize: 15, fontFamily: "bolt"),),
              ),

              ListTile(
                leading: Icon(Icons.info),
                title: Text("About", style: TextStyle(fontSize: 15, fontFamily: "bolt"),),
              ),
              ListTile(
                leading: Icon(Icons.bug_report),
                title: Text("Report Bugs", style: TextStyle(fontSize: 15, fontFamily: "bolt"),),
              ),
            ],
          ),
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 12,
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        backgroundColor: Colors.amber,
        items:[
          BottomNavigationBarItem(icon: Icon(Icons.motorcycle_rounded,),title: Text("Pazakay"),backgroundColor: Colors.amber),
          BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart,),title: Text("Pazabuy"),backgroundColor: Colors.amber),
          BottomNavigationBarItem(icon: Icon(Icons.markunread_mailbox,),title: Text("Pazship"),backgroundColor: Colors.amber),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on,),title: Text("Pazinga"),backgroundColor: Colors.amber),
        ],
      ),
    );
  }
}
