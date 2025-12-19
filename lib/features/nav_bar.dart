import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga/colors/app_color.dart';

import 'package:manga/screens/bookmarkpage.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});
  @override
  State<NavBar> createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30.0),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        width: 100.00,
                        height: 100.00,
                        'images/app_logo.png',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: Column(
                        children: [
                          Text(
                            'Free manga',
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'User interface: Ar-jay Urbina',
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 13.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Api owner: Patrick Cosmos',
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 13.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 1.00,
            margin: EdgeInsets.only(top: 10.0),
            color: AppColors.white,
          ),

          // GestureDetector(
          //   onTap: () {
          //     print("dark mode");
          //   },
          //   child: Container(
          //     width: double.infinity,
          //     margin: EdgeInsets.only(top: 30.0, left: 15.0),
          //     child: Row(
          //       children: [
          //         Image.asset('images/moonlight.png', width: 30, height: 30),
          //         Container(
          //           margin: EdgeInsets.only(left: 15.0),
          //           child: Text(
          //             'Dark mode',
          //             style: GoogleFonts.robotoCondensed(
          //               fontSize: 15.0,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.white,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              print("book mark");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bookmarkpage()),
              );
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 30.0, left: 15.0),
              child: Row(
                children: [
                  Image.asset(
                    'images/bookmark_white.png',
                    width: 30,
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Bookmark',
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
