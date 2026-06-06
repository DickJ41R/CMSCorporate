import 'package:cms_web/features/clientapp/models/client_address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/clientapp/models/client_data.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/clientapp/models/client_user.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_timecard_service.dart';

class ClientServices {
  ClientServices();

  static final _staticVariable = null;
  Map<String, dynamic>? client;
  UtilitiesServices util = UtilitiesServices();
  AuthService authServices = AuthService();
  HCPTimeCardService hts = HCPTimeCardService();

  Future<List<dynamic>> getClientWorkOrders(
      int clientId, BuildContext ctx) async {
    try {
      debugPrint('line 22 get clientworkorders $clientId');
      List<dynamic> response =
          await callRetrieveClientWorkOrdersFunction(clientId, ctx);
      debugPrint('line 24: $response');
      return response;
    } catch (e) {
      debugPrint('line 28: ${e.toString()}');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCannotBeScheduledData(
      int clientId) async {
    debugPrint('line 32: $clientId');
    List<Map<String, dynamic>> lm = [];
    DateTime dte = DateTime.now();
    dte = dte.subtract(Duration(
        hours: dte.hour,
        minutes: dte.minute,
        seconds: dte.second,
        microseconds: dte.microsecond,
        milliseconds: dte.millisecond));
    try {
      debugPrint('line 35 getcannot be scheduled: $clientId');
      await FirebaseFirestore.instance
          .collection('ClientCannotBeScheduled')
          .where("clientId", isEqualTo: clientId)
          .where('shiftDate', isGreaterThanOrEqualTo: Timestamp.fromDate(dte))
          .get()
          .then((snapshot) {
        debugPrint(
            'line 43 get client cannot be scheduled: ${snapshot.docs.length}');
        for (var snp in snapshot.docs) {
          lm.add(snp.data());
        }
      });
      debugPrint('line 48: ${lm.length}');
      return lm;
    } catch (e) {
      debugPrint('line 53 $e');
      throw Exception('line 54: ${e.toString()}');
    }
  }

  Future<List<dynamic>> callRetrieveClientWorkOrdersFunction(
      int clientId, BuildContext ctx) async {
    debugPrint('line 60 callretrieveclients: $clientId');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'retrieveclientworkorders02',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );
      debugPrint('line 68: just before calling retrieve client wos');
      List<dynamic> result = await callingRetrieveClientWorkOrdersFunction(
          callable, clientId, ctx);
      debugPrint('line 71: $result');
      if (result[0]['ERROR'] != null) {
        debugPrint('line 73: Error getting htc id to asm');
        return result;
      }
      debugPrint('line 76 successfully retrieved htc');

      return result;
    } catch (e) {
      debugPrint('line 80 $e');
      throw Exception('line 81: ${e.toString()}');
    }
  }

