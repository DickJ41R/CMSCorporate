import "package:cloud_firestore/cloud_firestore.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:cms_web/features/hcpapp/models/hcprofessional_data_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cms_web/features/hcpapp/services/utilities.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class HCPServices {
  HCPServices();

  UtilitiesServices util = UtilitiesServices();

  Future<List<Map<String, dynamic>>>? getHCPAddresses(int hcpId) async {
    try {
      List<Map<String, dynamic>> hcpAddresses = [];

      await FirebaseFirestore.instance
          .collection("HCPAddress")
          .where('hcpId', isEqualTo: hcpId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          hcpAddresses.add(obj);
        }
      });
      return hcpAddresses;
    } catch (e) {
      print('line 53 error getting hcpuser: $e');
      throw Exception(e);
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

  Future<List<Map<String, dynamic>>>? getHCPContacts(int hcpId) async {
    try {
      List<Map<String, dynamic>>? hcpContacts = [];

      await FirebaseFirestore.instance
          .collection("HCPContact")
          .where('hcpId', isEqualTo: hcpId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          String docId = docSnapshot.id;
          final obj = docSnapshot.data();
          obj['id'] = docId;
          hcpContacts.add(obj);
        }
      });
      return hcpContacts;
    } catch (e) {
      print('line 80 error getting hcpuser: $e');
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

  Future<List<Map<String, dynamic>>>? getAllHCProfessionals() async {
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

  Query buildDynamicQuery(Map<String, dynamic> arg) {
    CollectionReference contentsRef =
        FirebaseFirestore.instance.collection(arg['searchCollection']);
    Query query = contentsRef;

    //check search criteria
    //all
    if (arg['searchCriteria'] == 'All') {
      return query;
    }
    //isequalto
    if (arg['searchCriteria'] == 'Is Equal To') {
      if (arg['searchField'].indexOf('Id') != -1) {
        int value = int.parse(arg['searchValue']);
        query = query.where(arg['searchField'], isEqualTo: value);
        return query;
      } else {
        query = query.where(arg['searchField'], isEqualTo: arg['searchValue']);
        return query;
      }
    }
    //less than
    if (arg['searchCriteria'] == 'Is Less Than') {
      if (arg['searchField'].indexOf('Id') != -1) {
        int value = int.parse(arg['searchValue']);
        query = query.where(arg['searchField'], isLessThan: value);
        return query;
      } else {
        query = query.where(arg['searchField'], isLessThan: arg['searchValue']);
        return query;
      }
    }
    //greater than
    if (arg['searchCriteria'] == 'Is Greater Than') {
      if (arg['searchField'].indexOf('Id') != -1) {
        int value = int.parse(arg['searchValue']);
        query = query.where(arg['searchField'], isGreaterThan: value);
        return query;
      } else {
        query =
            query.where(arg['searchField'], isGreaterThan: arg['searchValue']);
        return query;
      }
    }
    // Is greater Than or Equal To,
    if (arg['searchCriteria'] == 'Is Greater Than Or Equal To') {
      if (arg['searchField'].indexOf('Id') != -1) {
        int value = int.parse(arg['searchValue']);
        query = query.where(arg['searchField'], isGreaterThanOrEqualTo: value);
        return query;
      } else {
        query = query.where(arg['searchField'],
            isGreaterThanOrEqualTo: arg['searchValue']);
        return query;
      }
    }

    //Is less Than or Equal To",
    if (arg['searchCriteria'] == 'Is Less Than Or Equal To') {
      if (arg['searchField'].indexOf('Id') != -1) {
        int value = int.parse(arg['searchValue']);
        query = query.where(arg['searchField'], isLessThanOrEqualTo: value);
      } else {
        query = query.where(arg['searchField'],
            isLessThanOrEqualTo: arg['searchValue']);
      }
    }
    //Is Between (Include Edges)",
    if (arg['searchCriteria'] == 'Is Between (Include Edges)') {
      if (arg['searchField'].indexOf('Id') != -1) {
        int value = int.parse(arg['searchValue']);
        query = query.where(arg['searchField'], isGreaterThanOrEqualTo: value);
        query = query.where(arg['searchField'], isLessThanOrEqualTo: value);
      } else {
        query = query.where(arg['searchField'],
            isGreaterThanOrEqualTo: arg['searchValue']);
        query = query.where(arg['searchField'],
            isLessThanOrEqualTo: arg['searchValue']);
      }
    }
    // Is Between (Do not Include Edges)",
    if (arg['searchCriteria'] == 'Is Between (Do not Include Edges)') {
      if (arg['searchField'].indexOf('Id') != -1) {
        int value = int.parse(arg['searchValue']);
        query = query.where(arg['searchField'], isGreaterThan: value);
        query = query.where(arg['searchField'], isLessThan: value);
      } else {
        query =
            query.where(arg['searchField'], isGreaterThan: arg['searchValue']);
        query = query.where(arg['searchField'], isLessThan: arg['searchValue']);
      }
    }

    if (arg['searchCriteria'] == 'Is In (colon separated list)') {
      String sx = arg['searchCriteria'].replaceAll(',', ':');
      List<String> lsx = sx.split(':');
      if (arg['searchField'].indexOf('Id') != -1) {
        List<int> lvalues = [];
        for (int i = 0; i < lsx.length; i++) {
          String sv = lsx[i];
          lvalues.add(int.parse(sv));
        }
        query = query.where(arg['searchField'], whereIn: lvalues);
      } else {
        List<String> svalues = [];
        for (int i = 0; i < lsx.length; i++) {
          String sv = lsx[i];
          svalues.add(sv);
        }
        query = query.where(arg['searchField'], whereIn: svalues);
      }
    }
    return query;
  }

  Future<List<Map<String, dynamic>>>? getHCProfessionalsByArgument(
      Map<String, dynamic> arguments) async {
    print('line 9 get all hcps: $arguments');
    try {
      //  return realm.all<ClientWorkOrderCampaign>();
      List<Map<String, dynamic>> mph = [];
      Query query = buildDynamicQuery(arguments!);
      print('line 182: $query');
      query.get().then(((querySnapshot) async {
        for (var docSnapShot in querySnapshot.docs) {
          print('line 198 in querysnapshot');
          Map<String, dynamic> obj = docSnapShot.data() as Map<String, dynamic>;
          obj['id'] = docSnapShot.id;
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
      }));
      return mph;
    } catch (e) {
      print('line 217 error: $e');
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

  Future<List<dynamic>> getHCPDocumentationCategories() async {
    List<dynamic> lst = [
      {
        "codeId": 118,
        "codeValue": "CERT",
        "description": "Professional Certification"
      },
      {"codeId": 120, "codeValue": "CPR", "description": "CPR Certification"},
      {
        "codeId": 121,
        "codeValue": "CRIM",
        "description": "Criminal Background Check"
      },
      {"codeId": 123, "codeValue": "Drug", "description": "Drug Screen"},
      {"codeId": 125, "codeValue": "HEPB", "description": "Hepatitis B"},
      {
        "codeId": 139,
        "codeValue": "XRAY",
        "description": "Chest X-Ray (Positive PPD"
      },
      {
        "codeId": 141,
        "codeValue": "LIC",
        "description": "Professional License - Number"
      },
      {
        "codeId": 146,
        "codeValue": "License Status Verified - Annually",
        "description": "Board Status - Clear"
      },
      {
        "codeId": 200,
        "codeValue": "Negative Drug Screen - 12 Panel",
        "description": "12 Panel Drug Test"
      },
      {
        "codeId": 251,
        "codeValue": "Background Verification",
        "description": "Background Verification"
      },
      {
        "codeId": 289,
        "codeValue": "CNA CERT",
        "description": "CNA Certification"
      },
      {
        "codeId": 302,
        "codeValue": "Sex Offender Report",
        "description": "Sex Offender Report"
      },
      {
        "codeId": 305,
        "codeValue": "COVID Vaccine w/ Exp Date",
        "description": "COVID Vaccine w/ Exp Date"
      },
    ];
    return lst;
  }
  // Timestamp convertToTimeStamp(String dts) {
  //   Timestamp? ts;
  //   try {
  //     dts = dts.replaceAll('\/', '-');
  //     List<String> sts = dts.split('-');
  //     if (sts[2].length != 4) {
  //       throw Exception('Invalid date: year not 4 digits');
  //     }
  //     if (sts[0].length == 1) {
  //       String st = '0' + sts[0];
  //       sts[0] = st;
  //     }
  //     if (sts[1].length == 1) {
  //       String st = '0' + sts[1];
  //       sts[1] = st;
  //     }
  //
  //     String dtm = sts[2] + '-' + sts[0] + '-' + sts[1];
  //     DateTime dte = DateTime.parse(dtm);
  //     ts = Timestamp.fromDate(dte);
  //     print('line 341: $ts $dte');
  //     return ts;
  //   } catch (e) {
  //     print('line 345: error: ${e.toString()}');
  //     throw Exception('Error: ${e.toString()}');
  //   }
  // }

  Future<List<HCProfessionalDataModel>> getHCPDataFromSearch(
      String hcpRecordName) async {
    print('line 379: $hcpRecordName');
    hcpRecordName = hcpRecordName.trim();
    String branchName = hcpRecordName.toLowerCase();
    try {
      int idx2 = hcpRecordName.indexOf(':');
      int branchNumber = 0;
      List<Map<String, dynamic>> dupIds = [];
      List<String> disciplines = [];
      if (idx2 == -1) {
        if (int.tryParse(hcpRecordName) != null) {
          branchNumber = int.parse(hcpRecordName);
        } else {
          branchName = hcpRecordName;
          branchName = branchName.toLowerCase();
        }
        print('line 394 $branchName');
        disciplines.add('*');
      } else {
        print('line  397: $hcpRecordName $branchName');
        branchName = hcpRecordName.substring(idx2 + 1);
        branchName = branchName.toString().trim();
        print('line 400: $branchName');
        List<String> listC = hcpRecordName.split(':');
        List<String> listD = listC[1].split(',');
        print('line 403: $listD');
        if (listD.length == 1) {
          disciplines.add('*');
        } else if (listD.length > 1) {
          for (int n = 0; n < listD.length; n++) {
            disciplines.add(listD[n].toUpperCase());
          }
        } else {
          disciplines.add('*');
        }
        if (int.tryParse(branchName) != null) {
          branchNumber = int.parse(branchName);
        }
      }
      String? branchN = null;
      branchNumber = -1;
      print('line 419: $disciplines, $branchName');
      await FirebaseFirestore.instance
          .collection('CMSBranch')
          .get()
          .then((querySnapshot) {
        print('line 424: ${querySnapshot.docs.length}');
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          String bn = obj['branchName'].toLowerCase();
          if (bn.contains(branchName)) {
            branchN = bn;
            branchNumber = obj['branchId'];
            break;
          }
        }
      });
      if (branchN == null) {
        return [];
      }
      branchName = branchN!;
      List<HCProfessionalDataModel> hcpms = [];
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
      print('line 451: $disciplines $branchName $branchNumber');
      // FirebaseFirestore.instance
      //     .collection('ClientWorkOrderCampaign')
      //     .where(Filter.or(
      //         Filter("clientName", : clientName),
      //         Filter("clientName", isLessThanOrEqualTo: clientName)))
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
          .where("branchId", isEqualTo: branchNumber)
          .where('shiftStatus', whereIn: [
            'Open',
            'Accepted',
            'Approved',
            'Confirmed',
            'SignedIn',
          ])
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
              int year = dte.year;
              int month = dte.month;
              int day = dte.day;

              print('line 495: $year, $cYear, $month $cMonth, $day $cDay');
              // if (obj['shiftStatus'] == 'Closed' ||
              //     //  obj['shiftStatus'] == 'Confirmed' ||
              //     obj['shiftStatus'] == 'Canceled' ||
              //     //   obj['shiftStatus'] == 'SignedIn' ||
              //     obj['shiftStatus'] == 'SignedOut') {
              //   continue;
              // }
              print(
                  'line 502 dates for skipping: ${obj['hcpId']} ${obj['hcpName']} ${obj['shiftStatus']} ${ts.millisecondsSinceEpoch} ${dnt.millisecondsSinceEpoch}');
              if (year == cYear && month == cMonth) {
                if (day < cDay) {
                  print(
                      'line 506: ${obj['hcpId']} ${obj['shiftStatus']} skipping because of dates');
                  print(
                      'line 509 ${ts.millisecondsSinceEpoch} ${dnt.millisecondsSinceEpoch}');
                  continue;
                }
              }

              DateTime tdy = ts.toDate();
              sTimes = util.getHoursAndMinutes(obj['startTime']);
              eTimes = util.getHoursAndMinutes(obj['endTime']);
              int startMinutes = util.getMinutes(obj['startTime']);
              int endMinutes = util.getMinutes(obj['endTime']);
              if (startMinutes > 720 && startMinutes > endMinutes) {
                eTimes[0] += 24;
                tdy = tdy.add(Duration(hours: eTimes[0], minutes: eTimes[1]));
                if (tdy.millisecondsSinceEpoch <
                    todayDate.millisecondsSinceEpoch) {
                  print(
                      'line 530 skipping late shift ${tdy.millisecondsSinceEpoch} ${tdy.millisecondsSinceEpoch}');
                  continue;
                }
              } else {
                if (tdy.millisecondsSinceEpoch < dnt.millisecondsSinceEpoch) {
                  print(
                      'line 536 skipping shift: ${tdy.millisecondsSinceEpoch} ${dnt.millisecondsSinceEpoch}');
                  continue;
                }
              }
              print(
                  'line 541: ${obj['branchId']} ${obj['branchName']} $branchName $branchNumber');
              // if (clientNumber != 0) {
              //   if (clientNumber != obj['clientId']) {
              //     print('line 382: $clientNumber ${obj['clientNumber']}');
              //     continue;
              //   }
              // } else {
              print('line 548: ${obj['branchName']} $branchName');
              print(
                  'line 550 ${obj['branchName'].toLowerCase().indexOf(branchName)}');
              if (obj['branchName']
                      .toLowerCase()
                      .contains(branchName.toLowerCase()) ==
                  false) {
                print(
                    'line 556 skipping because of name: ${obj['branchName']} $branchName');
                continue;
              }
              //  }
              Timestamp tms = ts;
              print(
                  'line 562 ${tms.millisecondsSinceEpoch} ${dtms.millisecondsSinceEpoch}');

              // int txs = dtms.millisecondsSinceEpoch - 60 * 60 * 24 * 1000;
              // print('line 440:  $txs');
              // if (tms.millisecondsSinceEpoch <= txs) {
              //   print(
              //       'line 443 skipping because of dates ${obj['hcpId']} ${obj['hcpName']} ${obj['disciplineCodes']}');
              //   continue;
              // }

              bool flagIsDup = false;
              Map<String, dynamic> dup = {};
              print('line 574 ${obj['shiftDate']}');
              if (dupIds.length > 0) {
                flagIsDup = false;
                for (int q = 0; q < dupIds.length; q++) {
                  dup = dupIds[q];
                  if (dup['hcpId'] == obj['hcpId'] &&
                      dup['branchId'] == obj['branchId']) {
                    flagIsDup = true;
                    break;
                  }
                }
              }
              if (flagIsDup == true) {
                continue;
              }
              dup = {"hcpId": obj['hcpId'], "branchId": obj['branchId']};
              dupIds.add(dup);
              print(
                  'line 592 ${obj['hcpName']} ${obj['disciplineName']} ${obj['branchName']}');

              if (disciplines[0] == '*' ||
                  disciplines.indexOf(obj['disciplineName']) != -1) {
                var dt = DateTime.fromMillisecondsSinceEpoch(
                    tms.millisecondsSinceEpoch);
                String date = DateFormat('MM/dd/yyyy').format(dt);
                date += '-' + obj['shiftCode'];
                print('line 600: $date');
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
                    shiftDateString: date,
                    shiftStatus: shft,
                    shiftCode: obj['shiftCode'],
                    startTime: obj['startTime'],
                    endTime: obj['endTime'],
                    disciplineName: obj['disciplineName']);
              } else {
                print(
                    'line 634 skipping on discipline name: ${obj['disciplineName']}');
                continue;
              }
              hcpms.add(htp!);
            }
            return;
          });
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
    var orgId = dotenv.env['ASM_DB2'];
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
}
