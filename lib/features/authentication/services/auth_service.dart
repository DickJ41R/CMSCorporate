//import 'dart:convert';

import 'package:cms_web/features/branchcorporateapp/services/cms_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:cms_web/features/branchcorporateapp/models/cms_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/authentication/views/pages/login/login.dart';
import 'dart:core';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/services/routes.dart';
import 'package:cms_web/features/branchcorporateapp/models/cms_branch_users.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cms_web/features/shared/utils/encdec.dart';
import 'package:cms_web/features/clientapp/models/client.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cms_web/features/clientapp/views/client_menu.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
// Private constructor to prevent external instantiation.

//import 'package:cms_web/apps/client/screens/process_hcp_menu_tester.dart';
class AuthService {
  static AuthService? _instance;

  AuthService._();

  factory AuthService() => _instance ??= AuthService._();

  // Private constructor to prevent external instantiation.

  final _auth = FirebaseAuth.instance;
  String? fcmToken;
  Map<String, dynamic>? client;
  int? hcpId;
  dynamic currentUser;
  dynamic clientUser;
  Map<String, dynamic>? hcpMap;
  Map<String, dynamic>? clientMap;
  Map<String, dynamic>? workOrderMap;
  Map<String, dynamic>? clientUserMap;
  Map<String, dynamic>? currentHCPMap;
  dynamic currentCredentialUser;
  List<Map<String, dynamic>>? listOfCMSUserBranches;
  List<Map<String, dynamic>>? listClientUserMap;
  String? targetType;
  String? gpoClient;
  String? userDocumentId;
  int? loginCounter;
  String? corporateOrBranch;
  int? clientId;
  int? clientUserId;
  CMSBranchUser? cmsBranchUser;
  Map<String, dynamic>? cmsBranchUserMap;
  CMSUser? cmsUser;
  Map<String, dynamic>? cmsUserMap;
  int? cmsUserId;
  bool? flagIsTester;
  bool? flagIsCorporate;
  bool? flagIsBranch;
  List<String>? roles;
  bool? isIOS;
  bool? isAndroid;
  bool? isMacos;
  bool? isWindows;
  bool? isWeb;
  int? branchId;
  bool? flagIsHCP;
  bool? flagIsCMS;
  bool? flagIsClient;
  String? apns;
  int? cmsBranchUserId;
  String? branchName;
  UserCredential? userCredential;
  String? clientStartDay;
  int? startWeekDayNumber;
  String? fcmTokenString;
  double? screenRatio;
  Map<String, dynamic>? hcpUserMap;
  Map<String, dynamic>? hcProfessional;
  List<Map<String, dynamic>>? clientFCMToken;
  List<Map<String, dynamic>>? testerFCMToken;

  UtilitiesServices utilityServices = UtilitiesServices();

  void setFCMToken(String FCMToken, bool isClientApp, bool isIOS,
      bool isAndroid, bool isMacos, bool isWindows, bool isWeb) {
    print('line 58 in setfcmtoken');
    this.isIOS = isIOS;
    this.isAndroid = isAndroid;
    this.isMacos = isMacos;
    this.isWindows = isWindows;
    this.fcmToken = FCMToken;
    this.fcmTokenString = FCMToken;
    this.isWeb = isWeb;
  }

