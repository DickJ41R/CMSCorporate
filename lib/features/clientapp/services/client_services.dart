import 'package:cms_web/features/clientapp/models/client_address.dart';
import 'package:cms_web/features/clientapp/models/client_rate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/clientapp/models/client_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/shared/services/utility_services.dart';
import 'package:cms_web/features/clientapp/models/client_user.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';

class ClientServices {
  ClientServices();
  Map<String, dynamic>? client;
  UtilitiesServices util = UtilitiesServices();
  AuthService authService = AuthService();
//new client
  Future<List<dynamic>> getClientWorkOrders(
      int clientId, BuildContext ctx) async {
    try {
      print('line 22 get clientworkorders $clientId');
      List<dynamic> response =
          await callRetrieveClientWorkOrdersFunction(clientId, ctx);
      print('line 24: $response');
      return response;
    } catch (e) {
      print('line 28: ${e.toString()}');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCannotBeScheduledData(
      int clientId) async {
    print('line 32: $clientId');
    List<Map<String, dynamic>> lm = [];
    try {
      print('line 35 getcannot be scheduled: $clientId');
      await FirebaseFirestore.instance
          .collection('ClientCannotBeScheduled')
          .where("clientId", isEqualTo: clientId)
          .get()
          .then((snapshot) {
        print(
            'line 43 get client cannot be scheduled: ${snapshot.docs.length}');
        for (var snp in snapshot.docs) {
          lm.add(snp.data());
        }
      });
      print('line 48: ${lm.length}');
      return lm;
    } catch (e) {
      print('line 53 $e');
      throw Exception('line 54: ${e.toString()}');
    }
  }

  Future<List<dynamic>> callRetrieveClientWorkOrdersFunction(
      int clientId, BuildContext ctx) async {
    print('line 60 callretrieveclients: $clientId');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'retrieveclientworkorders02',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 300),
        ),
      );
      print('line 68: just before calling retrieve client wos');
      List<dynamic> result = await callingRetrieveClientWorkOrdersFunction(
          callable, clientId, ctx);
      print('line 71: $result');
      if (result.length == 0) {
        print('line 73: Error getting htc id to asm');
        return [
          {'error': 'No Data'}
        ];
      }
      print('line 76 successfully retrieved htc');

