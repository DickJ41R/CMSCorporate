import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cms_web/features/authentication/views/pages/forgotpassword/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import "package:flutter/foundation.dart";
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'dart:ui';

//ignore: must_be_immutable
class Login extends StatefulWidget {
  final bool flagGetAPNS;
  const Login({super.key, required this.flagGetAPNS});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  late bool _passwordVisible;
  bool? showLogOutButton;
  String? clientName;
  bool? flagGetAPNS;
  FocusNode focusNode = FocusNode();
  FocusNode focusNodeEmail = FocusNode();
  bool? hadFocus = false;
  bool? hadFocusEmail = false;
  late FocusNode myPasswordFocusNode;
  late FocusNode myEmailFocusNode;
  AuthService? authService;
  void setAuthSingleton() {
    authService = AuthService();
  }

  @override
  void initState() {
    super.initState();
    debugPrint('line 37 login initstate');

    setAuthSingleton();
    debugPrint('line 42 loging after singleton get');
    myPasswordFocusNode = FocusNode();
    myEmailFocusNode = FocusNode();
    myPasswordFocusNode.addListener(_handlePasswordFocusChange);
    myEmailFocusNode.addListener(_handleEmailFocusChange);
    _passwordController.text = '';
    _emailController.text = '';
    flagGetAPNS = widget.flagGetAPNS;
    showLogOutButton = false;
    debugPrint('line login 45: ${FirebaseAuth.instance.currentUser}');
// Run a task after the first frame is displayed
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       debugPrint("First frame rendered! Let's load some data.");
//       // Perform data loading or other tasks here
//     });
    if (FirebaseAuth.instance.currentUser != null) {
      showLogOutButton = true;
    }
    _passwordVisible = true;
    _clientIdController.text = '';
  }

  void _handlePasswordFocusChange() {
    if (myPasswordFocusNode.hasFocus) {
      // Perform actions based on focus gain
      flagHasPassword = true;
    }
  }