  Future<List<dynamic>> callingRetrieveClientWorkOrdersFunction(
      HttpsCallable callable, int clientId, BuildContext ctx) async {
    debugPrint('line 87: $clientId');
    try {
      var data = {
        "clientId": clientId,
      };
      final HttpsCallableResult result = await callable(data);
      debugPrint('line 93 ${result.data}');
      //    var convertedResult = Map<String, dynamic>.from(result.data);
      return result.data;
    } catch (e) {
      debugPrint('line 97 error: $e');
      throw Exception('line 98  ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getClientAddressData(int clientId) async {
    List<Map<String, dynamic>> lm = [];
    debugPrint('line 76 getclientaddress: $clientId');
    await FirebaseFirestore.instance
        .collection('ClientAddress')
        .where("clientId", isEqualTo: clientId)
        .get()
        .then((snapshot) {
      debugPrint('line 82 get client addr ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        lm.add(snp.data());
      }
    });
    return lm;
  }

  Future<List<ClientAddress>>? getClientAddressDataClass(int clientId) async {
    List<ClientAddress> lm = [];
    await FirebaseFirestore.instance
        .collection('ClientAddress')
        .where("clientId", isEqualTo: clientId)
        .get()
        .then((snapshot) {
      debugPrint('line 33 gt clent ddress data  ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        ClientAddress cli = ClientAddress.fromFirestore(snp, null);
        lm.add(cli);
      }
    });
    return lm;
  }

  Future<List<Map<String, dynamic>>> getClientContactDataClass(
      int clientId) async {
    List<Map<String, dynamic>> lm = [];
    await FirebaseFirestore.instance
        .collection('ClientContact')
        .where("clientId", isEqualTo: clientId)
        .get()
        .then((snapshot) {
      debugPrint('line 49 get client contact ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        var obj = snp.data();
        obj['id'] = snp.id;
        lm.add(obj);
      }
    });
    return lm;
  }

  Future<List<Map<String, dynamic>>>? getClientDepartmentDataClass(
      int clientId) async {
    List<Map<String, dynamic>> lm = [];
    await FirebaseFirestore.instance
        .collection('ClientDepartment')
        .where("clientId", isEqualTo: clientId)
        .get()
        .then((snapshot) {
      debugPrint('line 72 get client deptgs ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        lm.add(snp.data());
      }
    });
    return lm;
  }

  Future<List<Map<String, dynamic>>>? getClientHolidays(int clientId) async {
    List<Map<String, dynamic>> lm = [];
    await FirebaseFirestore.instance
        .collection('HCPHoliday')
        .where("clientId", isEqualTo: clientId)
        .get()
        .then((snapshot) {
      debugPrint('line 75 get client holidays ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        lm.add(snp.data());
      }
    });
    return lm;
  }

  Future<List<Map<String, dynamic>>> getClientInvoice(int clientId) async {
    List<Map<String, dynamic>> lm = [];
    await FirebaseFirestore.instance
        .collection('ClientInvoice')
        .where("clientId", isEqualTo: clientId)
        .orderBy("invoiceDate", descending: true)
        .get()
        .then((snapshot) {
      debugPrint('line 88  client invoice ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        lm.add(snp.data());
      }
    });
    return lm;
  }

  Future<List<Map<String, dynamic>>>? getClientHCPDNU(int clientId) async {
    List<Map<String, dynamic>>? lm;
    await FirebaseFirestore.instance
        .collection('ClientDNU')
        .where("clientId", isEqualTo: clientId)
        .get()
        .then((snapshot) {
      debugPrint('line 1p1 client dnu ${snapshot.docs.length}');
      lm = [];
      for (var snp in snapshot.docs) {
        lm!.add(snp.data());
      }
    });
    return lm!;
  }

  // final CollectionReference<ClientData> clientRef = FirebaseFirestore.instance
  //     .collection('ClientData')
  //     .withConverter<ClientData>(
  //   fromFirestore: (snapshots, _) => ClientData.fromJson(snapshots.data()!),
  //   toFirestore: (client, _) => client.toJson(),
  // );

  Future<List<ClientData>> getClientData() async {
    List<ClientData> ld = [];
    await FirebaseFirestore.instance
        .collection('ClientData')
        .get()
        .then((snapshot) {
      for (var cr in snapshot.docs) {
        Map<String, dynamic> cd = cr.data();
        ClientData dta = ClientData(
            clientId: cd['clientId'],
            clientName: cd['clientName'],
            branchId: cd['branchId'],
            status: cd['status']);
        ld.add(dta);
      }
    });
    return ld;
  }

  Future<List<Map<String, dynamic>>>? getClients() async {
    List<Map<String, dynamic>>? lm;
    await FirebaseFirestore.instance
        .collection('Client')
        .get()
        .then((snapshot) {
      lm = [];
      debugPrint('line 158 client ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        lm!.add(snp.data());
      }
    });
    return lm!;
  }

  Future<Map<String, dynamic>>? getClient(int clientId) async {
    Map<String, dynamic>? lm;
    await FirebaseFirestore.instance
        .collection('Client')
        .where("clientId", isEqualTo: clientId)
        .get()
        .then((snapshot) {
      debugPrint('line 158 getclient ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        lm = snp.data();
        break;
      }
    });
    return lm!;
  }

  Future<List<Map<String, dynamic>>>? getClientsByBranchId(branchId) async {
    List<Map<String, dynamic>> lm = [];
    debugPrint('line 163 getclientbybranchid $branchId');
    try {
      //begin debug
      //take out for production
      List<int> clientIds = [];

      //end debug
      await FirebaseFirestore.instance
          .collection('Client')
          .where("branchId", isEqualTo: branchId)
          .where('clientId', whereIn: clientIds)
          . //debug
          get()
          .then((snapshot) {
        debugPrint('line 168 getclientbybrnchid ${snapshot.docs.length}');
        for (var snp in snapshot.docs) {
          final obj = snp.data();
          lm.add(obj);
        }
        debugPrint('line 174: ${lm.length}');
        return lm;
      });
      return lm;
    } catch (e) {
      debugPrint('line 258 error $e');
      String te = e.toString();
      te = te.replaceAll('Exception: Exception:', 'Exception:');
      throw Exception(te.toString());
    }
  }

  Future<List<Map<String, dynamic>>>? getClientsByBranchIds(
      List<int> branchIds) async {
    List<Map<String, dynamic>> lm = [];

    try {
      await FirebaseFirestore.instance
          .collection('Client')
          .get()
          .then((snapshot) {
        debugPrint('line 225 getclientbybrnchid ${snapshot.docs.length}');
        for (var snp in snapshot.docs) {
          final obj = snp.data();
          if (branchIds.indexOf(obj['branchId']) == true) {
            lm.add(snp.data());
          }
        }
      });
      return lm;
    } catch (e) {
      debugPrint('line 258 error $e');
      throw Exception(e.toString());
    }
  }

  int getShiftCodeId(String sc) {
    if (sc == '1') {
      return 1;
    } else if (sc == '2') {
      return 2;
    } else if (sc == '3') {
      return 3;
    } else if (sc == 'AP') {
      return 4;
    } else {
      return 5;
    }
  }

  double convertToDouble(dynamic dv) {
    if (dv is double) {
      return dv;
    } else {
      return dv.toDouble();
    }
  }

  String getStringDate(Timestamp? dt) {
    String? xt;
    int? dtt;
    final format = DateFormat('yyyy-MM-dd HH:mm');
    try {
      if (dt == null) {
        DateTime dx = new DateTime(1900, 1, 1);
        xt = format.format(dx);
        List<String> xts = xt.split(' ');
        xt = xts[1];
        xts = xt.split(':');
        int? x = int.tryParse(xts[0]);
        if (x! > 12) {
          xt += ' PM';
        } else {
          xt += ' AM';
        }
        return xt;
      } else {
        dtt = dt.millisecondsSinceEpoch;
        String ds =
            new DateTime.fromMillisecondsSinceEpoch(dtt).toIso8601String();
        final dateTime = DateTime.parse(ds);
        xt = format.format(dateTime); // 2021-08-11 11:38
        debugPrint('line 217 $xt');
        List<String> xts = xt.split(' ');
        xt = xts[1];
        xts = xt.split(':');
        int? x = int.tryParse(xts[0]);
        if (x! > 12) {
          xt += ' PM';
        } else {
          xt += ' AM';
        }
        debugPrint('line 230: $xt');
        return xt;
      }
    } catch (e) {
      debugPrint('line 233: $e');
      throw Exception('line 222 get ts ${e.toString()}');
    }
  }

  double getTimeHours(String? tme) {
    debugPrint('line 270 gettimehours: $tme');
    var slingPayrollHours = [
      {"minutes": 0.0, "decimal": 0.00},
      {"minutes": 1.0, "decimal": 0.02},
      {"minutes": 2.0, "decimal": 0.03},
      {"minutes": 3.0, "decimal": 0.05},
      {"minutes": 4.0, "decimal": 0.07},
      {"minutes": 5.0, "decimal": 0.08},
      {"minutes": 6.0, "decimal": 0.10},
      {"minutes": 7.0, "decimal": 0.12},
      {"minutes": 8.0, "decimal": 0.13},
      {"minutes": 9.0, "decimal": 0.15},
      {"minutes": 10.0, "decimal": 0.17},
      {"minutes": 11.0, "decimal": 0.19},
      {"minutes": 12.0, "decimal": 0.20},
      {"minutes": 13.0, "decimal": 0.22},
      {"minutes": 14.0, "decimal": 0.23},
      {"minutes": 15.0, "decimal": 0.25},
      {"minutes": 16.0, "decimal": 0.22},
      {"minutes": 17.0, "decimal": 0.28},
      {"minutes": 18.0, "decimal": 0.30},
      {"minutes": 19.0, "decimal": 0.32},
      {"minutes": 20.0, "decimal": 0.33},
      {"minutes": 21.0, "decimal": 0.35},
      {"minutes": 22.0, "decimal": 0.37},
      {"minutes": 23.0, "decimal": 0.38},
      {"minutes": 24.0, "decimal": 0.40},
      {"minutes": 25.0, "decimal": 0.42},
      {"minutes": 26.0, "decimal": 0.43},
      {"minutes": 27.0, "decimal": 0.45},
      {"minutes": 28.0, "decimal": 0.47},
      {"minutes": 29.0, "decimal": 0.48},
      {"minutes": 30.0, "decimal": 0.50},
      {"minutes": 31.0, "decimal": 0.52},
      {"minutes": 32.0, "decimal": 0.53},
      {"minutes": 33.0, "decimal": 0.55},
      {"minutes": 34.0, "decimal": 0.57},
      {"minutes": 35.0, "decimal": 0.58},
      {"minutes": 36.0, "decimal": 0.60},
      {"minutes": 37.0, "decimal": 0.62},
      {"minutes": 38.0, "decimal": 0.63},
      {"minutes": 39.0, "decimal": 0.65},
      {"minutes": 40.0, "decimal": 0.67},
      {"minutes": 41.0, "decimal": 0.68},
      {"minutes": 42.0, "decimal": 0.70},
      {"minutes": 43.0, "decimal": 0.72},
      {"minutes": 44.0, "decimal": 0.73},
      {"minutes": 45.0, "decimal": 0.75},
      {"minutes": 46.0, "decimal": 0.77},
      {"minutes": 47.0, "decimal": 0.78},
      {"minutes": 48.0, "decimal": 0.80},
      {"minutes": 49.0, "decimal": 0.82},
      {"minutes": 50.0, "decimal": 0.83},
      {"minutes": 51.0, "decimal": 0.85},
      {"minutes": 52.0, "decimal": 0.87},
      {"minutes": 53.0, "decimal": 0.88},
      {"minutes": 54.0, "decimal": 0.90},
      {"minutes": 55.0, "decimal": 0.92},
      {"minutes": 56.0, "decimal": 0.93},
      {"minutes": 57.0, "decimal": 0.95},
      {"minutes": 58.0, "decimal": 0.97},
      {"minutes": 59.0, "decimal": 0.98},
      {"minutes": 60.0, "decimal": 1.00},
    ];
    try {
      double hours = 0.0;
      if (tme == null) {
        return hours;
      }
      List<String> sts = tme.split(' ');
      if (sts.length < 2) {
        debugPrint('Error with data: $tme');
        return hours;
      }
      String sx = sts[0];
      debugPrint('line 345: $sx');
      List<String> sxs = sx.split(':');
      double dmstm = double.parse(sxs[1]);
      if (dmstm == 0) {
        dmstm = 0.0;
      }
      double stmin = 0.0;
      debugPrint('line 352: $dmstm');
      for (int m = 0; m < slingPayrollHours.length; m++) {
        debugPrint('line 348 comp: $stmin ${slingPayrollHours[m]['minutes']}');
        if (dmstm == slingPayrollHours[m]['minutes']) {
          stmin = slingPayrollHours[m]['decimal']!;
          debugPrint('line 351: $stmin');
          break;
        }
      }
      hours = double.parse(sxs[0]) + stmin;
      debugPrint('line 353: $hours');
      return hours;
    } catch (e) {
      debugPrint('line 356 error $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getClientRateDisciplines(
      int clientId, int departmentId, String departmentName) async {
    //List<dynamic> listD = [];
    debugPrint('line 391: $clientId $departmentId $departmentName');
    Map<String, dynamic>? rateMap;
    List<Map<String, dynamic>> listOfRateMaps = [];
    List<Map<String, dynamic>> listDisciplineMap = [];
    List<dynamic> listOfDisciplines = [];
    bool flagGotHit = false;
    try {
      debugPrint('line 397 check');
      await FirebaseFirestore.instance
          .collection('ClientRate')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) {
        // int cnt = 0;
        for (var docSnapshot in querySnapshot.docs) {
          debugPrint('line 405: $flagGotHit');
          if (flagGotHit == true) {
            continue;
          }
          debugPrint('line 407 ${docSnapshot.id}');
          final documentId = docSnapshot.id;
          final obj = docSnapshot.data();
          obj['id'] = documentId;
          debugPrint('line 411: $clientId ${obj['departments']}');
          if (obj['hcpId'] != null && obj['hcpId'] > 0) {
            continue;
          }
          if (obj['disciplines'] == null || obj['disciplines'].length == 0) {
            continue;
          }
          if (obj['departments'] == null || obj['departments'].length == 0) {
            Map<String, dynamic> dpm = {
              "departmentId": departmentId,
              "departmentName": departmentName,
            };
            obj['departments'] = [];
            obj['departments'].add(dpm);
          }
          debugPrint('line 431 check ${obj['departments']} ${obj['disciplines']}');
          flagGotHit = false;
          rateMap = Map.from(obj);
          for (int i = 0; i < obj['departments'].length; i++) {
            dynamic ob = obj['departments'][i];
            debugPrint('line 432: $ob ');
            debugPrint(
                'line 433 ${ob['departmentName'].toString()} ${departmentName.toString()}');
            debugPrint(
                'line 434 ${int.parse(ob['departmentId'].toString())} ${int.parse(departmentId.toString())}');
            if (ob['departmentName'].toString() == departmentName.toString() ||
                int.parse(ob['departmentId'].toString()) ==
                    int.parse(departmentId.toString())) {
              debugPrint('line 442 check');
              listOfDisciplines = [];
              for (int j = 0; j < obj['disciplines'].length; j++) {
                dynamic db = obj['disciplines'][j];
                bool flagIsDuplicate = false;
                for (int k = 0; k < listDisciplineMap.length; k++) {
                  Map<String, dynamic> mp = listDisciplineMap[k];
                  if (mp['disciplineId'] == db['disciplineId']) {
                    flagIsDuplicate = true;
                    break;
                  }
                }
                if (flagIsDuplicate == true) {
                  continue;
                }
                debugPrint('line 456 ${listOfDisciplines.length}');
                if (listOfDisciplines.length > 0) {
                  for (int k = 0; k < listOfDisciplines.length; k++) {
                    dynamic dd = listOfDisciplines[k];
                    if (dd['disciplineId'] == db['disciplineId'] ||
                        dd['disciplineName'] == db['disciplineName']) {
                      continue;
                    }
                    listOfDisciplines.add(db);
                  }
                } else {
                  debugPrint('line 468: $db');
                  listOfDisciplines.add(db);
                }
              }
              for (int k = 0; k < listOfDisciplines.length; k++) {
                dynamic obj = listOfDisciplines[k];
                Map<String, dynamic> disciplineMap = {
                  'disciplineId': int.parse(obj['disciplineId'].toString()),
                  'disciplineName': obj['disciplineName'].toString()
                };
                listDisciplineMap.add(disciplineMap);
              }
              debugPrint('line 484: ${rateMap!['disciplines']}');
              listOfRateMaps.add(rateMap!);
              flagGotHit = true;
            }
            if (flagGotHit == true) {
              break;
            }
          }
          if (flagGotHit == true) {
            break;
          }
        }
      });

      debugPrint('line 422 ${listOfRateMaps.length} ${listDisciplineMap.length}');
      Map<String, dynamic> ld = {
        "listDisciplineMap": listDisciplineMap,
        "listClientRates": listOfRateMaps
      };
      return ld;
    } catch (e) {
      debugPrint('line 484 error in getclientratedisciplinerate: $e');
      throw Exception('Error in getClientRateDisciplines: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getClientDepartmentData(
      int clientId) async {
    debugPrint('line 596: $clientId');
    List<Map<String, dynamic>> dps = [];
    try {
      await FirebaseFirestore.instance
          .collection('ClientDepartment')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) async {
        int cnt = 0;
        for (var docSnapshot in querySnapshot.docs) {
          final documentId = docSnapshot.id;
          final obj = docSnapshot.data();
          obj['id'] = documentId;
          cnt += 1;
          debugPrint('line 446: $cnt ${obj['statusId']}');
          bool bl = obj['departmentName'].contains('PSG');
          if (bl == true) {
            continue;
          }
          obj['expirationDate'] = obj['ExpirationDate'];
          if (obj['statusId'] != 'A') {
            continue;
          }
          debugPrint('line 417 $cnt');
          dps.add(obj);
        }
      });
      //  List<Map<String, dynamic>> drs = [];
      debugPrint('line 422 ${dps.length}');
      if (dps.length == 0) {
        throw Exception('No active departments found for the client');
      }
      return dps;
    } catch (e) {
      debugPrint('line 418 error getting departments.');
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getDepartmentData(
      int clientId, String departmentId) async {
    List<Map<String, dynamic>> dps = [];
    try {
      await FirebaseFirestore.instance
          .collection('ClientDepartment')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) async {
        int cnt = 0;
        for (var docSnapshot in querySnapshot.docs) {
          final documentId = docSnapshot.id;
          final obj = docSnapshot.data();
          obj['id'] = documentId;
          cnt += 1;
          debugPrint('line 446: $cnt ${obj['statusId']}');
          bool bl = obj['departmentName'].contains('PSG');
          if (bl == true) {
            continue;
          }
          if (obj['statusId'] == 'A') {
            continue;
          }
          if (obj['departmentId'] != departmentId) {
            continue;
          }
          debugPrint('line 417 $cnt');
          dps.add(obj);
        }
      });
      //  List<Map<String, dynamic>> drs = [];
      debugPrint('line 422 ${dps.length}');
      if (dps.length == 0) {
        throw Exception('No active departments found for the client');
      }
      return dps;
    } catch (e) {
      debugPrint('line 418 error getting departments.');
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<List<ClientData>> getClientDataFromSearch(String clientName) async {
    List<ClientData> clientData = [];
    debugPrint('line  577: $clientName');
    clientName = clientName.toLowerCase();
    List<Map<String, dynamic>> branches = [
      {"branchCode": 615, "branchName": "RALEIGH CMS 101"},
      {
        "branchCode": 624,
        "branchName": "COLUMBIA CMS 105",
      },
      {"branchCode": 631, "branchName": "NASHVILLE CMS 106"},
      {"branchCode": 632, "branchName": "MEMPHIS CMS 107"},
      {"branchCode": 634, "branchName": "AUGUSTA-GREENVILLE CMS 110"},
      {"branchCode": 635, "branchName": "FLORENCE CMS 111"},
      {"branchCode": 638, "branchName": "KNOXVILLE-TRI CITIES CMS 114"},
      {"branchCode": 640, "branchName": "CHATTANOOGA CMS 116"},
      {"branchCode": 641, "branchName": "LEXINGTON CMS 117"},
    ];

    int indx = clientName.indexOf('-');
    String branchNamex = '';
    String? clientNamex = null;
    int branchNumberx = -1;
    int clientNumber = -1;
    if (indx != -1) {
      List<String> lts = clientName.split('-');
      branchNamex = lts[0];
      for (int i = 0; i < branches.length; i++) {
        Map<String, dynamic> ob = branches[i];
        debugPrint(
            'line 616: ${ob['branchName'].toLowerCase().contains(lts[0].toLowerCase())}');

        if (ob['branchName'].toLowerCase().contains(lts[0].toLowerCase()) ==
            true) {
          branchNumberx = ob['branchCode'];
          break;
        }
      }
      clientNamex = lts[1].toLowerCase();
    } else {
      String lcl = clientName.toLowerCase();
      debugPrint('line 613: $lcl');
      for (int i = 0; i < branches.length; i++) {
        Map<String, dynamic> ob = branches[i];
        debugPrint(
            'line 616: ${ob['branchName'].toLowerCase().contains(lcl.toLowerCase())}');
        if (ob['branchName'].toLowerCase().contains(lcl.toLowerCase()) ==
            true) {
          branchNamex = ob['branchName'];
          branchNumberx = ob['branchCode'];
          break;
        }
      }
      if (branchNumberx == -1) {
        clientNamex = clientName.toLowerCase();
      }
    }
    if (int.tryParse(clientName) != null) {
      branchNumberx = -1;
      clientNamex = '';
      clientNumber = int.parse(clientName);
    }
    debugPrint('line 632: $branchNumberx');
    try {
      ClientData? tbj;
      await FirebaseFirestore.instance
          .collection('Client')
          //   .where('clientId',isEqualTo: clientId) --put back when live
          .where('clientId', isGreaterThan: 0)
          .orderBy("clientName", descending: false)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          if (obj['clientName'].indexOf('DO NOT') != -1) {
            continue;
          }
          if (obj['gpoClient'] != null && obj['gpoClient'] == true) {
            continue;
          }
          if (clientNumber != -1) {
            if (obj['clientId'] != clientNumber) {
              continue;
            }
          } else {
            if (branchNumberx != -1) {
              if (branchNumberx == obj['branchId']) {
                if (clientNamex == null) {
                  clientNamex = clientName.toLowerCase();
                }
                debugPrint('line 662: $clientNamex');

                if (obj['clientName'].toLowerCase().indexOf(clientNamex) !=
                    -1) {
                  tbj = ClientData(
                      clientId: obj['clientId'],
                      clientName: obj['clientName'],
                      branchId: obj['branchId'],
                      status: obj['statusId']);
                } else {
                  continue;
                }
              } else {
                continue;
              }
            } else {
              int idx = obj['clientName']
                  .toLowerCase()
                  .indexOf(clientNamex!.toLowerCase());
              debugPrint('line 589: $idx $clientNamex ${obj['clientName']}');
              if (idx == -1) {
                continue;
              }
            }
          }
          tbj = ClientData(
              clientId: obj['clientId'],
              clientName: obj['clientName'],
              branchId: obj['branchId'],
              status: obj['statusId']);

          clientData.add(tbj!);
        }
      });
      return clientData;
    } catch (e) {
      debugPrint('line 594 error: ${e.toString()}');
      return [];
    }
  }

  Future<Map<String, dynamic>>? getClientMapData(int clientId) async {
    Map<String, dynamic>? obj;
    await FirebaseFirestore.instance
        .collection('Client')
        //   .where('clientId',isEqualTo: clientId) --put back when live
        .where('clientId', isEqualTo: clientId)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        obj = docSnapshot.data();
        break;
      }
    });
    debugPrint('line  779: $obj');
    return obj!;
  }

  Future<int> getClientUserClientId(String userEmail) async {
    int clientId = -1;
    await FirebaseFirestore.instance
        .collection('ClientUser')
        //   .where('clientId',isEqualTo: clientId) --put back when live
        .where('email', isEqualTo: userEmail)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        final obj = docSnapshot.data();
        clientId = obj['clientId'];
        break;
      }
    });
    return clientId;
  }

  Future<Map<String, dynamic>> getClientCredit(int clientId) async {
    try {
      // DateTime shiftDate = DateTime.now();
      debugPrint('line 1152 $clientId');
      Map<String, dynamic>? clientCredit;
      await FirebaseFirestore.instance
          .collection('ClientCredit')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          clientCredit = obj;
          break;
        }
      });
      debugPrint('line 1165 $clientCredit');
      if (clientCredit == null) {
        throw Exception('line 800 no client credit records');
      }
      if (clientCredit!.entries.isNotEmpty) {
        Map<String, dynamic> agingData = await getAgingData(clientId);
        debugPrint('line 622: ${agingData}');
        return {
          'clientCredit': clientCredit,
          'agingData': agingData['balances'],
          'totalCurrentBalance': agingData['totalCurrentBalance']
        };
      } else {
        return {};
      }
    } catch (e) {
      debugPrint('line 1166 error: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getAgingData(int clientId) async {
    Map<String, dynamic> lag = {};
    List<Map<String, dynamic>> balances = [
      {
        'label': '0 to 30 days',
        'balance': 0.0,
      },
      {
        'label': '31 to 60 days',
        'balance': 0.0,
      },
      {
        'label': '61 to 90 days',
        'balance': 0.0,
      },
      {
        'label': '91 to 120 days',
        'balance': 0.0,
      },
      {
        'label': '120+ days',
        'balance': 0.0,
      }
    ];

    DateTime curDate = DateTime.now();

    curDate = curDate.subtract(Duration(
        hours: curDate.hour,
        minutes: curDate.minute,
        seconds: curDate.second,
        microseconds: curDate.microsecond,
        milliseconds: curDate.millisecond));
    Timestamp cds = Timestamp.fromDate(curDate);
    double totalCurrentBalance = 0;
    try {
      await FirebaseFirestore.instance
          .collection('ClientInvoice')
          .where('clientId', isEqualTo: clientId)
          .orderBy("invoiceDate", descending: false)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          lag = docSnapshot.data();
          double balance = lag['totalAmount'] - lag['totalPaid'];
          if (balance == 0) {
            continue;
          }
          debugPrint('line 686: ${lag['totalAmount']} ${lag['totalPaid']} $balance');
          Timestamp ids = lag['invoiceDate'];
          debugPrint('line 688: $ids');
          DateTime ide = ids.toDate();
          ide = ide.subtract(Duration(
              hours: ide.hour,
              minutes: ide.minute,
              seconds: ide.second,
              microseconds: ide.microsecond,
              milliseconds: ide.millisecond));
          int mse = cds.millisecondsSinceEpoch - ide.millisecondsSinceEpoch;
          double msed = double.parse(mse.toString());
          debugPrint('line 698: $msed');
          msed /= 86400000;
          int days = msed.round();
          debugPrint('line 701: $days');
          int idx = -1;
          if (days < 31) {
            idx = 0;
          } else if (days >= 31 && days < 60) {
            idx = 1;
          } else if (days >= 61 && days < 90) {
            idx = 2;
          } else if (days >= 91 && days < 120) {
            idx = 3;
          } else if (days >= 121) {
            idx = 4;
          }
          debugPrint('line 713: $balance $idx');
          totalCurrentBalance += balance;
          Map<String, dynamic> bal = balances[idx];
          debugPrint('line 715: ${bal}');
          bal['balance'] += balance;
          balances[idx] = bal;
        }
      });
      return {'balances': balances, 'totalCurrentBalance': totalCurrentBalance};
    } catch (e) {
      debugPrint('line 720 error $e');
      throw Exception('Error getting aging data');
    }
  }

  Future<String> updateClientUserFromItself(
      Map<String, dynamic> clt, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .doc(uid)
          .set(clt, SetOptions(merge: true));
      return "Success";
    } catch (e) {
      debugPrint('line 926 error getting users: ${e.toString()}');
      return "Error: ${e.toString()}";
    }
  }

  Future<bool> insertClientUserX(Map<String, dynamic> obj) async {
    try {
      debugPrint('line 999: ${obj}');
      String email = obj['email'];
      String password = obj['password'];

      UserCredential dyn = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      debugPrint('line 1738: $dyn');
      if (dyn.user == null) {
        debugPrint('line 2259: $email $password');
        throw Exception('line 937: dyn is null');
      }

      debugPrint('line 1744: ${dyn.user!.uid} ');
      String uid = dyn.user!.uid;
      debugPrint('line 1746 uid: ${uid}');
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .doc(uid)
          .set(obj);
      return true;
    } catch (e) {
      debugPrint('line 926 error getting users: ${e.toString()}');
      return false;
    }
  }

  Future<bool> updateTheClientContact(
      String documentId, Map<String, dynamic> obj) async {
    try {
      await FirebaseFirestore.instance
          .collection('ClientContact')
          .doc(documentId)
          .update(obj);
      return true;
    } catch (e) {
      debugPrint('line 937 error getting users: ${e.toString()}');
      return false;
    }
  }

  Future<bool> updateTheClientAddress(
      String documentId, Map<String, dynamic> obj) async {
    try {
      await FirebaseFirestore.instance
          .collection('ClientAddress')
          .doc(documentId)
          .update(obj);
      return true;
    } catch (e) {
      debugPrint('line 937 error getting users: ${e.toString()}');
      return false;
    }
  }

  Future<bool> updateTheClientUser(Map<String, dynamic> obj) async {
    debugPrint('line 1052 $obj');
    try {
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .doc(obj['id'])
          .set(obj, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint('line 937 error getting users: ${e.toString()}');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getClientUsers(int clientId) async {
    List<Map<String, dynamic>> listCls = [];
    try {
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .where('clientId', isEqualTo: clientId)
          .orderBy('genId', descending: false)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          obj['id'] = docSnapshot.id;
          listCls.add(obj);
        }
      });
      debugPrint('line 1062: ${listCls.length} ');
      return listCls;
    } catch (e) {
      debugPrint('line 926 error getting users: ${e.toString()}');
      return [];
    }
  }

  Future<Map<String, dynamic>> checkForCanceledWorkOrder(int clientId,
      disciplineName, String dcxId, String shiftCode, int shiftCount) async {
    bool bl = false;
    Map<String, dynamic> tvs = {
      'shiftCount': 0,
      'hasScheduledHCPs': false,
      'status': 'No Data'
    };
    debugPrint('line 860 check for cancel work order');
    try {
      DateTime dms = DateTime.now();
      dms = dms.subtract(Duration(
          hours: dms.hour,
          minutes: dms.minute,
          seconds: dms.second,
          microseconds: dms.microsecond,
          milliseconds: dms.millisecond));
      double shiftCount = 0.0;
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('clientId', isEqualTo: clientId)
          .where('dates.shiftDateInfo.shiftCode', isEqualTo: shiftCode)
          .where('shiftStatus', isEqualTo: 'Open')
          .where('disciplineName', isEqualTo: disciplineName)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          debugPrint('line 1066: $dcxId $docSnapshot.id');
          if (dcxId == docSnapshot.id) {
            continue;
          }
          var obj = docSnapshot.data();

          Timestamp tms = obj['shiftDate'];
          DateTime tmd = tms.toDate();
          tmd = tmd.subtract(Duration(
              hours: tmd.hour,
              minutes: tmd.minute,
              seconds: tmd.second,
              microseconds: tmd.microsecond,
              milliseconds: tmd.millisecond));
          if (tmd.millisecondsSinceEpoch == dms.millisecondsSinceEpoch) {
            int sct = obj['shiftCount'];
            sct += int.parse(shiftCount.toString());
            debugPrint('line 903: $sct ${obj['shiftCount']}');
            tvs['status'] = 'WriteCWO';
            tvs['shiftCount'] = sct;
            tvs['hasScheduledHCPs'] = true;
            debugPrint('line 906: $tvs $sct');
            return tvs;
          }
        }
      });
      bool flagGotSomeData = false;
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('clientId', isEqualTo: clientId)
          .where('dates.shiftDateInfo.shiftCode', isEqualTo: shiftCode)
          .where('shiftStatus', isNotEqualTo: 'Open')
          .where('disciplineName', isEqualTo: disciplineName)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (dcxId == docSnapshot.id) {
            continue;
          }
          var obj = docSnapshot.data();
          Timestamp tms = obj['shiftDate'];
          DateTime tmd = tms.toDate();
          tmd = tmd.subtract(Duration(
              hours: tmd.hour,
              minutes: tmd.minute,
              seconds: tmd.second,
              microseconds: tmd.microsecond,
              milliseconds: tmd.millisecond));
          if (tmd.millisecondsSinceEpoch == dms.millisecondsSinceEpoch) {
            tvs['shiftHasHCPs'] = true;
            tvs['status'] = 'CreateCWO';
            tvs['shiftCount'] = shiftCount;
            debugPrint('line 938');
            return tvs;
          }
        }
        tvs['hasScheduledHCPs'] = false;
        tvs['status'] = 'CreateCWO';
        tvs['shiftCount'] = shiftCount;
        return tvs;
      });
      return tvs;
    } catch (e) {
      debugPrint('line 889: ${e.toString()}');
      return tvs;
    }
  }

  Future<dynamic>? createSchedulingWorkOrder(
      List<dynamic> listOfDatesWithShifts,
      String scheduleNotes,
      String pushNotificationFrequencyRate,
      int clientId,
      List<String> clientFCMTokens,
      bool payPremiumRate,
      int clientUserId,
      BuildContext ctx) async {
    debugPrint('line 1171 clentsvrcreatescheduline ${listOfDatesWithShifts.length}');
    debugPrint('line 1192: $clientUserId');
    List<Map<String, dynamic>> wosForCounts = [];
    List<Map<String, dynamic>> clArray = [];
    List<String> listClientWorkOrderIds = [];
    int totalScheduledShifts = 0;
    try {
      //  int payRateGroupId =  rt.rateGroupId;
      String specialRequirements = '';
      int count = 0;
      String? clientFcmToken;
      String? clientUserEmail;
      Map<String, dynamic> mp = {};
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .where('clientId', isEqualTo: clientId)
          .where('clientUserId', isEqualTo: clientUserId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final rls = docSnapshot.data();
          rls['clientUserId'] = clientUserId;
          if (rls['Roles'] != null) {
            rls['roles'] = rls['Roles'];
          }
          clientUserEmail = rls['email'];
          clientFcmToken =
              rls['fcmToken'] == null ? 'Placeholder' : rls['fcmToken'];
          for (var j = 0; j < rls['roles'].length; j++) {
            var ro = rls['roles'][j];
            if (ro == 'ClientAdmin' ||
                ro == 'Administrator' ||
                ro == 'CMSAdmin' ||
                ro == 'ClientSupervisor') {
              mp['role'] = ro;
              mp['clientUserId'] = rls['genId'];
              break;
            }
          }
        }
      });
      debugPrint('line 1204 check $mp');
      if (mp.isEmpty) {
        throw Exception('Did not get a Clientuser');
      }
      await FirebaseFirestore.instance
          .collection('ClientInstructions')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          if (obj['details'] != null) {
            if (count > 0) {
              specialRequirements += "\r\n";
            }
            specialRequirements += obj['details'];
            count += 1;
          }
        }
      });
      debugPrint('line 1221: ${listOfDatesWithShifts[0]}');
      List<dynamic>? ldDepartments;
      debugPrint('line 1223: ${listOfDatesWithShifts[0]['departmentIds']}');
      ldDepartments = listOfDatesWithShifts[0]['departments'];
      debugPrint('line 1205 ${ldDepartments}');
      int departmentId = ldDepartments![0]['departmentId'];
      if (departmentId == 0) {
        throw Exception('line 1176 DepartmentId == 0');
      }
      String departmentName = ldDepartments[0]['departmentName'];
      String departmentNumber = ldDepartments[0]['departmentNumber'];
      debugPrint('line 1212 check');
      int workersCompCodeId = listOfDatesWithShifts[0]['workersCompCodeId'];
      debugPrint('line 1214 check');
      String workersCompType = listOfDatesWithShifts[0]['workersCompType'];
      if (listOfDatesWithShifts[0]['rateType'] == null ||
          listOfDatesWithShifts[0]['rateType'] == "") {
        listOfDatesWithShifts[0]['rateType'] = "Per Diem";
      }

      String rateType = listOfDatesWithShifts[0]['rateType'];
      if (listOfDatesWithShifts[0]['rateTypeCodeId'] == null) {
        listOfDatesWithShifts[0]['rateTypeCodeId'] = 2683;
      }
      int rateTypeCodeId = listOfDatesWithShifts[0]['rateTypeCodeId'];
      debugPrint('line 1226 check');
      List<dynamic>? ldDisciplines;
      ldDisciplines = listOfDatesWithShifts[0]['disciplines'];
      debugPrint('line 1229: ${ldDisciplines}');
      int disciplineId = ldDisciplines![0]['disciplineId'];
      String disciplineName = ldDisciplines[0]['disciplineName'];
      debugPrint('line 1232 check $clientId');
      Map<String, dynamic>? clientMap = await getClient(clientId);
      debugPrint('line 1234: ${clientMap!['clientId']} $clientMap');

      debugPrint('line 1236: clisvr createsched ${clientMap['orientation']}');

      //  List<ClientDepartment>?dps = fromClientDepartments;
      bool orientation = false;
      if (clientMap['orientation'] != null) {
        orientation = clientMap['orientation'];
      }
      List<dynamic> dps = listOfDatesWithShifts[0]['departments'];
      dynamic dp = dps[0];
      //bool useClientPayment = dp['useClientPayment'];
      debugPrint('line 1246 clisver create: $dp');
      //    int idx =-1;
      //   Map<String, dynamic>date;
      Map<String, dynamic> addr;
      //debug or testing 01/09/2025
      dp['useClientPhysicalAddress'] = true;
      if (dp['useClientPhysicalAddress'] == true) {
        List<Map<String, dynamic>>? addrs = [];
        await FirebaseFirestore.instance
            .collection('ClientAddress')
            .where('clientId', isEqualTo: clientId)
            .get()
            .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            final obj = docSnapshot.data();
            if (obj['addressType'] != 'Physical' &&
                obj['addressType'] != 'Primary') {
              continue;
            }

            addrs.add(obj);
            break;
          }
        });

        if (addrs.isNotEmpty) {
          addr = addrs[0];
        } else {
          // addr = {
          //   "city": null,
          //   "addressLine1": null,
          //   "addressLine2": null,
          //   "state": null,
          //   "zipCode": null
          // };
          debugPrint('line 1280 address is empty: $clientId');
          throw Exception('Address is empty for client: $clientId');
        }
      } else {
        addr = {
          "city": dp["mail_City"],
          "addressLine1": dp["mail_AddressLine1"],
          "addressLine2": dp["mail_AddressLine2"],
          "state": dp["mail_State"],
          "clientState": dp["mail_state"],
          "zipCode": dp["mail_ZipCode"],
          "latitude": dp["latitude"],
          "longitude": dp["longitude"],
          "timeZoneOffset": dp['timeZoneOffset']
        };
      }
      debugPrint('line 1295 clisver create: $addr');
      int? cClientId = clientMap['clientId'];
      int? cClientUserId = clientUserId;
      String? cClientName = clientMap['clientName'];
      int? cBranchId = clientMap['branchId'];
      String currentEmail = authServices.currentUser!['email'];
      String currentFcmToken = authServices.currentUser!['fcmToken'];
      String? cBranchName = clientMap['branchName'];
      // int? cDepartmentId = departmentId;
      //  String? cDDepartmentName = selectedDepartmentValue;
      //   int? cDisciplineId=  clientMap['disciplineId'];
      //   String? cDisciplineName = clientMap['disciplineName'];
      Map<String, dynamic>? cswo;
      // dynamic xr =
      //     listOfDatesWithShifts[listOfDatesWithShifts.length - 1]['rate'];
      // if (xr == null) {
      //   debugPrint('line 1308 last rate is null in listofdates is null');
      //   throw Exception('line 1309 debug exception');
      // }
      // dynamic rd = xr['rateDetails'];
      // debugPrint('line 1313: $xr');
      // debugPrint('line 1314: ${rd[rd.length - 1]}');
      // if (rd[rd.length - 1]['shiftCount'] == 0) {
      //   debugPrint('line 1315 last shift count = 0');
      //   throw Exception('line 1314 debug exception');
      // }
      Map<String, dynamic> clientSchedulingWorkOrder = {};
      var uuid = Uuid();
      debugPrint('line 1344: ${listOfDatesWithShifts.length}');
      for (int i = 0; i < listOfDatesWithShifts.length; i++) {
        debugPrint('line 1346 beginnng of i loop: $i');
        dynamic rt = listOfDatesWithShifts[i]['rate'];
        debugPrint('line 1402: ${rt}');
        debugPrint(
            'line 1350:  ${rt['rateDetails']} ${rt['rateDetails'][4]['shiftCode']} ${rt['rateDetails'][4]['shiftCount']}');

        rt['clientId'] = clientMap['clientId'];
        rt['clientName'] = clientMap['clientName'];
        rt['branchId'] = clientMap['branchId'];
        rt['branchName'] = clientMap['branchName'];
        debugPrint('line 1355 ${clientMap['clientUserId']}');
        if (mp['clientUserId'] != null) {
          rt['clientUserId'] = mp['clientUserId'];
        } else {
          rt['clientUserId'] = null;
        }
        if (clientUserId == 0) {
          clientUserId = mp['clientUserId'];
        }
        debugPrint('line 1361');
        workersCompCodeId = listOfDatesWithShifts[i]['workersCompCodeId'];
        debugPrint('line 1363');
        workersCompType = listOfDatesWithShifts[i]['workersCompType'];
        debugPrint('line 1365');
        if (listOfDatesWithShifts[i]['rateType'] == '' ||
            listOfDatesWithShifts[i]['rateType'] == null) {
          rateType = 'Per Diem';
        } else {
          rateType = listOfDatesWithShifts[i]['rateType'];
        }
        debugPrint('line 1372');
        if (listOfDatesWithShifts[i]['rateTypeCodeId'] != null) {
          rateTypeCodeId = listOfDatesWithShifts[i]['rateTypeCodeId'];
        } else {
          rateTypeCodeId = 2683;
        }
        debugPrint('line 1378');
        listOfDatesWithShifts[i]['rate'] = rt;
        dynamic ld = listOfDatesWithShifts[i];
        debugPrint(
            'line 1382: ${ld['payHolidayRate']}  ${ld['overridePayModifiers']}');
        debugPrint(
            'line 1384 ${rt['overridePayModifiers']} ${rt['rateDetails'][0]['payRate']} ${rt['rateDetails'][0]['isAHoliday']}');

        debugPrint('line 1386: ${clientMap} ${clientMap['payHolidayRate']}');
        // for (int z = 0; z < rt['rateDetails'].length; z++) {
        //   //     debugPrint('line 1324: $z ${rt['rateDetails'][z]}');
        //   if (rt['rateDetails'][z]['isAHoliday'] != null &&
        //       rt['rateDetails'][z]['isAHoliday'] == true) {
        //     if (rt['overridePayModifiers'] == false) {
        //       rt['rateDetails'][z]['payRate'] *= clientMap['payHolidayRate'];
        //       rt['rateDetails'][z]['payRateWE'] *= clientMap['payHolidayRate'];
        //       rt['rateDetails'][z]['billRate'] *=
        //           clientMap['billingHolidayRate'];
        //       rt['rateDetails'][z]['billRateWE'] *=
        //           clientMap['billingHolidayRate'];
        //     } else {
        //       debugPrint('line 1399');
        //       if (rt['payHolidayRate'] == null || rt[['payHolidayRate']] == 0) {
        //         rt['payHolidayRate'] = 1.5;
        //       }
        //       rt['rateDetails'][z]['payRate'] *= rt['payHolidayRate'];
        //       rt['rateDetails'][z]['payRateWE'] *= rt['payHolidayRate'];
        //       rt['rateDetails'][z]['billRate'] *= rt['billHolidayRate'];
        //       rt['rateDetails'][z]['billRateWE'] *= rt['billHolidayRate'];
        //     }
        //   }
        //   debugPrint(
        //       'line 1410 $z ${rt['rateDetails'][z]['payRate']} ${rt['rateDetails'][z]['payRateWE']} ${clientMap['payHolidayRate']} ${rt['payHolidayRate']}');
        // }

        //next two linees need to be correct to correction wit tlis date
        DateTime curd = ld['date'];
        DateTime dtm = DateTime.now();
        Timestamp createdDate = Timestamp.fromDate(dtm);
        curd = curd.subtract(Duration(
            hours: curd.hour,
            minutes: curd.minute,
            seconds: curd.second,
            microseconds: curd.microsecond,
            milliseconds: curd.millisecond));
        debugPrint(
            'line 1422: $curd ${clientMap['payHolidayRate']} ${rt['rateDetails'][0]['payRate']}');

        clientSchedulingWorkOrder['rateGroupId'] = rt['rateGroupId'];

        //   clientSchedulingWorkOrder['rateTypeCode'] = rt.rateType;
        //  clientSchedulingWorkOrder['rateTypeDescription'] = rt.rateTypeDescription'];
        clientSchedulingWorkOrder['userId'] = 0;
        clientSchedulingWorkOrder['clientFcmTokens'] = clientFCMTokens;
        clientSchedulingWorkOrder['clientUserId'] = clientUserId;
        clientSchedulingWorkOrder['clientUserEmail'] = clientUserEmail;
        clientSchedulingWorkOrder['hcpFcmTokens'] = ['Placeholder'];
        clientSchedulingWorkOrder['email'] = currentEmail;
        clientSchedulingWorkOrder['rateType'] = rt['rateType'];
        clientSchedulingWorkOrder['clientId'] = clientMap['clientId'];
        clientSchedulingWorkOrder['clientUserId'] = cClientUserId;
        clientSchedulingWorkOrder['clientName'] = clientMap['clientName'];
        clientSchedulingWorkOrder['createdDate'] =
            Timestamp.fromDate(DateTime.now());
        clientSchedulingWorkOrder['departmentId'] = departmentId;
        clientSchedulingWorkOrder['departmentName'] = departmentName;
        clientSchedulingWorkOrder['departmentNumber'] = departmentNumber;
        clientSchedulingWorkOrder['schedulerId'] = rt['schedulerId'];
        clientSchedulingWorkOrder['schedulerName'] = rt['schedulerName'];
        clientSchedulingWorkOrder['branchId'] = clientMap['branchId'];
        clientSchedulingWorkOrder['branchName'] = clientMap['branchName'];
        clientSchedulingWorkOrder['weekStartDay'] = clientMap['weekStartDay'];
        clientSchedulingWorkOrder['disciplineCodes'] = disciplineId;
        clientSchedulingWorkOrder['disciplineName'] = disciplineName;
        clientSchedulingWorkOrder['disciplineNames'] = [disciplineName];
        clientSchedulingWorkOrder['disciplineIds'] = [disciplineId];
        clientSchedulingWorkOrder['premiumRate'] = 1.0;
        clientSchedulingWorkOrder['scheduleNotes'] = scheduleNotes;
        clientSchedulingWorkOrder['clientFCMToken'] = currentFcmToken;
        clientSchedulingWorkOrder['overridePayModifiers'] =
            ld['overridePayModifiers'];
        clientSchedulingWorkOrder['overrideBillModifiers'] =
            ld['overrideBillModifiers'];

        double latitude = 0.0;
        double longitude = 0.0;
        if (clientMap['latitude'] == null || clientMap['latitude'] == 0.0) {
          throw Exception('No geofencing information available');
        } else {
          if (clientMap['longitude'] == null || clientMap['longitude'] == 0.0) {
            throw Exception('No geofencing information available');
          }
        }
        latitude = clientMap['latitude'];
        longitude = clientMap['longitude'];
        if (dp['latitude'] > 0) {
          debugPrint('line 1532 got dept lat');
          latitude = dp['latitude'];
          longitude = dp['longitude'];
          }
        debugPrint(
            'line 1443 clisver createsched $latitude, $longitude ${addr['state']}');
        clientSchedulingWorkOrder['latitude'] = latitude;
        clientSchedulingWorkOrder['longitude'] = longitude;
        clientSchedulingWorkOrder['hcpId'] = 0; //cannot be a value
        clientSchedulingWorkOrder['hcpName'] = '';
        clientSchedulingWorkOrder['charge'] = false;
        clientSchedulingWorkOrder['burden'] = rt['burden'];
        clientSchedulingWorkOrder['orderId'] = rt['orderId'];
        clientSchedulingWorkOrder['contract'] = rt['contract'];
        clientSchedulingWorkOrder['workersCompCodeId'] = workersCompCodeId;
        clientSchedulingWorkOrder['workersCompType'] =
            workersCompType; // rt['workersCompType'];
        clientSchedulingWorkOrder['rateType'] =
            rateType; // rt['workersCompType'];
        clientSchedulingWorkOrder['rateTypeCodeId'] =
            rateTypeCodeId; // rt['workersCompType'];
        clientSchedulingWorkOrder['quoteId'] = rt['quoteId'];
        clientSchedulingWorkOrder['rateGroupTypeCodeId'] =
            rt['rateGroupTypeCodeId'];
        clientSchedulingWorkOrder['rateGroupTypeName'] =
            rt['rateGroupTypeName'];
        clientSchedulingWorkOrder['rateGroupTypeValue'] =
            rt['rateGroupTypeValue'];
        clientSchedulingWorkOrder['contractTemplateName'] =
            rt['contractTemplateName'];
        clientSchedulingWorkOrder['state'] = addr['state'];
        clientSchedulingWorkOrder['specialRequirements'] = null;
        clientSchedulingWorkOrder['usePremiumRate'] = payPremiumRate;
        clientSchedulingWorkOrder['orientation'] = orientation;
        clientSchedulingWorkOrder['clientCity'] = addr['city'];
        clientSchedulingWorkOrder['addressLine1'] = addr['addressLine1'];
        clientSchedulingWorkOrder['addressLine2'] = addr['addressLine2'];
        clientSchedulingWorkOrder['clientState'] = addr['state'];
        clientSchedulingWorkOrder['zipCode'] = addr['zipCode'];
        clientSchedulingWorkOrder['orderTypeOrderId'] = null;
        clientSchedulingWorkOrder['specialRequirements'] = specialRequirements;
        clientSchedulingWorkOrder['dates'] = [];
        debugPrint('line 1480');
        cswo = Map.from(clientSchedulingWorkOrder);

        //  Map<String, dynamic>?ls;

        //  List<dynamic>shifts = List.from(listOfDatesWithShifts[i]['shifts']);
        List<dynamic> rateDetails = rt['rateDetails'];
        debugPrint('line 1487: ${rateDetails.length}');
        dynamic rate = listOfDatesWithShifts[i]['rate'];

        // for (int k = 0; k < rateDetails.length; k++) {
        //   var v4 = uuid.v4();
        //   dynamic rd = rateDetails[k];
        //   debugPrint('line 1493 $k  $rd');
        //   if (rd['startTime'] == null) {
        //     continue;
        //   }
        //   if (rd['shiftCount'] == 0) {
        //     continue;
        //   }
        //
        //   debugPrint('line 1501: $cBranchId $cBranchName $cClientId, $cClientName');
        //   debugPrint('line 1502: $disciplineId $disciplineName ${ld['date']}');
        // //   Map<String, dynamic> clientPublishedSchedule = {
        //     "uuid": v4,
        //     "clientId": cClientId,
        //     "clientName": cClientName,
        //     "branchId": cBranchId,
        //     "branchName": cBranchName,
        //     "departmentId": departmentId,
        //     "departmentName": departmentName,
        //     "disciplineId": disciplineId,
        //     "disciplineName": disciplineName,
        //     "shiftDate": ld['date'],
        //     "shiftId": rd['shiftCode'] == 'AP'
        //         ? 4
        //         : rd['shiftCode'] == 'PA'
        //             ? 5
        //             : int.tryParse(rd['shiftCode']),
        //     "shiftCode": rd['shiftCode'],
        //     "startTime": rd['startTime'],
        //     "endTime": rd['endTime'],
        //     "originalStartTime": rd['startTime'],
        //     "originalEndTime": rd['endTime'],
        //     "hcpRequired": rd['shiftCount'],
        //     "shiftCount": rd['shiftCount'],
        //     "hcpScheduled": 0,
        //     "status": "Open" //Open, Canceled, Scheduled
        //   };
        //   await FirebaseFirestore.instance
        //       .collection('ClientPublishedSchedule')
        //       .doc()
        //       .set(clientPublishedSchedule);
        // }

        debugPrint('line 1533 clisvr create: $i ${cswo}');
        // Map<String,dynamic>ld = Map.from(listOfDatesWithShifts[j]);
        //  List<dynamic>listOfShifts = List.from(listOfDatesWithShifts[j]['shifts']);
        List<dynamic> rtd = rateDetails;
        debugPrint('line 1537: ${rtd.length}');
        Map<String, dynamic> ccl = {};
        for (int k = 0; k < rtd.length; k++) {
          debugPrint('line 1539 start of k loop');
          clArray = [];
          String hour =
              util.getHoursString(rtd[k]['startTime'], rtd[k]['endTime']);
          debugPrint('line 1543: $k $hour');
          rtd[k]['hour'] = hour;
          if (rtd[k]['shiftCount'] == 0) {
            continue;
          }
          debugPrint('line 1545: ${rtd[k]['shiftCount']} ${rtd[k]['hour']}');
          var v4 = uuid.v4();
          cswo['uuid'] = v4;
          debugPrint('line 1548 $v4 ${cswo['uuid']}');
          if (rtd[k]['startTime'] == null) {
            continue;
          }
          debugPrint('line 1552:${rtd.length} $k ${rtd[k]['shiftCount']}');

          debugPrint('line 1556: ${rtd[k]['shiftCount']}');
          int shiftCount = rtd[k]['shiftCount'];
          debugPrint(
              'line 1559: ${rtd[k]['shiftCount']} ${rtd[k]['startTime']} ${rtd[k]['endTime']} ${rtd[k]['meals']}');
          double dvv = util.getHours(
              rtd[k]['startTime'], rtd[k]['endTime'], rtd[k]['meals']);
          debugPrint('line 1562: ${dvv.toStringAsFixed(2)}');
          rtd[k]['hours'] = dvv.toStringAsFixed(2);
          debugPrint(
              'line 1524: $k ${rtd[k]['shiftCode']}  ${rtd[k]['shiftCount']}');
          //  clientSchedulingWorkOrder = Map.from(cswo);
          rtd[k]['hour'] = hour;
          debugPrint('line 1568: ${rtd[k]['hour']}');
          dynamic shiftDetail = rtd[k];

          //get rate group;d
          debugPrint('line 1572: $rtd');
          int ckv = -1;
          String queryShiftCode = shiftDetail['shiftCode'].toString();

          Map<String, dynamic> si = {
            "shiftDate": listOfDatesWithShifts[i]['date'],
            "weekend": listOfDatesWithShifts[i]['weekend'] ? true : false,
            "holiday": listOfDatesWithShifts[i]['holiday'] ? true : false,
            "dayValue": listOfDatesWithShifts[i]['dayValue'],
            "shiftCode": shiftDetail['shiftCode'].toString(),
            "startTime": shiftDetail['startTime'].toString(),
            "endTime": shiftDetail['endTime'].toString(),
            'createdDate': createdDate,
            "statusId": 'O',
            "rateType": 'Per Diem',
            "overridePayModifiers": listOfDatesWithShifts[i]
                ["overridePayModifiers"],
            'overrideBillModifiers': listOfDatesWithShifts[i]
                ["overrideBillModifiers"],
            'payOTRate': clientMap['payOTRate'],
            'margin': shiftDetail['margin'],
            'marginWE': shiftDetail['marginWE']
          };
          debugPrint('line 1590 clisvr createsched $si $shiftDetail ');

          Map<String, dynamic> date = {};
          //  Map<String,dynamic> rts = {};
          debugPrint(
              'line 1621: ${si['overridePayModifiers']}  ${si['overrideBillModifiers']}');
          debugPrint('line 1634: ${rtd} ${rate['billingRate']} ${rate['rateType']}');

          debugPrint('line 1625 using client money rates');
          cswo['payOTRate'] = rt['payOTRate'];
          cswo["payOTPlusRate"] = rt['payOTPlusRate'];
          cswo["payDblRate"] = rt['payDblRate'];
          cswo["payDblPlusRate"] = rt['payDblPlusRate'];
          cswo["payHolidayRate"] = rt['payHolidayRate'];
          cswo["payHolidayPlusRate"] = rt['payHolidayPlusRate'];
          cswo["payMaxRate"] = rt['payMaxRate'];
          cswo["payMaxPlusRate"] = rt['payMaxPlusRate'];
          cswo["billOTRate"] = rt['billOTRate'];
          cswo["billOTPlusRate"] = rt['billOTPlusRate'];
          cswo["billDblRate"] = rt['billDblRate"'];
          cswo["billDblPlusRate"] = rt['billDblPlusRate'];
          cswo["billHolidayRate"] = rt['billHolidayRate'];
          cswo["billHolidayPlusRate"] = rt['billHolidayPlusRate'];
          cswo["billMaxRate"] = rt['billMaxRate'];
          cswo["billMaxPlusRate"] = rt['billMaxPlusRate'];
          cswo['facilityCancelLimit'] = ['facilityCancelLimit'];
          cswo['facilityCancelCharge'] = dp['facilityCancelCharge'];
          cswo['agencyCancelLimit'] = dp['agencyCancelLimit'];
          cswo['agencyCancelCredit'] = dp['agencyCancelCredit'];

          cswo['shiftApprovalNote'] = null;
          cswo['shiftCanceled'] = false;
          cswo['shiftCanceledActionDate'] = null;
          cswo['shiftCanceledById'] = null;
          cswo['shiftCanceledByName'] = null;
          cswo['shiftCanceledNote'] = null;
          cswo['shiftStatus'] = "Open";
          cswo['shiftStatusDate'] = Timestamp.fromDate(DateTime.now());
          cswo['pushNotificationFrequencyRate'] = pushNotificationFrequencyRate;
          cswo['clientFCMToken'] = clientFcmToken;

          debugPrint('line 1694 $k ${rtd[k]['shiftCount']}');
          shiftCount = rtd[k]['shiftCount'];
          // if (rate['departments'] == null) {
          //   Map<String,dynamic> mp = {
          //     'departmentId': selectedDepartmentId,
          //     'departmentName': selectedDepartmentValue
          //   };
          //   rate['departments'] = [mp];
          //   debugPrint('line 1566: ${rate['departments']}');
          // } else {
          //   if (rate['departments']['departmentId'] == 0) {
          //     rate['departments']['departmentId'] = selectedDepartmentId;
          //     rate['departments']['departmentName'] = selectedDepartmentValue;
          //   }
          //
          rate['scheduledRateDetails'] = null;
          debugPrint('line 1769: ${rate}');
          Map<String, dynamic> dts = {"rates": rate, "shiftDateInfo": si};
          cswo['dates'] = dts;
          debugPrint('line 1770: ${cswo['dates']}');
          ccl = Map.from(cswo);
          debugPrint('line 1771: ${ccl['workOrderId']} ${ccl['woWorkOrderId']} ');
          Map<String, dynamic> sii = Map.from(si);
          debugPrint('line 1773: ${sii}');
          sii['indexValue'] = false;
          date['shiftDateInfo'] = Map.from(sii);
          rate['rateDetails'] = Map.from(shiftDetail);
          date['rates'] = Map.from(rate);
          debugPrint('line 1778: ${date} $rate');
          //       clArray.add(clientSchedulingWorkOrder);
          debugPrint('line 1779: ${ccl['dates']}');

          debugPrint(
              'line 1782: $shiftCount ${ccl['clientId']} $disciplineName $queryShiftCode');

          for (int s = 0; s < shiftCount; s++) {
            Map<String, dynamic> xbj = Map.from(ccl);
            xbj['dates']['shiftDateInfo']['shiftCount'] = shiftCount;
            xbj['dates']['shiftDateInfo']['shiftSequence'] = s + 1;
            xbj['dates']['shiftDateInfo']['indexValue'] = false;
            xbj['indexValue'] = false;
            if (s > 0) {
              xbj['dates']['shiftDateInfo']['indexValue'] = true;

              xbj['indexValue'] = true;
            }
            debugPrint('line 1792 ${xbj}');
            Map<String, dynamic> asmwo =
                convertClientWorkOrderToAsmWorkOrder(xbj);
            debugPrint('line 1795 ${asmwo}');
            dynamic result = await hts.callCreateMobileWOFunction(asmwo, ctx);
            debugPrint('line 1788: $result');
            if (result != null) {
              String workOrderIdUuid = uuid.v4();
              String woWorkOrderId = uuid.v4();
              xbj['orderId'] = result;
              xbj['workOrderId'] = result.toString();
              xbj['workOrderIdUuid'] = workOrderIdUuid;
              xbj['woWorkOrderId'] = woWorkOrderId;
              xbj['bookShift'] = true;
              xbj['isGPOClient'] = false;
              xbj['clientUserId'] =
                  mp['clientUserId'] == null ? 0 : mp['clientUserId'];
              xbj['flagShowPushNotifications'] =
                  pushNotificationFrequencyRate == 'None' ? false : true;
              xbj['clientHCPWorkOrderId'] = result.toString();
              xbj['asmWorkOrderId'] = int.parse(result.toString());
              xbj['orderId'] = int.parse(result.toString());
              xbj['shiftCount'] = xbj['dates']['shiftDateInfo']['shiftCount'];
              await FirebaseFirestore.instance
                  .collection('ClientWorkOrder')
                  .doc(result.toString())
                  .set(xbj);

              Map<String, dynamic> hobj = convertObjToHbj(xbj);
              hobj['workOrderId'] = xbj['workOrderId'];
              listClientWorkOrderIds.add(xbj['workOrderId']);
              hobj['woWorkOrderId'] = woWorkOrderId;
              hobj['woWorkOrderIdUuid'] = workOrderIdUuid;
              debugPrint('line 1799: ${hobj['workOrderId']}');
              await FirebaseFirestore.instance
                  .collection('ClientHCPWorkOrder')
                  .doc()
                  .set(hobj);
            }
            debugPrint('line 1740 check');
          }
        }
        int sfc =
            int.parse(ccl['dates']['shiftDateInfo']['shiftCount'].toString());
        debugPrint(
            'line 1855: ${pushNotificationFrequencyRate} $sfc ${totalScheduledShifts}');
        //     if (woWorkOrderId != null) {
        //       if (listClientWorkOrderIds.indexOf(woWorkOrderId!) == -1) {
        //         listClientWorkOrderIds.add(woWorkOrderId!);
        //       }
        //     }
        //   });
        // Map<String, dynamic> mp = {
        //   "clientId": ccl['clientId'],
        //   "uuid": ccl['uuid']
        // };
        // wosForCounts.add(mp);
        //   await FirebaseFirestore.instance
        //       .collection('ClientHCPWorkOrder')
        //       .doc()
        //       .set(hobj);
        //   Map<String, dynamic> initialObj = Map.from(ccl);
        //   clArray.add(initialObj);
        //   debugPrint('line 1831: ${clArray.length} ${shiftDetail}');
        //   debugPrint('line 1832 ${shiftDetail['shiftCount']}');
        //   for (int p = 1; p < shiftDetail['shiftCount']; p++) {
        //     debugPrint('line 1834: $p ${ccl['dates']['shiftDateInfo']}');
        //     dynamic six = ccl['dates']['shiftDateInfo'];
        //     six['indexValue'] = true;
        //     ccl['dates']['shiftDateInfo'] = six;
        //     ccl['workOrderId'] = workOrderId;
        //     ccl['woWorkOrderId'] = woWorkOrderId;
        //     debugPrint('line 1838 $workOrderId $woWorkOrderId');
        //     // cswo['dates'] = Map.from(date);
        //     clArray.add(ccl);
        //   }
        //   //      clArray.insert(0, ccl); // at index 0 we are adding A
        //   debugPrint('line 1843 ${clArray.length} ');
        //   debugPrint('line 1844: ${shiftDetail['shiftCount']}');
        //
        //   for (int p = 1; p < shiftDetail['shiftCount']; p++) {
        //     Map<String, dynamic> obj = clArray[p];
        //     debugPrint('line 1848: $i $p, ${obj['dates']}');
        //     debugPrint('line 1849:  ${obj['dates']['shiftDateInfo']}');
        //     String wid = uuid.v4();
        //     clientHCPWorkOrderId = uuid.v4();
        //     obj['workOrderId'] = workOrderId;
        //     obj['shiftCount'] = shiftDetail['shiftCount'];
        //     debugPrint('line 1854: ${obj['workOrderId']}');
        //     obj['woWorkOrderId'] = null;
        //     obj['clientHCPWorkOrderId'] = clientHCPWorkOrderId;
        //     String? wwo;
        //     await FirebaseFirestore.instance
        //         .collection('ClientWorkOrder')
        //         .add(obj)
        //         .then((DocumentReference doc) {
        //       wwo = doc.id;
        //     });
        //     debugPrint('line 1880: $wwo $wid');
        //     Map<String, dynamic> zbj = {
        //       'woWorkOrderId': wwo,
        //       'workOrderId': wwo
        //     };
        //     obj['woWorkOrderId'] = wwo;
        //     await FirebaseFirestore.instance
        //         .collection('ClientWorkOrder')
        //         .doc(wwo)
        //         .set(zbj, SetOptions(merge: true));
        //     Map<String, dynamic> hobj = convertObjToHbj(obj);
        //     hobj['workOrderId'] = workOrderId;
        //     hobj['woWorkOrderId'] = woWorkOrderId;
        //     await FirebaseFirestore.instance
        //         .collection('ClientHCPWorkOrder')
        //         .doc()
        //         .set(hobj);
        //   }
        // }
        debugPrint('line 1868');
      }
      //    }
      debugPrint('line 1858: ${listClientWorkOrderIds}');
      if (listClientWorkOrderIds.length == 0) {
        List<double> cnt = [0];
        return cnt;
      }
      double dCnt = double.parse(listClientWorkOrderIds.length.toString());
      List<double> cnt = [dCnt];
      return cnt;