  Future<void> sendEmailVerificationLink() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signup(Map<String, dynamic> mp, BuildContext context) async {
    print('line 113: ${mp['email']} ${mp['password']}');
    try {
      String email = mp['email'].toLowerCase();
      String password = mp['password'];
      print('line 117 cms_auth: $email $password ');
      Map<String,dynamic> oId = {};
      Map<String, dynamic>? npm;
      var errorCode;
      var errorMessage;
      String documentId = '';
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((snapshot) {
        print('line 124 auth service: $snapshot');
        userCredential = snapshot;
        currentCredentialUser = userCredential!.user;
        print('line 127 $currentCredentialUser');
      }).catchError((error) {
        errorCode = error.code;
        errorMessage = error.message;
        // Handle errors here
        switch (errorCode) {
          case 'auth/invalid-email':
            print('Invalid email format.');
            break;
          case 'auth/user-not-found':
            print('No user found with this email.');
            break;
          case 'auth/wrong-password':
            print('Incorrect password.');
            break;
          default:
            print('An error occurred during login:  $errorMessage');
        }
      });
      print('line 146');
      if (errorCode != null) {
        print('line 150 error: $errorMessage');
        throw Exception(errorMessage);
      }
      await Future.delayed(const Duration(seconds: 1));
      print('line 154: ${currentCredentialUser}');
      documentId = currentCredentialUser!['id'];

        if (currentCredentialUser!.displayName == 'CMSUser') {
          //   print('line 227');
          //   oId['message'] = '10. You are not authorized to use this app.';
          //   return oId;
          // }
          // documentId = usr.uid;
          print('line 225: $currentCredentialUser ');
          // await Future.delayed(const Duration(seconds: 1)
          print('line 202 $email');

          await FirebaseFirestore.instance
              .collection('CMSUser')
              .doc(documentId)
              .get()
              .then((querySnapshot) async {
            print('line 208 ${querySnapshot.data()}');
            final docSnapshot = querySnapshot.data();
            userDocumentId = querySnapshot.id;

            if (docSnapshot == null) {
              print('line 242');
              oId['success'] = false;
              oId['message'] = 'Invalid find for a user.';
              return oId;
            }
            if (docSnapshot['userType'] != 'CNSUser') {
              print('line 346');
              await FirebaseAuth.instance.signOut();
              oId['success'] = false;
              oId['documentId'] = null;
              oId['message'] =
              'Invalid user type. User must be a Client User';
              return oId;
            }
            currentUser = docSnapshot;
            if (currentUser == null) {
              throw Exception('line 144 No current user found');
            }
          });
        } else {
          print('line 189: $currentCredentialUser ');
          oId['documentId'] = documentId;
          // await Future.delayed(const Duration(seconds: 1)
          print('line 202 $email');
          await FirebaseFirestore.instance
              .collection('CMSBranchUser')
              .doc(documentId)
              .get()
              .then((querySnapshot) async {
            print('line 208 ${querySnapshot.data()}');
            final docSnapshot = querySnapshot.data();
            userDocumentId = querySnapshot.id;

            if (docSnapshot == null) {
              print('line 242');
              oId['success'] = false;
              oId['message'] = 'Invalid find for a user.';
              return oId;
            }
            if (docSnapshot['userType'] != 'CNSUser') {
              print('line 346');
              await FirebaseAuth.instance.signOut();
              oId['success'] = false;
              oId['documentId'] = null;
              oId['message'] = 'Invalid user type. User must be a Client User';
              return oId;
            }
            currentUser = docSnapshot;
            if (currentUser == null) {
              throw Exception('line 144 No current user found');
            }
          });
        }
      print('line 146: $currentUser ${mp['email']}');

      final navigator = Navigator.of(context)
          .pushNamed(AutofillHints.language, arguments: null);
    } catch (e) {
      String message = '';
      print('line 168 $message');
    }
  }

  T? tryCast<T>(dynamic value, {T? fallback}) {
    print('line 119: $value');
    try {
      return (value as T);
    } on TypeError catch (_) {
      return fallback;
    }
  }

  Map<String, dynamic> _loadDeviceInfos() {
    //   FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    //   WidgetsBinding.instance.platformDispatcher.textScaleFactor;
    //   double dv = view.physicalSize.width / view.physicalSize.height;
    String aspectRatio = "16:9";
    String device = 'desktop';
    //   print('line 323 in loadevices: $dv');
    print('line 326: $screenRatio');
    double dv = screenRatio!;
    if (1.78 >= dv - .10 && 1.78 <= dv + .10) {
      aspectRatio = "16:9";
      device = "desktop";
    } else if (.46 >= dv - .10 && .46 <= dv + 10) {
      aspectRatio = "9:16";
      device = "phone";
    } else if (1.33 >= dv - .10 && 1.33 <= dv + .10) {
      aspectRatio = "4:3";
      device = "tablet";
    } else if (.75 >= dv - .10 && .75 <= dv + .10) {
      aspectRatio = "3:4";
      device = "phone";
    }
    Map<String, dynamic> mp = {"aspectRatio": aspectRatio, "device": device};
    //     "_screenWidth": view.physicalSize.width,
    //     "_screenHeight": view.physicalSize.height,
    //     "_statusBarHeight": view.padding.top,
    //     "_bottomBarHeight" : view.padding.bottom,
    //     "_aspectRatio": aspectRatio,
    //     "_device": device
    //   };
    return mp;
  }

