import 'package:flutter/material.dart';
//import 'package:cms_web/services/client_services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';

class ForgotPassword extends StatefulWidget {
  final double fontSize;
  final String email;

  const ForgotPassword(
      {super.key, required this.fontSize, required this.email});

  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
//  final _auth = AuthService();
  late double fontSize;
  late String email;

  final TextEditingController _email = TextEditingController();
  AuthService _authServices = AuthService();
  @override
  void initState() {
    super.initState();
    fontSize = widget.fontSize;
    email = widget.email;
    _email.text = email;
  }

  @override
  Widget build(BuildContext context) {
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'CMS/Branch Login',
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        Theme.of(context).textTheme.headlineMedium!.fontSize! /
                            h!,
                  )),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("The address to send the reset information!",
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(fontSize: fontSize),
                          controller: _email,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Enter Email',
                            hintStyle: TextStyle(
                                color: Colors.black, //Color(0xff6A6A6A),
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize),
                            label: Text('Email'),
                            labelStyle: TextStyle(
                                color: Colors.black, // Color(0xff6A6A6A),
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize),
                          ),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              onTap: () async {
                                await _authServices
                                    .sendPasswordResetLink(_email.text);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'An email for password reset has been sent to the email address you provided.',
                                        style: TextStyle(fontSize: fontSize))));
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Send Email',
                                style: TextStyle(
                                    color: Colors.black87,
                                    backgroundColor: Colors.lightBlue,
                                    fontWeight: FontWeight.normal,
                                    fontSize: fontSize),
                              )),
                        ),
                        // CustomButton(label: "Send Email",
                        // onPressed: () async {
                        //   await _auth.sendPasswordResetLink(_email.text);
                        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An email for password reset has been sent to the email address you provided.',
                        //   style: TextStyle(
                        //     fontSize: fontSize
                        //   ))));
                        //   Navigator.pop(context);
                        // },
                        //  ),
                      ])),
            ],
          ),
        ),
      ),
    );
  }
}
