import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/profile/profile_screen.dart';
import 'package:pazada/widgets/idle_screen/idle_screen.dart';
import 'package:pazada/widgets/login/login_screen.dart';

import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/bottomBar/colors.dart';
import 'package:pazada/bottomBar/config/size_config.dart';
import 'package:pazada/bottomBar/style.dart';

// Stateful widget created
class BottomBar extends StatefulWidget {
  static const String idScreen = "BottomBar";
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
// index given for tabs
  int currentIndex = 0;
  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

// Number of tabs
  final tabs = [
    IdleScreen(),
    ProfileScreen(),
    Center(child: PrimaryText(text: 'Profile Page', size: 40, color: AppColors.primary)),
    Center(child: PrimaryText(text: 'Cart detail Page', size: 40, color: AppColors.primary)),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
       index: currentIndex,
       children: tabs,
      ),

      // bottom app bar
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // button 1
              GestureDetector(
                onTap: () {
                  setBottomBarIndex(0);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal:20, vertical: 10),
                  decoration: BoxDecoration(
                    color: currentIndex == 0 ? AppColors.primaryLight : AppColors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                  'images/svg/home.svg',
                  width: 20,
                  color: currentIndex == 0 ? AppColors.primary : Colors.grey,
                ),
                currentIndex == 0 ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: PrimaryText(text: 'Home', size: 16, color: AppColors.primary, fontWeight: FontWeight.w700),
                ) : SizedBox()
                      ],
                    )),
              ),

              // button 2
              // GestureDetector(
              //   onTap: () {
              //     setBottomBarIndex(1);
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal:20, vertical: 10),
              //     decoration: BoxDecoration(
              //       color: currentIndex == 1 ? AppColors.primaryLight : AppColors.white,
              //       borderRadius: BorderRadius.circular(20)
              //     ),
              //       child: Row(
              //         children: [
              //           SvgPicture.asset(
              //     'images/svg/location.svg',
              //     width: 20,
              //     color: currentIndex == 1 ? AppColors.primary : Colors.grey,
              //   ),
              //   currentIndex == 1 ? Padding(
              //     padding: const EdgeInsets.only(left: 10),
              //     child: PrimaryText(text: 'Near by', size: 16, color: AppColors.primary, fontWeight: FontWeight.w700),
              //   ) : SizedBox()
              //         ],
              //       )),
              // ),
              // button 3
               GestureDetector(
                onTap: () {
                  setBottomBarIndex(1);
                  //logoutUser();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal:20, vertical: 10),
                  decoration: BoxDecoration(
                    color: currentIndex == 1 ? AppColors.primaryLight : AppColors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                  'images/svg/user.svg',
                  width: 20,
                  color: currentIndex == 2 ? AppColors.primary : Colors.grey,
                ),
                currentIndex == 1 ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: PrimaryText(text: 'Profile', size: 16, color: AppColors.primary, fontWeight: FontWeight.w700),
                ) : SizedBox()
                      ],
                    )),
              ),

              // button 4
              //  GestureDetector(
              //   onTap: () {
              //     setBottomBarIndex(3);
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal:20, vertical: 10),
              //     decoration: BoxDecoration(
              //       color: currentIndex == 3 ? AppColors.primaryLight : AppColors.white,
              //       borderRadius: BorderRadius.circular(20)
              //     ),
              //       child: Row(
              //         children: [
              //           SvgPicture.asset(
              //     'assets/cart.svg',
              //     width: 20,
              //     color: currentIndex == 3 ? AppColors.primary : Colors.grey,
              //   ),
              //   currentIndex == 3 ? Padding(
              //     padding: const EdgeInsets.only(left: 10),
              //     child: PrimaryText(text: 'Cart', size: 16, color: AppColors.primary, fontWeight: FontWeight.w700),
              //   ) : SizedBox()
              //         ],
              //       )),
              // ),
            ],
          ),
        ),
      ),
    );
  }
  void logoutUser(){
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
  }
}
