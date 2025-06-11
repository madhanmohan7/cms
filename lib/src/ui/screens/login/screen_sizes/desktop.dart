import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../services/api.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/logger.dart';

import 'package:http/http.dart' as http;

import '../../../../utils/routes/route_names.dart';

class LoginDesktopUi extends StatefulWidget {
  const LoginDesktopUi({super.key});

  @override
  State<LoginDesktopUi> createState() => _LoginDesktopUiState();
}

class _LoginDesktopUiState extends State<LoginDesktopUi> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _userTxt = "";
  String _passTxt = "";

  bool isPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onusernameChangeListener);
    _passwordController.addListener(_onpasswordChangeListener);
  }

  _onusernameChangeListener() {
    setState(() {
      _userTxt = _usernameController.text;
    });
  }

  _onpasswordChangeListener() {
    setState(() {
      _passTxt = _passwordController.text;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          width: MediaQuery.of(context).size.width,
          child: Image.asset('images/bg6.jpeg', fit: BoxFit.cover),
        ),
        Positioned(
          //top: 70,
          top: MediaQuery.of(context).size.width * 0.05,
          left: MediaQuery.of(context).size.width * 0.2,
          child: Container(
            // width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.width * 0.4,
            width: 500,
            //height: 550,
            decoration: BoxDecoration(
              color: oWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let\'s Login\nOCPP CMS Portal",
                  style: GoogleFonts.poppins(
                      color: oBlack,
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Kindly provide your registered username and a working password in the blanks below.",
                  style: GoogleFonts.poppins(
                      color: oBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Username",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: oBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' *',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: oRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _usernameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 21,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username required';
                    }
                    if (RegExp(r'^\d').hasMatch(value)) {
                      return 'Username should not start with a digit';
                    }
                    // Check if the username contains only alphabets and digits
                    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                      return 'Username contain alphabets and digits only';
                    }
                    return null;
                  },
                  cursorColor: oBlack,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: oBlack, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: oBlack, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: oRed, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: oRed),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.person_solid,
                      color: oBlack.withOpacity(0.35),
                      size: 22,
                    ),
                    hintText: "Username",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 15,
                      color: oBlack.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    errorStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: oRed,
                      ),
                    ),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Password",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: oBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' *',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: oRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _passwordController,
                  obscureText: isPasswordVisible,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password required';
                    }
                    if (value.length < 8) {
                      return 'Password must be atleast 8 characters';
                    }
                    if (value.toString().startsWith(" ")) {
                      return 'First character of the password cannot be a space.';
                    }
                    // RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).+$');
                    // if (!regex.hasMatch(value)) {
                    //   return 'Password at least one uppercase, one lowercase, one special character and one digit';
                    // }
                    //  else if (value.toString().startsWith(" ")) {
                    //    return 'First character of the password cannot be a space.';
                    //  }
                    // else if (value.contains(' ')) {
                    //   return 'Password won\'t accept spaces';
                    // }

                    return null;
                  },
                  cursorColor: oBlack,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: oBlack, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: oBlack, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: oRed, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: oRed),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: "Password",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 15,
                      color: oBlack.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      Icons.password_rounded,
                      color: oBlack.withOpacity(0.35),
                      size: 22,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isPasswordVisible
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye,
                        color: oBlack.withOpacity(0.35),
                        size: 22,
                      ),
                    ),
                    border: InputBorder.none,
                    errorStyle: GoogleFonts.poppins(
                      color: oRed,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      LoggerUtil.getInstance.print("login button pressed");
                      loginUser();
                      //Navigator.pushNamed(context, RouteNames.homeScreen);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(oBlack),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(const Size(200, 60)),
                    ),
                    child: Text(
                      "LogIn",
                      style: GoogleFonts.poppins(
                        color: oWhite,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "© 2024 ",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: oBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "CMS(Charger Management System)",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: oGreen,
                            fontWeight: FontWeight.w500,
                            //decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: " Company.",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: oBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> loginUser() async {
    const String apiUrl = BaseURLConfig.loginApiURL;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _userTxt,
          'password': _passTxt,
        }),
      );
      print('response.body: ${response.body}');
      if (response.statusCode == 200) {
        print('If response>>>>>>>');
        Map<String, dynamic> data = jsonDecode(response.body);
        print('data: $data');
        String token = data['token'];
        print('token: $token');
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('token', token);

        var prefToken = prefs.getString('token');
        print('pref_token: $prefToken');
        Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
        print('Decoded Token: $decodedToken');

        String name = decodedToken['name'];
        String emailId = decodedToken['email'];
        String role = decodedToken['role'];
        int userCommunity = int.parse(decodedToken['organization_id'].toString());
        int userId = int.parse(decodedToken['user_id'].toString());
        int jwtEndTime = int.parse(decodedToken['exp'].toString());

        // Convert the JWT expiration time (UTC) to DateTime
        DateTime jwtEndDateTimeUtc = DateTime.fromMillisecondsSinceEpoch(jwtEndTime * 1000, isUtc: true);

        // Convert the UTC DateTime to IST DateTime
        DateTime jwtEndDateTimeIst = jwtEndDateTimeUtc.add(Duration(hours: 5, minutes: 30)); // IST is UTC+5:30

        // Convert the IST DateTime to a timestamp or format it as needed
        // int jwtEndTimeIst = jwtEndDateTimeIst.millisecondsSinceEpoch;
        String formattedJwtEndTimeIst = DateFormat('yy-MM-dd HH:mm:ss').format(jwtEndDateTimeIst);


        prefs.setString('username', name);
        prefs.setString('email', emailId);
        prefs.setString('userRole', role);
        prefs.setInt('userId', userId);
        prefs.setInt('userCommunity', userCommunity);
        prefs.setString('jwtexptime', formattedJwtEndTimeIst);

        // window.localStorage['username'] = name;
        // window.localStorage['email'] = emailId;
        // window.localStorage['userRole'] = role;

        print('Current User Name: $name');
        print('Current User EmailId: $emailId');
        print('Current User role: $role');
        print('Current User Id: $userId');
        print('Current User Community Id: $userCommunity');
        print('JWT Expiration Time in IST: $formattedJwtEndTimeIst');


        switch (role) {
          case 'sub-admin':
          //_showLoginResult(context, true);
            await Future.delayed(const Duration(milliseconds: 2000));
            Navigator.pushNamed(context, RouteNames.homeScreen);
            break;
          case 'admin':
          //_showLoginResult(context, true);
            await Future.delayed(const Duration(milliseconds: 2000));
            Navigator.pushNamed(context, RouteNames.homeScreen);
            break;
          default:
            print('Unknown role or no role specified.');
            break;
        }
      } else {
        print('Failed to login. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        //_showLoginResult(context, false);
        await Future.delayed(const Duration(milliseconds: 2000));
        Navigator.pop(context);

      }
    } catch (e) {
      print('Exception during login: $e');
      //_showLoginResult(context, false);
      await Future.delayed(const Duration(milliseconds: 2000));
      Navigator.pop(context);
    }
  }

}


