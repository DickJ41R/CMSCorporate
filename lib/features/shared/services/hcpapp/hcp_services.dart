import "package:cloud_firestore/cloud_firestore.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:cms_web/features/hcpapp/models/hcprofessional_data_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class HCPServices {
  HCPServices();

  UtilitiesServices util = UtilitiesServices();
  AuthService authServices = AuthService();

  Future<List<Map<String, dynamic>>>? getHCPAddresses(int hcpId) async {
    try {
      List<Map<String, dynamic>> hcpAddresses = [];
      print('line 22 get address: $hcpId');
      await FirebaseFirestore.instance
          .collection("HCPAddress")
          .where('hcpId', isEqualTo: hcpId)
          .get()
          .then((querySnapshot) {
        hcpAddresses = [];
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          hcpAddresses!.add(obj);
        }
      });
      print('line 34: ${hcpAddresses.length}');
      return hcpAddresses;
    } catch (e) {
      print('line 53 error getting hcpuser: $e');
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>>? getSingleUser(int hcpId) async {
    Map<String, dynamic> lm = {};
    await FirebaseFirestore.instance
        .collection('users')
        .where('genId', isEqualTo: hcpId)
        .get()
        .then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        lm = docSnapshot.data();
        break;
      }
    });
    return lm;
  }

  Future<List<Map<String, dynamic>>>? getHCPContacts(int hcpId) async {
    try {
      List<Map<String, dynamic>>? hcpContacts = [];

      await FirebaseFirestore.instance
          .collection("HCPContact")
          .where('hcpId', isEqualTo: hcpId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          hcpContacts.add(obj);
        }
      });
      return hcpContacts;
    } catch (e) {
      print('line 53 error getting hcpuser: $e');
      throw Exception(e);
    }
  }

  Future<List<Map<String, dynamic>>>? getHCPEducation(int hcpId) async {
    try {
      List<Map<String, dynamic>>? hcpEducation = [];

      await FirebaseFirestore.instance
          .collection("HCPEducation")
          .where('hcpId', isEqualTo: hcpId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          hcpEducation.add(obj);
        }
      });
      return hcpEducation;
    } catch (e) {
      print('line 53 error getting hcpuser: $e');
      throw Exception(e);
    }
  }

  Future<List<Map<String, dynamic>>>? getHCPCredentials(int hcpId) async {
    print('line 9 get all hcps');
    //  return realm.all<ClientWorkOrderCampaign>();
    List<Map<String, dynamic>> listOfHCPCredentials = [];
    await FirebaseFirestore.instance
        .collection('HCPCredential')
        .where('hcpId', isEqualTo: hcpId)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        String id = docSnapshot.id;
        if (id.indexOf('-') != -1) {
          continue;
        }
        final obj = docSnapshot.data();

        listOfHCPCredentials.add(obj);
      }
    });
    return listOfHCPCredentials;
  }

  Future<List<Map<String, dynamic>>>? getHCPDNUs(int hcpId) async {
    print('line 9 get all hcps');
    //  return realm.all<ClientWorkOrderCampaign>();
    List<Map<String, dynamic>> listOfHCPDNUs = [];
    List<int> clientIds = [];
    await FirebaseFirestore.instance
        .collection('ClientDNU')
        .where('hcpId', isEqualTo: hcpId)
        .get()
        .then((snapshot) {
      for (var docSnapshot in snapshot.docs) {
        final obj = docSnapshot.data();
        int clientId = obj['clientId'];
        if (clientIds.indexOf(clientId) != -1) {
          continue;
        }
        clientIds.add(clientId);
        listOfHCPDNUs.add(obj);
      }
    });
    List<Map<String, dynamic>>? listOfClientsFromDNUs =
        await getClientsFromDNUs(clientIds);
    for (int i = 0; i < listOfHCPDNUs.length; i++) {
      var obj = listOfHCPDNUs[i];
      for (int j = 0; j < listOfClientsFromDNUs!.length; j++) {
        var rbj = listOfClientsFromDNUs[j];
        if (obj['clientId'] == rbj['clientId']) {
          obj['clientName'] - rbj['clientName'];
          break;
        }
      }
    }
    return listOfHCPDNUs;
  }

  Future<List<Map<String, dynamic>>>? getClientsFromDNUs(
      List<int> clientIds) async {
    print('line 9 get all hcps');
    //  return realm.all<ClientWorkOrderCampaign>()
    List<int> clientIds = [];
    List<Map<String, dynamic>> listOfClientsFromDNUs = [];
    await FirebaseFirestore.instance
        .collection('ClientDNU')
        .where('client', whereIn: clientIds)
        .get()
        .then((snapshot) {
      for (var docSnapshot in snapshot.docs) {
        final obj = docSnapshot.data();
        listOfClientsFromDNUs.add(obj);
      }
    });

    return listOfClientsFromDNUs;
  }

  Future<Map<String, dynamic>>? getSingleTestFromClientUsers(int hcpId) async {
    print('line 134 get all singletestclientuser: $hcpId');
    //  return realm.all<ClientWorkOrderCampaign>();
    Map<String, dynamic>? mph;
    await FirebaseFirestore.instance
        .collection('ClientUser')
        .where("cmsId", isEqualTo: hcpId)
        .get()
        .then((snapshot) {
      for (var docSnapshot in snapshot.docs) {
        mph = docSnapshot.data();
      }
    });
    return mph!;
  }

  Future<Map<String, dynamic>>? getSingleClientByBranchId(int branchId) async {
    print('line 148 get single clientbybranchid: $branchId');
    //  return realm.all<ClientWorkOrderCampaign>();
    Map<String, dynamic>? mph;
    await FirebaseFirestore.instance
        .collection('Client')
        .where("branchId", isEqualTo: branchId)
        .get()
        .then((snapshot) {
      for (var docSnapshot in snapshot.docs) {
        mph = docSnapshot.data();
      }
    });
    return mph!;
  }

  Future<List<Map<String, dynamic>>>? getBranchesFromBranchIds(
      List<int> branchIds) async {
    print('line 163 get branches from breancid: $branchIds');
    //  return realm.all<ClientWorkOrderCampaign>();
    List<Map<String, dynamic>> mph = [];
    await FirebaseFirestore.instance
        .collection('CMSBranch')
        .where("branchId", whereIn: branchIds)
        .get()
        .then((snapshot) {
      for (var docSnapshot in snapshot.docs) {
        mph.add(docSnapshot.data());
      }
    });
    return mph;
  }

  Future<List<Map<String, dynamic>>>? getAllHCPProfessionals() async {
    print('line 9 get all hcps');
    //  return realm.all<ClientWorkOrderCampaign>();
    List<Map<String, dynamic>> listOfHCPs = [];
    await FirebaseFirestore.instance
        .collection('HCProfessional')
        .get()
        .then((snapshot) {
      for (var docSnapshot in snapshot.docs) {
        final obj = docSnapshot.data();
        listOfHCPs.add(obj);
      }
    });
    return listOfHCPs;
  }

  Future<Map<String, dynamic>>? getSingleHCProfessional(int hcpId) async {
    print('line 9 get all hcps: $hcpId');
    //  return realm.all<ClientWorkOrderCampaign>();
    Map<String, dynamic>? mph;
    await FirebaseFirestore.instance
        .collection('HCProfessional')
        .where("hcpId", isEqualTo: hcpId)
        .get()
        .then((snapshot) {
      for (var docSnapshot in snapshot.docs) {
        mph = docSnapshot.data();
      }
    });
    return mph!;
  }

  Future<List<Map<String, dynamic>>>? getHCPProfessionalByBranchId(
      int branchId) async {
    print('line 9 get all hcps: $branchId');
    try {
      //  return realm.all<ClientWorkOrderCampaign>();
      List<Map<String, dynamic>> mph = [];
      await FirebaseFirestore.instance
          .collection('HCProfessional')
          .where("branchId", isEqualTo: branchId)
          .get()
          .then((snapshot) {
        for (var docSnapshot in snapshot.docs) {
          mph.add(docSnapshot.data());
        }
      });
      return mph;
    } catch (e) {
      print('line 217 error: $e');
      throw Exception(e.toString());
    }
  }

  // Future<List<HCProfessionalDataModel>> getHCPDataFromSearchCNA(
  //     String hcpRecordName) async {
  //   print('line 309: $hcpRecordName');
  //   await FirebaseFirestore.instance
  //       .collection('HCProfessional')
  //       .where("branchId", isEqualTo: 624)
  //       .where("disciplineId", isEqualTo: 558)
  //       .get()
  //       .then((querySnapshot) {
  //     print('line 324: ${querySnapshot.docs.length}');
  //     for (var docSnapshot in querySnapshot.docs) {
  //       final obj = docSnapshot.data();
  //       print('line 327: ${obj['hcpId']} ${obj['fullName']}');
  //     }
  //   });
  //   return [];
  // }

  Timestamp convertToTimeStamp(String dts) {
    Timestamp? ts;
    try {
      dts = dts.replaceAll('\/', '-');
      List<String> sts = dts.split('-');
      if (sts[2].length != 4) {
        throw Exception('Invalid date: year not 4 digits');
      }
      if (sts[0].length == 1) {
        String st = '0' + sts[0];
        sts[0] = st;
      }
      if (sts[1].length == 1) {
        String st = '0' + sts[1];
        sts[1] = st;
      }

      String dtm = sts[2] + '-' + sts[0] + '-' + sts[1];
      DateTime dte = DateTime.parse(dtm);
      ts = Timestamp.fromDate(dte);
      print('line 341: $ts $dte');
      return ts;
    } catch (e) {
      print('line 345: error: ${e.toString()}');
      throw Exception('Error: ${e.toString()}');
    }
  }

  List<int> getHoursAndMinutes(String et) {
    String char = String.fromCharCode(8239);
    et = et.replaceAll(char, ' ');
    List<String> sts = et.split(' ');
    String es = sts[0];
    List<String> ess = es.split(':');
    List<int> its = [];
    its.add(int.parse(ess[0]));
    its.add(int.parse(ess[1]));
    if (sts[1].toLowerCase() == 'pm') {
      its[0] += 12;
    }
    return its;
  }


  Future<List<HCProfessionalDataModel>> getHCPDataFromSearch(
      Map<String, String> arguments) async {
    print('line 379: $arguments');
    try {
      List<HCProfessionalDataModel> hcpms = [];
      Query query = util.buildDynamicQuery(arguments!);
      print('line 182: $query');
      QuerySnapshot querySnapshot = await query.get();
      for (var docSnapShot in querySnapshot.docs) {
        print('line 206: ${querySnapshot.docs.length}');
        Map<String, dynamic> obj = docSnapShot.data() as Map<String, dynamic>;
        String bn = obj['branchName'].toLowerCase();
        int hcpId = obj['hcpId'];

        HCProfessionalDataModel? htp;
        DateTime dte = DateTime.now();
        DateTime todayDate = dte;
        dte = dte.subtract(Duration(
            hours: dte.hour,
            minutes: dte.minute,
            seconds: dte.second,
            microseconds: dte.microsecond,
            milliseconds: dte.millisecond));
        Timestamp dtms = Timestamp.fromDate(dte);
        int counter = 0;
        DateTime dns = DateTime.now();
        Duration duration = dns.timeZoneOffset;
        DateTime today = dns;
        int cDay = today.day;
        int cYear = today.year;
        int cMonth = today.month;
        dns = dns.subtract(Duration(
            hours: dns.hour,
            minutes: dns.minute,
            seconds: dns.second,
            microseconds: dns.microsecond,
            milliseconds: dns.millisecond));
        //  dns = dns.subtract(Duration(days: 1));
        Timestamp dnt = Timestamp.fromDate(dns);
        List<int> sTimes = [];
        List<int> eTimes = [];
        print(
            'line 474: $dns $dnt $duration ${dns.timeZoneName} ${duration.inHours}');

        await FirebaseFirestore.instance
            .collection('ClientWorkOrderCampaign')
            .where("hcpId", isEqualTo: hcpId)
            .where('shiftStatus', whereIn: [
          'Open',
          'Accepted',
          'Approved',
          'Confirmed',
          'SignedIn',
        ])
            .where('shiftDate', isGreaterThanOrEqualTo: dns)
        //  .where('shiftStatus', whereNotIn: ['Closed', 'Canceled', 'SignedOut'])
            .orderBy("branchId", descending: false)
            .orderBy('disciplineName', descending: false)
            .orderBy('shiftStatus', descending: false)
            .orderBy("shiftDate", descending: false)
            .orderBy("shiftCode", descending: false)
            .orderBy('hcpName', descending: false)
            .get()
            .then((querySnapshot) {
          print('line 493: ${querySnapshot.docs.length}');

          for (var docSnapshot in querySnapshot.docs) {
            final obj = docSnapshot.data();

            Timestamp ts = obj['shiftDate'];
            DateTime dte = ts.toDate();

            print('line 548: ${obj['branchName']}');

            print('line 574 ${obj['shiftDate']}');
            print(
                'line 592 ${obj['hcpName']} ${obj['disciplineName']} ${obj['branchName']}');
            var shft = '';
            if (obj['shiftStatus'] == 'Open') {
              shft = 'Opn';
            } else if (obj['shiftStatus'] == 'Accepted') {
              shft = 'Acp';
            } else if (obj['shiftStatus'] == 'Approved') {
              shft = 'App';
            } else if (obj['shiftStatus'] == 'Confirmed') {
              shft = 'Cnf';
            } else if (obj['shiftStatus'] == 'SignedIn') {
              shft = 'SgI';
            } else if (obj['shiftStatus'] == 'SignedOut') {
              shft = 'SgO';
            } else {
              print(
                  'line 616 **** : ${obj['hcpId']} ${obj['shiftStatus']}');
              shft = obj['shiftStatus'].substring(0, 3);
            }
            counter += 1;
            print(
                'line 621 **** : $counter ${obj['hcpId']} ${obj['shiftStatus']}');
            htp = HCProfessionalDataModel(
                hcpId: obj['hcpId'],
                hcpName: obj['hcpName'],
                branchId: obj['branchId'],
                branchName: obj['branchName'],
                shiftDateString: dte.toString(),
                shiftStatus: shft,
                shiftCode: obj['shiftCode'],
                startTime: obj['startTime'],
                endTime: obj['endTime'],
                disciplineName: obj['disciplineName']);

            hcpms.add(htp!);
            break;
          }
        });
        break;
      }
      print('line 641: ${hcpms.length}');
      return hcpms;
    } catch (e) {
      print('line 644: ${e.toString()}');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>>? getAllHCProfessionalsFromWorkingSetData(
      int testerUserId) async {
    print('line 292 in hcpservices get hcs $testerUserId');
    try {
      Map<String, dynamic> wks = {};
      List<Map<String, dynamic>> lst = [];
      List<Map<String, dynamic>> listOfTesters = [];
      await FirebaseFirestore.instance
          .collection('TestingWorkingSet')
          .where("testerUserId", isEqualTo: testerUserId)
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          wks = obj;
          break;
        }
        print('line 306 $wks');
        if (wks.isEmpty) {
          throw Exception('line 310 WKS is empty');
        }
        List<dynamic> hcpIds = [];
        for (int i = 0; i < wks['hcpCNAs'].length; i++) {
          hcpIds.add(wks['hcpCNAs'][i]);
        }
        for (int i = 0; i < wks['hcpLPNs'].length; i++) {
          hcpIds.add(wks['hcpLPNs'][i]);
        }
        for (int i = 0; i < wks['hcpRNs'].length; i++) {
          hcpIds.add(wks['hcpRNs'][i]);
        }

        print('line 318 ${hcpIds.length}');
        List<int> lst = [];
        List<int> dupIds = [];
        await FirebaseFirestore.instance
            .collection('ClientWorkOrderCampaign')
            .where("hcpId", whereIn: hcpIds)
            .get()
            .then((querySnapshot) async {
          print('line 329:');
          for (var docSnapshot in querySnapshot.docs) {
            final obj = docSnapshot.data();
            int hcpId = obj['hcpId'];
            if (dupIds.contains(hcpId) == true) {
              continue;
            }
            lst.add(obj['hcpId']);
            dupIds.add(hcpId);
          }
          // for (int i = 0; i < lst.length; i++) {
          //   int hcpId = lst[i];
          print('line 340: ${lst.length}');
          if (lst.length > 0) {
            print('lne 341: ${lst[0]}');
          }
          if (lst.length == 0) {
            throw Exception('Line 343: List of HCPs to show is equal to 0.');
          }
          await FirebaseFirestore.instance
              .collection('HCProfessional')
              .where("hcpId", whereIn: lst)
              .get()
              .then((querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              final obj = docSnapshot.data();
              listOfTesters.add(obj);
            }
            print('line 335 ${listOfTesters.length}');
          });
          //   }
          return listOfTesters;
        });
      });
      return listOfTesters;
    } catch (e) {
      print('line 333  error $e');
      throw Exception(e.toString());
    }
  }

  Future<dynamic>? getToken() async {
    var client = http.Client();
    // const ura = 'https://api.stafferlink.com/asm/authenticate';
    var url = Uri.https('api.stafferlink.com', 'asm/authenticate');
    var orgId = dotenv.env['ASM_DB1'];
    print('url:  $url');
    Map data = {
      'key': '30c39597a9604a979e9430ee5794fab6',
      'secret': 'a594b1ede33b48e7bed9418c6fd50e43',
      'orgId': orgId
    };
    var body = json.encode(data);
    print('body: $body');
    // headers: {"Content-Type": "application/json"},
    try {
      http.Response response = await client.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: body);
      if (response.statusCode == 200) {
        String data = response.body;
        var jsonDecodedData = json.decode(data);
        print('jsonDecodedData with access token: $jsonDecodedData');
        var token = jsonDecodedData['accessToken'];
        print('Data:  $token');
        return token;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getHCPDocuments(int hcpId, int credId) async {
    var client = http.Client();
    dynamic token = await getToken();
    print('line 701 gethcpdocuments');
    // List<int> validCodes = [118, 120, 121, 123, 125, 139, 141, 146, 200, 251,
    //   289, 302, 305];

    try {
      Map<String, String>? hdrs = {
        "Accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };

      //  var encodedHeaders = json.encode(hdrs);
      print('Hdrs: $hdrs');
      // var url = Uri.https('api.stafferlink.com',
      //     'asm/Registry/28481?IncludeAddresses=true&IncludeContacts=true&IncludeCredentials=true');
      var url =
          "https://api.stafferlink.com/asm/Registry/$hcpId/Credentials/$credId/Documents";
      print('url: $url');
      http.Response response2 = await client.get(
        Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        // headers: {
        //   HttpHeaders.authorizationHeader: 'Bearer $token',
        // },
      );
      if (response2.statusCode == 200) {
        print('line 767: ${response2.body}');
        String data = response2.body;
        print('line 770: $data');
        if (data.isEmpty) {
          return null;
        }
        dynamic jsonDecodedData = json.decode(data);
        print('line 771: $jsonDecodedData, ${jsonDecodedData[0]}');
        // print(jsonDecodedData);
        dynamic jd = jsonDecodedData[0];
        dynamic docId = jd['DocumentID'];
        print('line 774: $docId');
        var url =
            "https://api.stafferlink.com/asm/Registry/$hcpId/Credentials/Documents/$docId/GetDocument";
        http.Response response = await client.get(Uri.parse(url), headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
        });
        print('line 788: ${response.headers}');
        if (response.statusCode == 200) {
          print('line 790: ${response.headers}');
          if (!response.headers['content-type']!.contains('application/pdf')) {
            // Display image
            print('line 793: ${response.bodyBytes}');
            final imageData = response.bodyBytes;
            print('line 795: ${imageData.length}');
            // File ff = await _localFile;
            //
            // ff.writeAsBytes(imageData);
            dynamic obj = {"imageData": imageData, "route": "image"};
            return obj;
          } else {
            final imageData = response.bodyBytes;
            print('line 886: ${imageData.length}');
            // File ff = await _localFile;
            //
            // ff.writeAsBytes(imageData);
            dynamic obj = {"imageData": imageData, "route": "pdf"};
            return obj;
          }
        } else {
          return null;
        }
      } else {
        return null;
      }
// Display image
    } catch (e) {
      print('line 821 $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getHCPs(int clientId,
      [DateTime? date]) async {
    print('line 981 in getHCPtimecard');
    try {
      DateTime shiftDate = DateTime.now();
      //remove next linine after getrting screens
      //change to
      DateTime newDate = DateTime(
          shiftDate.year, shiftDate.month, shiftDate.day - 2, 0, 0, 0, 0, 0);
      print('line 986 $newDate');
      List<Map<String, dynamic>> listOfHCPS = [];
      FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('clientId', isEqualTo: clientId)
          .where('shiftDate', isEqualTo: newDate)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          listOfHCPS.add(obj);
        }
      });
      print('line 991: ${listOfHCPS.length}');
      return listOfHCPS;
    } catch (e) {
      print('line 710');
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> getHCPWorkOrderCampaigns(
      int hcpId, BuildContext ctx) async {
    try {
      List<dynamic> response =
          await callRetrieveHCPWorkOrderCampaignsFunction(hcpId, ctx);
      print('line 750: ${response.length}');
      // for (int i = 0; i < response.length; i++) {
      //   var obj = response[i];
      //   print('line 753: $i $obj');
      //   print("******");
      // }
      // int x = 0;
      // if (x == 0) {
      //   throw Exception('line 753 debug exception');
      // }
      return response;
    } catch (e) {
      print('line 23: ${e.toString()}');
      return [];
    }
  }

  Future<List<dynamic>> callRetrieveHCPWorkOrderCampaignsFunction(
      int hcpId, BuildContext ctx) async {
    print('line 34: $hcpId');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'retrievehcpworkordercampaigns01',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );
      List<dynamic> result = await callingRetrieveHCPWorkOrderCampaignsFunction(
          callable, hcpId, ctx);
      print('line 44 after call: $result');
      if (result.isEmpty) {
        return result;
      }
      if (result[0]['ERROR'] != null) {
        print('line 46: Error getting htc id to asm');
        return result;
      }
      print('line 494 successfully retrieved htc');

      return result;
    } catch (e) {
      print('line 53 $e');
      throw Exception('line 54: ${e.toString()}');
    }
  }

  Future<List<dynamic>> callingRetrieveHCPWorkOrderCampaignsFunction(
      HttpsCallable callable, int hcpId, BuildContext ctx) async {
    print('line 782: $hcpId');
    try {
      var data = {
        "hcpId": hcpId,
      };
      final HttpsCallableResult result = await callable(data);
      print('line 788: $result');
      print('line 789 ${result.data}');
      return result.data;
    } catch (e) {
      print('line 792 error: $e');
      throw Exception('line 739  ${e.toString()}');
    }
  }
  Future<List<Map<String, dynamic>>>? getHCProfessionalsByArgument(
      Map<String, dynamic> arguments) async {
    print('line 376 get all hcps: $arguments');
    try {
      //  return realm.all<ClientWorkOrderCampaign>();
      List<Map<String, dynamic>> mph = [];
      Query query = util.buildDynamicQuery(arguments!);
      print('line 381: $query');
      QuerySnapshot querySnapshot = await query.get();
      List<int> dupIds = [];
      print('line 384: ${querySnapshot.docs.length}');
      for (var docSnapShot in querySnapshot.docs) {
        Map<String, dynamic> obj = docSnapShot.data() as Map<String, dynamic>;
        obj['id'] = docSnapShot.id;
        print('line 387: ${obj['id']}');
        Timestamp ts = obj['credsWillWarnDate'];
        DateTime date = ts.toDate();
        var formattedDate = DateFormat('MM/dd/yyyy').format(date);
        obj['credsWillWarnDate'] = formattedDate;
        ts = obj['lastWorked'];
        date = ts.toDate();
        formattedDate = DateFormat('MM/dd/yyyy').format(date);
        obj['lastWorked'] = formattedDate;

        //    print('line 184: $formattedDate  ${obj['credsWillWarnDate']}');

        mph.add(obj);
      }
      print('line 402: ${mph.length}');
      return mph;
    } catch (e) {
      print('line 403 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>>? getHCProfessionalsByBranchId(
      int branchId) async {
    print('line 9 get all hcps: $branchId');
    try {
      //  return realm.all<ClientWorkOrderCampaign>();
      List<Map<String, dynamic>> mph = [];
      await FirebaseFirestore.instance
          .collection('HCProfessional')
          .where("branchId", isEqualTo: branchId)
          .get()
          .then((snapshot) {
        for (var docSnapshot in snapshot.docs) {
          Map<String, dynamic> obj = docSnapshot.data();
          Timestamp ts = obj['credsWillWarnDate'];
          DateTime date = ts.toDate();
          var formattedDate = DateFormat('MM/dd/yyyy').format(date);
          obj['credsWillWarnDate'] = formattedDate;
          ts = obj['lastWorked'];
          date = ts.toDate();
          formattedDate = DateFormat('MM/dd/yyyy').format(date);
          obj['lastWorked'] = formattedDate;

          //    print('line 184: $formattedDate  ${obj['credsWillWarnDate']}');

          mph.add(obj);
        }
      });
      return mph;
    } catch (e) {
      print('line 217 error: $e');
      throw Exception(e.toString());
    }
  }
  Future<Map<String, dynamic>> getHCPUser(int hcpId) async {
    print('line 19 in gethcpuser $hcpId');
    try {
      Map<String, dynamic>? hcpUser;
      await FirebaseFirestore.instance
          .collection("HCProfessional")
          .where('hcpId', isEqualTo: hcpId)
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          hcpUser = obj;
          print('line 29: ${hcpUser!['hcpId']}');
          await FirebaseFirestore.instance
              .collection('HCPAddress')
              .where('hcpId', isEqualTo: obj['hcpId'])
              .get()
              .then((querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              var adr = docSnapshot.data();
              if (adr['latitude'] != null) {
                hcpUser!['latitude'] = adr['latitude'];
                hcpUser!['longitude'] = adr['longitude'];
                break;
              }
            }
          });
          if (hcpUser == null) {
            print('line 48 hcpuser is null ');
            return {};
          }
          print('line 50:  ${hcpUser!['latitude']} ${hcpUser!['longitude']}');
          authServices.hcpId = hcpUser!['hcpId'];
          print('line 52 in get hcpuser hcpid');
          return hcpUser!;
        }
      });
      return hcpUser!;
    } catch (e) {
      print('line 58 error getting hcpuser: $e');
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> getHCProfessional(String email) async {
    print('line 61 in getHCPProfessional: $email');
    try {
      Map<String, dynamic>? hcpUser;
      await FirebaseFirestore.instance
          .collection("HCProfessional")
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          hcpUser = obj;
        }
      });

      print('line 42: in get hcpuser $email');
      return hcpUser!;
    } catch (e) {
      print('line 53 error getting hcpuser: $e');
      throw Exception(e);
    }
  }
  Future<Map<String, dynamic>> getASingleHCPUser(int hcpId) async {
    print('line 185 get a singled hcpuser');
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where("genId", isEqualTo: hcpId)
          .get()
          .then((querySnapshot) {
        var snapShot = querySnapshot.docs[0];
        String documentId = snapShot.id;
        Map<String, dynamic> userMap = snapShot.data();
        userMap['id'] = documentId;
        return userMap;
      });
      return {};
    } catch (e) {
      print('line 201 error: ${e.toString()}');
      return {};
    }
  }

  Future<Map<String, dynamic>>? getHCProfessionalByHCPId(int hcpId) async {
    print('line 207 gethcprofessionalbyHCPId $hcpId');
    Map<String, dynamic>? hcpMap;
    try {
      await FirebaseFirestore.instance
          .collection('HCProfessional')
          .where("hcpId", isEqualTo: hcpId)
          .get()
          .then((querySnapshot) {
        var snapShot = querySnapshot.docs[0];
        String documentId = snapShot.id;
        hcpMap = snapShot.data();
        hcpMap!['id'] = documentId;
        return;
      });
      return hcpMap!;
    } catch (e) {
      print('line 233 error: ${e.toString()}');
      return {};
    }
  }
  Future<List<Map<String, dynamic>>>? getHCPSpecialRates(int hcpId) async {
    try {
      List<Map<String, dynamic>>? hcpSpecialRates = [];

      await FirebaseFirestore.instance
          .collection("HCProfessionalRate")
          .where('hcpId', isEqualTo: hcpId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          String docId = docSnapshot.id;
          final obj = docSnapshot.data();
          obj['id'] = docId;
          hcpSpecialRates.add(obj);
        }
      });
      hcpSpecialRates.sort((a, b) {
        int sd = a['shiftCode'].compareTo(b['shiftCode']);
        return sd;
      });
      return hcpSpecialRates;
    } catch (e) {
      print('line 56 error getting hcpuser: $e');
      throw Exception(e);
    }
  }



}