  Future<bool> storeUserInformation(
      String email, String password, String app) async {
    EncryptionService ens = EncryptionService();
    try {
      print('line 381 in storeuserinfo $fcmToken');
      Timestamp ts = Timestamp.fromDate(DateTime.now());
      var kw = dotenv.env['USERINFORMATION_KEY']!;
      ens.init(kw);
      String encd = ens.encryptData(password);
      String? documentId;
      await FirebaseFirestore.instance
          .collection('UserInformation')
          .where('fcmToken', isEqualTo: fcmToken)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          documentId = docSnapshot.id;
        }
      });
      if (documentId == null) {
        await FirebaseFirestore.instance
            .collection('UserInformation')
            .doc()
            .set({
          "dateEntered": ts,
          "email": email,
          "fcmToken": fcmToken,
          "userWord": encd,
          "app": app
        });
      }
      return true;
    } catch (e) {
      print('line 397 error: ${e.toString()}');
      return false;
    }
  }

  Future<int> getCMSBranchUserLoginCount(String email) async {
    print('line 331 getlogincount: $email');
    int lgc = 0;
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        final obj = docSnapshot.data();
        lgc = obj['loginCounter'] > 0 ? obj['loginCounter'] : 0;
      }
      return lgc;
    });
    return lgc;
  }

  Future<void> signin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    bool flagInitialTest = false;
    bool flagHaveUserInformation = false;
    bool flagIsAuthenticated = false;
    Map<String, dynamic>? fcmMap;
    print('line 346: $email $password');
    try {
      email = email.toLowerCase();
      print('line 349: $email $password');
      Map<String, dynamic>? npm;
      Map<String, dynamic>? fcmMap = null;
      List<Map<String, dynamic>> listFCMTokens = [];
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((snapshot) {
        print('line 356: $snapshot');
        userCredential = snapshot;
        currentCredentialUser = userCredential!.user;
      }).catchError((error) {
        var errorCode = error.code;
        var errorMessage = error.message;
        // Handle errors here
        switch (errorCode) {
          case 'auth/invalid-email':
            print('Invalid email format.');
            break;
          case 'auth/user-not-found':
            print('No user found with this email.');
            break;
          case 'auth/wrong-password':
            print('Incorrect password.');
            break;
          default:
            print('An error occurred during login:  $errorMessage');
        }
        print('line 376: in singin $errorMessage');
        throw Exception(errorMessage);
      });
      await Future.delayed(const Duration(seconds: 1));
      print('line 380  $email');
      Map<String, dynamic>? obj;
      print('line 382: ${currentCredentialUser.displayName}');
      if (currentCredentialUser == null) {
        print('line 383 null currentCredentialUser');
        throw Exception('No User found with the entered email.');
      }
      if (currentCredentialUser.displayName == 'BranchUser') {
        await FirebaseFirestore.instance
            .collection('CMSBranchUser')
            .where('email', isEqualTo: email)
            .get()
            .then((querySnapshot) async {
          for (var docSnapshot in querySnapshot.docs) {
            userDocumentId = docSnapshot.id;

            obj = docSnapshot.data();
            print('line 396 checking _authservice $obj');
            cmsBranchUserId = obj!['genId'];
            cmsBranchUserMap = obj;
            bool flagIsCorporate = false;
            flagIsAuthenticated = true;
            List<Map<String, dynamic>> listBranches = [];
            for (int i = 0; i < obj!['branchIds'].length; i++) {
              Map<String, dynamic> ob = {
                'branchId': obj!['branchIds'][i],
                'branchName': obj!['branchNames'][i]
              };
              listBranches.add(ob);
            }
            listOfCMSUserBranches = listBranches;
            if (obj!['Roles'] != null) {
              obj!['roles'] = obj!['Roles'];
            }
          }

        });
        Timestamp ts = Timestamp.fromDate(DateTime.now());
        await FirebaseFirestore.instance
            .collection('CMSBranchUser')
            .doc(userDocumentId)
            .update({
          "loginCounter": FieldValue.increment(1),
          "dateOfLastLogin": ts
        });
      } else {
        await FirebaseFirestore.instance
            .collection('CMSUser')
            .where('email', isEqualTo: email)
            .get()
            .then((querySnapshot) async {
          for (var docSnapshot in querySnapshot.docs) {
            userDocumentId = docSnapshot.id;

            obj = docSnapshot.data();
            print('line 413 checking _authservice $obj');
            cmsUserId = obj!['genId'];
            cmsUserMap = obj;
            bool flagIsCorporate = false;
            flagIsAuthenticated = true;
          }
          List<Map<String, dynamic>> listBranches = [];
          for (int i = 0; i < obj!['branchIds'].length; i++) {
            Map<String, dynamic> ob = {
              'branchId': obj!['branchIds'][i],
              'branchName': obj!['branchNames'][i]
            };
            listBranches.add(ob);
          }
          listOfCMSUserBranches = listBranches;
          if (obj!['Roles'] != null) {
            obj!['roles'] = obj!['Roles'];
          }
          print('line 363 ${obj!['roles']} ${obj!['Roles']}');
          flagIsCorporate = false;
          String npx = obj!['roles'][0];
          if (npx.indexOf('CORPORATE') != -1) {
            flagIsCorporate = true;
            corporateOrBranch = "Corporate";
            flagIsBranch = false;
          } else {
            flagIsCorporate = false;
            flagIsBranch = true;
            corporateOrBranch = "Branch";
          }

        });
        Timestamp ts = Timestamp.fromDate(DateTime.now());
        await FirebaseFirestore.instance
            .collection('CMSUser')
            .doc(userDocumentId)
            .update({
          "loginCounter": FieldValue.increment(1),
          "dateOfLastLogin": ts
        });
        print('line 363 ${obj!['roles']} ${obj!['Roles']}');


      }
      // List<Map<String, dynamic>> listOfUserBranches = [
      //   {'branchId': 0, 'branchName': 'CMS CORPORATE'},
      //   {'branchId': 615, 'branchName': 'RALEIGH CMS 101'},
      //   {'branchId': 624, 'branchName': 'COLUMBIA CMS 105'},
      //   {'branchId': 631, 'branchName': 'NASHVILLE CMS 106'},
      //   {'branchId': 632, 'branchName': 'MEMPHIS CMS 107'},
      //   {'branchId': 634, 'branchName': 'AUGUSTA-GREENVILLE CMS 110'},
      //   {'branchId': 635, 'branchName': 'FLORENCE CMS 111'},
      //   {'branchId': 638, 'branchName': 'KNOXVILLE-TRI-CITIES CMS 114'},
      //   {'branchId': 640, 'branchName': 'CHATTANOOGA CMS 116'},
      //   {'branchId': 641, 'branchName': 'LEXINGTON CMS 117'}
      // ];
      // print('line 334 ${listOfUserBranches.length}');
      // if (obj!['branchIds'][0] == 0) {
      //   if (obj!['branchNames'] == null) {
      //     obj!['branchNames'] = [];
      //     obj!['branchNames'].add('CMS CORPORATE');
      //   }

      print('line  534 $fcmToken $email $flagIsAuthenticated');

      // if (fcmToken != null && fcmToken != 'PlaceHolder') {

      Navigator.of(context).pushNamed(landingPageWeb);
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }
      print('line 549 $message');
      throw Exception('Unable to process user');
    } catch (e) {
      print('line 552 error $e');
      String err = e.toString();
      int idx = err.indexOf('Exception:');
      if (idx != -1) {
        if (idx == 0) {
          err = err.substring(10);
        } else {
          err = err.substring(0, idx - 1) + err.substring(idx + 11);
        }
      }
      throw Exception(err);
    }
  }