  void _handleEmailFocusChange() {
    if (myEmailFocusNode.hasFocus) {
      // Perform actions based on focus gain
      flagHasEmail = true;
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myEmailFocusNode.dispose();
    myPasswordFocusNode.dispose();
    super.dispose();
  }

  // Future <void> _signOut()  async{
  //   await FirebaseAuth.instance.signOut();
  //
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) =>
  //               Login()));
  //
  // }
  // showAlertDialog(BuildContext context) {
  //
  //   Widget okButton = TextButton(
  //     child: Text("OK"),
  //     onPressed: () { },
  //   );
  //
  //   AlertDialog alert = AlertDialog(
  //     title: Text("fcmtoken"),
  //     content: Text("$fcmToken"),
  //     actions: [
  //       okButton,
  //     ],
  //   );
  //
  //   showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return alert;
  //   },
  //   );
  // }
  String? fcmToken;
  double? screenWidth;
  double? screenHeight;
  double? h;
  double fontSize = 18;
  bool flagHasEmail = false;
  bool flagHasPassword = false;
  bool flagHasClient = false;
  bool isBranchUser = false;
  //Color color1 = Color.fromARGB(255, 200, 240, 201);
// Color color2 = Color.fromARGB(255, 37, 150, 190);
  // Color color1 = Color.fromARGB(255, 172, 223, 252);
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Future<int> _getLoginCount() async {
    debugPrint('line 80 getlogincount');
    try {
      if (_emailController.text == '') {
        AlertDialog alert = AlertDialog(
          backgroundColor: Colors.yellowAccent,
          title: Text('Request for Password Change'),
          content: Text(
            'You must enter your email before trying to change your password.',
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
        );

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            });
        Future.delayed(Duration(seconds: 3));
        return 0;
      }
      String email = _emailController.text;
      int lc = await authService!.getCMSBranchUserLoginCount(email);
      debugPrint('line 106: $lc');
      if (lc == 0) {
        AlertDialog alert = AlertDialog(
          backgroundColor: Colors.yellowAccent,
          title: Text('Request for Password Change'),
          content: Text(
            'You must login successfully with provided password at least one time.',
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
        );
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            });
        Future.delayed(Duration(seconds: 3));
        return 0;
      }
      return lc;
    } catch (e) {
      debugPrint('line 129 error $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    double fontSize = 18;
    if (screenWidth! <= 480) {
      fontSize = 18;
    } else if (screenWidth! > 480 && screenWidth! < 960) {
      fontSize = 24;
    } else {
      fontSize = 30;
    }
    fontSize /= h!;
    authService!.screenRatio = screenWidth! / screenHeight!;
    fcmToken = authService!.fcmToken;
    //  debugPrint('line 60 $h, ${MediaQuery.maybeOf(context)?.textScaler.scale(1.0)}');
    return Scaffold(
      backgroundColor: color1,
      resizeToAvoidBottomInset: true,

      //  bottomNavigationBar: _signup(context),
      appBar: AppBar(
        title: Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black87),
              color: color2,
              shape: defaultTargetPlatform == TargetPlatform.iOS
                  ? BoxShape.rectangle
                  : defaultTargetPlatform == TargetPlatform.android
                      ? BoxShape.rectangle
                      : BoxShape.circle),
          child: Image.asset(defaultTargetPlatform == TargetPlatform.iOS
              ? "images/apple/logo.png"
              : defaultTargetPlatform == TargetPlatform.android
                  ? "images/apple/logo.png"
                  : "assets/logo.png"),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        // leading: GestureDetector(
        //   onTap: () {
        //     //   showAlertDialog(context);
        //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        //   },
        //   child: Container(
        //     margin: EdgeInsets.only(left: 10),
        //     decoration: BoxDecoration(color: color2, shape: BoxShape.circle),
        //     child: const Center(
        //       child: Icon(Icons.close, color: Colors.white),
        //     ),
        //   ),
        // ),
      ),
        body: ScrollConfiguration(
          // 1. Target the specific area containing your split view
          behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse, // Ensures mouse-drag resizing still works flawlessly
                PointerDeviceKind.trackpad,
                PointerDeviceKind.stylus,

              }),
          child: SafeArea(
        child: Center(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 600, maxWidth: 600, minHeight: 500, maxHeight: 500),
            child: Container(
              color: Colors.blue[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'CMS or Branch Login',
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                        color: color2,
                        fontWeight: FontWeight.bold,
                        fontSize: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .fontSize! /
                            h!,
                      )),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: Column(
                          children: [
                            // const SizedBox(height: 80),
                            // _clientName(context, fontSize),
                            // const SizedBo(height: 20)
                            // CheckboxListTile(
                            //  controlAffinity: ListTileControlAffinity.trailing,
                            //   title: Text('Branch User'),
                            //   value: isBranchUser,
                            //   onChanged: (bool? newValue) {
                            //     debugPrint('line 286 $newValue');
                            //     if (newValue == false) {
                            //      _branchUserController.text  = 'false';
                            //      } else {
                            //      _branchUserController.text  = 'true';
                            //     }
                            //     setState ( (val) {
                            //         _isBranchUser` = newValue ?? false;
                            //     }
                            //   },
                            // )
                            const SizedBox(height: 20),
                            _emailAddress(context, fontSize),
                            const SizedBox(
                              height: 20,
                            ),
                            _password(context, fontSize),
                            const SizedBox(
                              height: 20,
                            ),
                            _signin(context, fontSize),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
    );
  }

  // Widget _clientName(BuildContext context, double fontSize) {
  //   return showLogOutButton == true
  //       ? Container()
  //       : Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Branch-Client Name or Client Name',
  //               style: GoogleFonts.raleway(
  //                   textStyle: TextStyle(
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.normal,
  //                       fontSize: fontSize)),
  //             ),
  //             const SizedBox(height: 16),
  //             Container(
  //               alignment: Alignment.centerLeft,
  //               height: 64,
  //               width: screenWidth! - 10,
  //               child: Padding(
  //                 padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
  //                 child: TextField(
  //                   expands: false,
  //                   textDirection: TextDirection.ltr,
  //                   textAlign: TextAlign.start,
  //                   autocorrect: false,
  //                   style: TextStyle(
  //                     overflow: TextOverflow.clip,
  //                     fontSize: fontSize,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black87,
  //                   ),
  //                   obscureText: false,
  //                   controller: _clientIdController,
  //                   decoration: InputDecoration(
  //                       suffixIcon: IconButton(
  //                           onPressed: () async {
  //                             debugPrint('line 273 in button press for search');
  //                             String? clientN = await Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) =>
  //                                         ProcessSearchClientsScreen(
  //                                             ctx: context,
  //                                             clientName:
  //                                                 _clientIdController.text)));
  //                             debugPrint('line 281: ${clientN}');
  //                             if (clientN == null) {
  //                               debugPrint(
  //                                   'line 293 error no data returned from shift screen');
  //                               // throw Exception(
  //                               _clientIdController.text = "No clients found.";
  //                               //     'Lisnt No data returned from search screen.');
  //                             } else {
  //                               debugPrint(
  //                                   'line 288: $clientN, ${_clientIdController.text.length}');
  //                               int n1 = 28;
  //                               if (clientN.length < 28) {
  //                                 n1 = clientN.length;
  //                               }
  //                               _clientIdController.text =
  //                                   clientN.trim().substring(0, n1);
  //                               flagHasClient = true;
  //                             }
  //                           },
  //                           icon: Icon(Icons.search)),
  //                       filled: true,
  //                       hintText: 'Branch-Client or Branch or Client',
  //                       hintStyle: TextStyle(
  //                           color: Color(0xff6A6A6A),
  //                           fontWeight: FontWeight.normal,
  //                           fontSize: fontSize),
  //                       fillColor: const Color(0xffF7F7F9),
  //                       border: OutlineInputBorder(
  //                           borderSide: BorderSide.none,
  //                           borderRadius: BorderRadius.circular(14))),
  //                 ),
  //               ),
  //             )
  //           ],
  //         );
// class SingleCheckboxExample extends StatefulWidget {
//   const SingleCheckboxExample({super.key});
//
//   @override
//   State<SingleCheckboxExample> createState() => _SingleCheckboxExampleState();
// }
//
// class _SingleCheckboxExampleState extends State<SingleCheckboxExample> {
//   // 1. Declare the data entry variable
//   bool _isBranchUser = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return CheckboxListTile(
//       title: const Text('Branch User'),
//       value: _isBranchUser,
//       // 2. Update state upon user click
//       onChanged: (bool? newValue) {
//         setState(() {
//           _isBranchUser= newValue ?? false;
//         });
//       },
//       controlAffinity: ListTileControlAffinity.trailing;
//     );
//   }
// }
  Widget _emailAddress(BuildContext context, double fontSize) {
    return showLogOutButton == true
        ? Container()
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email Address',
                style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                        color: color2,
                        fontWeight: FontWeight.normal,
                        fontSize: fontSize)),
              ),
              const SizedBox(height: 16),
              Container(
                height: 64,
                width: screenWidth! - 10,
                child: TextField(
                  focusNode: myEmailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  onChanged: (value) {
                    setState(() {
                      flagHasEmail = true;
                      flagHasPassword = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      _emailController.text = value;
                      flagHasEmail = true;
                      //  _emailController.text = value;
                      //added code
                    });
                  },
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  obscureText: false,
                  controller: _emailController,
                  decoration: InputDecoration(
                      filled: true,
                      hintText: 'example@gmail.com',
                      hintStyle: TextStyle(
                          color: Color(0xff6A6A6A),
                          fontWeight: FontWeight.normal,
                          fontSize: fontSize),
                      fillColor: const Color(0xffF7F7F9),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(14))),
                ),
              )
            ],
          );
  }

  // Widget _password(BuildContext context,double fontSize) {
  //   return showLogOutButton == true ? Container() :
  //   Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Password',
  //         style: GoogleFonts.raleway(
  //              textStyle: TextStyle(
  //                 color: Colors.black,
  //                  fontWeight: FontWeight.normal,
  //                  fontSize: fontSize,
  //              ),
  //         ),
  //       ),
  //       SizedBox(height: 10),
  //       Container(
  //         height: 64,
  //         width: screenWidth! -10,
  //         child: TextField(
  //           style: TextStyle(
  //           fontSize: fontSize,
  //              backgroundColor: Colors.white,
  //             fontWeight: FontWeight.bold,
  //              color: Colors.black87,
  //            ),
  //           obscuringCharacter: '*',
  //           controller: _passwordController,
  //           obscureText: _passwordVisible,
  //
  //           decoration: InputDecoration(
  //            // labelText: 'Password',
  //             hintText: 'Enter your password',
  //             hintStyle: TextStyle(
  //               color: Colors.black87,
  //               backgroundColor: Colors.white,
  //               fontWeight: FontWeight.normal,
  //               fontSize: fontSize
  //             ),
  //             // Here is key idea
  //             fillColor: Colors.white,
  //             border: OutlineInputBorder(
  //             borderSide: BorderSide.none,
  //             borderRadius: BorderRadius.circular(14)
  //             ),
  //             suffixIcon: IconButton(
  //               icon: Icon(
  //                 // Based on passwordVisible state choose the icon
  //                 !_passwordVisible
  //                     ? Icons.visibility
  //                     : Icons.visibility_off,
  //                 color: Theme.of(context).primaryColorDark,
  //               ),
  //               onPressed: () {
  //                 // Update the state i.e. toogle the state of passwordVisible variable
  //                 setState(() {
  //                   _passwordVisible = !_passwordVisible;
  //                 });
  //               },
  //             ),
  //           ),
  //
  //         ),
  //       ),
  Widget _password(BuildContext context, double fontSize) {
    return showLogOutButton == true
        ? Container()
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password',
                style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                  color: color2,
                  fontWeight: FontWeight.normal,
                  fontSize: fontSize,
                )),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 64,
                child: TextField(
                  autofocus: true,
                  enabled: true,
                  focusNode: myPasswordFocusNode,
                  keyboardType: TextInputType.text,
                  // onChanged: (value) {
                  //   _passwordController.text += value;
                  //   flagHasPassword = true;
                  // },
                  onSubmitted: (value) {
                    setState(() {
                      _passwordController.text = value;
                      flagHasPassword = true;
                    });
                  },
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  controller: _passwordController,
                  obscuringCharacter: '•',
                  obscureText: _passwordVisible,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Color(0xff6A6A6A),
                      fontWeight: FontWeight.normal,
                      fontSize: fontSize,
                    ),
                    fillColor: const Color(0xffF7F7F9),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(14)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        !_passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              //   Container(
              //   height: 64,
              //   child: TextField(
              //     style: TextStyle(
              //       fontSize: fontSize,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.black87,
              //       backgroundColor: Colors.white,
              //     ),
              //     controller: _passwordController,
              //     obscuringCharacter: '•',
              //     obscureText: _passwordVisible,
              //
              //     decoration: InputDecoration(
              //       labelText: 'Password',
              //       labelStyle: TextStyle(
              //         color: Color(0xff6A6A6A),
              //         fontWeight: FontWeight.normal,
              //         fontSize: fontSize,
              //       ),
              //       hintText: 'Enter your password',
              //       hintStyle: TextStyle(
              //         color: Color(0xff6A6A6A),
              //         fontWeight: FontWeight.normal,
              //         fontSize: fontSize,
              //       ),
              //       // Here is key idea
              //       fillColor: Colors.white,
              //       suffixIcon: IconButton(
              //         icon: Icon(
              //           // Based on passwordVisible state choose the icon
              //           !_passwordVisible
              //               ? Icons.visibility
              //               : Icons.visibility_off,
              //           color: Theme.of(context).primaryColorDark,
              //         ),
              //         onPressed: () {
              //           // Update the state i.e. toogle the state of passwordVisible variable
              //           setState(() {
              //             _passwordVisible = !_passwordVisible;
              //           });
              //         },
              //       ),
              //     ),
              //
              //   ),
              // ),
              SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    onTap: () async {
                      if (await _getLoginCount() == 0) {
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword(
                                  fontSize: fontSize,
                                  email: _emailController.text)));
                    },
                    child: Text('Forgot Password?',
                        style: TextStyle(
                            backgroundColor: Colors.blue[100],
                            color: color2,
                            fontSize: fontSize))),
              ),
            ],
          );
  }

  Widget _signin(BuildContext context, double fontSize) {
    try {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[100], // const Color(0xff0D6EFD),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: color2),
            ),
            minimumSize: const Size(double.infinity, 60),
            elevation: 0,
          ),
          onPressed: () async {
            try {
              debugPrint('line 621: $flagHasEmail $flagHasPassword');
              if (flagHasEmail == false || flagHasPassword == false) {
                AlertDialog alert = AlertDialog(
                  backgroundColor: Colors.yellowAccent,
                  title: Text('SignIn Error'),
                  content: Text(
                    'You must (1)  enter your email; and (2) enter your password to sign in',
                    style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                );
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    });
              } else {
                await authService!.signin(
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context);
              }
            } catch (e) {
              AlertDialog alert = AlertDialog(
                backgroundColor: Colors.yellowAccent,
                title: Text('Error on signing in',
                    style: TextStyle(
                      fontSize: fontSize,
                    )),
                content: Text(
                  '${e.toString()} - Try again! USE THE "ESC" KEY TO CLOSE DIALOG.',
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              );
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  });
              Future.delayed(Duration(seconds: 3));
              return;
            }
          },
          child: Text("Sign In",
              style: TextStyle(
                fontSize: 22 / h!,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.blue[100],
                color: color2,
              )));
      // ElevatedButton(
      // style: ElevatedButton.styleFrom(
      // backgroundColor:  color1, // const Color(0xff0D6EFD),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(14),
      //   ),
      //   minimumSize: const Size(double.infinity, 60),
      //   elevation: 0,
      // ),
      //     onPressed: ( ) {
      //     _signOut();
      //     },
      //     child: const Text("Log Out",
      //     style: TextStyle(
      //     fontSize: 18,
      //     fontWeight: FontWeight.bold,
      //     color: Colors.white
      //     )
      //     )
      //     );
    } catch (e) {
      debugPrint('line 217 $e');
      return Container();
    }
  }

// Widget _signup(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 16),
//     child: RichText(
//         textAlign: TextAlign.center,
//         text: TextSpan(
//             children: [
//               const TextSpan(
//                 text: "New User? ",
//                 style: TextStyle(
//                     color: Color(0xff6A6A6A),
//                     fontWeight: FontWeight.normal,
//                     fontSize: 16
//                 ),
//               ),
//               TextSpan(
//                   text: "Create Account",
//                   style: const TextStyle(
//                       color: Color(0xff1A1D1E),
//                       fontWeight: FontWeight.normal,
//                       fontSize: 16
//                   ),
//                   recognizer: TapGestureRecognizer()..onTap = () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => Signup()
//                       ),
//                     );
//                   }
//               ),
//             ]
//         )
//     ),
//   );
//
// }
}