//       debugPrint('line 1930: ${DateTime.now().second}');
//       double countOfScheduled = 0;
//       await Future.delayed(Duration(seconds: 5), () async {
//         debugPrint('line 1932: ${DateTime.now().second}');
//
//         await FirebaseFirestore.instance
//             .collection('ClientWorkOrderCampaign')
//             .where('woWorkOrderId', whereIn: listClientWorkOrderIds)
//             .get()
//             .then((querySnapshot) {
//           countOfScheduled =
//               double.parse(querySnapshot.docs.length.toStringAsFixed(0));
//           return;
//         });
//         debugPrint('line 1881: $countOfScheduled');
//         if (countOfScheduled == 0) {
//           await cleanUpSchedulingData(listClientWorkOrderIds);
//         }
//         return;
//       });
//       return [countOfScheduled];
    } catch (e) {
      debugPrint('line 1954 error: $e');
      List<double> cnt = [0];
      return cnt;
//      throw Exception('$e');
    }
  }

  Map<String, dynamic> convertClientWorkOrderToAsmWorkOrder(
      Map<String, dynamic> ccl) {
//     Timestamp tms = ccl['dates']['shiftDateInfo']['shiftDate'];
//     DateTime tm = tms.toDate();

    try {
      debugPrint('line 1984 in convert');
      DateTime tm = ccl['dates']['shiftDateInfo']['shiftDate'];
      String smonth = (tm.month).toString();
      String sday = (tm.day).toString();
      String syear = (tm.year).toString();
      String formattedShiftDate = '${smonth}/${sday}/${syear}';
      debugPrint('line 1990: ${formattedShiftDate}');
      Map<String, dynamic> asm = {
        "ExternalID": "9999999",
        "AnticipatedNeed": false,
        "ShiftDate": formattedShiftDate,
        "DeptID": ccl['departmentId'],
        "AreaID": null,
        "Caller": null,
        "PurchaseOrderID": null,
        "Skills": null,
        "DisciplineID": ccl['disciplineCodes'],
        "DisciplineID2": null,
        "SpecialtyID": null,
        "SpecialtyID2": null,
        "AdvertisedHourlyRate": 0.00,
        "AdvertisedHourlyRate2": 0.00,
        "VisibleAllRegsMobileApp": true,
        "RegID": null,
        "RateTypeCodeID": ccl['rateTypeCodeId'],
        "ShiftCode": ccl['dates']['shiftDateInfo']['shiftCode'],
        "WorkersCompCodeID": ccl['workersCompCodeId'],
        "workersCompType": 8833,
        "Charge": false,
        "StartTime": ccl['dates']['shiftDateInfo']['startTime'],
        "EndTime": ccl['dates']['shiftDateInfo']['endTime'],
        "Meals": ccl['dates']['rates']['rateDetails']['meals'],
        "Orientation": false,
        "TimeclockEarlyClockMinutes": 30,
        "InternalNote": "Ignore Client Generated",
        "InvoiceNote": "Ignore Client Generated",
        "OverrideRates": false,
        "PayRate": ccl['dates']['rates']['rateDetails']['payRate'],
        "PayRateWE": ccl['dates']['rates']['rateDetails']['payRateWE'],
        "BillRate": ccl['dates']['rates']['rateDetails']['billRate'],
        "BillRateWE": ccl['dates']['rates']['rateDetails']['billRateWE']
      };
      return asm;
    } catch (e) {
      debugPrint('line 2030: ${e.toString()}');
      return {};
    }
  }

  Future<void> cleanUpSchedulingData(List<String> lwos) async {
    //clientWorkOrderUuid of ClientPublishedSchedule maps to  ClientWorkOrder.uuid;
    //clientWorkOrderUuid of ClientScheduled maps to  ClientWorkOrder.uuid;
    //woWorkOrderId of ClientWorkOrderCampaign maps to ClientWorkOrder.woWorkOrderId
    //woWorkOrderId of ClientHCPWorkOrder maps to ClientWorkOrder.woWorkOrderId
    //1. remove ClientHCPWorkOrders
    List<String> listOfWos = [];
    await FirebaseFirestore.instance
        .collection('ClientWorkOrder')
        .where('woWorkOrderId', whereIn: lwos)
        .get()
        .then((querySnapshot) async {
      for (var snapshot in querySnapshot.docs) {
        var obj = snapshot.data();
        debugPrint('line 2011: ${snapshot.id}');
        String woWorkOrderId = snapshot.id;
        String uuid = obj['uuid'];
        debugPrint('line 2014: $uuid $obj');
        await FirebaseFirestore.instance
            .collection('ClientHCPWorkOrder')
            .where('woWorkOrderId', isEqualTo: woWorkOrderId)
            .get()
            .then((querySnapshot) async {
          for (var snapshot in querySnapshot.docs) {
            String docId = snapshot.id;
            await FirebaseFirestore.instance
                .collection('ClientHCPWorkOrder')
                .doc(docId)
                .delete();
          }
        });
        debugPrint('line 2044: $uuid');
        // await FirebaseFirestore.instance
        //     .collection('ClientPublishedSchedule')
        //     .where('uuid', isEqualTo: uuid)
        //     .get()
        //     .then((querySnapshot) async {
        //   for (var snapshot in querySnapshot.docs) {
        //     String docId = snapshot.id;
        //     await FirebaseFirestore.instance
        //         .collection('ClientPublishedSchedule')
        //         .doc(docId)
        //         .delete();
        //   }
        // });
        // // await FirebaseFirestore.instance
        //     .collection('ClientScheduled')
        //     .where('clientWorkOrderUuid', isEqualTo: uuid)
        //     .get()
        //     .then((querySnapshot) async {
        //   for (var snapshot in querySnapshot.docs) {
        //     String docId = snapshot.id;
        //     await FirebaseFirestore.instance
        //         .collection('ClientScheduled')
        //         .doc(docId)
        //         .delete();
        //   }
        // });
      }
    });
    for (int i = 0; i < lwos.length; i++) {
      String docId = lwos[i];
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .doc(docId)
          .delete();
    }
    return;
  }

  DateTime getFirestoreDateTime(dynamic gms) {
    try {
      return gms;
    } catch (e) {
      DateTime td = gms.toDate();
      return td;
    }
  }

  Future<Map<String, dynamic>> getScheduledCount(
      Map<String, dynamic> action, BuildContext ctx) async {
    debugPrint('line 1845 ${action['clientId']} ${action['uuid']}');

    try {
      Map<String, dynamic> response =
          await callGetClientSchedulingStatsFunction(action['uuid'], ctx);
      debugPrint('line 1856: $response');
      return response;
    } catch (e) {
      debugPrint('line 1839 error in getting schedule count: ${e.toString()}');
      return {};
    }
  }

  Future<Map<String, dynamic>> callGetClientSchedulingStatsFunction(
      String clientWorkOrderUuid, BuildContext ctx) async {
    debugPrint('line 1866 cwou: $clientWorkOrderUuid');
    Map<String, dynamic>? mp;
    try {
      await Future.delayed(Duration(seconds: 10), () async {
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'getSchedulingStats05',
          options: HttpsCallableOptions(
            timeout: const Duration(seconds: 300),
          ),
        );
        debugPrint('line 1416: just before calling retrieve client wos');
        Map<String, dynamic> result =
            await callingGetClientSchedulingStatsFunction(
                callable, clientWorkOrderUuid, ctx);
        debugPrint('line 1879: $result');
        if (result['data'] is String) {
          debugPrint('line 1881: Error getting htc id to asm');
          throw Exception('No matching documents');
        }
        debugPrint('line 1884 successfully retrieved htc');
        mp = result;

        return;
      });
      debugPrint('line 1890: $mp');
      return mp!;
    } catch (e) {
      debugPrint('line 1890 $e');
      throw Exception('line 81: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> callingGetClientSchedulingStatsFunction(
      HttpsCallable callable,
      String clientWorkOrderUuid,
      BuildContext ctx) async {
    debugPrint('line 1899: $clientWorkOrderUuid');
    try {
      var data = {
        "clientWorkOrderUuid": clientWorkOrderUuid,
      };
      final HttpsCallableResult result = await callable(data);
      debugPrint('line 1905 ${result.data}');
      var convertedResult = Map<String, dynamic>.from(result.data);
      return convertedResult;
    } catch (e) {
      debugPrint('line 1909 error: $e');
      throw Exception('line 98  ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getShiftsByClientAndDiscipline(
      int clientId, String disciplineDescription, rateGroupId) async {
    debugPrint('line 2127 doc: $clientId $disciplineDescription $rateGroupId');
    try {
      String val = '';
      int idx = disciplineDescription.indexOf('(');
      if (idx != -1) {
        val = disciplineDescription.substring(0, idx).trim();
      } else {
        val = disciplineDescription;
      }
      Map<String, dynamic> obj = {};
      Map<String, dynamic> holdObj = {};
      bool flagGotHit = false;
      int objCount = -1;

      Map<String, dynamic>? rateInstance;
      debugPrint('line 2177: ${rateInstance}');
      await FirebaseFirestore.instance
          .collection('ClientRateInstance')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.length > 0) {
          var snapShot = querySnapshot.docs[0];
          rateInstance = snapShot.data();
        }
      });
      debugPrint('ine 2187: ${rateInstance}');
      await FirebaseFirestore.instance
          .collection('ClientRate')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          obj = docSnapshot.data();
          objCount += 1;
          if (obj['rateType'] != 'Per Diem') {
            continue;
          }
          if (obj['rateTypeDescription'] != null) {
            if (obj['rateTypeDescription'].toLowerCase().contains('contract')) {
              debugPrint('line 2152: ${obj['rateTypeDescription']}');
              continue;
            }
          } else {
            obj['rateTypeDescription'] = obj['rateType'];
          }
          if (flagGotHit == true) {
            continue;
          }

          debugPrint('line 2215: ${flagGotHit}');
          for (int j = 0; j < obj['disciplines'].length; j++) {
            dynamic db = obj['disciplines'][j];
            if (flagGotHit == true) {
              continue;
            }
            debugPrint('line 2160: $val $db ${obj['rateGroupId']}, $rateGroupId');
            if (db['disciplineName'] == val &&
                obj['rateGroupId'] == rateGroupId) {
              debugPrint('line 2224: ${obj['departments']} $obj');
              flagGotHit = true;
              if (obj['rates'][0]['overridePayModifiers']! == false) {
                debugPrint('line 2227 ${rateInstance}');
                if (rateInstance != null) {
                  obj['rates'][0]['payDblPlusRate'] =
                      rateInstance!['payDblPlusRate'];
                  obj['rates'][0]['payDblRate'] = rateInstance!['payDblRate'];
                  obj['rates'][0]['payHolidayPlusRate'] =
                      rateInstance!['payHolidayPlusRate'];
                  obj['rates'][0]['payHolidayRate'] =
                      rateInstance!['payHolidayRate'];
                  obj['rates'][0]['payMaxPlusRate'] =
                      rateInstance!['payMaxPlusRate'];
                  obj['rates'][0]['payMaxRate'] = rateInstance!['payMaxRate'];
                  obj['rates'][0]['payOTPlusRate'] =
                      rateInstance!['payOTPlusRate'];
                  obj['rates'][0]['payOTRate'] = rateInstance!['payOTRate'];
                }
              }
              if (obj['rates'][0]['overrideBillModifiers']! == false) {
                debugPrint('line 2245: ${rateInstance}');
                if (rateInstance != null) {
                  obj['rates'][0]['billDblPlusRate'] =
                      rateInstance!['billDblPlusRate'];
                  obj['rates'][0]['billDblRate'] = rateInstance!['billDblRate'];
                  obj['rates'][0]['billHolidayPlusRate'] =
                      rateInstance!['billHolidayPlusRate'];
                  obj['rates'][0]['billHolidayRate'] =
                      rateInstance!['billHolidayRate'];
                  obj['rates'][0]['billMaxPlusRate'] =
                      rateInstance!['billMaxPlusRate'];
                  obj['rates'][0]['billMaxRate'] = rateInstance!['billMaxRate'];
                  obj['rates'][0]['billOTPlusRate'] =
                      rateInstance!['billOTPlusRate'];
                  obj['rates'][0]['billOTRate'] = rateInstance!['billOTRate'];
                }
              }
            }
            debugPrint('line 2263: ${obj}');
            holdObj = Map.from(obj);
            // if (flagGotHit == true) {
            //   break;
            // }
          }
          debugPrint('line 2268: ${obj}');
        }
      });
      obj = Map.from(holdObj);
      List<dynamic> rds = [];
      if (flagGotHit == true) {
        List<String> lTimes = ['1', '2', '3', 'AP', 'PA'];
        List<dynamic> rd = obj['rates'][0]['rateDetails'];
        for (int q = 0; q < rd.length; q++) {
          dynamic rdt = rd[q];
          if (lTimes.indexOf(rdt['shiftCode']) == -1) {
            debugPrint('line 2188 ${rdt['shiftCode']}');
            // if (rdt['startTime'] == null) {
            //   continue;
            // }
            continue;
          }
          debugPrint('line 2193');
          if (rdt['startTime'] == null) {
            continue;
          }
          rds.add(rdt);
        }
        if (rds.length == 0) {
          throw Exception('Invalid data in the rate table');
        }
      } else {
        throw Exception('Invalid data in the rate table');
      }
      obj['rates'][0]['rateDetails'] = rds;
      flagGotHit = true;
      debugPrint('line 2207 $obj');
      return obj;
    } catch (e) {
      debugPrint('line 2218 error: $e');
      throw Exception('Error ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>>? getListOfHolidays(int clientId) async {
    List<Map<String, dynamic>> listOfHolidays = [];
    await FirebaseFirestore.instance
        .collection('ClientHoliday')
        .where('clientId', isEqualTo: clientId)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        final obj = docSnapshot.data();
        var docId = docSnapshot.id;
        obj['id'] = docId;
        listOfHolidays.add(obj);
      }
    });
    return listOfHolidays;
  }

  Future<List<Map<String, dynamic>>>? getDisciplinesFromClientRates(
      int clientId) async {
    debugPrint('line 2231 in get disciplines from client rates $clientId');
    try {
      List<Map<String, dynamic>> lstm = [];
      List<String> listNms = [];
      List<int> generatedCount = [0, 0, 0];
      List<String> generatedDisciplines = ['CNA', 'LPN', 'RN'];
      await FirebaseFirestore.instance
          .collection('ClientRate')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          var docId = docSnapshot.id;
          debugPrint('line 2245: $docId');
          obj['id'] = docId;
          if (obj['hcpId'] > 0) {
            continue;
          }
          if (obj['rateType'] != 'Per Diem') {
            continue;
          }
          if (obj['rateType'] != null) {
            if (obj['rateType'].toLowerCase().contains('contract')) {
              continue;
            }
          } else {
            obj['rateTypeDescription'] = obj['rateType'];
          }
          int disciplineIndex = -1;
          if (obj['disciplines'] != null && obj['disciplines'].length > 0) {
            for (int j = 0; j < obj['disciplines'].length; j++) {
              dynamic db = obj['disciplines'][j];
              if (db['disciplineName'] != 'CNA' &&
                  db['disciplineName'] != 'LPN' &&
                  db['disciplineName'] != 'RN') {
                continue;
              }
              debugPrint('line 2265: ${obj['disciplines']} ${obj['departments']}');
              if ((obj['departments'] == null ||
                      obj['departments'].length == 0) &&
                  obj['rateType'] == 'Per Diem') {
                if (db['disciplineName'] == 'CNA' &&
                    obj['rateType'] == 'Per Diem') {
                  generatedCount[0] += 1;
                  disciplineIndex = 0;
                } else if (db['disciplineName'] == 'LPN' &&
                    obj['rateType'] == 'Per Diem') {
                  generatedCount[1] += 1;
                  disciplineIndex = 1;
                } else if (db['disciplineName'] == 'RN' &&
                    obj['rateType'] == 'Per Diem') {
                  disciplineIndex = 2;
                  generatedCount[2] += 1;
                } else {
                  continue;
                }
                obj['departments'] = [
                  {
                    'departmentName': 'Generated ' +
                        generatedDisciplines[disciplineIndex] +
                        ' Department -' +
                        generatedCount[disciplineIndex].toString()
                  }
                ];
              }

              debugPrint('line 2294 ${obj['departments']}');
              if (obj['departments'].length == 0) {
                continue;
              }
              List<dynamic> listDepts = obj['departments'];
              debugPrint('line 2299: ${listDepts[0]}');
              debugPrint('line 2300: ${obj['rateGroupId']} $db ${listDepts}');
              listNms.add(db['disciplineName']);
              Map<String, dynamic> dm = {
                'rateGroupId': obj['rateGroupId'],
                'disciplineId': db['disciplineId'],
                'disciplineName': db['disciplineName'],
                'disciplineDescription': db['disciplineName'],
                'departmentName': listDepts[0]['departmentName']
              };
              debugPrint('line 2309: $dm');
              lstm.add(dm);
            }
          }
        }
      }).catchError((error) {
        debugPrint('line 2315: $error');
      });
      debugPrint('line 2317 ${lstm.length}');
      List<int> listCt = [0, 0, 0];
      for (int i = 0; i < listNms.length; i++) {
        if (listNms[i] == 'CNA') {
          listCt[0] += 1;
        } else if (listNms[i] == 'LPN') {
          listCt[1] += 1;
        } else if (listNms[i] == 'RN') {
          listCt[2] += 1;
        }
      }
      bool flagHaveDups = false;
      if (listCt[0] > 1 || listCt[1] > 1 || listCt[2] > 1) {
        flagHaveDups = true;
      }
      if (flagHaveDups == true) {
        for (int i = 0; i < lstm.length; i++) {
          Map<String, dynamic> db = lstm[i];
          db['disciplineDescription'] =
              db['disciplineName'] + ' (' + db['departmentName'] + ')';
          lstm[i] = db;
        }
      }
      lstm.sort((a, b) => a['disciplineId'].compareTo(b['disciplineId']));
      debugPrint('line 2338: ${lstm.length}');
      return lstm;
    } catch (e) {
      debugPrint('line 2341 error getting disciplines ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getDNUForClients(int clientId) async {
    debugPrint('line 2060 $clientId');
    try {
      // DateTime shiftDate = DateTime.now();
      List<Map<String, dynamic>> listOfDNUHCPS = [];
      await FirebaseFirestore.instance
          .collection('ClientDNU')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          int hcpId = obj['hcpId'];
          String? hcpName;
          await FirebaseFirestore.instance
              .collection('HCProfessional')
              .where('hcpId', isEqualTo: hcpId)
              .get()
              .then((querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              var obj = docSnapshot.data();
              hcpName = obj['fullName'];
              break;
            }
            return;
          });
          if (hcpName == null) {
            continue;
          }
          obj['hcpName'] = hcpName;
          listOfDNUHCPS.add(obj);
        }
      });
      debugPrint('line 2074: ${listOfDNUHCPS.length}');
      return listOfDNUHCPS;
    } catch (e) {
      debugPrint('line 2077');
      throw Exception('Error: $e');
    }
  }

  Future<String> insertClientUser(
      Map<String, dynamic> obj, String userType) async {
    try {
      debugPrint('line 2209: ${obj}');
      String email = obj['email'];
      String password = obj['password'];
      debugPrint('line 2212 cms_auth: $email $password ');
      final UserCredential dyn =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('line 2216: $dyn');
      if (dyn.user == null) {
        debugPrint('line 2218: $email $password');
        return 'Error: Invalid login';
      }
      await dyn.user!.updateDisplayName(userType);
      obj['password'] = '**********';
      //
      debugPrint('line 1744: ${dyn.user!.uid} ');
      // String uid =
      //     obj['clientId'].toString() + ':' + obj['clientUserId'].toString();
      String uid = dyn.user!.uid;
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .doc(uid)
          .set(obj, SetOptions(merge: true));
      return "Success";
    } catch (e) {
      debugPrint('line 926 error getting users: ${e.toString()}');
      return "Error: ${e.toString()}";
    }
  }

  Future<bool> insertClientDNU(int clientId, int hcpId, int departmentId,
      String departmentName, String comments) async {
    debugPrint('line  745 $clientId, $hcpId $comments');

    int clientUserId = authServices.clientUserId!;
    try {
      dynamic obj = {
        "hcpId": hcpId,
        "clientId": clientId,
        "departmentId": departmentId,
        "departmentName": departmentName,
        "comments": comments,
        "lastTouched": DateTime.now(),
        "flagDNU": true,
        "flagClientDNU": true,
        "flagHCPDNU": false,
        "dnuDate": DateTime.now(),
        "clientDNUDate": DateTime.now(),
        "hcpDNUDate": null,
        "clientUserId": clientUserId,
      };
      debugPrint('line 751: $obj');

      FirebaseFirestore.instance.collection("ClientDNU").doc().set(obj);
      return true;
    } catch (e) {
      debugPrint('line 750 error: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getClientDepartment(int clientId) async {
    List<Map<String, dynamic>> lm = [];
    List<String> departmentNames = [];
    await FirebaseFirestore.instance
        .collection('ClientDepartment')
        .where("clientId", isEqualTo: clientId)
        .get()
        .then((snapshot) {
      debugPrint('line 733 clientdet ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        if (snp['departmentName'] == null || snp['departmentName'] == '') {
          continue;
        }
        if (snp['departmentName'] == 'Not Specified') {
          continue;
        }
        if (snp['departmentName'].toLowerCase().contains('contract')) {
          continue;
        }
        if (snp['branchName'].contains('PSG') == true) {
          continue;
        }
        if (departmentNames.indexOf(snp['departmentName']) != -1) {
          continue;
        }

        lm.add(snp.data());
      }
    });
    return lm;
  }

  Future<ClientUser> getClientUserMap(int clientId, String userEmail) async {
    ClientUser? lm;
    debugPrint('line 747 in get clientUser: $userEmail');
    try {
      await FirebaseFirestore.instance
          .collection('ClientUser')
          //   .where('clientId',isEqualTo: clientId) --put back when live
          .where('clientId', isEqualTo: clientId)
          .where('email', isEqualTo: userEmail)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          //   debugPrint('line 1762: ${obj}');
          String usn = obj['firstName'].toString().toLowerCase() +
              obj['lastName'].toString().toLowerCase().substring(0, 1);
          ClientUser clu = ClientUser(
              clientId: obj['clientId'],
              clientUserId: obj['clientUserId'],
              active: obj['active'],
              branchIds: obj['branchIds'],
              branchNames: obj['branchNames'],
              devices: obj['devices'],
              displayName: obj['displayName'],
              email: obj['email'],
              fcmToken: obj['fcmToken'],
              fcmTokens: obj['fcmTokens'],
              firstName: obj['firstName'],
              fullName: obj['fullName'],
              genId: obj['genId'],
              lastName: obj['lastName'],
              loginCounter: obj['loginCounter'],
              dateOfLastLogin: obj['dateOfLastLogin'],
              ownerId: obj['ownerId'],
              password: obj['password'],
              roles: obj['roles'],
              userId: obj['userId'],
              username: obj['username'] == null ? usn : obj['username']);
          lm = clu;
          break;
        }
      });
      if (lm == null) {
        throw Exception('line 1793 getclientusermap: No lm');
      }
      return lm!;
    } catch (e) {
      debugPrint('line 1797 error: $e');
      throw Exception(e.toString());
    }
  }

  String getStringDate2(Timestamp ts, dynamic dayValue) {
    debugPrint('line 920 getstringdate2 $ts $dayValue');
    try {
      List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      int dv = int.parse(dayValue.toString());
      String dvs = days[dv - 1];
      DateTime dt = ts.toDate();

      final format = DateFormat('MM-dd-yyyy');
      String dte = format.format(dt);
      dte += ' ( ' + dvs + ')';
      return dte;
    } catch (e) {
      debugPrint('line 1248 $e');
      throw Exception('Error line 1248: ${e.toString()}');
    }
  }

  Map<String, dynamic> convertObjToHbj(Map<String, dynamic> obj) {
    debugPrint('line 2152 ${obj['dates']['shiftDateInfo']}');
    debugPrint(
        'line 2154 convertobjtohobj ${obj['dates']['shiftDateInfo']['shiftDate']}');
    //      var od= 0;
    Timestamp shiftDate =
        Timestamp.fromDate(obj['dates']['shiftDateInfo']['shiftDate']);
    DateTime nwd = DateTime.now();
    Timestamp ts = Timestamp.fromDate(nwd);
    Map<String, dynamic> hobj = {};
    debugPrint('line 2161');
    try {
      hobj = {
        "orderId": obj['orderId'],
        "uniqueId": 0,
        "lastModified": ts,
        "clientId": obj['clientId'],
        'clientUserId': obj['clientUserId'],
        "clientName": obj['clientName'],
        "departmentId": obj['departmentId'],
        "departmentName": obj["departmentName"],
        "branchId": obj['branchId'],
        "branchName": obj['branchName'],
        "areaId": null,
        "areaName": null,
        "disciplineId": obj['disciplineIds'],
        "disciplineName": obj['disciplineNames'],
        "disciplineId2": null,
        "disciplineName2": null,
        "specialityId": null,
        "specialityName": null,
        "statusId": 'O',
        "statusDate": obj['shiftStatusDate'],
        "hcpId": obj['hcpId'],
        "hcpName": obj['hcpName'],
        "shiftDateTime": shiftDate,
        "shiftDate": shiftDate,
        "shiftDateString": getStringDate2(
            shiftDate, obj['dates']['shiftDateInfo']['dayValue']),
        "shiftCode": obj['dates']['shiftDateInfo']['shiftCode'],
        "startTime": obj['dates']['rates']['rateDetails']['startTime'],
        "endTime": obj['dates']['rates']['rateDetails']['endTime'],
        "originalStartTime": obj['dates']['rates']['rateDetails']['startTime'],
        "originalEndTime": obj['dates']['rates']['rateDetails']['endTime'],
        'shiftCount': obj['shiftCount'],
        "dayValue": obj['dates']['shiftDateInfo']['dayValue'],
        "meals": obj['dates']['rates']['rateDetails']['meals'],
        "isWeekEnd": obj['dates']['shiftDateInfo']['weekend'],
        "isHoliday": obj['dates']['shiftDateInfo']['holiday'],
        "charge": obj['charge'],
        "orientation": obj['orientation'],
        "lateCancel": false,
        "anticipatedNeed": false,
        "calcType": obj['dates']['rates']['rateDetails']['calcType'],
        "contract": obj["contract"],
        'con_StartDate': null,
        'con_EndDate': null,
        'con_pattern': null,
        'con_Guarantee': null,
        'con_weeks': null,
        'con_DaysPerWeek': null,
        'createdDate': ts,
        'conf_Cli': null,
        'conf_Cli_UserId': null,
        'conf_Cli_Date': null,
        'conf_Cli_Note': null,
        'conf_emp': null,
        'conf_Emp_UserId': null,
        'conf_Emp_Date': null,
        'conf_Emp_note': null,
        'internalNote': null,
        'invoiceNote': null,
        'transportationNote': null,
        'publicNote': null,
        'caller': obj['schedulerName'],
        'orderType': null,
        'poNumber': null,
        'workersCompCode': obj['workersCompCodeId'],
        'cancelReason': null,
        'calculatedPayRate': null,
        'calculatedBillRate': null,
        'totalHours': obj['dates']['rates']['rateDetails']['hours'],
        'decimalHours': obj['dates']['rates']['rateDetails']['hours'],
        'totalPayAmount': null,
        'totalBillAmount': null,
        'grossMargin': null,
        'registrantSpecialities': null,
        'registrantBranchName': obj['branchName'],
        'addressLine1': obj['addressLine1'],
        'addressLine2': obj['addressLine2'],
        'city': obj['clientCity'],
        'state': obj['state'],
        'zip': obj['zipCode'],
        'county': null,
        'rateId': obj['dates']['rates']['rateId'],
        'regRateId':
            obj['hcpId'] == null ? null : obj['dates']['rates']['rateId'],
        'rateIdPayRate': obj['dates']['rates']['rateDetails']['payRate'],
        'rateIdBillRate': obj['dates']['rates']['rateDetails']['billRate'],
        'createdDateTime': ts,
        'lastTouched': null,
        'payRate': obj['dates']['rates']['rateDetails']['payRate'],
        'payRateWE': obj['dates']['rates']['rateDetails']['payRateWE'],
        'billRate': obj['dates']['rates']['rateDetails']['billRate'],
        'billRateWE': obj['dates']['rates']['rateDetails']['billRateWE'],
        'overrideRates': obj['dates']['shiftDateInfo']['overriderates'],
        'con_RotatingSchedule': null,
        'con_Sun': null,
        'con_Mon': null,
        'con_Tue': null,
        'con_Wed': null,
        'con_Thu': null,
        'con_Fri': null,
        'con_Sat': null,
        'con_SplitShifts': null,
        'con_SplitWeekends': null,
        'con_SplitHolidays': null,
        'ExternalID': null,
        'orderTypeCodeId': obj['orderTypeCodeId'],
        'vmsStatus': null,
        'vmsOrderId': null,
        'vmsAPIOrderId': null,
        'vmsSource': null,
        'vmsNote': null,
        'vmsJobDescription': null,
        'uuid': obj['uuid'],
        'workOrderId': 0,
        'bookShift': obj['bookShift'],
        'isGPOClient': obj['isGPOClient']
      };
      debugPrint('line 2452 return from converttohobj: $hobj');
      return hobj;
    } catch (e) {
      debugPrint('line 1041 catch error:  $hobj $e');
      throw Exception(e.toString());
    }
  }

  Future<bool>? updateClientUser(int clientId, String fcmToken) async {
    Map<String, dynamic>? obj;
    String? objId;
    await FirebaseFirestore.instance
        .collection('ClientUser')
        .where("clientId", isEqualTo: clientId)
        .where("primaryRole", isEqualTo: 'ClientScheduler')
        .get()
        .then((snapshot) async {
      debugPrint('line 88 ${snapshot.docs.length}');
      for (var i = 0; i < snapshot.docs.length; i++) {
        objId = snapshot.docs[i].id;
        obj = snapshot.docs[i].data();
        break;
      }
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .doc(objId)
          .update({"fcmToken": fcmToken});
    });
    return true;
  }

  Future<Map<String, dynamic>>? getSingleClientUser(
      int clientId, int clientUserId) async {
    Map<String, dynamic> lm = {};
    await FirebaseFirestore.instance
        .collection('ClientUser')
        .where("clientId", isEqualTo: clientId)
        .where("genId", isEqualTo: clientUserId)
        .get()
        .then((snapshot) {
      debugPrint('line 88 ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        String documentId = snp.id;
        lm = snp.data();
        lm['id'] = documentId;
        clientId = lm['clientId'];
        clientUserId = lm['genId'];
        client = lm;
        break;
      }
    });
    return lm;
  }

  Future<Map<String, dynamic>>? getSingleHCPUser(int hcpId) async {
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
    debugPrint('line 2653: $lm');
    return lm;
  }

  Future<Map<String, dynamic>>? getSingleUserFromEmail(String email) async {
    Map<String, dynamic> lm = {};
    await FirebaseFirestore.instance
        .collection('ClientUser')
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        lm = docSnapshot.data();
        break;
      }
    });
    debugPrint('line 2653: $lm');
    return lm;
  }

  Future<void> sendClientCancelMessage(
      Map<String, dynamic> wor, List<String> tos, String reason) async {
    //Timestamp ts = Timestamp.fromDate(DateTime.now());
    debugPrint('line 2438: ${wor}');
    String sname = 'No Employee Scheduled';
    int hcpId = 0;
    String email = 'No Email';
    var lastName = '';
    var firstName = '';
    String templateId = "clientCancelWithNoEmployee";
    if (wor['hcpId'] != 0) {
      hcpId = wor['hcpId'];
      sname = wor['hcpName'];
      int idx = -1;
      idx = sname.indexOf(',');

      if (idx != -1) {
        lastName = sname.substring(0, idx);
        firstName = sname.substring(idx + 1, sname.length);
        firstName = firstName.trim();
      }
      await FirebaseFirestore.instance
          .collection('users')
          .where('genId', isEqualTo: hcpId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.length > 0) {
          var snp = querySnapshot.docs[0];
          email = snp['email'];
          tos.add(email);
        }
      });
    }
    if (wor['shiftStatus'] != 'Open') {
      templateId = "clientCancelWithEmployee";
    }
    Timestamp ts = wor['dates']['shiftDateInfo']['shiftDate'];
    wor['asmWorkOrderId'] = wor['clientHCPWorkOrderId'];
    int orderId = wor['asmWorkOrderId'];
    Map<String, dynamic> cancelShift = {
      "orderId": wor['asmWorkOrderId'].toString(),
      "branchId": wor['branchId'],
      "branchName": wor['branchName'],
      "clientId": wor['clientId'],
      "clientName": wor['clientName'],
      "departmentId": wor['departmentId'],
      "departmentName": wor['departmentName'],
      "disciplineId": wor['disciplineCodes'],
      "disciplineName": wor['disciplineName'],
      "email": email,
      "endTime": wor['dates']['rates']['rateDetails']['endTime'],
      "hcpId": hcpId,
      'firstName': firstName,
      'lastName': lastName,
      "hcpName": sname,
      "reason": reason,
      "shiftCode": wor['dates']['shiftDateInfo']['shiftCode'],
      "shiftDate": ts,
      "startTime": wor['dates']['rates']['rateDetails']['startTime'],
      "statusId": 'C',
      "templateId": templateId,
      "toList": tos
    };
    debugPrint('line 557: ${cancelShift}');
    await FirebaseFirestore.instance
        .collection('ClientShiftCancellationMessage')
        .doc(orderId.toString())
        .set(cancelShift);

    return;
  }
  Future<bool> updateClientAddressForm(
      String documentId, Map<String, dynamic> mp) async {
    try {
      debugPrint('line 36: $documentId ${mp}');
      await FirebaseFirestore.instance
          .collection('ClientAddress')
          .doc(documentId)
          .set(mp, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint('line 37 error: ${e.toString()}');
      return false;
    }
  }
  Future<Map<String,dynamic>>? getASingleClientById(int clientId) async {
    try {
      debugPrint('line 36: $clientId');
      Map<String,dynamic>?mp;
      await FirebaseFirestore.instance
          .collection('Client')
          .where('clientId',isEqualTo: clientId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.length == 0) {
          debugPrint('line 36 no records returned');
          final snapShot = querySnapshot.docs[0];
          mp = snapShot.data();
        }
        return mp!;
      });
      return mp!;
    } catch (e) {
      debugPrint('line 2592 error: ${e.toString()}');
      return {};
    }
  }
  Future<Map<String, dynamic>>? getASingleClientUser(int clientId) async {
    debugPrint('line 20 get a singleclient user ${clientId}');
    try {
      Map<String, dynamic>? mp;
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .where('clientId', isEqualTo: clientId)
          .where('roles', arrayContainsAny: [
        'ClientDON',
        'ClientADON',
        'ClientAdmin',
        'ClientSupervisor',
        'ClientScheduler',
        'ClientStaff',
        'CMSAdmin',
        'CMSScheduler'
      ])
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.length == 0) {
          debugPrint('line 36 no records returned');
          mp = {};
          return mp;
        }
        var snp = querySnapshot.docs[0];
        var documentId = snp.id;
        var obj = snp.data();
        obj['id'] = documentId;
        mp = obj;
        debugPrint('line 45 $mp');
        return mp;
      });
      debugPrint('line 48 $mp');
      return mp!;
    } catch (e) {
      debugPrint('line 42 error: ${e.toString()}');
      throw Exception('line 37 ${e.toString()}');
    }
  }
  Future<Map<String, dynamic>>? getSingleClientUserWithClientId(
      int clientId) async {
    Map<String, dynamic> lm = {};
    try {
      debugPrint('line 356: $clientId ');
      bool flagGotHit = false;
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .where("clientId", isEqualTo: clientId)
          .get()
          .then((snapshot) {
        debugPrint('line 88 ${snapshot.docs.length}');
        for (var snp in snapshot.docs) {
          lm = snp.data();
          flagGotHit = false;
          for (int i = 0; i < lm['roles'].length; i++) {
            String ro = lm['roles'][i];
            if (ro == 'ClientAdmin' ||
                ro == 'CMSAdmin' ||
                ro == 'ClientSupervisor' ||
                ro == 'CMSSupervisor' ||
                ro == 'ClientDON' ||
                ro == 'ClientADON') {
              flagGotHit = true;
              break;
            }
          }
          if (flagGotHit == true) {
            break;
          }
        }
        return;
      });
      return lm;
    } catch (e) {
      debugPrint('line 372 read error clientuser: ${e.toString()}');
      throw Exception(e.toString());
    }
  }
