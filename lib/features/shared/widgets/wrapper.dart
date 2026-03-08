import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cms_web/features/authentication/views/pages/login/login.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

//Stream<User?> authStateChanges();

class Wrapper extends StatelessWidget {
  final Map<String, dynamic> args;
  const Wrapper({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error on stream'));
              } else {
                if (snapshot.data == null) {
                  return Login(
                    flagGetAPNS: false,
                  );
                } else {
                  final navigator = Navigator.of(context)
                      .pushNamed(landingPageWeb, arguments: this.args);
                }
              }
              return Container();
            }));
  }
}
