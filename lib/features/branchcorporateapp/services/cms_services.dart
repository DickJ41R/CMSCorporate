import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/branchcorporateapp/models/cms_branch_users.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';

class CMSServices {
  CMSServices();
  UtilitiesServices util = UtilitiesServices();
  ClientServices clientServices = ClientServices();

  Future<List<Map<String, dynamic>>>? getCMSBranchUsers() async {
    List<Map<String, dynamic>>? lm;
    await FirebaseFirestore.instance
        .collection('CMSBranchUser')
        .get()
        .then((snapshot) {
      lm = [];
      debugPrint('line 158 cmsuser ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        lm!.add(snp.data());
      }
    });
    return lm!;
  }

  Future<Map<String, dynamic>>? getCMSBranchUser(int cmsBranchUserId) async {
    Map<String, dynamic>? lm;
    await FirebaseFirestore.instance
        .collection('CMSUser')
        .where("genId", isEqualTo: cmsBranchUserId)
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

  Future<List<Map<String, dynamic>>>? getCMSBranchUsersByBranchIds(
      List<int> branchIds) async {
    List<Map<String, dynamic>> lm = [];

    try {
      await FirebaseFirestore.instance
          .collection('CMSBranchUser')
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

  Future<CMSBranchUser>? getCMSBranchUserMapData(String userEmail) async {
    CMSBranchUser? lm;
    debugPrint('line 747 in get clientUser: $userEmail');
    try {
      final docRef =
          FirebaseFirestore.instance.collection("CMSBranchUser").doc(userEmail);
      docRef.get().then(
        (DocumentSnapshot doc) {
          final obj = doc.data() as Map<String, dynamic>;
          // ...
          CMSBranchUser cmsb = CMSBranchUser(
              obj['active'],
              obj['branchIds'],
              obj['branchNames'],
              obj['dateOfLastLogin'],
              obj['devices'],
              obj['displayName'],
              obj['email'],
              obj['fcmToken'],
              obj['fcmTokens'],
              obj['firstName'],
              obj['fullName'],
              obj['genId'],
              obj['isAdministrator'],
              obj['isEmailVerified'],
              obj['lastName'],
              obj['loginCounter'],
              obj['ownerId'],
              obj['password'],
              obj['roles'],
              obj['status'],
              obj['statusId'],
              obj['securityGroupId'],
              obj['securityGroupName'],
              obj['telephone'],
              obj['telephoneExtension'],
              obj['userId'],
              obj['username'],
              obj['userType']);
          lm = cmsb;
        },
        onError: (e) => debugPrint("Error getting document: $e"),
      );

      if (lm == null) {
        throw Exception('line 760 getclientusermap: No lm');
      }
      return lm!;
    } catch (e) {
      debugPrint('line 761 error: $e');
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

      final format = DateFormat('MM-DD-yyyy');
      String dte = format.format(dt);
      dte += ' ( ' + dvs + ')';
      return dte;
    } catch (e) {
      debugPrint('line 1248 $e');
      throw Exception('Error line 1248: ${e.toString()}');
    }
  }

  Map<String, dynamic> convertObjToHbj(Map<String, dynamic> obj) {
    debugPrint('line 1251 ${obj['dates']['shiftDateInfo']}');
    debugPrint(
        'line 927 convertobjtohobj ${obj['dates']['shiftDateInfo']['shiftDate'].runtimeType}');
    //      var od= 0;
    Timestamp shiftDate =
        Timestamp.fromDate(obj['dates']['shiftDateInfo']['shiftDate']);
    DateTime nwd = DateTime.now();
    Timestamp ts = Timestamp.fromDate(nwd);
    Map<String, dynamic> hobj = {};
    debugPrint('line 932');
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
        'uuid': obj['uuid']
      };
      return hobj;
    } catch (e) {
      debugPrint('line 1041 catch error:  $hobj $e');
      throw Exception(e.toString());
    }
  }

  Future<bool>? updateCMSBranchUser(int cmsBranchId, String fcmToken) async {
    Map<String, dynamic>? obj;
    String? objId;
    await FirebaseFirestore.instance
        .collection('CMSBranchUser')
        .where("genId", isEqualTo: cmsBranchId)
        .get()
        .then((snapshot) async {
      debugPrint('line 88 ${snapshot.docs.length}');
      for (var i = 0; i < snapshot.docs.length; i++) {
        objId = snapshot.docs[i].id;
        obj = snapshot.docs[i].data();
        break;
      }
      await FirebaseFirestore.instance
          .collection('CMSBranchUser')
          .doc(objId)
          .update({"fcmToken": fcmToken});
    });
    return true;
  }

  Future<Map<String, dynamic>>? getSingleCMSBranchUser(
      int cmsBranchUserId) async {
    Map<String, dynamic> lm = {};
    await FirebaseFirestore.instance
        .collection('CMSBranchUser')
        .where("genId", isEqualTo: cmsBranchUserId)
        .get()
        .then((snapshot) {
      debugPrint('line 88 ${snapshot.docs.length}');
      for (var snp in snapshot.docs) {
        lm = snp.data();
        break;
      }
    });
    return lm;
  }

  Future<List<int>> getCMSBranchUserIds(int branchId) async {
    List<int> listCMSBranchIds = [];
    try {
      await FirebaseFirestore.instance
          .collection('CMSBranchUser')
          .where('genId', isGreaterThan: 0)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> lm = docSnapshot.data();
          listCMSBranchIds.add(lm['genId']);
        }
      });
      return listCMSBranchIds;
    } catch (e) {
      debugPrint('line 394 error: ${e.toString()}');
      return [];
    }
  }

  // Future<List<dynamic>> getAppropriateScreenData(int selectedBranchNumber,
  //     String selectedMenuOption, BuildContext ctx) async {
  //   List<dynamic> listData = [];
  //   List<int> listClientIds = [];
  //   try {
  //     debugPrint('line 418: ${listClientIds.length}');
  //     if (selectedMenuOption == 'Work Orders') {
  //       //all by data
  //       if (selectedBranchNumber != 0) {
  //         listClientIds =
  //             await clientServices.getClientIds(selectedBranchNumber);
  //       }
  //       listData = await callGetWorkOrdersFirestore(ctx, listClientIds);
  //       debugPrint('line 421: ${listData.length}');
  //     } else if (selectedMenuOption == 'Clients') {
  //       if (selectedBranchNumber != 0) {
  //         listClientIds =
  //             await clientServices.getClientIds(selectedBranchNumber);
  //       }
  //       listData =
  //           await clientServices.callGetClientsFirestore(ctx, listClientIds);
  //       debugPrint('line 424: ${listData.length}');
  //     } else if (selectedMenuOption == 'HCPs') {
  //       listData =
  //           await hcpServices.callGetHCPsFirestore(ctx, selectedBranchNumber);
  //       debugPrint('line 424: ${listData.length}');
  //     } else if (selectedMenuOption == 'Time Cards') {}
  //     return listData;
  //   } catch (e) {
  //     debugPrint('line 402: ${e.toString()}');
  //     return [];
  //   }
  // }

  Future<List<Map<String, dynamic>>> callGetWorkOrdersFirestore(
      BuildContext ctx, List<int> listClientIds) async {
    debugPrint('line 434 in getworkorders firestore: ${listClientIds.length}');
    List<Map<String, dynamic>> listLm = [];
    try {
      if (listClientIds.length > 0) {
        await FirebaseFirestore.instance
            .collection('ClientASMWorkOrder')
            .where('clientId', whereIn: listClientIds)
            .get()
            .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            Map<String, dynamic> lm = docSnapshot.data();
            listLm.add(lm);
          }
          return;
        });
        debugPrint('line 448: ${listLm.length}');
        return listLm;
      } else {
        await FirebaseFirestore.instance
            .collection('ClientASMWorkOrder')
            .get()
            .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            Map<String, dynamic> lm = docSnapshot.data();
            listLm.add(lm);
          }
        });
        debugPrint('line 460: ${listLm.length}');
        return listLm;
      }
    } catch (e) {
      debugPrint('line 464 error: ${e.toString()}');
      return [];
    }
  }

  int calc_ranks(ranks) {
    double multiplier = .5;
    return (multiplier * ranks).round();
  }

  Future<List<dynamic>> callGetWorkOrders(
      BuildContext ctx, List<int> listClientIds) async {
    List<dynamic> result = [];
    try {
      HttpsCallable callable = await FirebaseFunctions.instance.httpsCallable(
        'getWorkOrders',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 290),
        ),
      );
      debugPrint('line 441 in call A  function: $callable');
      result = await callingGetWorkOrders(callable, ctx, listClientIds);
      debugPrint('line 443: ${result.length}');
      return result;
    } catch (e) {
      debugPrint('line 446: $e');
      return [];
    }
  }

  Future<List<dynamic>> callingGetWorkOrders(
      HttpsCallable callable, BuildContext ctx, List<int> listClientIds) async {
    try {
      Map<String, dynamic> data = {'data': listClientIds};
      debugPrint('line 457: ${data}');

      final HttpsCallableResult result = await callable(data);
      debugPrint('line 458 $result');
      //  debugPrint('line 459: ${result.data}');
      return result.data;
    } catch (e) {
      debugPrint('line 462 error: $e');
      return [];
    }
  }

  Future<List<int>> getClientIds(int branchId) async {
    List<int> listClientIds = [];
    try {
      await FirebaseFirestore.instance
          .collection('Client')
          .where('branchId', isEqualTo: branchId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> lm = docSnapshot.data();
          listClientIds.add(lm['clientId']);
        }
      });
      debugPrint('line 5424: ${listClientIds.length}');
      return listClientIds;
    } catch (e) {
      debugPrint('line 527 error: ${e.toString()}');
      return [];
    }
  }

  Future<List<int>> getCorporateBranchClientIds() async {
    List<int> listClientIds = [];
    try {
      await FirebaseFirestore.instance
          .collection('Client')
          .where('branchId', isGreaterThan: 0)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> lm = docSnapshot.data();
          listClientIds.add(lm['clientId']);
        }
      });
      debugPrint('line 544: ${listClientIds.length}');
      return listClientIds;
    } catch (e) {
      debugPrint('line 547 error: ${e.toString()}');
      return [];
    }
  }

  Future<List<dynamic>> getAppropriateScreenData(int selectedBranchNumber,
      String selectedMenuOption, BuildContext ctx) async {
    List<dynamic> listData = [];
    List<int> listClientIds = [];
    try {
      debugPrint('line 558: $selectedBranchNumber $selectedMenuOption ');
      if (selectedMenuOption == 'Work Orders') {
        //all by data
        if (selectedBranchNumber != 0) {
          listClientIds = await getClientIds(selectedBranchNumber);
        }
        listData = await callGetWorkOrdersFirestore(ctx, listClientIds);
        debugPrint('line 565: ${listData.length}');
      } else if (selectedMenuOption == 'Clients') {
        if (selectedBranchNumber != 0) {
          listClientIds = await getClientIds(selectedBranchNumber);
        } else {
          listClientIds = await getCorporateBranchClientIds();
        }
        listData = await callGetClientsFirestore(ctx, listClientIds);
        debugPrint('line 573: ${listData.length}');
      } else if (selectedMenuOption == 'HCPs') {
        listData = await callGetHCPsFirestore(ctx, selectedBranchNumber);
        debugPrint('line 576: ${listData.length}');
      } else if (selectedMenuOption == 'Time Cards') {}
      debugPrint('line 578: ${listData.length}');
      return listData;
    } catch (e) {
      debugPrint('line 581: ${e.toString()}');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> callGetClientsFirestore(
      BuildContext ctx, List<int> listClientIds) async {
    debugPrint('line 588 in getclients firestore: ${listClientIds.length}');
    List<Map<String, dynamic>> listLm = [];
    double loops = num.parse(listClientIds.length.toString()) / 10;
    int lops = loops.truncate();
    debugPrint('ine 592: $lops $loops');
    List<int> loopCounter = [];
    if (lops > 0) {
      for (int i = 0; i < lops; i++) {
        loopCounter.add(10);
      }
    }
    int lp = 0;
    if (listClientIds.length % 10 > 0) {
      if (lops == 0) {
        lp = 0;
      } else {
        lp = lops + 1;
      }
      debugPrint('line 606: $lp $loops $lops');

      loopCounter.add(listClientIds.length % 10);
    }
    debugPrint('line 610: ${loopCounter}');
    try {
      if (listClientIds.length > 0) {
        Map<String, dynamic> lm = {};
        int iss = -10;
        int ie = 0;
        for (int i = 0; i < loopCounter.length; i++) {
          List<int> ids = [];
          iss += 10;
          ie += loopCounter[i];
          ids = [];
          debugPrint('line 621: $iss $ie');
          for (int j = iss; j < ie; j++) {
            ids.add(listClientIds[j]);
          }
          debugPrint('lint 625: $i ${ids.length}');
          await FirebaseFirestore.instance
              .collection('Client')
              .where('clientId', whereIn: ids)
              .get()
              .then((querySnapshot) async {
            for (var docSnapshot in querySnapshot.docs) {
              lm = docSnapshot.data();
              await FirebaseFirestore.instance
                  .collection('ClientCredit')
                  .where('clientId', isEqualTo: lm['clientId'])
                  .get()
                  .then((querySnapshot) async {
                Map<String, dynamic>? cm = null;
                for (var docSnapshot in querySnapshot.docs) {
                  cm = docSnapshot.data();
                  break;
                }
                if (cm != null) {
                  lm['openCredit'] = cm['creditLimit'].toString();
                } else {
                  lm['openCredit'] = "0.0";
                }
                debugPrint('line 648 ${lm['clientId']}');
                Map<String, dynamic>? im = null;
                await FirebaseFirestore.instance
                    .collection('ClientInvoice')
                    .where('clientId', isEqualTo: lm['clientId'])
                    .where('balance', isGreaterThan: 0)
                    .orderBy("invoiceDate", descending: true)
                    .get()
                    .then((querySnapshot) {
                  Map<String, dynamic>? im = null;
                  for (var docSnapshot in querySnapshot.docs) {
                    im = docSnapshot.data();
                    break;
                  }
                  if (im != null) {
                    lm['balance'] = im['balance'].toString();
                  } else {
                    lm['balance'] = "0.0";
                  }
                });
                debugPrint('line 668: ${lm['clientId']}');
                lm['city'] = "Unknown";
                lm['state'] = "UKN";
                Map<String, dynamic>? adr = null;
                await FirebaseFirestore.instance
                    .collection('ClientAddress')
                    .where('clientId', isEqualTo: lm['clientId'])
                    .where('addressType', isEqualTo: 'Primary')
                    .get()
                    .then((querySnapshot) {
                  Map<String, dynamic>? adr = null;
                  for (var docSnapshot in querySnapshot.docs) {
                    adr = docSnapshot.data();
                    break;
                  }
                  if (adr != null) {
                    lm['city'] = adr!['city'];
                    lm['state'] = adr['state'];
                  } else {
                    debugPrint('line 687 not address data for : ${lm['clientId']}');
                  }
                });
              });

              listLm.add(lm);
            }
          });
        }
        debugPrint('line 692: ${listLm.length}');
        return listLm;
      } else {
        Map<String, dynamic> lm = {};
        await FirebaseFirestore.instance
            .collection('Client')
            .get()
            .then((querySnapshot) async {
          for (var docSnapshot in querySnapshot.docs) {
            lm = docSnapshot.data();
            await FirebaseFirestore.instance
                .collection('ClientCredit')
                .where('clientId', isEqualTo: lm['clientId'])
                .get()
                .then((querySnapshot) async {
              Map<String, dynamic>? cm = null;
              for (var docSnapshot in querySnapshot.docs) {
                cm = docSnapshot.data();
                break;
              }
              if (cm != null) {
                lm['openCredit'] = cm['creditLimit'].toString();
              } else {
                lm['openCredit'] = "0.0";
              }
            });
            debugPrint('line  718: ${lm['clientId']}');
            Map<String, dynamic>? im = null;
            await FirebaseFirestore.instance
                .collection('ClientInvoice')
                .where('clientId', isEqualTo: lm['clientId'])
                .where('balance', isGreaterThan: 0)
                .orderBy("invoiceDate", descending: true)
                .get()
                .then((querySnapshot) {
              Map<String, dynamic>? im = null;
              for (var docSnapshot in querySnapshot.docs) {
                im = docSnapshot.data();
                break;
              }
              if (im != null) {
                lm['balance'] = im['balance'].toString();
              } else {
                lm['balance'] = "0.0";
              }
            });
            Map<String, dynamic>? adr = null;
            await FirebaseFirestore.instance
                .collection('ClientAddress')
                .where('clientId', isEqualTo: lm['clientId'])
                .where('addressType', isEqualTo: 'Primary')
                .get()
                .then((querySnapshot) {
              Map<String, dynamic>? adr = null;
              for (var docSnapshot in querySnapshot.docs) {
                adr = docSnapshot.data();
                break;
              }
              lm['city'] = adr!['city'];
              lm['state'] = adr['state'];
            });
            listLm.add(lm);
          }
        });
        debugPrint('line 756 ${listLm.length}');
        return listLm;
      }
    } catch (e) {
      debugPrint('line  760 error: ${e.toString()}');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> callGetHCPsFirestore(
      BuildContext ctx, int branchId) async {
    debugPrint('line 434 in getHCPs firestore: ${branchId}');
    List<Map<String, dynamic>> listLm = [];
    try {
      if (branchId == 0) {
        await FirebaseFirestore.instance
            .collection('HCProfessional')
            .where('branchId', isGreaterThan: branchId)
            .orderBy("disciplineName", descending: false)
            .orderBy("fullName", descending: false)
            .get()
            .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            Map<String, dynamic> lm = docSnapshot.data();
            listLm.add(lm);
          }
        });
      } else {
        await FirebaseFirestore.instance
            .collection('HCProfessional')
            .where('branchId', isEqualTo: branchId)
            .orderBy("disciplineName", descending: false)
            .orderBy("fullName", descending: false)
            .get()
            .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            Map<String, dynamic> lm = docSnapshot.data();
            listLm.add(lm);
          }
        });
      }
      debugPrint('line 460: ${listLm.length}');
      return listLm;
    } catch (e) {
      debugPrint('line 464 error: ${e.toString()}');
      return [];
    }
  }
}
