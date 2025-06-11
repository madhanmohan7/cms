import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/colors/colors.dart';
import '../../logout/logout.dart';

class HomeCustomAppBar extends StatefulWidget {
  const HomeCustomAppBar({super.key});

  @override
  _HomeCustomAppBarState createState() => _HomeCustomAppBarState();
}

class _HomeCustomAppBarState extends State<HomeCustomAppBar> {
  String usernameLetter = "G";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    setState(() {
      usernameLetter = (username != null && username.isNotEmpty) ? username.substring(0, 1) : "G";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'icons/ev_leaf.svg',
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CMS',
                    style: GoogleFonts.goldman(
                        color: oBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    'Charger Management System',
                    style: GoogleFonts.goldman(
                      color: oBlack,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),

          GestureDetector(
            onTap: () => _showCustomProfileDialog(context),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: oWhite,
                shape: BoxShape.circle,
                border: Border.all(width: 0.5, color: oBlack),
              ),
              child: Center(
                child: Text(
                  usernameLetter,
                  style: GoogleFonts.poppins(
                    color: oBlack,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCustomProfileDialog(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // LoggerUtil.getInstance.print("storage data : $prefs");
    String? name = prefs.getString('username');
    String? emailId = prefs.getString('email');
    int? userid = prefs.getInt('userId');

    String usernameLetter = (name != null && name.isNotEmpty) ? name.substring(0, 1) : "G";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: 50,
              right: 0,
              child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    width: 450,
                    height: 380,
                    decoration: BoxDecoration(
                      // color: oWhite,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          child: Container(
                            width: 450,
                            height: 140,
                            decoration: const BoxDecoration(
                                color: oGreen,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                )
                            ),
                          ),
                        ),

                        Positioned(
                          top: 100,
                          left: 25,
                          right: 25,
                          child: Container(
                            width: 350,
                            height: 250,
                            decoration: const BoxDecoration(
                              color: oWhite,
                              // borderRadius: BorderRadius.circular(12)
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 55),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Text(
                                  name ?? "Guest",
                                  style: GoogleFonts.poppins(
                                      color: oBlack,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  emailId ?? "guest@example.com",
                                  style: GoogleFonts.poppins(
                                    color: oGrey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  'User ID: ${userid ?? '00000'}',
                                  style: GoogleFonts.poppins(
                                    color: oBlack,
                                    fontSize: 14.0,
                                  ),
                                ),

                                const SizedBox(height: 15.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        // Handle 'My account' action
                                      },
                                      style: ButtonStyle(
                                        //backgroundColor: MaterialStateProperty.all(oBlack),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              side: const BorderSide(width: 1.5, color: oGrey)
                                          ),
                                        ),
                                        minimumSize: MaterialStateProperty.all(const Size(100, 45)),
                                      ),
                                      child: Text('My account',
                                        style: GoogleFonts.poppins(
                                          color: oGrey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Handle 'Sign out' action
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return LogoutDialog();
                                          },
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(oRed),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            //side: const BorderSide(width: 1.5, color: oGrey)
                                          ),
                                        ),
                                        minimumSize: MaterialStateProperty.all(const Size(100, 45)),
                                      ),
                                      child: Text('Sign out',
                                        style: GoogleFonts.poppins(
                                          color: oWhite,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          top: 50,
                          left: 50,
                          right: 50,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: oWhite,
                                shape: BoxShape.circle,
                                border: Border.all(width: 1, color: oGreen)
                            ),
                            child: Center(
                              child: Text(
                                usernameLetter,
                                style: GoogleFonts.poppins(
                                    color: oGreen,
                                    fontSize: 45.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ),
          ],
        );
      },
    );
  }

}