Future<List<Map<String,dynamic>>>? getQueryData(Query query) async {
    List<Map<String,dynamic>>? clm;
    List<Map<String,dynamic>>? listOfClients;
    try {

      listOfClients = [];
      QuerySnapshot querySnapshot = await query.get();
      clm = [];
      for (var docSnapShot in querySnapshot.docs) {
        debugPrint('line 3041: ${querySnapshot.docs.length}');
        Map<String, dynamic> obj = docSnapShot.data() as Map<String, dynamic>;
        obj['id'] = docSnapShot.id;
        debugPrint('line 3044 in querysnapshot: $obj');

        listOfClients.add(obj);
        obj['city'] = '';
        obj['state'] =  '';
        await FirebaseFirestore.instance
            .collection('ClientAddress')
            .where('clientId', isEqualTo: obj['clientId'])
            .where('addressType', isEqualTo: 'Physical')
            .get()
            .then((QuerySnapshot) async {
              debugPrint('line 3057: ${QuerySnapshot.docs.length}');
          for (var docSnapshot in QuerySnapshot.docs) {
            Map<String, dynamic> tobj = docSnapshot.data();
           debugPrint('line 3055: $tobj');
            obj['city'] = tobj['city'];
            obj['state'] = tobj['state'];
            break;
          }
        });
        debugPrint('line 3066: $obj');
        obj['balance'] = '0.0';
        obj['openCredit'] = false;
        obj['creditLimit'] = 0.0;
        debugPrint('line 3070 $obj');
        await FirebaseFirestore.instance
            .collection('ClientCredit')
            .where('clientId', isEqualTo: obj['clientId'])
            .get()
            .then((QuerySnapshot) async {
          for (var docSnapshot in QuerySnapshot.docs) {
            Map<String, dynamic> cobj = docSnapshot.data();
//     debugPrint('line 113: $cobj');
            obj['balance'] = '0.00';
            obj['openCredit'] = cobj['weeklyCreditLimit'];
            obj['creditLimit'] = cobj['creditLimit'] == null ? 0.0 : cobj['creditLimit'];
            break;
          }
        });
        debugPrint('line 3805: $obj');
        Map<String, dynamic> xbj = {
          'clientId': obj['clientId'].toString().length < 4
              ? "    ".substring(0, 4 - obj['clientId'].toString().length) +
              obj['clientId'].toString()
              : obj['clientId'].toString(),
          'statusId': obj['statusId'] == null ? 'U' : obj['statusId'],
          'clientName':
          obj['clientName'] == null ? 'Unknown' : obj['clientName'],
          'branchName':
          obj['branchName'] == null ? 'Unknown' : obj['branchName'],
          'clientType':
          obj['clientType'] == null ? 'Unknown' : obj['clientType'],
          'disciplinesServiced': obj['disciplinesServiced'] == null
              ? "Unknown"
              : obj['disciplinesServiced'].indexOf('CNA') == -1
              ? "Unknown"
              : obj['disciplinesServiced'].indexOf('LPN') == -1
              ? "Unknown"
              : obj['disciplinesServiced'].indexOf('RN') == -1
              ? "Unknown"
              : obj['disciplinesServiced'],
          'city': obj['city'] == null ? "Unknown" : obj['city'],
          'state': obj['state'] == null ? "Unk" : obj['state'],
          'balance':
          obj['balance'] == null ? "0.00" : obj['balance'].toString(),
          'openCredit':
          obj['openCredit'] == false ? "No" : "Yes"
        };
     debugPrint('line 3110: $xbj');
        clm.add(xbj);
      }
      clm.sort((a, b) {
        int cmp = a['clientId'].compareTo(b['clientId']);
        if (cmp != 0) return cmp;
        return a['clientId'].compareTo(b['clientId']);
      });
      debugPrint('line 3123 ${clm.length}');
      return clm;

    } catch(e) {
      debugPrint('line 3116 error: ${e.toString()}');
      return [];

    }

  }

}