//   Future<void>changePasswords({
//   required String email,
//   required String password,
//   required BuildContext context
// }) async {
//
// try {
//    FirebaseAuth.instance.sendPasswordResetEmail(auth, email)
//       .then(() => {
//     // Password reset email sent!
//     // ..
//   })
//     .catch((error) => {
//     const errorCode = error.code;
//     const errorMessage = error.message;
//     // ..
//     });
// await Future.delayed(const Duration(seconds: 1));
// Navigator.pushReplacement(
// context,
// MaterialPageRoute(
// builder: (BuildContext context) => const Home()
// )
// );
//
// } on FirebaseAuthException catch(e) {
// String message = '';
// if (e.code == 'invalid-email') {
// message = 'No user found for that email.';
// } else if (e.code == 'invalid-credential') {
// message = 'Wrong password provided for that user.';
// }
//
// }
// catch(e){
//
// }
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signout({required BuildContext context}) async {
    flagIsTester = false;
    flagIsHCP = false;
    flagIsCMS = false;
    flagIsClient = false;
    isIOS = false;
    isAndroid = false;
    isMacos = false;
    isWindows = false;

    apns = null;

    await FirebaseAuth.instance.signOut();
    userCredential = null;
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Login(
                  flagGetAPNS: false,
                )));
  }

  Future<Map<String, dynamic>>? cmsBranchUserFindByEmail(String email) async {
    Map<String, dynamic>? mpp;
    await FirebaseFirestore.instance
        .collection('CMSBranchUser')
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        userDocumentId = docSnapshot.id;

        final obj = docSnapshot.data();
        obj['id'] = userDocumentId;
        mpp = obj;
        break;
      }
    });
    return mpp!;
  }

  // Future<Map<String, dynamic>>? clientUserFind(String email) async {
  //   Map<String, dynamic>? mpp;
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('email', isEqualTo: email)
  //       .get()
  //       .then((querySnapshot) {
  //     for (var docSnapshot in querySnapshot.docs) {
  //       userDocumentId = docSnapshot.id;
  //
  //       final obj = docSnapshot.data();
  //       obj['id'] = userDocumentId;
  //       mpp = obj;
  //       break;
  //     }
  //   });
  //   return mpp!;
  // }

  Future<Map<String, dynamic>>? cmsBranchUserFindById(int cmsId) async {
    Map<String, dynamic>? mpp;
    await FirebaseFirestore.instance
        .collection('CMSBranchUser')
        .where('cmsId', isEqualTo: cmsId)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        userDocumentId = docSnapshot.id;

        final obj = docSnapshot.data();
        obj['id'] = userDocumentId;
        mpp = obj;
        break;
      }
    });
    return mpp!;
  }

  // Future<void> callingFunction(HttpsCallable callable, BuildContext context,
  //     String title, String message, String clientToken, String hcpToken) async {
  //   try {
  //     print('line 354 in callingFunction: $title $message $hcpToken');
  //     var data = {'title': title, 'message': message, 'hcpToken': hcpToken};
  //     final result = await callable(data);
  //     print('line 355: ${result.data}');
  //   } catch (e) {
  //     print('line 356 error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('ERROR: $e'),
  //       ),
  //     );
  //   }
  // }

  Future<Map<String, dynamic>>? CMSBranchUserFind(String email) async {
    Map<String, dynamic>? mpp;
    String? userDocumentId;
    await FirebaseFirestore.instance
        .collection('CMSBranchUser')
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        userDocumentId = docSnapshot.id;

        final obj = docSnapshot.data();
        obj['id'] = userDocumentId;
        mpp = obj;
        break;
      }
    });
    return mpp!;
  }
}