      return result;
    } catch (e) {
      print('line 80 $e');
      return [
        {'error': e.toString()}
      ];
      throw Exception('line 81: ${e.toString()}');
    }
  }

  Future<List<dynamic>> callingRetrieveClientWorkOrdersFunction(
      HttpsCallable callable, int clientId, BuildContext ctx) async {
    print('line 87: $clientId');
    try {
      var data = {
        "clientId": clientId,
      };
      final HttpsCallableResult result = await callable(data);
      print('line 93 ${result.data}');
      var convertedResult = Map<String, dynamic>.from(result.data);
      if (convertedResult.containsKey('success') == true) {
        return convertedResult['data'];
      } else {
        return ['Error'];
      }
    } catch (e) {
      print('line 97 error: $e');
      throw Exception('line 98  ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getClientAddressData(int clientId) async {
    List<Map<String, dynamic>> lm = [];
    print('line 76 getclientaddress: $clientId');
    await FirebaseFirestore.instance
        .collection('ClientAddress')
        .where("clientId", isEqualTo: clientId)
        .get()
        .then((snapshot) {
      print('line 82 get client addr ${snapshot.docs.length}');
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
      print('line 33 gt clent ddress data  ${snapshot.docs.length}');
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
      print('line 49 get client contact ${snapshot.docs.length}');
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
      print('line 72 get client deptgs ${snapshot.docs.length}');
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
      print('line 75 get client holidays ${snapshot.docs.length}');
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
      print('line 88  client invoice ${snapshot.docs.length}');
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
      print('line 1p1 client dnu ${snapshot.docs.length}');
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
      print('line 158 client ${snapshot.docs.length}');
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
      print('line 158 getclient ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        lm = snp.data();
        break;
      }
    });
    return lm!;
  }

  // Future<List<Map<String, dynamic>>>? getClientsByBranchId(branchId) async {
  //   List<Map<String, dynamic>> lm = [];
  //   print('line 163 getclientbybranchid $branchId');
  //   try {
  //     //begin debug
  //     //take out for production
  //     List<int> clientIds = [];
  //     if (branchId == 632) {
  //       clientIds = [137, 805, 2691];
  //     } else if (branchId == 634) {
  //       clientIds = [1231, 1300, 2519];
  //     } else if (branchId == 638) {
  //       clientIds = [1381, 2446, 2525];
  //     } else {
  //       print('line 177 invalid branch id $branchId');
  //       throw Exception('Invalice branch id $branchId');
  //     }
  //     //end debug
  //     await FirebaseFirestore.instance
  //         .collection('Client')
  //         .where("branchId", isEqualTo: branchId)
  //         .where('clientId', whereIn: clientIds)
  //         . //debug
  //         get()
  //         .then((snapshot) {
  //       print('line 168 getclientbybrnchid ${snapshot.docs.length}');
  //       for (var snp in snapshot.docs) {
  //         final obj = snp.data();
  //         lm.add(obj);
  //       }
  //       print('line 174: ${lm.length}');
  //       return lm;
  //     });
  //     return lm;
  //   } catch (e) {
  //     print('line 258 error $e');
  //     String te = e.toString();
  //     te = te.replaceAll('Exception: Exception:', 'Exception:');
  //     throw Exception(te.toString());
  //   }
  // }

  Future<List<Map<String, dynamic>>>? getClientsByBranchIds(
      List<int> branchIds) async {
    List<Map<String, dynamic>> lm = [];

    try {
      await FirebaseFirestore.instance
          .collection('Client')
          .get()
          .then((snapshot) {
        print('line 225 getclientbybrnchid ${snapshot.docs.length}');
        for (var snp in snapshot.docs) {
          final obj = snp.data();
          if (branchIds.indexOf(obj['branchId']) == true) {
            lm.add(snp.data());
          }
        }
      });
      return lm;
    } catch (e) {
      print('line 258 error $e');
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
        print('line 217 $xt');
        List<String> xts = xt.split(' ');
        xt = xts[1];
        xts = xt.split(':');
        int? x = int.tryParse(xts[0]);
        if (x! > 12) {
          xt += ' PM';
        } else {
          xt += ' AM';
        }
        print('line 230: $xt');
        return xt;
      }
    } catch (e) {
      print('line 233: $e');
      throw Exception('line 222 get ts ${e.toString()}');
    }
  }

  double getTimeHours(String? tme) {
    print('line 270 gettimehours: $tme');
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
        print('Error with data: $tme');
        return hours;
      }
      String sx = sts[0];
      print('line 345: $sx');
      List<String> sxs = sx.split(':');
      double dmstm = double.parse(sxs[1]);
      if (dmstm == 0) {
        dmstm = 0.0;
      }
      double stmin = 0.0;
      print('line 352: $dmstm');
      for (int m = 0; m < slingPayrollHours.length; m++) {
        print('line 348 comp: $stmin ${slingPayrollHours[m]['minutes']}');
        if (dmstm == slingPayrollHours[m]['minutes']) {
          stmin = slingPayrollHours[m]['decimal']!;
          print('line 351: $stmin');
          break;
        }
      }
      hours = double.parse(sxs[0]) + stmin;
      print('line 353: $hours');
      return hours;
    } catch (e) {
      print('line 356 error $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getClientRateDisciplines(
      int clientId, int departmentId, String departmentName) async {
    List<dynamic> listD = [];
    print('line 391: $clientId $departmentId $departmentName');
    Map<String, dynamic>? rateMap;
    List<Map<String, dynamic>> listOfRateMaps = [];
    List<Map<String, dynamic>> listDisciplineMap = [];
    List<dynamic> listOfDisciplines = [];
    bool flagGotHit = false;
    try {
      print('line 397 check');
      await FirebaseFirestore.instance
          .collection('ClientRate')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) {
        int cnt = 0;
        for (var docSnapshot in querySnapshot.docs) {
          print('line 405: $flagGotHit');
          if (flagGotHit == true) {
            continue;
          }
          print('line 407 ${docSnapshot.id}');
          final documentId = docSnapshot.id;
          final obj = docSnapshot.data();
          obj['id'] = documentId;
          print('line 411: $clientId ${obj['departments']}');
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
          print('line 431 check ${obj['departments']} ${obj['disciplines']}');
          flagGotHit = false;
          rateMap = Map.from(obj);
          for (int i = 0; i < obj['departments'].length; i++) {
            dynamic ob = obj['departments'][i];
            print('line 432: $ob ');
            print(
                'line 433 ${ob['departmentName'].toString()} ${departmentName.toString()}');
            print(
                'line 434 ${int.parse(ob['departmentId'].toString())} ${int.parse(departmentId.toString())}');
            if (ob['departmentName'].toString() == departmentName.toString() ||
                int.parse(ob['departmentId'].toString()) ==
                    int.parse(departmentId.toString())) {
              print('line 442 check');
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
                print('line 456 ${listOfDisciplines.length}');
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
                  print('line 468: $db');
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
              print('line 484: ${rateMap!['disciplines']}');
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

      print('line 422 ${listOfRateMaps.length} ${listDisciplineMap.length}');
      Map<String, dynamic> ld = {
        "listDisciplineMap": listDisciplineMap,
        "listClientRates": listOfRateMaps
      };
      return ld;
    } catch (e) {
      print('line 484 error in getclientratedisciplinerate: $e');
      throw Exception('Error in getClientRateDisciplines: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getClientDepartmentData(
      int clientId) async {
    print('line 596: $clientId');
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
          print('line 446: $cnt ${obj['statusId']}');
          bool bl = obj['departmentName'].contains('PSG');
          if (bl == true) {
            continue;
          }
          obj['expirationDate'] = obj['ExpirationDate'];
          if (obj['statusId'] != 'A') {
            continue;
          }
          print('line 417 $cnt');
          dps.add(obj);
        }
      });
      //  List<Map<String, dynamic>> drs = [];
      print('line 422 ${dps.length}');
      if (dps.length == 0) {
        throw Exception('No active departments found for the client');
      }
      return dps;
    } catch (e) {
      print('line 418 error getting departments.');
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
          print('line 446: $cnt ${obj['statusId']}');
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
          print('line 417 $cnt');
          dps.add(obj);
        }
      });
      //  List<Map<String, dynamic>> drs = [];
      print('line 422 ${dps.length}');
      if (dps.length == 0) {
        throw Exception('No active departments found for the client');
      }
      return dps;
    } catch (e) {
      print('line 418 error getting departments.');
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<List<ClientData>> getClientDataFromSearch(String clientName) async {
    List<ClientData> clientData = [];
    print('line  577: $clientName');
    clientName = clientName.toLowerCase();
    List<Map<String, dynamic>> branches = [
      {"branchCode": 615, "branchName": "RALEIGH CMS 101"},
      {
        "branchCode": 624,
        "branchName": "COLUMBIA CMS 105",
      },
      {"branchCode": 631, "branchName": "NASHVILLE CMS 106"},
      {"branchCode": 632, "branchName": "MEMPHIS CMS 107"},
      {"branchCode": 634, "branchName": "AUGUSTA CMS 110"},
      {"branchCode": 635, "branchName": "FLORENCE CMS 111"},
      {"branchCode": 637, "branchName": "GREENVILLE CMS 113"},
      {"branchCode": 638, "branchName": "KNOXVILLE CMS 114"},
      {"branchCode": 639, "branchName": "TRI CITIES CMS 115"},
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
        print(
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
      print('line 613: $lcl');
      for (int i = 0; i < branches.length; i++) {
        Map<String, dynamic> ob = branches[i];
        print(
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
    print('line 632: $branchNumberx');
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
                print('line 662: $clientNamex');

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
              print('line 589: $idx $clientNamex ${obj['clientName']}');
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
      print('line 594 error: ${e.toString()}');
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
    print('line  779: $obj');
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
      print('line 1152 $clientId');
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
      print('line 1165 $clientCredit');
      if (clientCredit!.entries.isNotEmpty) {
        Map<String, dynamic> agingData = await getAgingData(clientId);
        print('line 622: ${agingData}');
        return {
          'clientCredit': clientCredit,
          'agingData': agingData['balances'],
          'totalCurrentBalance': agingData['totalCurrentBalance']
        };
      } else {
        return {};
      }
    } catch (e) {
      print('line 1166 error: $e');
      throw Exception('Error: $e');
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
          print('line 686: ${lag['totalAmount']} ${lag['totalPaid']} $balance');
          Timestamp ids = lag['invoiceDate'];
          print('line 688: $ids');
          DateTime ide = ids.toDate();
          ide = ide.subtract(Duration(
              hours: ide.hour,
              minutes: ide.minute,
              seconds: ide.second,
              microseconds: ide.microsecond,
              milliseconds: ide.millisecond));
          int mse = cds.millisecondsSinceEpoch - ide.millisecondsSinceEpoch;
          double msed = double.parse(mse.toString());
          print('line 698: $msed');
          msed /= 86400000;
          int days = msed.round();
          print('line 701: $days');
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
          print('line 713: $balance $idx');
          totalCurrentBalance += balance;
          Map<String, dynamic> bal = balances[idx];
          print('line 715: ${bal}');
          bal['balance'] += balance;
          balances[idx] = bal;
        }
      });
      return {'balances': balances, 'totalCurrentBalance': totalCurrentBalance};
    } catch (e) {
      print('line 720 error $e');
      throw Exception('Error getting aging data');
    }
  }

  Future<bool> insertClientUser(Map<String, dynamic> obj) async {
    try {
      await FirebaseFirestore.instance.collection('ClientUser').doc().set(obj);
      return true;
    } catch (e) {
      print('line 926 error getting users: ${e.toString()}');
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
      print('line 937 error getting users: ${e.toString()}');
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
      print('line 937 error getting users: ${e.toString()}');
      return false;
    }
  }

  Future<bool> updateTheClientUser(Map<String, dynamic> obj) async {
    try {
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .doc(obj['id'])
          .update(obj);
      return true;
    } catch (e) {
      print('line 937 error getting users: ${e.toString()}');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getClientUsers(int clientId) async {
    List<Map<String, dynamic>> listCls = [];
    try {
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .where('clientId', isEqualTo: clientId)
          .orderBy('clientUserId', descending: false)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          obj['id'] = docSnapshot.id;
          listCls.add(obj);
        }
      });
      return listCls;
    } catch (e) {
      print('line 926 error getting users: ${e.toString()}');
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
    print('line 860 check for cancel work order');
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
          print('line 1066: $dcxId $docSnapshot.id');
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
            print('line 903: $sct ${obj['shiftCount']}');
            tvs['status'] = 'WriteCWO';
            tvs['shiftCount'] = sct;
            tvs['hasScheduledHCPs'] = true;
            print('line 906: $tvs $sct');
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
            print('line 938');
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
      print('line 889: ${e.toString()}');
      return tvs;
    }
  }

  Future<List<double>> createSchedulingWorkOrder(
      List<dynamic> listOfDatesWithShifts,
      String scheduleNotes,
      String pushNotificationFrequencyRate,
      int clientId,
      List<Map<String, dynamic>> clientFCMToken,
      List<Map<String, dynamic>> testerFCMToken,
      bool payPremiumRate,
      BuildContext ctx) async {
    print('line 1171 clentsvrcreatescheduline ${listOfDatesWithShifts.length}');
    print('line 1172: $clientFCMToken $testerFCMToken');
    //  bool bl = false;
    bool useClientPayment = false;
    List<Map<String, dynamic>> wosForCounts = [];
    List<Map<String, dynamic>> clArray = [];
    // int meals = 0;
    Map<String, dynamic> cswo = {};
    List<Map<String, dynamic>> initObjs = [];
    List<int> scheduleCount = [];
    try {
      //  int payRateGroupId =  rt.rateGroupId;
      String specialRequirements = '';
      int count = 0;
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
      print('line 1201: ${listOfDatesWithShifts[0]}');
      List<dynamic>? ldDepartments;
      print('line 1203: ${listOfDatesWithShifts[0]['departmentIds']}');
      ldDepartments = listOfDatesWithShifts[0]['departments'];
      print('line 1205 ${ldDepartments}');
      int departmentId = ldDepartments![0]['departmentId'];
      if (departmentId == 0) {
        throw Exception('line 1176 DepartmentId == 0');
      }
      String departmentName = ldDepartments[0]['departmentName'];
      String departmentNumber = ldDepartments[0]['departmentNumber'];
      print('line 1212 check');
      int workersCompCodeId = listOfDatesWithShifts[0]['workersCompCodeId'];
      print('line 1214 check');
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
      print('line 1226 check');
      List<dynamic>? ldDisciplines;
      ldDisciplines = listOfDatesWithShifts[0]['disciplines'];
      print('line 1229: ${ldDisciplines}');
      int disciplineId = ldDisciplines![0]['disciplineId'];
      String disciplineName = ldDisciplines[0]['disciplineName'];
      print('line 1232 check $clientId');
      Map<String, dynamic>? clientMap = await getClient(clientId);
      print('line 1234: ${clientMap!['clientId']} $clientMap');

      print('line 1236: clisvr createsched ${clientMap['orientation']}');

      //  List<ClientDepartment>?dps = fromClientDepartments;
      bool orientation = false;
      if (clientMap['orientation'] != null) {
        orientation = clientMap['orientation'];
      }
      List<dynamic> dps = listOfDatesWithShifts[0]['departments'];
      dynamic dp = dps[0];
      useClientPayment = dp['useClientPayment'];
      print('line 1246 clisver create: $dp');
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
            if (obj['addressType'] != 'Physical') {
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
          print('line 1280 address is empty: $clientId');
          throw Exception('Address is empty for client: $clientId');
        }
      } else {
        addr = {
          "city": dp["mail_City"],
          "addressLine1": dp["mail_AddressLine1"],
          "addressLine2": dp["mail_AddressLine2"],
          "state": dp["mail_State"],
          "zipCode": dp["mail_ZipCode"],
          "latitude": dp["latitude"],
          "longitude": dp["longitude"],
          "timeZoneOffset": dp['timeZoneOffset']
        };
      }
      print('line 1295 clisver create: $addr');
      int? cClientId = clientMap['clientId'];
      int? cClientUserId = authService.clientUserId;
      String? cClientName = clientMap['clientName'];
      int? cBranchId = clientMap['branchId'];
      String? cBranchName = clientMap['branchName'];
      // int? cDepartmentId = departmentId;
      //  String? cDDepartmentName = selectedDepartmentValue;
      //   int? cDisciplineId=  clientMap['disciplineId'];
      //   String? cDisciplineName = clientMap['disciplineName'];
      Map<String, dynamic>? cswo;
      // dynamic xr =
      //     listOfDatesWithShifts[listOfDatesWithShifts.length - 1]['rate'];
      // if (xr == null) {
      //   print('line 1308 last rate is null in listofdates is null');
      //   throw Exception('line 1309 debug exception');
      // }
      // dynamic rd = xr['rateDetails'];
      // print('line 1313: $xr');
      // print('line 1314: ${rd[rd.length - 1]}');
      // if (rd[rd.length - 1]['shiftCount'] == 0) {
      //   print('line 1315 last shift count = 0');
      //   throw Exception('line 1314 debug exception');
      // }
      Map<String, dynamic> clientSchedulingWorkOrder = {};
      var uuid = Uuid();
      print('1054: ${listOfDatesWithShifts.length}');
      for (int i = 0; i < listOfDatesWithShifts.length; i++) {
        print('line 1322 beginnng of i loop: $i');
        dynamic rt = listOfDatesWithShifts[i]['rate'];

        print(
            'line 1326:  ${rt['rateDetails']} ${rt['rateDetails'][4]['shiftCode']} ${rt['rateDetails'][4]['shiftCount']}');
        rt['clientId'] = clientMap['clientId'];
        rt['clientName'] = clientMap['clientName'];
        rt['branchId'] = clientMap['branchId'];
        rt['branchName'] = clientMap['branchName'];
        print('line 1331 ${clientMap['clientUserId']}');
        if (clientMap['clientUserId'] != null) {
          rt['clientUserId'] = clientMap['clientUserId'];
        } else {
          rt['clientUserId'] = 0;
        }
        print('line 1337');
        workersCompCodeId = listOfDatesWithShifts[i]['workersCompCodeId'];
        print('line 1339');
        workersCompType = listOfDatesWithShifts[i]['workersCompType'];
        print('line 1341');
        if (listOfDatesWithShifts[i]['rateType'] == '' ||
            listOfDatesWithShifts[i]['rateType'] == null) {
          rateType = 'Per Diem';
        } else {
          rateType = listOfDatesWithShifts[i]['rateType'];
        }
        print('line 1343');
        if (listOfDatesWithShifts[i]['rateTypeCodeId'] != null) {
          rateTypeCodeId = listOfDatesWithShifts[i]['rateTypeCodeId'];
        } else {
          rateTypeCodeId = 2683;
        }
        print('line 1345');
        listOfDatesWithShifts[i]['rate'] = rt;
        dynamic ld = listOfDatesWithShifts[i];
        print(
            'line 1358: ${ld['payHolidayRate']}  ${ld['overridePayModifiers']}');
        print(
            'line 1360 ${rt['overridePayModifiers']} ${rt['rateDetails'][0]['payRate']} ${rt['rateDetails'][0]['isAHoliday']}');

        print('line 1362: ${clientMap} ${clientMap['payHolidayRate']}');
        for (int z = 0; z < rt['rateDetails'].length; z++) {
          //     print('line 1324: $z ${rt['rateDetails'][z]}');
          if (rt['rateDetails'][z]['isAHoliday'] != null &&
              rt['rateDetails'][z]['isAHoliday'] == true) {
            if (rt['overridePayModifiers'] == false) {
              rt['rateDetails'][z]['payRate'] *= clientMap['payHolidayRate'];
              rt['rateDetails'][z]['payRateWE'] *= clientMap['payHolidayRate'];
              rt['rateDetails'][z]['billRate'] *=
                  clientMap['billingHolidayRate'];
              rt['rateDetails'][z]['billRateWE'] *=
                  clientMap['billingHolidayRate'];
            } else {
              print('line 1375');
              if (rt['payHolidayRate'] == null || rt[['payHolidayRate']] == 0) {
                rt['payHolidayRate'] = 1.5;
              }
              rt['rateDetails'][z]['payRate'] *= rt['payHolidayRate'];
              rt['rateDetails'][z]['payRateWE'] *= rt['payHolidayRate'];
              rt['rateDetails'][z]['billRate'] *= rt['billHolidayRate'];
              rt['rateDetails'][z]['billRateWE'] *= rt['billHolidayRate'];
            }
          }
          print(
              'line 1386 $z ${rt['rateDetails'][z]['payRate']} ${rt['rateDetails'][z]['payRateWE']} ${clientMap['payHolidayRate']} ${rt['payHolidayRate']}');
        }

        //next two linees need to be correct to correction wit tlis date
        DateTime curd = ld['date'];
        curd = curd.subtract(Duration(
            hours: curd.hour,
            minutes: curd.minute,
            seconds: curd.second,
            microseconds: curd.microsecond,
            milliseconds: curd.millisecond));
        print(
            'line 1398: $curd ${clientMap['payHolidayRate']} ${rt['rateDetails'][0]['payRate']}');

        clientSchedulingWorkOrder['rateGroupId'] = rt['rateGroupId'];

        //   clientSchedulingWorkOrder['rateTypeCode'] = rt.rateType;
        //  clientSchedulingWorkOrder['rateTypeDescription'] = rt.rateTypeDescription'];
        clientSchedulingWorkOrder['userId'] = 0;
        clientSchedulingWorkOrder['rateType'] = rt['rateType'];
        clientSchedulingWorkOrder['clientId'] = clientMap['clientId'];
        clientSchedulingWorkOrder['clientUserId'] = cClientUserId;
        clientSchedulingWorkOrder['clientName'] = clientMap['clientName'];
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
        clientSchedulingWorkOrder['clientFCMToken'] = clientFCMToken;
        clientSchedulingWorkOrder['testerFCMToken'] = testerFCMToken;
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

        print(
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
        clientSchedulingWorkOrder['clientCity'] = addr['city'];
        clientSchedulingWorkOrder['zipCode'] = addr['zipCode'];
        clientSchedulingWorkOrder['orderTypeOrderId'] = null;
        clientSchedulingWorkOrder['specialRequirements'] = specialRequirements;
        clientSchedulingWorkOrder['dates'] = [];
        print('line 1480');
        cswo = Map.from(clientSchedulingWorkOrder);

        //  Map<String, dynamic>?ls;

        //  List<dynamic>shifts = List.from(listOfDatesWithShifts[i]['shifts']);
        List<dynamic> rateDetails = rt['rateDetails'];
        print('line 1487: ${rateDetails.length}');
        dynamic rate = listOfDatesWithShifts[i]['rate'];

        for (int k = 0; k < rateDetails.length; k++) {
          var v4 = uuid.v4();
          dynamic rd = rateDetails[k];
          print('line 1493 $k  $rd');
          if (rd['startTime'] == null) {
            continue;
          }
          if (rd['shiftCount'] == 0) {
            continue;
          }

          print('line 1501: $cBranchId $cBranchName $cClientId, $cClientName');
          print('line 1502: $disciplineId $disciplineName ${ld['date']}');
          Map<String, dynamic> clientPublishedSchedule = {
            "uuid": v4,
            "clientId": cClientId,
            "clientName": cClientName,
            "branchId": cBranchId,
            "branchName": cBranchName,
            "departmentId": departmentId,
            "departmentName": departmentName,
            "disciplineId": disciplineId,
            "disciplineName": disciplineName,
            "shiftDate": ld['date'],
            "shiftId": rd['shiftCode'] == 'AP'
                ? 4
                : rd['shiftCode'] == 'PA'
                    ? 5
                    : int.tryParse(rd['shiftCode']),
            "shiftCode": rd['shiftCode'],
            "startTime": rd['startTime'],
            "endTime": rd['endTime'],
            "hcpRequired": rd['shiftCount'],
            "shiftCount": rd['shiftCount'],
            "hcpScheduled": 0,
            "status": "Open" //Open, Canceled, Scheduled
          };
          await FirebaseFirestore.instance
              .collection('ClientPublishedSchedule')
              .doc()
              .set(clientPublishedSchedule);
        }

        print('line 1533 clisvr create: $i ${cswo}');
        // Map<String,dynamic>ld = Map.from(listOfDatesWithShifts[j]);
        //  List<dynamic>listOfShifts = List.from(listOfDatesWithShifts[j]['shifts']);
        List<dynamic> rtd = rateDetails;
        print('line 1537: ${rtd.length}');
        for (int k = 0; k < rtd.length; k++) {
          print('line 1539 start of k loop');
          clArray = [];
          String hour =
              util.getHoursString(rtd[k]['startTime'], rtd[k]['endTime']);
          print('line 1543: $k $hour');
          rtd[k]['hour'] = hour;
          if (rtd[k]['shiftCount'] == 0) {
            continue;
          }
          print('line 1545: ${rtd[k]['shiftCount']} ${rtd[k]['hour']}');
          var v4 = uuid.v4();
          cswo['uuid'] = v4;
          print('line 1548 $v4 ${cswo['uuid']}');
          if (rtd[k]['startTime'] == null) {
            continue;
          }
          print('line 1552:${rtd.length} $k ${rtd[k]['shiftCount']}');

          print('line 1556: ${rtd[k]['shiftCount']}');
          int shiftCount = rtd[k]['shiftCount'];
          print(
              'line 1559: ${rtd[k]['shiftCount']} ${rtd[k]['startTime']} ${rtd[k]['endTime']} ${rtd[k]['meals']}');
          double dvv = util.getHours(
              rtd[k]['startTime'], rtd[k]['endTime'], rtd[k]['meals']);
          print('line 1562: ${dvv.toStringAsFixed(2)}');
          rtd[k]['hours'] = dvv.toStringAsFixed(2);
          print(
              'line 1524: $k ${rtd[k]['shiftCode']}  ${rtd[k]['shiftCount']}');
          //  clientSchedulingWorkOrder = Map.from(cswo);
          rtd[k]['hour'] = hour;
          print('line 1568: ${rtd[k]['hour']}');
          dynamic shiftDetail = rtd[k];
          dynamic clrg = {};
          //get rate group;d
          print('line 1572: $rtd');
          int ckv = -1;
          String queryShiftCode = shiftDetail['shiftCode'].toString();

          Map<String, dynamic> si = {
            "shiftDate": listOfDatesWithShifts[i]['date'],
            "weekend": listOfDatesWithShifts[i]['weekend'] ? true : false,
            "holiday": listOfDatesWithShifts[i]['holiday'] ? true : false,
            "dayValue": listOfDatesWithShifts[i]['dayValue'],
            "shiftCode": shiftDetail['shiftCode'].toString(),
            "rateType": 'Per Diem',
            "overridePayModifiers": listOfDatesWithShifts[i]
                ['overridePayModifiers'],
            'payOTRate': authService!.clientMap!['PayOTRate'],
          };
          si['overrideBillModifiers'] = false;
          si['overridePayModifiers'] =
              listOfDatesWithShifts[i]['overridePayModifiers'];
          print('line 1590 clisvr createsched $si $shiftDetail ');

          Map<String, dynamic> date = {};
          //  Map<String,dynamic> rts = {};
          print('line 1634: ${rtd} ${rate['billingRate']} ${rate['rateType']}');
          if (useClientPayment == true) {
            cswo['payOT'] = rate['billingOTRate'];
            cswo["payOTPlus"] = rate['billingOTPlusRate'];
            cswo["payDbl"] = dp['billingDblRate'];
            cswo["payDblPlus"] = dp['billingDblPlusRate'];
            cswo["payHoliday"] = dp['payHolidayRate'];
            cswo["payHolidayPlus"] = dp['payHolidayPlusRate'];
            cswo["payMax"] = dp['payMaxRate'];
            cswo["payMaxPlus"] = dp['payMaxPlusRate'];
            cswo["billOT"] = dp['billingOTRate'];
            cswo["billOTPlus"] = dp['billingOTPlusRate'];
            cswo["billDbl"] = dp['billingDblRate"'];
            cswo["billDblPlus"] = dp['billingDblPlusRate'];
            cswo["billHoliday"] = dp['billingHolidayRate'];
            cswo["billHolidayPlus"] = dp['billingHolidayPlusRate'];
            cswo["billMax"] = dp['billingMaxRate'];
            cswo["billMaxPlus"] = dp['billingMaxPlusRate'];
            cswo['facilityCancelLimit'] = dp['facilityCancelLimit'];
            cswo['facilityCancelCharge'] = dp['facilityCancelCharge'];
            cswo['agencyCancelLimit'] = dp['agencyCancelLimit'];
            cswo['agencyCancelCredit'] = dp['agencyCancelCredit'];
          } else {
            cswo["rateType"] = rt['rateType'];
            cswo["overridePayModifier"] = rt['overridePayModifiers'];
            cswo["overrideRates"] = rt['overridePayModifiers'];
            cswo["overrideBillModifiers"] = rt['overrideBillModifiers'];
            cswo['payOT'] = rt['payOT'];
            cswo["payOTPlus"] = rt['payOTPlus'];
            cswo["payDbl"] = rt['payDbl'];
            cswo["payDblPlus"] = rt['payDblPlus'];
            cswo["payHoliday"] = rt['payHoliday'];
            cswo["payHolidayPlus"] = rt['payHolidayPlus'];
            cswo["payMax"] = rt['payMax'];
            cswo["payMaxPlus"] = rt['payMaxPlus'];
            cswo["billOT"] = rt['billOT'];
            cswo["billOTPlus"] = rt['billOTPlus'];
            cswo["billDbl"] = rt['billDbl'];
            cswo["billDblPlus"] = rt['billDblPlus'];
            cswo["billHoliday"] = rt['billHoliday'];
            cswo["billHolidayPlus"] = rt['billHolidayPlus'];
            cswo["billMax"] = rt['billMax'];
            cswo["billMaxPlus"] = rt['billMaxPlus'];
            cswo['facilityCancelLimit'] = dp['facilityCancelLimit'];
            cswo['facilityCancelCharge'] = dp['facilityCancelCharge'];
            cswo['agencyCancelLimit'] = dp['agencyCancelLimit'];
            cswo['agencyCancelCredit'] = dp['agencyCancelCredit'];
          }
          cswo['shiftApprovalNote'] = null;
          cswo['shiftCanceled'] = false;
          cswo['shiftCanceledActionDate'] = null;
          cswo['shiftCanceledById'] = null;
          cswo['shiftCanceledByName'] = null;
          cswo['shiftCanceledNote'] = null;
          cswo['shiftStatus'] = "Open";
          cswo['shiftStatusDate'] = Timestamp.fromDate(DateTime.now());
          cswo['pushNotificationsFrequencyRate'] =
              pushNotificationFrequencyRate;
          cswo['clientFCMToken'] = clientFCMToken;

          print('line 1694 $k ${rtd[k]['shiftCount']}');
          // if (rate['departments'] == null) {
          //   Map<String,dynamic> mp = {
          //     'departmentId': selectedDepartmentId,
          //     'departmentName': selectedDepartmentValue
          //   };
          //   rate['departments'] = [mp];
          //   print('line 1566: ${rate['departments']}');
          // } else {
          //   if (rate['departments']['departmentId'] == 0) {
          //     rate['departments']['departmentId'] = selectedDepartmentId;
          //     rate['departments']['departmentName'] = selectedDepartmentValue;
          //   }
          //
          rate['scheduledRateDetails'] = null;
          Map<String, dynamic> ccl = Map.from(cswo);
          Map<String, dynamic> sii = Map.from(si);
          sii['indexValue'] = false;
          date['shiftDateInfo'] = Map.from(sii);
          rate['rateDetails'] = Map.from(shiftDetail);
          date['rates'] = Map.from(rate);

          ccl['dates'] = Map.from(date);
          //       clArray.add(clientSchedulingWorkOrder);
          print('line 1718: ${ccl['dates']}');
          String workOrderId = uuid.v4();
          String clientHCPWorkOrderId = uuid.v4();
          workOrderId = uuid.v4();
          clientHCPWorkOrderId = uuid.v4();
          bool flagDidACheck = false;
          DateTime curD = curd;
          String? dcxId;
          bool flagGotCWK = false;
          print('line 1727: $queryShiftCode');
          await FirebaseFirestore.instance
              .collection('ClientWorkOrder')
              .where('clientId', isEqualTo: ccl['clientId'])
              .where('disciplineName', isEqualTo: disciplineName)
              .where('dates.shiftDateInfo.shiftCode', isEqualTo: queryShiftCode)
              .get()
              .then((querySnapshot) async {
            for (var docSnapshot in querySnapshot.docs) {
              dcxId = docSnapshot.id;
              final obj = docSnapshot.data();
              print(
                  'line 1738 $dcxId ${obj['shiftStatus']} ${obj['dates']['shiftDateInfo']['shiftCode']}');
              if ((obj['ExternalId'] != null &&
                      obj['externalId'] == '999999') ||
                  (obj['internalNote'] != null &&
                      obj['internalNote'].length > 0)) {
                print('line 1743 continued on sl wkords');
                continue;
              }
              //  shiftCount = double.parse(obj['shiftCount'].toString());
              Timestamp stm = obj['dates']['shiftDateInfo']['shiftDate'];
              DateTime dtm = stm.toDate();
              dtm = dtm.subtract(Duration(
                  hours: dtm.hour,
                  minutes: dtm.minute,
                  seconds: dtm.second,
                  microseconds: dtm.microsecond,
                  milliseconds: dtm.millisecond));
              flagGotCWK = false;
              Map<String, dynamic>? tvs;

              if (curD.millisecondsSinceEpoch == dtm.millisecondsSinceEpoch) {
                flagGotCWK = true;
                print('line 1753: $curD $dtm $shiftCount');

                for (int s = 0; s < shiftCount; s++) {
                  Map<String, dynamic> xbj = Map.from(ccl);
                  xbj['dates']['shiftDateInfo']['shiftCount'] = 1;
                  xbj['dates']['shiftDateInfo']['indexValue'] = true;
                  if (s > 0) {
                    workOrderId = uuid.v4();
                    xbj['workOrderId'] = workOrderId;
                    xbj['uuid'] = uuid.v4();
                  }
                  String? woWorkOrderId;
                  await FirebaseFirestore.instance
                      .collection('ClientWorkOrder')
                      .add(xbj)
                      .then((DocumentReference doc) {
                    woWorkOrderId = doc.id;
                  });
                  print('line 1740 $woWorkOrderId');
                  await FirebaseFirestore.instance
                      .collection('ClientWorkOrder')
                      .doc(woWorkOrderId)
                      .update({'woWorkOrderId': woWorkOrderId!});
                  Map<String, dynamic> hobj = convertObjToHbj(xbj);
                  hobj['workOrderId'] = workOrderId;
                  hobj['woWorkOrderId'] = woWorkOrderId!;
                  print('line 1799: ${hobj['workOrderId']}');
                  await FirebaseFirestore.instance
                      .collection('ClientHCPWorkOrder')
                      .doc()
                      .set(hobj);
                }
                print('line 1740 check');
                return [1];
              }

              print('line 1780: $workOrderId $clientHCPWorkOrderId');
              ccl['workOrderId'] = workOrderId;
              ccl['clientHCPWorkOrderId'] = clientHCPWorkOrderId;
              ccl['shiftCount'] = shiftDetail['shiftCount'];
              print('line 1784 check $flagGotCWK ');

              clArray = [];
              Map<String, dynamic> initialObj = ccl;
              print('line 1759: $ccl');
              int x = 0;
              if (x == 0) {
                throw Exception('line 1762 debug exception');
              }
              if (flagGotCWK == false) {
                await FirebaseFirestore.instance
                    .collection('ClientWorkOrder')
                    .doc()
                    .set(ccl);
                print('line 1796: ${ccl['dates']['shiftDateInfo']}');
                Map<String, dynamic> hobj = convertObjToHbj(ccl);
                hobj['workOrderId'] = workOrderId;
                print('line 1799: ${hobj['workOrderId']}');
                Map<String, dynamic> mp = {
                  "clientId": ccl['clientId'],
                  "uuid": ccl['uuid']
                };
                wosForCounts.add(mp);
                await FirebaseFirestore.instance
                    .collection('ClientHCPWorkOrder')
                    .doc()
                    .set(hobj);
                clArray.add(ccl);
                print('line 1810: ${clArray.length} ${shiftDetail}');
                print('line 1811 ${shiftDetail['shiftCount']}');
                for (int p = 1; p < shiftDetail['shiftCount']; p++) {
                  print('line 1813: $p ${ccl['dates']['shiftDateInfo']}');
                  dynamic six = ccl['dates']['shiftDateInfo'];
                  six['indexValue'] = true;
                  ccl['dates']['shiftDateInfo'] = six;
                  print('line 1817 $ccl');
                  // cswo['dates'] = Map.from(date);
                  clArray.add(ccl);
                }
                //      clArray.insert(0, ccl); // at index 0 we are adding A
                print('line 1822 ${clArray.length} ');
                print('line 1823: ${shiftDetail['shiftCount']}');
                await Future.delayed(const Duration(seconds: 2));
                for (int p = 1; p < shiftDetail['shiftCount']; p++) {
                  Map<String, dynamic> obj = clArray[p];
                  print('line 1827: $i $p, ${obj['dates']}');
                  print('line 1828:  ${obj['dates']['shiftDateInfo']}');
                  workOrderId = uuid.v4();
                  clientHCPWorkOrderId = uuid.v4();
                  obj['workOrderId'] = workOrderId;
                  obj['shiftCount'] = shiftDetail['shiftCount'];
                  print('line 1833: ${obj['shiftCount']}');
                  obj['clientHCPWorkOrderId'] = clientHCPWorkOrderId;
                  await FirebaseFirestore.instance
                      .collection('ClientWorkOrder')
                      .doc()
                      .set(obj);
                  Map<String, dynamic> hobj = convertObjToHbj(obj);
                  hobj['workOrderId'] = workOrderId;
                  await FirebaseFirestore.instance
                      .collection('ClientHCPWorkOrder')
                      .doc()
                      .set(hobj);
                }
              }
              print('line 1847');
              //    clientRateGroups = List.from(myList);
              // print('line 1220 ${clArray.length}');
              // for (int q=0; q < clArray.length; q++) {
              //   Map<String,dynamic> obj = clArray[q];
              //   FirebaseFirestore.instance.collection('ClientWorkOrder')
              //       .doc().set(obj);
              // }
              //  bl = true;
            }
          });
        }
      }
      print('line 1858');
      List<double> scheduleCount = [1];
      // int? ib;
      // double ctn = 0;
      // await Future.forEach(wosForCounts, (action) async {
      //   print('line 1814: $action');
      //   Map<String, dynamic> mpp = await getScheduledCount(action, ctx);
      //   print('line 1816: $mpp');
      //   ctn += mpp['selected'];
      //   scheduleCount.add(mpp['selected']);
      // });
      // print('line 1821: $scheduleCount');
      // if (ctn == 0) {
      //   if (scheduleCount.length == 0) {
      //     scheduleCount.add(1);
      //   } else {
      //     int len = scheduleCount.length;
      //     scheduleCount = [];
      //     for (int i = 0; i < len; i++) {
      //       scheduleCount.add(1);
      //     }
      //   }
      // }
      print('line 1881: $scheduleCount');
      return scheduleCount;
    } catch (e) {
      print('line 1884 error: $e');
      return [0];
//      throw Exception('$e');
    }
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
    print('line 1845 ${action['clientId']} ${action['uuid']}');

    try {
      Map<String, dynamic> response =
          await callGetClientSchedulingStatsFunction(action['uuid'], ctx);
      print('line 1856: $response');
      return response;
    } catch (e) {
      print('line 1839 error in getting schedule count: ${e.toString()}');
      return {};
    }
  }

  Future<Map<String, dynamic>> callGetClientSchedulingStatsFunction(
      String clientWorkOrderUuid, BuildContext ctx) async {
    print('line 1866 cwou: $clientWorkOrderUuid');
    Map<String, dynamic>? mp;
    try {
      await Future.delayed(Duration(seconds: 10), () async {
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'getSchedulingStats05',
          options: HttpsCallableOptions(
            timeout: const Duration(seconds: 300),
          ),
        );
        print('line 1416: just before calling retrieve client wos');
        Map<String, dynamic> result =
            await callingGetClientSchedulingStatsFunction(
                callable, clientWorkOrderUuid, ctx);
        print('line 1879: $result');
        if (result['data'] is String) {
          print('line 1881: Error getting htc id to asm');
          throw Exception('No matching documents');
        }
        print('line 1884 successfully retrieved htc');
        mp = result;

        return;
      });
      print('line 1890: $mp');
      return mp!;
    } catch (e) {
      print('line 1890 $e');
      throw Exception('line 81: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> callingGetClientSchedulingStatsFunction(
      HttpsCallable callable,
      String clientWorkOrderUuid,
      BuildContext ctx) async {
    print('line 1899: $clientWorkOrderUuid');
    try {
      var data = {
        "clientWorkOrderUuid": clientWorkOrderUuid,
      };
      final HttpsCallableResult result = await callable(data);
      print('line 1905 ${result.data}');
      var convertedResult = Map<String, dynamic>.from(result.data);
      return convertedResult;
    } catch (e) {
      print('line 1909 error: $e');
      throw Exception('line 98  ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getShiftsByClientAndDiscipline(
      int clientId, String disciplineDescription, rateGroupId) async {
    print('linee 1377 docis: $clientId $disciplineDescription $rateGroupId');
    try {
      String val = '';
      int idx = disciplineDescription.indexOf('(');
      if (idx != -1) {
        val = disciplineDescription.substring(0, idx).trim();
      } else {
        val = disciplineDescription;
      }
      Map<String, dynamic> obj = {};
      bool flagGotHit = false;
      int objCount = -1;

      await FirebaseFirestore.instance
          .collection('ClientRate')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          obj = docSnapshot.data();
          objCount += 1;
          for (int j = 0; j < obj['disciplines'].length; j++) {
            dynamic db = obj['disciplines'][j];
            print('line 1399: $val $db ${obj['rateGroupId']}, $rateGroupId');
            if (db['disciplineName'] == val &&
                obj['rateGroupId'] == rateGroupId) {
              print('line 1401: ${obj['departments']} $obj');
              flagGotHit = true;
              if (authService!.clientMap!['billingSameAsPhysical'] == true) {
                obj['payHolidayPlusRate'] =
                    authService!.clientMap!['payHolidayPlusRate'];
                obj['payHolidayRate'] =
                    authService!.clientMap!['payHolidayRate'];
                obj['payMaxPlusRate'] =
                    authService!.clientMap!['payMaxPlusRate'];
                obj['payMaxRate'] = authService!.clientMap!['payMaxRate'];
                obj['payOTRate'] = authService!.clientMap!['payHolidayRate'];
              }
              break;
            }
          }
          if (flagGotHit == true) {
            break;
          }
        }
      });
      List<dynamic> rds = [];
      if (flagGotHit == true) {
        List<String> lTimes = ['1', '2', '3', 'AP', 'PA'];
        List<dynamic> rd = obj['rates'][0]['rateDetails'];
        for (int q = 0; q < rd.length; q++) {
          dynamic rdt = rd[q];
          if (lTimes.indexOf(rdt['shiftCode']) == -1) {
            print('line 1956');
            if (rdt['startTime'] == null) {
              continue;
            }
          }
          print('line 1958');
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
      print('line 1427 $obj');
      return obj;
    } catch (e) {
      print('line 1430 error: $e');
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
    print('line 1813 in get disciplines from client rates $clientId');
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
          obj['id'] = docId;
          if (obj['hcpId'] > 0) {
            continue;
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
              print('line 1836: ${obj['disciplines']} ${obj['departments']}');
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

              print('line 1867 ${obj['departments']}');
              if (obj['departments'].length == 0) {
                continue;
              }
              List<dynamic> listDepts = obj['departments'];
              print('line 1866: ${listDepts[0]}');
              print('line 1867: ${obj['rateGroupId']} $db ${listDepts}');
              listNms.add(db['disciplineName']);
              Map<String, dynamic> dm = {
                'rateGroupId': obj['rateGroupId'],
                'disciplineId': db['disciplineId'],
                'disciplineName': db['disciplineName'],
                'disciplineDescription': db['disciplineName'],
                'departmentName': listDepts[0]['departmentName']
              };
              print('line 1847: $dm');
              lstm.add(dm);
            }
          }
        }
      });
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
      print('line 1874: ${lstm.length}');
      return lstm;
    } catch (e) {
      print('line 1073 error getting disciplines ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getDNUForClients(int clientId) async {
    print('line 2060 $clientId');
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
      print('line 2074: ${listOfDNUHCPS.length}');
      return listOfDNUHCPS;
    } catch (e) {
      print('line 2077');
      throw Exception('Error: $e');
    }
  }

  Future<bool> insertClientDNU(int clientId, int hcpId, int departmentId,
      String departmentName, String comments) async {
    print('line  745 $clientId, $hcpId $comments');

    int clientUserId = authService.clientUserId!;
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
      print('line 751: $obj');

      FirebaseFirestore.instance.collection("ClientDNU").doc().set(obj);
      return true;
    } catch (e) {
      print('line 750 error: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getClientDepartment(
      int clientId, List<int> departmentIds) async {
    List<Map<String, dynamic>> lm = [];
    List<String> departmentNames = [];
    await FirebaseFirestore.instance
        .collection('ClientDepartment')
        .where("clientId", isEqualTo: clientId)
        .get()
        .then((snapshot) {
      print('line 733 clientdet ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        if (snp['departmentName'] == null || snp['departmentName'] == '') {
          continue;
        }
        if (snp['departmentName'] == 'Not Specified') {
          continue;
        }
        if (snp['branchName'].contains('PSG') == true) {
          continue;
        }
        if (departmentNames.indexOf(snp['departmentName']) != -1) {
          continue;
        }
        bool gotDepartmentId = false;
        for (int i = 0; i < departmentIds.length; i++) {
          gotDepartmentId = false;
          if (snp['departmentId'] == departmentIds[i]) {
            gotDepartmentId = true;
            break;
          }
        }
        if (gotDepartmentId == true) {
          departmentNames.add(snp['departmentName']);
        }
        lm.add(snp.data());
      }
    });
    return lm;
  }

  Future<ClientUser> getClientUserMap(int clientId, String userEmail) async {
    ClientUser? lm;
    print('line 747 in get clientUser: $userEmail');
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
          //   print('line 1762: ${obj}');
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
      print('line 1797 error: $e');
      throw Exception(e.toString());
    }
  }

  String getStringDate2(Timestamp ts, dynamic dayValue) {
    print('line 920 getstringdate2 $ts $dayValue');
    try {
      List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      int dv = int.parse(dayValue.toString());
      String dvs = days[dv - 1];
      DateTime dt = ts.toDate();

      final format = DateFormat('MM-DD-yyyy');
      String dte = format.format(dt);
      dte += ' ( ' + dvs + ')';
      return dte;
    } catch (e) {
      print('line 1248 $e');
      throw Exception('Error line 1248: ${e.toString()}');
    }
  }

  Map<String, dynamic> convertObjToHbj(Map<String, dynamic> obj) {
    print('line 2152 ${obj['dates']['shiftDateInfo']}');
    print(
        'line 2154 convertobjtohobj ${obj['dates']['shiftDateInfo']['shiftDate']}');
    //      var od= 0;
    Timestamp shiftDate =
        Timestamp.fromDate(obj['dates']['shiftDateInfo']['shiftDate']);
    DateTime nwd = DateTime.now();
    Timestamp ts = Timestamp.fromDate(nwd);
    Map<String, dynamic> hobj = {};
    print('line 2161');
    try {
      hobj = {
        "orderId": 0,
        "uniqueId": 0,
        "lastModified": ts,
        "clientId": obj['clientId'],
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
        'workOrderId': 0
      };
      print('line 2452 return from converttohobj: $hobj');
      return hobj;
    } catch (e) {
      print('line 1041 catch error:  $hobj $e');
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
      print('line 88 ${snapshot.docs.length}');
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
        .where("clientUserId", isEqualTo: clientUserId)
        .get()
        .then((snapshot) {
      print('line 88 ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        String documentId = snp.id;
        lm = snp.data();
        lm['id'] = documentId;
        clientId = lm['clientId'];
        clientUserId = lm['clientUserId'];
        client = lm;
        break;
      }
    });
    return lm;
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

  Future<void> sendClientCancelMessage(
      Map<String, dynamic> wor, List<String> tos, String reason) async {
    //Timestamp ts = Timestamp.fromDate(DateTime.now());
    print('line 2438: ${wor}');
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
    print('line 557: ${cancelShift}');
    await FirebaseFirestore.instance
        .collection('ClientShiftCancellationMessage')
        .doc(orderId.toString())
        .set(cancelShift);

    return;
  }

//old cms_web
  Future<Map<String, dynamic>>? getASingleClientUser(int clientId) async {
    print('line 20 get a singleclient user ${clientId}');
    try {
      Map<String, dynamic>? mp;
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .where('clientId', isEqualTo: clientId)
          .where('roles', arrayContainsAny: [
            'ClientAdmin',
            'ClientSupervisor',
            'ClientScheduler',
            'CMSAdmin',
            'CMSScheduler'
          ])
          .get()
          .then((querySnapshot) {
            if (querySnapshot.docs.length == 0) {
              print('line 36 no records returned');
              mp = {};
              return mp;
            }
            var snp = querySnapshot.docs[0];
            var documentId = snp.id;
            var obj = snp.data();
            obj['id'] = documentId;
            mp = obj;
            print('line 45 $mp');
            return mp;
          });
      print('line 48 $mp');
      return mp!;
    } catch (e) {
      print('line 42 error: ${e.toString()}');
      throw Exception('line 37 ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getListOfClientUsers(int clientId) async {
    try {
      List<Map<String, dynamic>> listMap = [];
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) {
        for (var snp in querySnapshot.docs) {
          String documentId = snp.id;
          var obj = snp.data();
          obj['id'] = documentId;
          listMap.add(obj);
        }
      });
      return listMap;
    } catch (e) {
      print('line 49 error: ${e.toString()}');
      return [];
    }
  }

  Future<bool> updateClientAddressForm(
      String documentId, Map<String, dynamic> mp) async {
    try {
      print('line 36: $documentId ${mp}');
      await FirebaseFirestore.instance
          .collection('ClientAddress')
          .doc(documentId)
          .set(mp, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('line 37 error: ${e.toString()}');
      return false;
    }
  }

  //end of original client services
  Future<List<Map<String, dynamic>>> getClientUsersByRole(
      int clientId, String role) async {
    List<Map<String, dynamic>> clus = [];

    try {
      List<Map<String, dynamic>>? lclu = await FirebaseFirestore.instance
          .collection('ClientUser')
          //   .where('clientId',isEqualTo: clientId) --put back when live
          .where('clientId', isEqualTo: clientId)
          .where('roles', arrayContains: role)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          obj['id'] = docSnapshot.id;
          clus.add(obj);
        }
      });
      print('line 955: ${clus.length}');
      return clus;
    } catch (e) {
      print('line 941 error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>>? getClientFromHCPSignedIn(int hcpId) async {
    print('ine 19 in getclientfromhcpsignedin: $hcpId');
    Map<String, dynamic>? lm;
    int? clientId;
    DateTime curd = DateTime.now();
    curd = curd.subtract(Duration(
        hours: curd.hour,
        minutes: curd.minute,
        seconds: curd.second,
        microseconds: curd.microsecond,
        milliseconds: curd.millisecond));

    try {
      print('line 31: $curd');
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where("hcpId", isEqualTo: hcpId)
          .where('shiftStatus', isEqualTo: 'SignedIn')
          .get()
          .then((snapshot) async {
        print('line 38: ${snapshot.docs.length}');
        for (var snp in snapshot.docs) {
          var obj = snp.data();
          print('line 39: ${obj['shiftDate']}');
          Timestamp tss = obj['shiftDate'];
          DateTime tdt = tss.toDate();
          tdt = tdt.subtract(Duration(
              hours: tdt.hour,
              minutes: tdt.minute,
              seconds: tdt.second,
              microseconds: tdt.microsecond,
              milliseconds: tdt.millisecond));
          if (curd.millisecondsSinceEpoch == tdt.millisecondsSinceEpoch) {
            //same day
            clientId = obj['clientId'];
            break;
          } else {
            //last shift
            if (obj['shiftCode'] == 'PA' || obj['shiftCode'] == '5') {
              tdt.add(Duration(days: 1));
              if (curd.millisecondsSinceEpoch == tdt.millisecondsSinceEpoch) {
                clientId = obj['clientId'];
                break;
              }
            }
          }
        }
        print('line 64: $clientId');
        if (clientId != null) {
          await FirebaseFirestore.instance
              .collection('Client')
              .where("clientId", isEqualTo: clientId!)
              .get()
              .then((snapshot) {
            for (var snp in snapshot.docs) {
              var obj = snp.data();
              print('line 71: ${obj['gpoClient']}');
              lm = {'clientId': clientId, 'gpoClient': obj['gpoClient']};
              break;
            }
            return lm;
          });
        } else {
          return lm;
        }
      });
      print('line 83');
      return lm!;
    } catch (e) {
      print('line 20 error: ${e.toString()}');
      throw Exception('line 21 error: ${e.toString()}');
    }
  }

  Future<bool>? getClientUserByName(int clientId, String usn) async {
    String xusn = usn.replaceAll(' ', '');
    bool? retV;
    print('line 96: $clientId $usn $xusn');
    await FirebaseFirestore.instance
        .collection('ClientUser')
        .where("clientId", isEqualTo: clientId)
        .where('fullName', whereIn: [usn, xusn])
        .get()
        .then((snapshot) async {
          print('line 38: ${snapshot.docs.length}');
          if (snapshot.docs.length == 0) {
            retV = false;
          } else {
            for (var snp in snapshot.docs) {
              var obj = snp.data();
              break;
            }
            retV = true;
            return;
          }
        });
    return retV!;
  }

  Future<bool>? getClientFromHCPSignedOut(int hcpId) async {
    print('ine 93 in getclientfromhcpsignedin: $hcpId');
    Map<String, dynamic>? lm;
    int? clientId;
    DateTime curd = DateTime.now();
    curd = curd.subtract(Duration(
        hours: curd.hour,
        minutes: curd.minute,
        seconds: curd.second,
        microseconds: curd.microsecond,
        milliseconds: curd.millisecond));

    try {
      print('line 31: $curd');
      bool retV = false;
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where("hcpId", isEqualTo: hcpId)
          .where('shiftStatus', isEqualTo: 'SignedOut')
          .get()
          .then((snapshot) async {
        print('line 38: ${snapshot.docs.length}');
        for (var snp in snapshot.docs) {
          var obj = snp.data();
          print('line 39: ${obj['shiftDate']}');
          Timestamp tss = obj['shiftDate'];
          DateTime tdt = tss.toDate();
          tdt = tdt.subtract(Duration(
              hours: tdt.hour,
              minutes: tdt.minute,
              seconds: tdt.second,
              microseconds: tdt.microsecond,
              milliseconds: tdt.millisecond));
          if (curd.millisecondsSinceEpoch == tdt.millisecondsSinceEpoch) {
            //same day
            clientId = obj['clientId'];
            retV = true;
            break;
          } else {
            //last shift
            if (obj['shiftCode'] == 'PA' || obj['shiftCode'] == '5') {
              tdt.add(Duration(days: 1));
              if (curd.millisecondsSinceEpoch == tdt.millisecondsSinceEpoch) {
                clientId = obj['clientId'];
                retV = true;
                break;
              }
            }
          }
        }
      });
      print('line 64: $clientId');
      return retV;
    } catch (e) {
      print('line 20 error: ${e.toString()}');
      throw Exception('line 21 error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>>? getASMWorkOrder(
      int hcpId, DateTime shiftDate, String shiftCode) async {
    DateTime time = shiftDate;
    int timestamp = time.millisecondsSinceEpoch;
    Map<String, dynamic> lm = {};
    await FirebaseFirestore.instance
        .collection('ASMWorkOrder')
        .where("hcpId", isEqualTo: hcpId)
        .where('shiftDate', isEqualTo: timestamp)
        .where('shiftCode', isEqualTo: shiftCode)
        .get()
        .then((snapshot) {
      print('line 88 ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        lm = snp.data();
        break;
      }
    });
    return lm;
  }

  final CollectionReference<ClientData> clientRef = FirebaseFirestore.instance
      .collection('ClientData')
      .withConverter<ClientData>(
        fromFirestore: (snapshots, _) => ClientData.fromJson(snapshots.data()!),
        toFirestore: (client, _) => client.toJson(),
      );

  Future<List<Map<String, dynamic>>>? getBranches(List<int> branchIds) async {
    List<Map<String, dynamic>> lm = [];
    print('line 179 berbranches: $branchIds');
    try {
      await FirebaseFirestore.instance
          .collection('CMSBranch')
          .get()
          .then((snapshot) {
        print('line 88 ${snapshot.docs.length}');
        for (var snp in snapshot.docs) {
          final obj = snp.data();
          int obi = obj['branchId'];
          if (branchIds.indexOf(obi) != -1) {
            lm.add(snp.data());
          }
        }
      });
      print('line 192:  ${lm.length}');
      return lm;
    } catch (e) {
      print('line 191 get branches $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>>? getBranchesOfHCP(String userEmail) async {
    Map<String, dynamic> lm = {};
    List<int> branchIds = [];
    print('line 202 $userEmail');
    if (userEmail.contains('tester') == true) {
      await FirebaseFirestore.instance
          .collection('users')
          .where("email", isEqualTo: userEmail)
          .get()
          .then((snapshot) {
        print('line 88 ${snapshot.docs.length}');
        for (var snp in snapshot.docs) {
          lm = snp.data();
          for (int j = 0; j < lm['branchIds'].length; j++) {
            int bid = lm['branchIds'][j];
            if (bid == 0) {
              branchIds = [
                615,
                624,
                632,
                634,
                635,
                637,
                638,
                639,
                640,
                641,
                643
              ];
              break;
            }
            branchIds.add(bid);
          }
        }
      });
      lm = lm[0];
    } else {
      await FirebaseFirestore.instance
          .collection('HCProfessional')
          .where("email", isEqualTo: userEmail)
          .get()
          .then((snapshot) {
        print('line 239 ${snapshot.docs.length}');
        for (var snp in snapshot.docs) {
          lm = snp.data();
        }
      });
      lm = lm[0];
      branchIds.add(lm['branchId']);
    }
    List<Map<String, dynamic>>? bm = [];
    await FirebaseFirestore.instance
        .collection('CMSBranch')
        .where("branchId", whereIn: branchIds)
        .get()
        .then((snapshot) {
      print('line 88 ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        bm.add(snp.data());
      }
    });
    return bm;
  }

  Future<dynamic> getSchedulingData(int clientId) async {
    print('line 392 getscheudling data: $clientId');
    try {
      List<Map<String, dynamic>>? dps = [];
      FirebaseFirestore.instance
          .collection('ClientDepartment')
          .where('clientId', isEqualTo: clientId)
          .where('statusDescription', isEqualTo: 'Active')
          .orderBy("clientId", descending: false)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          dps.add(obj);
        }
      });
      // List<Map<String, dynamic>> drs = [];
      List<Map<String, dynamic>> listClientDepartments = dps;
      var clientRateGroups = await FirebaseFirestore.instance
          .collection('ClientRate')
          .where('clientId', isEqualTo: clientId)
          .where('rateType', isEqualTo: 'Per Diem')
          .orderBy("clientId", descending: false)
          .get();
      List<ClientRate> listClientRateClass = [];
      List<Map<String, dynamic>> listClientRates = [];
      for (var doc in clientRateGroups.docs) {
        Map<String, dynamic> obj = doc.data();
        listClientRates.add(obj);
      }
      List<Map<String, dynamic>> listClientDisciplines = [];
      List<Map<String, dynamic>> listClientShiftRates = [];
      int currentDisciplineId = 0;
      String currentDisciplineName = '';
      List<String> validDisciplines = [
        'CNA',
        'RN',
        'LPN',
        'MedTech',
        'KMA',
        'SRNA',
        'HCT',
        'Sitter',
        'House'
      ];

      for (int i = 0; i < listClientRates.length; i++) {
        Map<String, dynamic> dr = listClientRates[i];
        print('line 681: $dr');
        if (dr['disciplines'].length == 0) {
          continue;
        }
        List<DepartmentInstance> listDepartments = dr['departments'];
        int ii = 0;
        print('line 693 ${dps.length}');
        bool gotAHit = false;
        int departmentId = -1;
        while (ii < listDepartments.length) {
          DepartmentInstance dp = listDepartments[ii];
          gotAHit = false;
          for (int j = 0; j < dps.length; j++) {
            Map<String, dynamic> dv = dps[j];

            // print('line 698 $dv');
            // print('line 699: ${dv['departmentId']}');
            // print('line 700: ${dp['DeptID']}');
            if (dv['departmentId'] == dp.departmentId) {
              gotAHit = true;
              if (dv['statusDescription'] != 'Active') {
                listDepartments.removeAt(ii);
                ii = -1;
                break;
              } else {
                departmentId = dp.departmentId;
                break;
              }
            }
          }
          if (gotAHit == false && ii != -1) {
            listDepartments.removeAt(ii);
            ii = -1;
          } else {
            if (departmentId != -1) {
              break;
            }
          }
          ii += 1;
        }
        List<DisciplineInstance> listDisciplines = dr['disciplines'];
        List<RateInstance> listRates = dr['rates'];
        int currentRateGroupId = 0;
        print('line ${dr['rates']}');
        if (dr['disciplineId'] == null || dr['rateType'] == null) {
          continue;
        }
        ClientRate drr = ClientRate(
            rateGroupId: dr['rateGroupId'],
            rateType: dr['rateType'],
            branchId: dr['branchId'],
            branchName: dr['branchName'],
            disciplineId: dr['disciplineId'],
            disciplineName: dr['disciplineName'],
            clientId: dr['clientId'],
            clientName: dr['clientName'],
            nationalClient: dr['nationalClient'],
            hcpId: dr['hcpId'] == null ? 0 : dr['hcpId'],
            hcpName: dr['hcpName'],
            burden: dr['burden'],
            orderId: dr['orderId'],
            contract: dr['contract'],
            workersCompCodeId: dr['workersCompCodeId'],
            workersCompType: dr['workersCompType'],
            quoteId: dr['quoteId'],
            rateGroupTypeCodeId: dr['rateGroupTypeCodeId'],
            rateGroupTypeName: dr['rateGroupTypeName'],
            rateGroupTypeValue: dr['rateGroupTypeValue'],
            contractTemplateName: dr['contractTemplateName'],
            overridePayModifiers: dr['overridePayModifiers'],
            payOT: dr['payOT'],
            payOTPlus: dr['payOTPlus'],
            payDbl: dr['payDbl'],
            payDblPlus: dr['payDblPlus'],
            payHoliday: dr['payHoliday'],
            payHolidayPlus: dr['payHolidayPlus'],
            payMax: dr['payMax'],
            payMaxPlus: dr['payMaxPlus'],
            overrideBillModifiers: dr['overrideBillModifiers'],
            billOT: dr['billOT'],
            billOTPlus: dr['billOTPlus'],
            billDbl: dr['billDbl'],
            billDblPlus: dr['billDblPlus'],
            billHoliday: dr['billHoliday'],
            billHolidayPlus: dr['billHolidayPlus'],
            billMax: dr['billMax'],
            billMaxPlus: dr['billMaxPlus'],
            departments: listDepartments,
            disciplines: listDisciplines,
            rates: listRates,
            expirationDate: null,
            lastModifiedDate: null);
        currentDisciplineId = dr['disciplineId'];
        currentDisciplineName = dr['disciplineName'];
        currentRateGroupId = dr['rateGroupId'];
        dynamic lsd;
        //   bool hasDrr = false;

        print('line 740 check ${drr.branchName}');
        print('line 741: ${listDepartments.length}');
        for (int j = 0; j < listDepartments.length; j++) {
          lsd = listDepartments[j];
          bool isDuplicate = false;
          for (int k = 0; k < listClientDepartments.length; k++) {
            dynamic lse = listClientDepartments[k];
            if (lsd['departmentId'] == lse['departmentId']) {
              isDuplicate = true;
              break;
            }
          }
          if (isDuplicate == false) {
            listClientDepartments.add(lsd);
          }
        }
        print('line 756: ${listClientDepartments.length}');
        for (int j = 0; j < listDisciplines.length; j++) {
          lsd = listDisciplines[j];
          bool isDuplicate = false;
          for (int k = 0; k < listClientDisciplines.length; k++) {
            dynamic lse = listClientDisciplines[k];
            if (lsd['disciplineId'] == lse['disciplineId']) {
              isDuplicate = true;
              break;
            }
          }
          //     print('line 490: $isDuplicate');
          if (isDuplicate == false) {
            if (lsd['disciplineName'] == 'Sitt2') {
              lsd['disciplineName'] = 'Sitter';
            }
            if (lsd['disciplineName'] == 'HOUSE') {
              lsd['disciplineName'] = 'House';
            }
            if (lsd['disciplineName'] == 'MTECH') {
              lsd['disciplineName'] = 'MedTech';
            }
            print('line 777 in clsvr getschedata');
            int idx = validDisciplines.indexOf(lsd['disciplineName']);
            print('line 779 in clsvr getschedata');
            if (idx == -1) {
              continue;
            }

            listClientDisciplines.add(lsd);
          }
        }
        //   print('line 511 clenver getsche  ${listRates.length}, $currentDisciplineId, $currentDisciplineName');
        for (int j = 0; j < listRates.length; j++) {
          lsd = listRates[j];
          lsd['disciplineId'] = currentDisciplineId;
          lsd['disciplineName'] = currentDisciplineName;
          lsd['rateGroupId'] = currentRateGroupId;
          listClientShiftRates.add(lsd);
        }
        listClientRateClass.add(drr);
      }

      dynamic obj = {
        'clientRates': listClientRates,
        'disciplines': listClientDisciplines,
        'departments': listClientDepartments,
        'shiftRates': listClientShiftRates
      };
      //   print('line 509: ${listClientDisciplines.length}');

      return obj;
    } catch (e) {
      print('line 838: $e');
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> getClientDepartments(int? clientId) async {
    //   print('line 114: $app');

    print('line 512 clntsrv $clientId');
    String? userEmail = authService.clientMap!['email'];
    if (clientId == null) {
      print('line 516 clnsvr getdepts: $userEmail');
      if (userEmail == null) {
        throw Exception('line 122 clientsvr null email');
      }
      clientId = await getClientUser(userEmail);
      if (clientId == null) {
        throw Exception('line 126 clientsvr clientid =- null');
      }
    }
    print('line 525 in cientserverices get depts: $clientId');
    Map<String, dynamic>? lc;
    try {
      // var clientBase= await FirebaseFirestore.instance.collection("Client").withConverter(
      //   fromFirestore: Client.fromFirestore,  //returns what it gets from the database as an object
      //   //to write to firebase return object as map
      //   toFirestore: (Client clientData,options) => clientData.toFirestore(),
      // ).where("clientId", isGreaterThan: 0).get();

      var clientDepartments = await FirebaseFirestore.instance
          .collection('ClientDepartment')
          .where('clientId', isEqualTo: clientId)
          .where('statusDescription', isEqualTo: 'Active')
          .get();

      List<Map<String, dynamic>> listClientDepartments = [];
      for (var doc in clientDepartments.docs) {
        var obj = doc.data();
        listClientDepartments.add(obj);
      }
      print('line 633: ${listClientDepartments[0]['departmentNumber']}');
      //List<dynamic>lst = [];

      var clientRateGroups = await FirebaseFirestore.instance
          .collection('ClientRate')
          .where('clientId', isEqualTo: clientId)
          .get();

      List<Map<String, dynamic>> listClientRates = [];
      for (var doc in clientRateGroups.docs) {
        var obj = doc.data();
        listClientRates.add(obj);
      }
      //  updateClientDepartments(listClientDepartments);
      //  val = await coll.findOne(where.eq("my_field", 17).fields(['str_field','my_field']));
      //   List<Map<String,dynamic>> drs = await MongoDatabaseNonRealm.db!
      //       .collection('ClientRate')
      //       .find(where.eq('clientId',clientId).oneFrom('departments.DeptID',[departmentId])).toList();
      //  ClientDepartment cdt = listClientDepartments[0];
      for (int i = 0; i < listClientDepartments.length; i++) {
        Map<String, dynamic> obj = listClientDepartments[i];
        int departmentId = obj['departmentId'];
        bool haveRate = false;
        for (int j = 0; j < listClientRates.length; j++) {
          Map<String, dynamic> obr = listClientRates[j];

          for (int k = 0; k < obr['departments']!.length; k++) {
            if (obr['departments']![k].departmentId == departmentId) {
              haveRate = true;
              obj['rateGroups'].add(obr);
              break;
            }
          }
          if (haveRate == true) {
            break;
          }
        }
      }
      Map<String, dynamic> rtv = {'listDepartments': listClientDepartments};
      print('line 6555 clsvrs getepts: ${rtv['listDepartments'].length}');
      //   print('line 196  clsvrs getepts: ${listC[0]}');
      return rtv;
    } catch (e) {
      print('line 3660 _getClient Schedule error: $lc $e');
      throw Exception('line 661 error in clientsvr gett depts: $e');
      //rethrow
      //throw Exception('Error getting client invoices: $e');
    }
  }

  Future<int?> getClientUser(dynamic email) async {
    int? clientId;

    try {
      print('line 82 clver getcluser $email');
      Map<String, dynamic>? ssr;
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final obj = docSnapshot.data();
          ssr = obj;
          break;
        }
      });
      print('line 85 in getclientuser $ssr');
      //   ssr.then( (val) {
      //     print('line 229: $ssr $val');
      //     clientUser = val;
      // });
      //
      if (ssr != null) {
        return ssr!['clientId'];
      }
      return clientId;
    } catch (e) {
      Future.delayed(const Duration(seconds: 1));
      print('line 236 gettingclientuser: $e');
      return clientId;
    }
  }
}
