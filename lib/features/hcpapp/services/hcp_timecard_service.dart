import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
// Create a storage reference from our app
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Directory, File;
import 'package:cms_web/features/shared/services/utility_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cms_web/features/clientapp/services/client_services.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';

final storageRef = FirebaseStorage.instance.ref();

class HCPTimeCardService {
  UtilitiesServices util = UtilitiesServices();

  // Map<String,int> getHoursMinutes(String tme) {
  //
  //   List<String> tms = tme.split(' ');
  //   String ampm = tms[1];
  //   List<String> tcs = tms[0].split(":");
  //   int hours = int.parse(tcs[0]);
  //   if (ampm == 'PM') {
  //     hours += 12;
  //   }
  //   int minutes = int.parse(tcs[1]);
  //   Map<String,int> mps = {
  //     "hours": hours,
  //     "minutes": minutes
  //   };
  //   return mps;
  // }
  ClientServices clientServices = ClientServices();
  AuthService authServices = AuthService();

  T? tryCast<T>(dynamic value, {T? fallback}) {
    print('line 119: $value');
    try {
      return (value as T);
    } on TypeError catch (_) {
      return fallback;
    }
  }

  Future<List<Map<String, dynamic>>>? getHCPTimeCardsWithClients(
      int hcpId) async {
    List<Map<String, dynamic>> tcs = [];
    List<Map<String, dynamic>> listOfClients = [];
    List<Map<String, dynamic>> clientDNUs = [];
    List<int> noDups = [];
    try {
      FirebaseFirestore.instance
          .collection("HCPTimeCard")
          .where('hcpId', isEqualTo: hcpId)
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          tcs.add(obj);
        }

        int dts = DateTime(1900, 1, 1).millisecondsSinceEpoch;

        Map<String, dynamic> dnu = {
          "clientDNUDate": dts,
          "clientId": 0,
          "flagClientDNU": false,
          "FlagDNU": false,
          "hcpDNUDate": dts,
          "hcpId": hcpId,
          "lastTouched": dts,
          "clientName": "",
          "statusId": "A"
        };

        for (int i = 0; i < tcs.length; i++) {
          Map<String, dynamic> obj = tcs[i];
          int clientId = obj['clientId'];
          if (noDups.indexOf(clientId) != -1) {
            continue;
          }
          dnu['clientId'] = tcs[i]['clientId'];
          dnu['departmentId'] = tcs[i]['departmentId'];
          clientDNUs.add(dnu);
          noDups.add(clientId);
        }
        print('line 50 no nodups: ${noDups.length}');
        FirebaseFirestore.instance
            .collection("Client")
            .where('clientId', whereIn: noDups)
            .get()
            .then((querySnapshot) {
          print('line 54: ${querySnapshot.docs.length}');
          for (var docSnapshot in querySnapshot.docs) {
            var obj = docSnapshot.data();
            listOfClients.add(obj);
          }
          for (int i = 0; i < clientDNUs.length; i++) {
            Map<String, dynamic> dnu = clientDNUs[i];
            int clientId = dnu['clientId'];
            Map<String, dynamic> hld = {};
            for (int j = 0; j < listOfClients.length; j++) {
              Map<String, dynamic> cl = listOfClients[j];
              if (cl['statusId'] != 'A') {
                continue;
              }
              if (cl['deleted'] == true) {
                continue;
              }
              if (clientId == cl['clientId']) {
                hld = cl;
                break;
              }
            }
            if (hld.entries.isNotEmpty) {
              clientDNUs[i]['clientName'] = hld['clientName'];
            }
          }
        });
      });
      return listOfClients;
    } catch (e) {
      print('line 189 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<bool> insertHCPTimeCard(
      Map<String, dynamic> item, WriteBatch batch) async {
    print('line 136 insertimechard ${item['id']}');
    bool retV = false;
    late Map<String, dynamic> htc;
    try {
      DateTime sed = item['shiftDate'].toDate();
      Timestamp est = Timestamp.fromDate(sed);
      DateTime currentDate = DateTime.now(); //DateTime
      DateTime newDate = currentDate.subtract(Duration(
          hours: currentDate.hour,
          minutes: currentDate.minute,
          seconds: currentDate.second,
          milliseconds: currentDate.millisecond,
          microseconds: currentDate.microsecond));
      Timestamp myTimeStamp = Timestamp.fromDate(newDate);
      htc = {
        "asmWorkOrderId": item['asmWorkOrderId'],
        "shiftDate": item['shiftDate'],
        "scheduleWorkOrderId": item['scheduleWorkOrderId'],
        "orderId": item['orderId'],
        "clientId": item['clientId'],
        "departmentId": item['departmentId'],
        "branchId": item['branchId'],
        "orderType": "Per Diem",
        "clientName": item['clientName'],
        "departmentName": item["departmentName"],
        "branchName": item["branchName"],
        "workOrderDescription": item["workOrderDescription"],
        "areaId": null,
        "areaName": null,
        "campaignMessage": item["scheduleNotes"],
        "disciplineId": item["disciplineIds"],
        "disciplineNames": item["disciplineCodes"],
        "status": 'Confirmed',
        "shiftStatus": "Confirmed",
        "statusDate": Timestamp.fromDate(DateTime.now()),
        "hcpId": item['hcpId'],
        "hcpName": item['hcpName'],
        "latitude": item['hcpLatitude'] == 'latitude' ? 0 : item['hcpLatitude'],
        "longitude":
            item['hcpLongitude'] == 'longitude' ? 0 : item['hcpLongitude'],
        "clientLatitude": item['clientLatitude'],
        "clientLongitude": item['clientLongitude'],
        "shiftId": int.tryParse(item['shiftCode']) != null
            ? int.parse(item['shiftCode'])
            : 0,
        "shiftCode": item['shiftCode'],
        "shiftDescription": item['shiftCodeDescription'],
        "shiftType": item['rateType'],
        "shiftTypeDescription": null,
        "shiftStartDate": item["shiftDate"],
        "shiftEndDate": est,
        "shiftTimeCode": "UTC",
        "shiftStartTime": item["startTime"],
        "shiftEndTime": item['endTime'],
        'signedInShift': false,
        'shiftSignedInActionDate': null,
        'shiftStatusDate': Timestamp.fromDate(DateTime.now()),
        'signedInDateTime': null,
        'signedInDateTimeValue': null,
        'signedInDateTimeValueVerified': null,
        'signedInShiftDateTime': null,
        'signedInGeofenceVerified': false,
        'signedInGeofenceAvailable': false,
        "signedInHCPNotes": null,
        'signedInDeviceDateTime': null,
        'signedInLatitude': null,
        'signedInLongitude': null,
        'signedInShiftStartTime': null,
        'signedInLocationLatitude': null,
        'signedInLocationLongitude': null,
        "shiftCanceledByHCP": false,
        "shiftCanceledHCPDateTime": null,
        "shiftCanceledByClient": false,
        "shiftClientCanceledById": null,
        "shiftClientCancelByName": null,
        "meals": item['meals'],
        "isWeekend": item['weekend'],
        "isHoliday": item['holiday'],
        "useOT": false,
        "useDblTime": false,
        "useHolidayTime": false,
        "createdDate": Timestamp.fromDate(DateTime.now()),
        "payRate": item['payRate'],
        "payRateWE": item['payRateWE'],
        "overtimeRateFactor": 1.5,
        "doubleTimeRateFactor": 2.0,
        "holidayRateFactor": 2.0,
        "shiftPayRate": item['payRate'],
        "shiftBillWeekend": 0.0,
        "shiftMarginWeekend": 0.0,
        "initialVerifiedWorkHours": 0.0,
        "shiftHoursOverTime": 0.0,
        "signedOutDeviceDateTime": null,
        "signedOutGeofenceAvailable": false,
        "signedOutGeofenceVerified": false,
        "signedOutHCPNotes": null,
        "signedOutHasInitialVerification": false,
        "signedOutSupervisorSignatureFileName": null,
        "signedOutShiftDateTime": null,
        "signedOutInitialSupervisorName": null,
        "signedOutHCPSignatureFileName": null,
        "signedOutInitialVerificationNotes": null,
        "signedOutInitialStartTimeChanged": null,
        "signedOutInitialEndTimeChanged": null,
        "signedOutInitialVerification": null,
        "signedOutInitialDecimalHoursChanged": null,
        "signedOutInitialMealsChanged": null,
        "signedOutInitialVerificationDateTime": null,
        "signedOutInitialValuesChanged": null,
        "email": item['email'],
        // "signedOutHasSecondaryVerification" : false,
        // "signedOutSecondaryVerificationDateTime":null,
        //   "secondaryVerificationName": null,
        //   "secondaryVerificationId" : null,
        // "secondaryStartTimeChanged": null,
        // "secondaryEndTimeChanged": null,
        // "sSecondaryDecimalHoursChanged":null,
        // "secondaryMealsChanged": null,
        // "secondaryValuesChanges": null,
        // "secondaryVerificationComments" : null,
        // "workOrderId": item['workOrderId'],
        "woWorkOrderId": item['woWorkOrderId'],
        'clientWorkOrderCampaignId': item['id'],
      };
      print('line 243 $htc');
      final docRefx =
          await FirebaseFirestore.instance.collection('HCPTimeCard').doc();

      // await FirebaseFirestore.instance
      //     .collection('HCPTimeCard')
      //     .doc(item['id'])
      //     .set(htc);
      batch.set(docRefx, htc);
      print('line 268 after set: $htc');
      //
      // await FirebaseFirestore.instance.collection("HCPTimeCard")
      //  .doc(item['id'])
      //     .get().then(
      //         (querySnapshot)  async {
      //           print('line 219: $querySnapshot');
      //           return querySnapshot.data();
      //       });
      return true;
    } catch (e) {
      print('line 279: $htc');
      print('line 278 error: $e');
      throw Exception('line 280 ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>>? getRelatedHCPTimeCards(int hcpId) async {
    List<Map<String, dynamic>> tcs = [];
    try {
      await FirebaseFirestore.instance
          .collection("HCPTimeCard")
          .where('hcpId', isEqualTo: hcpId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          tcs.add(obj);
          break;
        }
      });
      return tcs;
    } catch (e) {
      print('line 66 error: $e');
      throw Exception(e.toString());
    }
  }

  // Future<bool> writeTimecardAfterConfrmed(ClientWorkOrderCampaign cwc) async {
  //
  //
  // }
  Future<bool>? updateSignedOutHCPTimeCards(
      Map<String, dynamic> item, Map<String, dynamic> data) async {
    //Map<String, dynamic> rlm = {};
    String? documentId;
    DateTime time = item['shiftDate'];
    int timestamp = time.millisecondsSinceEpoch;
    //  return realm.query("clientId = $clientId && hcpId == $hcpId && shiftStatus == 'SignedOut' SORT(shiftDate ASC, hcpId ASC, shiftCode ASC)");
    try {
      await FirebaseFirestore.instance
          .collection("HCPTimeCard")
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('hasSignedOut', isEqualTo: false)
          .where('shiftId', isEqualTo: item['shiftId'])
          .where('shiftDate', isEqualTo: timestamp)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          documentId = docSnapshot.id;
          //  rlm = docSnapshot.data();
          break;
        }
      });
      // var data = {
      //  "ShiftSignedOutDateTime": item['shiftSignedOutDateTime'],
      //  "signedOutGeofenceVerified": item['signedOutGeofenceVerified'],
      //  "signedOutGeofenceAvailable": item['signedOutGeofenceAvailable'],
      // "supervisorSignOutSignature" : item['supervisorSignOutSignature'],
      // "supervisorSignOutiName" : item[' supervisorSignOutiName'],
      // "signedOutGeoFencingPassed": item['signedOutGeoFencingPassed'],
      //   "signedOutVerifiedWorkHours": item['signedOutVerifiedWorkHours']
      // };

      final docRef =
          FirebaseFirestore.instance.collection("HCPTimeCard").doc(documentId);
      docRef.update(data).then(
          (value) => print("line 303 DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));

      return true;
    } catch (e) {
      print('line 351 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<bool>? cancelScheduledShift(
      Map<String, dynamic> item, BuildContext ctx) async {
    DateTime dte = DateTime.now();
    Timestamp myTimeStamp = Timestamp.fromDate(dte);
    Map<String, dynamic> rlm = {};
    print('line 360: ${item['asmWorkOrderId']}');
    //  return realm.query("clientId = $clientId && hcpId == $hcpId && shiftStatus == 'SignedOut' SORT(shiftDate ASC, hcpId ASC, shiftCode ASC)");
    try {
      if (item['asmWorkOrderId'] == null || item['asmWorkOrderId'] == 0) {
        throw Exception(
            'Error: in cancelschededshift with asmworkoderid not valid.');
      }
      String? documentId;
      await FirebaseFirestore.instance
          .collection("HCPTimeCard")
          .where('asmWorkOrderId', isEqualTo: item['asmWorkOrderId'])
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          documentId = docSnapshot.id;
          break;
        }
        final docRef = FirebaseFirestore.instance
            .collection("HCPTimeCard")
            .doc(documentId);
        docRef.delete();
      });
      print('line 383');
      int ClientId = item['clientId'];
      String ShiftCode = item['shiftCode'];
      Timestamp ts = item['shiftDate'];
      DateTime dte = ts.toDate();
      String ShiftDate = dte.toString();
      int idx = ShiftDate.indexOf(' ');
      if (idx != -1) {
        ShiftDate = ShiftDate.substring(0, idx);
      }
      final DateFormat formatter = DateFormat('MM/dd/yyyy');
      final DateTime now = DateTime.now();
      final formatted = formatter.format(now);
      String time = DateFormat.jm().format(now);
      String hardSpace = String.fromCharCode(8239);
      time = time.replaceAll(hardSpace, ' ');
      String nbsp = String.fromCharCode(0x00A0);
      time = time.replaceAll(nbsp, ' ');
      print('line 401 $time');

      dynamic cancellationMap = {
        "CancelType": item['shiftCancellationType'],
        "LateCancel": false,
        "ReOpen": true,
        "Record": false,
        "CancelReasonCodeID": item['cancelReasonCodeId'],
        "Conf_Emp": true,
        "Conf_Emp_EmailText": true,
        "Conf_Emp_Date": formatted,
        "Conf_Emp_Time": time,
        "Conf_Emp_Note": item['shiftCancellationNote'],
        "Conf_Cli": true,
        "Conf_Cli_EmailText": true,
        "Conf_Cli_Date": formatted,
        "Conf_Cli_Time": time,
        "Conf_Cli_Note": item['shiftCancellationNote'],
        "InternalNote": "Mobile cancellation by employee",
        "InvoiceNote": "Shift should not be invoiced"
      };
      print('line 421');
      Map<String, dynamic> result = await callCancelWOFunction(
          item['asmWorkOrderId'].toString(),
          'E',
          item['clientId'].toString(),
          item['shiftCode'],
          ShiftDate,
          cancellationMap,
          ctx);
      print('line 430: $result ');
      if (result.containsKey('error') == true) {
        throw Exception(result['error']);
      }
      int newOrderId = result['orderId'];
      String cwkId = '';
      String hcpCwkId = '';
      //update 4 tables: ClientHCPWorkOrder,ClientWorkOrder,ClientWorkOrderCampaign,HCPTimeCard
      //doit in batch mode
      //HCPTable
      print('line 440 $newOrderId');
      int oldOrderId = item['asmWorkOrderId']; //old value
      final db = FirebaseFirestore.instance;

      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('orderId', isEqualTo: oldOrderId)
          .get()
          .then((querySnapshot) {
        var dns = querySnapshot.docs[0];
        cwkId = dns.id;
      });
      print('line 451');
      await FirebaseFirestore.instance
          .collection('ClientHCPWorkOrder')
          .where('woWorkOrderId', isEqualTo: cwkId)
          .get()
          .then((querySnapshot) {
        var dns = querySnapshot.docs[0];
        hcpCwkId = dns.id;
      });

      WriteBatch batch = db.batch();
      //update 2 files
      //ClientWorkOrder
      print('line 463');
      final docRef2 =
          FirebaseFirestore.instance.collection("ClientWorkOrder").doc(cwkId);
      batch.set(
          docRef2,
          {
            'orderId': newOrderId,
            'woWorkOrderId': newOrderId,
            'asmWorkOrderId': newOrderId
          },
          SetOptions(merge: true));
      //ClientHCPWorkOrder
      final docRef3 = FirebaseFirestore.instance
          .collection("ClientHCPWorkOrder")
          .doc(hcpCwkId);
      batch.set(docRef3, {'orderId': newOrderId, 'asmWorkOrderId': newOrderId},
          SetOptions(merge: true));
      batch.commit();
      print('line 475');
      //send email
      var uuid = Uuid();
      var xuuid = uuid.v4();
      var ss = item['shiftDate'].toString();
      Map<String, dynamic> cancelShift = {
        "branchId": item['branchId'],
        "branchName": item['branchName'],
        "clientId": item['clientId'],
        "clientName": item['clientName'],
        "departmentId": item['departmentId'],
        "departmentName": item['departmentName'],
        "disciplineId": item['disciplineCodes'],
        "disciplineName": item['disciplineName'],
        "endTime": item['endTime'],
        "hcpId": item['hcpId'],
        "hcpName": item['hcpName'],
        "reason": item['cancelReason'],
        "shiftCode": item['shiftCode'],
        "shiftDate": ss,
        "startTime": item['startTime'],
        "statusId": "E",
        "uuid": xuuid,
      };
      FirebaseFirestore.instance
          .collection('HCPCancelConfirmMessage')
          .doc(xuuid)
          .set(cancelShift);
      return true;
    } catch (e) {
      print('line 473 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> sendCancelConfirmMessage() async {
    var uuid = Uuid();
    var xuuid = uuid.v4();
    Timestamp ts = Timestamp.fromDate(DateTime.now());
    String sname = "Duffy-11, Marie";
    int idx = -1;
    idx = sname.indexOf(',');
    var lastName = '';
    var firstName = '';
    if (idx != -1) {
      lastName = sname.substring(0, idx);
      firstName = sname.substring(idx + 1, sname.length);
      firstName = firstName.trim();
    }
    print('line 534: $idx $firstName $lastName');

    Map<String, dynamic> cancelShift = {
      "branchId": 634,
      "branchName": 'Augusta',
      "clientId": 1300,
      "clientName": 'Anchor Post',
      "departmentId": 13257,
      "departmentName": 'Department Name',
      "disciplineId": 559,
      "disciplineName": 'LPN',
      "email": "duffymarie@aol.com",
      "endTime": '11:00 PM',
      "hcpId": 46090,
      "hcpName": "Duffy-11, Marie",
      "firstName": firstName,
      "lastName": lastName,
      "reason": 'Sick',
      "shiftCode": 2,
      "shiftDate": ts,
      "startTime": "3:00 PM",
      "statusId": "E",
      "uuid": xuuid,
    };
    print('line 557: ${cancelShift}');
    await FirebaseFirestore.instance
        .collection('HCPCancelConfirmMessage')
        .doc(xuuid)
        .set(cancelShift);

    return;
  }

  Future<List<Map<String, dynamic>>>? getAllSignedOutHCPTimeCards(
      int hcpId) async {
    print('line 48: $hcpId');

    List<Map<String, dynamic>> rlm = [];
    //  return realm.query("clientId = $clientId && hcpId == $hcpId && shiftStatus == 'SignedOut' SORT(shiftDate ASC, hcpId ASC, shiftCode ASC)");
    try {
      await FirebaseFirestore.instance
          .collection("HCPTimeCard")
          .where('hcpId', isEqualTo: hcpId)
          .where('hasSignedOut', isEqualTo: true)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          rlm.add(obj);
          break;
        }
      });
      return rlm;
    } catch (e) {
      print('line 73 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>>? getHCPs(int hcpId,
      [DateTime? date]) async {
    print('line 981 in getHCPtimecard');
    try {
      DateTime shiftDate = DateTime.now();
      DateTime time = DateTime.now();
      time = time.subtract(Duration(
          hours: time.hour,
          minutes: time.minute,
          seconds: time.second,
          microseconds: time.microsecond,
          milliseconds: time.millisecond));
      Timestamp currentTimeStamp = Timestamp.fromDate(time);
      int timestamp = currentTimeStamp.millisecondsSinceEpoch;
      //remove next linine after getrting screens
      //change to
      DateTime newDate = DateTime(
          shiftDate.year, shiftDate.month, shiftDate.day - 2, 0, 0, 0, 0, 0);
      print('line 986 $newDate');
      List<Map<String, dynamic>>? listOfHCPS;
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('hcpId', isEqualTo: hcpId)
          .get()
          .then((querySnapshot) {
        listOfHCPS = [];
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> obj = docSnapshot.data();
          Timestamp shft = obj['shiftDate'];
          DateTime stm = shft.toDate();
          stm = stm.subtract(Duration(
              hours: stm.hour,
              minutes: stm.minute,
              seconds: stm.second,
              microseconds: stm.microsecond,
              milliseconds: stm.millisecond));
          shft = Timestamp.fromDate(stm);
          int shifti = shft.millisecondsSinceEpoch;
          if (timestamp != shifti) {
            continue;
          }

          listOfHCPS!.add(obj);
        }
      });
      print('line 991: ${listOfHCPS!.length}');
      return listOfHCPS!;
    } catch (e) {
      print('line 710');
      throw Exception('Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>>? getCompletedTimeCards(int hcpId) async {
    print('line 981 in getHCPtimecard');
    try {
      DateTime shiftDate = DateTime.now();
      DateTime time = DateTime.now();
      int timestamp = time.millisecondsSinceEpoch;
      //remove next linine after getrting screens
      //change to
      DateTime newDate = DateTime(
          shiftDate.year, shiftDate.month, shiftDate.day - 2, 0, 0, 0, 0, 0);
      print('line 986 $newDate');
      List<Map<String, dynamic>>? listOfHCPS;
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('HcpId', isEqualTo: hcpId)
          .where('shiftDate', isEqualTo: timestamp)
          .get()
          .then((querySnapshot) {
        listOfHCPS = [];
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> obj = docSnapshot.data();
          listOfHCPS!.add(obj);
        }
      });
      print('line 991: ${listOfHCPS!.length}');
      return listOfHCPS!;
    } catch (e) {
      print('line 710');
      throw Exception('Error: $e');
    }
  }

  Future<bool>? setDNUForClient(
      Map<String, dynamic> item, String dnuComments) async {
    String? documentId;
    // DateTime shiftDate = item['shiftDate'];
    // DateTime time = shiftDate;
    // int timestamp = time.millisecondsSinceEpoch;
    var uuid = Uuid();

// Generate a v1 (time-based) id
    // uuid.v4(); // -> '6c84fb90-12c4-11e1-840d-7b25c5ee775a'
    var data = {
      "dnuId": uuid.v4(),
      "clientId": item['clientId'],
      "hcpId": item['hcpId'],
      'flagHCPDNU': true,
      "hcpDNUDate": DateTime.now().toIso8601String(),
      "comments": dnuComments
    };
    final docRef =
        FirebaseFirestore.instance.collection('HCPTimeCard').doc(documentId);
    docRef.update(data).then(
        (value) => print("line 472 DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
    return true;
  }
  // Map<String,dynamic>getStartEndDates(String startTime,String endTime) {
  //    print('line 457 in getstartenddates');
  //   try {
  //   //start time
  //     String char = String.fromCharCode(8239);
  //     startTime = startTime.replaceAll(char, ' ');
  //     endTime = endTime.replaceAll(char, ' ');
  //   List<String> sts = startTime.split(' ');
  //   if (sts.length != 2) {
  //     return {};
  //   }
  //   List<String> stt = sts[0].split(':');
  //   if (stt.length != 2) {
  //     return {};
  //   }
  //   int startHours = int.parse(stt[0]);
  //   int startMinutes = int.parse(stt[1]);
  //   int compareStartHours = startHours;
  //   int compareStartMinutes = startMinutes;
  //   if (startMinutes == 0) {
  //     compareStartMinutes = 45;
  //     compareStartHours -= 1;
  //   }
  //   List<String> ets = endTime.split(' ');
  //   if (ets.length != 2) {
  //     return {};
  //   }
  //   List<String> ett = ets[0].split(':');
  //   if (stt.length != 2) {
  //     return {};
  //   }
  //   int endHours = int.parse(stt[0]);
  //   int endMinutes = int.parse(stt[1]);
  //   DateTime startDate = DateTime.now();
  //   DateTime newStartDate = startDate.subtract(Duration(hours:startDate.hour, minutes: startDate.minute,
  //       seconds: startDate.second, milliseconds: startDate.millisecond, microseconds: startDate.microsecond));
  //   DateTime endDate = newStartDate;
  // //  Timestamp myTimeStamp = Timestamp.fromDate(newDate);
  //   int addEndDay = 0;
  //   if (sts[1].toLowerCase().trim() == 'am') {
  //     if (ets[1].toLowerCase().trim() == 'pm') {
  //       // 7:00 am to 3:00 pm
  //       endHours += 12;
  //     } else {
  //       //3:00 am to 11:00 am
  //       //do nothing
  //     }
  //   } else if (sts[1].toLowerCase().trim() == 'pm') {
  //     if (ets[1].toLowerCase().trim() == 'pm') {
  //       // 3:00 pm to 11:00 pm
  //       startHours += 12;
  //       endHours += 12;
  //     } else {
  //       //11:00 pm to 7:00 am
  //       startHours += 12;
  //       addEndDay = 1;
  //     }
  //   }
  //   newStartDate = newStartDate.add(Duration(hours: startHours, minutes:startMinutes));
  //
  //   endDate = endDate.add(Duration(days:addEndDay,hours:endHours,minutes:endMinutes));
  //   print('line 503: $newStartDate $endDate');
  //    return {
  //      "startDate": newStartDate,
  //      "endDate": endDate,
  //      "startHours": startHours,
  //      "startMinutes": startMinutes,
  //      "compareStartHours": compareStartHours,
  //      "compareStartMinutes": compareStartMinutes,
  //      "endHours": endHours,
  //      "endMinutes": endMinutes,
  //      "addEndDay": addEndDay
  //    };
  //   } catch(e) {
  //     print('line 502 error: $e');
  //     throw Exception(e.toString());
  //   }

  //}

  Future<Map<String, dynamic>>? getSignInHCPTimeCard(String tcId) async {
    print('line 534 hst.getsingehcp: $tcId');
    DateTime currentDate = DateTime.now();
    try {
      //"hcpId == \$0 SORT(shiftDate ASC, shiftCode ASC)",[userId]);
      String documentId = '';
      Map<String, dynamic> tcm = {};
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('clientWorkOrderCampaignId', isEqualTo: tcId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          tcm = obj;
          return tcm;
          ;
        }
      });
      return tcm;
    } catch (e) {
      print('line 567 error: $e');
      throw Exception('Error: $e');
    }
  }

  Map<String, dynamic> getStartEndDates(String startTime, String endTime) {
    startTime = startTime.replaceAll(String.fromCharCode(8239), ' ');
    endTime = endTime.replaceAll(String.fromCharCode(8239), ' ');
    print('line 825: $startTime $endTime');
    try {
      //start time
      List<String> sts = startTime.split(' ');
      if (sts.length != 2) {
        return {};
      }
      List<String> stt = sts[0].split(':');
      if (stt.length != 2) {
        return {};
      }
      int startHours = int.parse(stt[0]);
      int startMinutes = int.parse(stt[1]);
      int compareStartHours = startHours;
      int compareStartMinutes = startMinutes;
      if (startMinutes == 0) {
        compareStartMinutes = 45;
        compareStartHours -= 1;
      }
      List<String> ets = endTime.split(' ');
      if (ets.length != 2) {
        return {};
      }
      List<String> ett = ets[0].split(':');
      if (ett.length != 2) {
        return {};
      }
      int endHours = int.parse(ett[0]);
      int endMinutes = int.parse(ett[1]);
      DateTime startDate = DateTime.now();
      DateTime newStartDate = startDate.subtract(Duration(
          hours: startDate.hour,
          minutes: startDate.minute,
          seconds: startDate.second,
          milliseconds: startDate.millisecond,
          microseconds: startDate.microsecond));
      DateTime endDate = newStartDate;
      //  Timestamp myTimeStamp = Timestamp.fromDate(newDate);
      int addEndDay = 0;
      if (sts[1].toLowerCase().trim() == 'am') {
        if (ets[1].toLowerCase().trim() == 'pm') {
          // 7:00 am to 3:00 pm
          endHours += 12;
        } else {
          //3:00 am to 11:00 am
          //do nothing
        }
      } else if (sts[1].toLowerCase().trim() == 'pm') {
        if (ets[1].toLowerCase().trim() == 'pm') {
          // 3:00 pm to 11:00 pm
          startHours += 12;
          endHours += 12;
        } else {
          //11:00 pm to 7:00 am
          startHours += 12;
          addEndDay = 1;
        }
      }
      newStartDate =
          newStartDate.add(Duration(hours: startHours, minutes: startMinutes));
      Timestamp tms = Timestamp.fromDate(newStartDate);
      endDate = endDate
          .add(Duration(days: addEndDay, hours: endHours, minutes: endMinutes));
      Timestamp tme = Timestamp.fromDate(endDate);
      print('line 906: $newStartDate $endDate');
      return {
        "startDateTime": newStartDate,
        "endDateTime": endDate,
        'startDate': tms,
        'endDate': tme,
        "startHours": startHours,
        "startMinutes": startMinutes,
        "compareStartHours": compareStartHours,
        "compareStartMinutes": compareStartMinutes,
        "endHours": endHours,
        "endMinutes": endMinutes,
        "addEndDay": addEndDay
      };
    } catch (e) {
      print('line 921 error: $e');
      throw Exception(e.toString());
    }
  }

  Map<String, dynamic> getStartAndEndMinutes(String st, String et) {
    print('line 18: $st $et');
    st = st.replaceAll(String.fromCharCode(8239), ' ');
    et = et.replaceAll(String.fromCharCode(8239), ' ');
    List<String> sts = st.split(' ');
    List<String> ets = et.split(' ');
    String startTime = sts[0];
    String endTime = ets[0];
    List<String> sts0 = startTime.split(':');
    List<String> ets0 = endTime.split(':');
    double sdh = double.parse(sts0[0]);
    double sdm = double.parse(sts0[1]);
    double edh = double.parse(ets0[0]);
    double edm = double.parse(ets0[1]);
    if (sts[1].toString().toLowerCase() == 'pm') {
      sdh += 12;
    }
    if (ets[1].toString().toLowerCase() == 'pm') {
      edh += 12;
    }
    double ths = (sdh * 60) + sdm;
    ths = ths * 60; //seconds
    double the = (edh * 60) + edm;
    the = the * 60; //seconds;
    return {"startTime": ths, "endTime": the};
  }

  Future<Map<String, dynamic>>? getSingleHCPTimeCard(
      int hcpId,
      int clientId,
      String shiftScheduleStatus,
      int shiftId,
      Timestamp ts,
      String startTime,
      String endTime) async {
    print(
        'line 793 hst.getsingehcp: $hcpId $clientId $shiftScheduleStatus $shiftId $startTime $endTime');
    DateTime currentDate = DateTime.now();
    try {
      //"hcpId == \$0 SORT(shiftDate ASC, shiftCode ASC)",[userId]);
      Map<String, dynamic>? tcm;
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('hcpId', isEqualTo: hcpId)
          .where('clientId', isEqualTo: clientId)
          .where('shiftId', isEqualTo: shiftId)
          .where('shiftStatus', isEqualTo: shiftScheduleStatus)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          print('line 808: $obj');
          obj['id'] = docSnapshot.id;
          Map<String, dynamic> dates = getStartEndDates(startTime, endTime);
          print('line 810: ${dates}');
          Timestamp ts0 = Timestamp.fromDate(currentDate);
          Timestamp ts1 = Timestamp.fromDate(dates['startDateTime']);
          Timestamp ts2 = Timestamp.fromDate(dates['endDateTime']);
          //debug 021825
          int ts3 = ts2.millisecondsSinceEpoch; //+ 3600000;
          //put back in above line
          print('line 817: $ts0 $ts1 $ts2  $ts3');
          // if (ts0.millisecondsSinceEpoch >= ts1.millisecondsSinceEpoch
          //      && ts0.millisecondsSinceEpoch <=
          //          ts2.millisecondsSinceEpoch + (3600000)) {
          tcm = obj;
          print('line 822: $tcm');
          break;
          // }
        }
        return tcm;
      });
      print('line 829: $tcm');
      if (tcm == null) {
        return {};
      } else {
        return tcm!;
      }
    } catch (e) {
      print('line 830 error: $e');
      throw Exception('Error: $e');
    }
  }

  Future<bool>? updateHCPTimeCardSignIn(item, Map<String, dynamic> data) async {
    print('line 838: $data');
    bool retV = false;
    try {
      DateTime nww = DateTime.now();
      nww = nww.subtract(Duration(
          hours: nww.hour,
          minutes: nww.minute,
          seconds: nww.second,
          microseconds: nww.microsecond,
          milliseconds: nww.millisecond));
      Timestamp tms = Timestamp.fromDate(nww);
      String documentId = '';
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('clientId', isEqualTo: item['clientId'])
          .where('shiftCode', isEqualTo: item['shiftCode'])
          .where('shiftStatus', isEqualTo: 'Confirmed') //change
          .get()
          .then((querySnapshot) async {
        print('line 858 got hcptime card');
        for (var docSnapshot in querySnapshot.docs) {
          documentId = docSnapshot.id;
          var obj = docSnapshot.data();
          print('line 841: ${obj['shiftDate']}');
          Timestamp tmx = obj['shiftDate'];
          DateTime dbx = tmx.toDate();
          dbx = dbx.subtract(Duration(
              hours: dbx.hour,
              minutes: dbx.minute,
              seconds: dbx.second,
              microseconds: dbx.microsecond,
              milliseconds: dbx.millisecond));
          if (dbx.millisecondsSinceEpoch != nww.millisecondsSinceEpoch) {
            print(
                'line 852: dates are equal ${dbx.millisecondsSinceEpoch} ${nww.millisecondsSinceEpoch}');
            continue;
          }

          break;
        }
        if (documentId == '') {
          print('line 880 false bad document id');
          retV = false;
        } else {
          await FirebaseFirestore.instance
              .collection('HCPTimeCard')
              .doc(documentId)
              .update(data)
              .then((value) {
            print("line 888 documentSnapshot successfully updated!");
            retV = true;
          }, onError: (e) => print("line 867 Error updating document $e"));
          await FirebaseFirestore.instance
              .collection('HCPTimeCard')
              .doc(documentId)
              .update({"signInServerTime": FieldValue.serverTimestamp()}).then(
                  (value) {
            print("line 896 documentSnapshot successfully updated!");
            retV = true;
          }, onError: (e) => print("line 867 Error updating document $e"));

          print('line 900');
          retV = true;
        }
      });
      print('line 904: $retV');
      return retV;
    } catch (e) {
      print('line 907 error $e');
      throw Exception('Error: $e');
    }
  }

  Future<bool> updateHCPTimeCard(
      Map<String, dynamic> hcpt, Map<String, dynamic> data) async {
    bool retV = false;
    print('line 642 updatehcptime card: $data ${hcpt['id']}');
    try {
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .doc(hcpt['id'])
          .update(data)
          .then((value) {
        retV = true;
      }, onError: (e) => print("Error updating document $e"));

      return retV;
    } catch (e) {
      print('line 789 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>>? getGPOClientDataFromHCPATimeCard(
      int hcpId) async {
    print('line 925 in getgpocient: $hcpId');
    Map<String, dynamic>? retV;
    try {
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where("hcpId", isEqualTo: hcpId)
          .where("shiftStatus", isEqualTo: 'SignedOut')
          // .where("shiftDate",isGreaterThanOrEqualTo: myTimeStamp)
          .where('signedOutHasInitialVerification', isEqualTo: false)
          //  .where('signedOutHasSecondaryVerification',isEqualTo: false)
          .get()
          .then((querySnapshot) async {
        print('line 939: ${querySnapshot.docs.length}');
        if (querySnapshot.docs.length == 0) {
          throw Exception('Did not find a time card for verification');
        }
        if (querySnapshot.docs.length > 1) {
          throw Exception('Found more than one time card for verification');
        }
        Map<String, dynamic>? obj;
        for (var docSnapshot in querySnapshot.docs) {
          obj = docSnapshot.data();
          break;
        }
        print('line 951: ${obj!['clientId']}');
        await FirebaseFirestore.instance
            .collection('Client')
            .where("clientId", isEqualTo: obj!['clientId'])
            .get()
            .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            retV = docSnapshot.data();
            break;
          }
          return;
        });
        return;
      });
      print('line 967 $retV');
      return retV!;
    } catch (e) {
      print('line 931 error: ${e.toString()}');
      return {};
    }
  }

  Future<bool> updateHCPTimeCardSignOut(
      Map<String, dynamic> item, Map<String, dynamic> data) async {
    print('line 784 updatehcptimecardsignout $data');
    bool bl = false;

    String signatureFilename = '';
    String imageFilePath = '';
    int idx = -1;
    print(
        'line 799: ${item['workOrderId']} ${data['signedOutHCPSignatureFilePath']}');
    if (data['signedOutHCPSignatureFilePath'] != null) {
      imageFilePath = data['signedOutHCPSignatureFilePath'];
      print('line 666: $imageFilePath');
      // idx = imageFilePath.indexOf('Application Support');
      // if (idx == -1) {
      //   throw Exception('Unable to find signature file name');
      // }
      // idx += 20;
      // signatureFilename = imageFilePath.substring(idx);
      signatureFilename = imageFilePath;
      print('line 668: $signatureFilename');
    }
    // int x = 0;
    // if (x == 0) {
    //   print('line 1002 $data');
    //   print('line 1003: ${data['signedOutHCPSignatureFilePath']}');
    //   throw Exception('line 1004 debug exception');
    // }
    //     var data = {
    //     "shiftScheduleStatus" : 'SignedOut',
    //     "shiftScheduleStatusDate":  tme,
    //     "shiftSignedOutTime": signedOutTime,
    //     "shiftTimecardSignedOutGeoLocationUtilized": geolocationUtilized,
    //     "supervisorSignature" : true,
    //     "supervisorName": null,
    //     "pdfFilename" :null,
    //    "shiftTimeWorkedDecimal" : hoursWorkedDecimal,
    //    "shiftTimeWorked" :hoursWorked,
    //    "signatureFilePath" :imageFilePath,
    //     "signatureFilename": signatureFilename,
    //    "supervisorNotes": supervisorNotes,
    //    "shiftDate":    shiftDate,
    // };
    //  int day = tmc['shiftDate'].day;

    try {
      DateTime nww = DateTime.now();
      nww = nww.subtract(Duration(
          hours: nww.hour,
          minutes: nww.minute,
          seconds: nww.second,
          microseconds: nww.microsecond,
          milliseconds: nww.millisecond));
      Timestamp tms = Timestamp.fromDate(nww);
      //next lines path for debugging storage of signature
      //add code to get documentid for update
      String documentId;

      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('clientId', isEqualTo: item['clientId'])
          .where('shiftStatus', isEqualTo: 'SignedIn')
          .where('shiftCode', isEqualTo: item['shiftCode'])
          .where('shiftDate', isGreaterThanOrEqualTo: tms)
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          documentId = docSnapshot.id;
          print('line 834:  $documentId');
          final docRef = FirebaseFirestore.instance
              .collection('HCPTimeCard')
              .doc(documentId);
          docRef.update(data).then(
              (value) =>
                  print("line 846 DocumentSnapshot successfully updated!"),
              onError: (e) => print("Error updating document $e"));
          docRef
              .update({"signOutServerTime": FieldValue.serverTimestamp()}).then(
                  (value) =>
                      print("line 846 DocumentSnapshot successfully updated!"),
                  onError: (e) => print("Error updating document $e"));
          break;
        }
      });
      // final signatureImagesRef =
      //     storageRef.child("images/${signatureFilename}");
      // Directory appDocDir = await getApplicationDocumentsDirectory();
      // String filePath = '${appDocDir.absolute}/${signatureFilename}';
      //print('line 1008: ${appDocDir.path}');
      //print('line 1009: ${appDocDir} $filePath $signatureFilename');
      Directory appSupDir = (await getApplicationSupportDirectory());
      print('line 1011: $appSupDir');
      if (authServices.isAndroid == true) {
        idx = signatureFilename.indexOf('files\/');
        print('line 1013: $idx');
        if (idx != -1) {
          idx += 6;
          signatureFilename = signatureFilename.substring(idx);
        }
      } else {
        int idx = signatureFilename.indexOf('Library\/Application Support\/');
        if (idx != -1) {
          idx += 28;
          signatureFilename = signatureFilename.substring(idx);
          print('line 1087: $signatureFilename');
        } else {
          throw Exception('line 1083 invalid file path: $signatureFilename');
        }
      }
      print('line 1018: $signatureFilename');
      String filePath = appSupDir.path + '/' + signatureFilename;
      print('line 1020: $filePath');

      // String bg = filePath.substring(0, idx);
      // idx += 11;
      // String end = filePath.substring(idx);
      // bg += 'Library/Application Support/';
      // filePath = bg + end;
      // filePath = filePath.replaceAll("\'", '');
      // idx = filePath.indexOf('Directory:');
      // idx += 11;
      // filePath = filePath.substring(idx);
      // print('line 1019 filepath: $filePath');

      final signatureRef = storageRef.child('images/${signatureFilename}');
      File file = File(filePath);

      try {
        if (!file.existsSync()) {
          print('line 1090 file not found: $file');
          throw 'line 1091 File not found';
        }

        print('line 1094: $file ${filePath}');
        await signatureRef.putFile(file);
      } catch (e) {
        print('line 1097 error storing signature file');
        throw Exception('line 1098: ${e.toString()}');
      }

      bl = true;
      print('line 1127: $bl, ');
      return bl;
    } catch (e) {
      print('line 1130 error $e');
      throw Exception('line 1106 Error: $e');
    }
  }

  Future<bool> sendSingleMessage(
      Map<String, dynamic> parameters, BuildContext ctx) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        // 'uploadTimesheetFromStorage',
        'sendSingleMessage',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );
      print('line 1202 in call A  function: $callable');
      dynamic result =
          await callingSendSingleMessageFunction(callable, parameters, ctx);
      print('line 1204: $result');
      return result;
    } catch (e) {
      print('line 1165: $e');
      throw Exception('line 1168: ${e.toString()}');
    }
  }

  Future<bool> callingSendSingleMessageFunction(HttpsCallable callable,
      Map<String, dynamic> message, BuildContext ctx) async {
    try {
      //  String fcmToken = "clJsAO0w-kwoj5nyfj3zzE:APA91bGnhOsYUxI2lcBVKUVewgQ5cXFjlqftp2UB8v979cnOEMzBJ521c9fSUA3tGuWJuQVA881t-GomQfrUweXOBDRYlA02W7gE-9xF9VeNCyQkDmHje58";
      //josh not correct   String fcmToken = "ePpx5Qg3VkPtq7u8EOB0nZ:APA91bFDg8N-BWYj0gIMZJYvIYvyUYZ0rQqfXR3e2bJ7LR8ZuKEAPKHlC1RqNyYL-z1QLGx5zqXVAp9FLynAHsPvXEvTc5PiWkg5_db-MYW7vGZebM3HI3w";
      //billie jo not correct  String fcmToken = "dthZ2F6SMEQ_mcSr5gl5AC:APA91bGVDGyzJ3GufukIpDDZuccAhuuXm1jAJLI9eBw9IvIg3Qv_iR6Vceq5xah0-gI0i0mh3HtWZFo4LIs2heYtbwttoSXjckQ6B559y49OInvYjgYC9kg";
      //chris not  String fcmToken = "fPKs90BGdkurhCkiI63vmO:APA91bFI35CFTCi99vzYJXxRV42CnRxJihMFGTB_--diJmu4gVFGupJtSj8eLN2Z2JyEW7VTcWrkwGfFo90q4xZcljTyccPTrrLWhx-PKSYokwmSmC1tDE0";
      // String fcmToken = "clJsAO0w-kwoj5nyfj3zzE:APA91bGnhOsYUxI2lcBVKUVewgQ5cXFjlqftp2UB8v979cnOEMzBJ521c9fSUA3tGuWJuQVA881t-GomQfrUweXOBDRYlA02W7gE-9xF9VeNCyQkDmHje58";
      // String fcmToken = 'dvcfisiV30sOm2a_DeFHJl:APA91bG27S98JTMhBRR931hmOxTpoAK1gDDtdg6Z_c-fMEN4pnZbZgeOBe1RQx1WC6fCOUX12YWf6_CMG91XqjPf2x0AXqb7aNyYk6aVQ1K7PKzGAjp3n-Q';
      var data = {
        "message": message,
      };
      print('line 1035: $data');
      final HttpsCallableResult result = await callable(data);
      print('line 1208: $result');
      print('line 1221 ${result.data}');
      return result.data['data']['boolValue'];
    } catch (e) {
      print('line 1224 error: $e');
      throw Exception('line 1225  ${e.toString()}');
    }
  }

  // Future<bool> callCancelWO(
  //     String OrderID, Map<String, dynamic> data, BuildContext ctx) async {
  //   print('line 1360: $OrderID $data');
  //   try {
  //     HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
  //       // 'uploadTimesheetFromStorage',
  //       'cancelWO06',
  //       options: HttpsCallableOptions(
  //         timeout: const Duration(seconds: 5),
  //       ),
  //     );
  //     print('line 1369 in call A  function: $callable');
  //     dynamic result = await callingCancelWO(callable, OrderID, data, ctx);
  //     print('line 1372: $result');
  //     return result;
  //   } catch (e) {
  //     print('line 1375: $e');
  //     return false;
  //   }
  // }

  // Future<bool> callingCancelWO(HttpsCallable callable, String OrderID,
  //     Map<String, dynamic> dataa, BuildContext ctx) async {
  //   print('line 1382: $OrderID $dataa');
  //   Map<String, dynamic> data = {'data': dataa, 'OrderID': OrderID};
  //   try {
  //     final HttpsCallableResult result = await callable(data);
  //     print('line 1324: $result');
  //     print('line 1325: ${result.data}');
  //     return result.data;
  //   } catch (e) {
  //     print('line 1332 error: $e');
  //     return false;
  //   }
  // }

  //from client
  Future<List<Map<String, dynamic>>> getHCPTimeCardsSignedOutInitial(
      int hcpId, typeVerification) async {
    List<Map<String, dynamic>> lmap = [];

    print('line 301: $typeVerification $hcpId');

    try {
      DateTime myDt = DateTime.now();
      DateTime myt = myDt;
      myt = myt.subtract((Duration(
          hours: myt.hour,
          minutes: myt.minute,
          seconds: myt.second,
          microseconds: myt.microsecond,
          milliseconds: myt.millisecond)));
      // Timestamp myTimeStamp = Timestamp.fromDate(dte);
      String documentId;
      print('line 316: $hcpId $myt');
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where("hcpId", isEqualTo: hcpId)
          .where("shiftStatus", isEqualTo: 'SignedOut')
          // .where("shiftDate",isGreaterThanOrEqualTo: myTimeStamp)
          .where('signedOutHasInitialVerification', isEqualTo: typeVerification)
          //  .where('signedOutHasSecondaryVerification',isEqualTo: false)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          documentId = docSnapshot.id;
          Map<String, dynamic> obj = docSnapshot.data();
          String shiftStartTime = obj['shiftStartTime'];
          String shiftEndTime = obj['shiftEndTime'];
          int startMinutes = util.getMinutes(shiftStartTime);
          int endMinutes = util.getMinutes(shiftEndTime);

          obj['id'] = documentId;
          Timestamp ts = obj['shiftDate'];
          DateTime dbx = ts.toDate();
          dbx = dbx.subtract(Duration(
              hours: dbx.hour,
              minutes: dbx.minute,
              seconds: dbx.second,
              microseconds: dbx.microsecond,
              milliseconds: dbx.millisecond));
          if (startMinutes > 720 && startMinutes > endMinutes) {
            DateTime lmyt = myt.subtract(Duration(days: 1));
            if (lmyt.millisecondsSinceEpoch != dbx.millisecondsSinceEpoch) {
              continue;
            }
          } else {
            if (myt.millisecondsSinceEpoch != dbx.millisecondsSinceEpoch) {
              continue;
            }
          }
          print('line 1980: $startMinutes $endMinutes');
          DateTime dbx2 = dbx;
          dbx = dbx.add(Duration(
              hours: 0,
              minutes: startMinutes,
              seconds: 0,
              microseconds: 0,
              milliseconds: 0));
          if (startMinutes > 720 && startMinutes > endMinutes) {
            dbx2 = dbx2.add(Duration(
                days: 1,
                hours: 0,
                minutes: endMinutes,
                seconds: 0,
                microseconds: 0,
                milliseconds: 0));
          } else {
            dbx2 = dbx2.add(Duration(
                hours: 0,
                minutes: endMinutes,
                seconds: 0,
                microseconds: 0,
                milliseconds: 0));
          }
          DateTime ldbx = dbx.subtract(Duration(minutes: 20));
          if (ldbx.millisecondsSinceEpoch < myDt.millisecondsSinceEpoch) {
            print('line 2012 passed 1st check');
          } else {
            print('line 2014 failed 1st check');
            continue;
          }
          if (myt.millisecondsSinceEpoch < dbx2.millisecondsSinceEpoch) {
            print('line 2018 passed second test valid');
          } else {
            print('lint 2020 failed second check');
            continue;
          }
          print('line 329 $documentId');
          lmap.add(obj);
        }
        return lmap;
      });
      print('line 340: ${lmap}');
      return lmap;
    } catch (e) {
      print('line 337 error $e');
      throw Exception(e.toString());
    }
  }

  Future<dynamic>? updateInitialSignedOutHCPTimeCards(Map<String, dynamic> item,
      Map<String, dynamic> data, BuildContext ctx) async {
    print(
        'line 380 in upatesignedouthcp ${item['id']} $data,${item['asmTimeCardId']}');
    //Map<String, dynamic> rlm = {};

    //  return realm.query("clientId = $clientId && hcpId == $hcpId && shiftStatus == 'SignedOut' SORT(shiftDate ASC, hcpId ASC, shiftCode ASC)");
    try {
      // await FirebaseFirestore.instance.collection("HCPTimeCard")
      //     .where('hcpId', isEqualTo: item['hcpId'])
      //     .where('hasSignedOut',isEqualTo: false)
      //     .where('shiftId',isEqualTo:item['shiftId'])
      //     .where('shiftDate',isEqualTo: timestamp)
      //     .get().then(
      //         (querySnapshot) {
      //       for (var docSnapshot in querySnapshot.docs) {
      //         documentId = docSnapshot.id;
      //       //  rlm = docSnapshot.data();
      //         break;
      //       }
      //     });
      final db = FirebaseFirestore.instance;
      WriteBatch batch = db.batch();
      final docRef =
          FirebaseFirestore.instance.collection("HCPTimeCard").doc(item['id']);
      batch.update(docRef, data);
      // await docRef.update(data).then(
      //     (value) => print("line 441 DocumentSnapshot successfully updated!"),
      //     onError: (e) => print("Error updating document $e"));
      int timeCardId = item['asmHCPTimeCardId'];
      if (timeCardId == 0) {
        throw Exception('line 448 invalid timecardid');
      }
      String timeCardFile = data['timesheetFileName'];
      print('line 445: $timeCardId $timeCardFile');
      //umcommented from production
      //  dynamic rsp = await  writeTimeCardSheetToStorage(timeCardFile,data['fileAndPathName']);
      //dynamic rsp =  await  callUploadOnRequestTimesheetFunction(timeCardFile,ctx);
      // print('line 406 $rsp');
      //now load time sheet to asm from storage
      Map<String, dynamic> rsp = await callUploadTimesheetFromStorageFunction(
          timeCardId.toString(), timeCardFile, ctx);
      //uncomment after we have loaded to storage
      print('line 1336: $rsp');
      if (rsp.containsKey('TimecardImageId') == true) {
        int timeCardImageId = rsp['TimecardImageId'];
        print('line 466: $timeCardImageId');
        batch.update(docRef, {
          'asmTimeCardImageId': timeCardImageId,
          'signedOutHasInitialVerification': true,
          'signedOutInitialVerification': true,
          'signedOutInitialVerificationNotes':
              data['signedOutInitialSupervisorNotes'],
          'signedOutInitialVerificationDateTime':
              Timestamp.fromDate(DateTime.now()),
          'signedOutSupervisorName': data['signedOutSupervisorName'],
          'hasSignedOut': data['hasSignedOut'],
          'woWorkOrder': data['woWorkOrderId']
        });
        //update time card with shift data data
        dynamic rxp = await callUpdateTimesheetFunction(
            timeCardId,
            item['departmentId'],
            item['shiftDate'],
            item['signedInInitialStartTimeChanged'],
            item['signedOutInitialEndTimeChanged'],
            item['signedOutMeals'],
            ctx);

        if (rxp.data[0]['success'] == false) {
          throw Exception('Error trying to update timecard times');
        }
        print(
            'line 1365: ${authServices.clientUserMap!['clientUserId']} $rsp ${rxp.data}');
        Map<String, dynamic>? clc = await clientServices.getSingleClientUser(
            item['clientId'], authServices.clientUserMap!['clientUserId']);
        if (clc!.isEmpty) {
          throw Exception('line 1369 clc is empty from getsingleclientuser');
        }
        Map<String, dynamic>? usc =
            await clientServices.getSingleUser(item['hcpId']);
        if (usc!.isEmpty) {
          throw Exception('line 476 usc is empty for getsingle user');
        }
        print('line 471: ${clc}');
        String fcmToken = usc['fcmToken'];
        Timestamp ts = item['shiftDate'];
        print('line 474: $fcmToken ${item['shiftDate']}');
        String shiftDate = convertFromTimestamp(ts);
        print('line 476 just before body creation');
        String body =
            '${clc['fullName']} has verified the shift ${item['shiftCode']} for $shiftDate';
        Map<String, dynamic> parameters = {
          "title": "Shift Verified for: ${item['hcpName']}",
          "body": body,
          "fcmToken": fcmToken
        };
        print('line 484 ${parameters}');
        await sendSingleMessage(parameters, ctx);
        batch.commit();
      } else {
        throw Exception('Rsp: $rsp');
      }
      return "Success";
    } catch (e) {
      print('line 1395 error: $e');
      return "ERROR: " + e.toString();
      // throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> callUploadTimesheetFromStorageFunction(
      String timecardId, String timecardName, BuildContext ctx) async {
    print('line 1607: $timecardId $timecardName');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        // 'uploadTimesheetFromStorage',
        'uploadTimesheetFromStorage',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );
      print('line 1616 in call A  function: $callable');
      dynamic result = await callingUploadTimesheetFromStorageFunction(
          callable, timecardId, timecardName, ctx);
      try {
        if (int.tryParse(result.toString()) != null) {
          return {'TimecardImageId': result};
        } else {
          return result;
        }
      } catch (e) {
        throw Exception('Unknown data type: $result');
      }
    } catch (e) {
      print('line 1336: $e');
      throw Exception('line 1336: ${e.toString()}');
    }
  }

  Future<dynamic> callingUploadTimesheetFromStorageFunction(
      HttpsCallable callable,
      String timecardId,
      String timecardName,
      BuildContext ctx) async {
    print('line 1304: $timecardId $timecardName');
    try {
      var data = {"timecardId": timecardId, "timecardFile": timecardName};
      final HttpsCallableResult result = await callable(data);
      print('line 1636: $result');
      print('line 1637 ${result.data}');
      if (result.data.containsKey('TimeCardImageID') == false) {
        return result.data;
      }
      var timc = result.data['TimeCardImageID'];
      print('line 1642: $timc');
      print('line 1643 ${timc['TimecardImageID']}');
      return timc['TimecardImageID'];
    } catch (e) {
      print('line 1646 error: $e');
      throw Exception('line 1356  ${e.toString()}');
    }
  }

  Future<String> callUploadOnRequestTimesheetFunction(
      String timesheetPathAndName, BuildContext ctx) async {
    print('line 1320: $timesheetPathAndName');
    var client = Client();
    String urlString =
        "https://us-central1-cmsproject-8e245.cloudfunctions.net/uploadOnRequestTimesheet";
    try {
      var url = Uri.parse(urlString);

      Map<String, dynamic> request = {
        "timesheetPathAndName": timesheetPathAndName
      };
      Map<String, dynamic> h_headers = {"Content-Type": "application/json"};
      var response = await client.post(url, body: request);
      if (response.statusCode == 201) {
        String st = 'ok';
        print('line 1334');
        return json.decode(response.body);
      } else {
        return "line 1337 ERROR ${response.statusCode}";
      }
    } catch (e) {
      print('line 1340 error: $e');
      throw Exception('line 1118 error: ${e.toString()}');
    }
  }

  Future<String> callUploadInitialTimesheetFunctionX(
      String timesheetPathAndName, BuildContext ctx) async {
    print('line 1095: $timesheetPathAndName');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'uploadInitialTimesheet',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );
      int idx = timesheetPathAndName.indexOf('timesheet');
      String timeCardLocation = timesheetPathAndName.substring(0, idx);
      String timeCardName = timesheetPathAndName.substring(idx);
      print('line 1107 in call A  function: $callable');
      dynamic result = await callingUploadInitialTimesheetFunction(
          callable, timeCardName, timeCardLocation, ctx);
      print('line 1109: $result');
      if (result.contains('ERROR') == true) {
        print('line 1111: Error getting htc id to asm');
        return result;
      }
      print('line 1114 successfully retrieved htc $result');

      return result;
    } catch (e) {
      print('line 1118: $e');
      throw Exception('line 1119: ${e.toString()}');
    }
  }

  Future<String> callingUploadInitialTimesheetFunction(HttpsCallable callable,
      String timeCardName, String fileLocation, BuildContext ctx) async {
    print('line 1125: $timeCardName $fileLocation');
    try {
      var data = {
        "timeCardFileName": timeCardName,
        "timeCardFilePath": fileLocation
      };
      final HttpsCallableResult result = await callable(data);
      print('line 1132 ${result.data}');
      return result.data.toString();
    } catch (e) {
      print('line 1135 error: $e');
      throw Exception('line 1136  ${e.toString()}');
    }
  }

  String convertFromTimestamp(Timestamp? t) {
    if (t == null) {
      DateTime d = new DateTime(1970, 1, 1);
      int itt = d.millisecondsSinceEpoch;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(itt);
      String ss = getFormattedDate(dateTime);
      return ss;
    }
    DateTime date = t.toDate();
    String s = getFormattedDate(date);
    return s;
  }

  String getFormattedDate(DateTime dte) {
    DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(dte);
    return formatted;
  }

  Future<HttpsCallableResult> callUpdateTimesheetFunction(
      int timecardId,
      int departmentId,
      Timestamp shiftDate,
      String signInTime,
      String signOutTime,
      int meals,
      BuildContext ctx) async {
    DateTime dte = shiftDate.toDate();
    String dts = getFormattedDate(dte);
    print('line 1607: $timecardId $departmentId, ');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        // 'uploadTimesheetFromStorage',
        'updateTimeCardFunction',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );
      print('line 1616 in call A  function: $callable');
      HttpsCallableResult result = await callingUpdateTimesheetFunction(
          callable,
          timecardId,
          departmentId,
          dts,
          signInTime,
          signOutTime,
          meals,
          ctx);
      print('line 1690 $result');
      return result;
    } catch (e) {
      print('line 1693: $e');
      throw Exception('line 1694: ${e.toString()}');
    }
  }

  Future<HttpsCallableResult<dynamic>> callingUpdateTimesheetFunction(
      HttpsCallable callable,
      int timeCardId,
      int departmentId,
      String shiftDate,
      String signInTime,
      String signOutTime,
      int meals,
      BuildContext ctx) async {
    print('line 1304: $timeCardId ');
    var ddata = {"timeCardId": timeCardId, "data": []};
    try {
      List<dynamic> data = [];
      data.add({"op": "replace", "path": "/DeptID", "value": departmentId});
      data.add({"op": "replace", "path": "/ShiftDate", "value": shiftDate});
      data.add({
        "op": "replace",
        "path": "/StartTime",
        "value": signInTime,
      });
      data.add({"op": "replace", "path": "/EndTime", "value": signOutTime});
      data.add({"op": "replace", "path": "/Meals", "value": meals});
      ddata['data'] = data;
      //var data = {"timecardId": timecardId, "timecardFile": timecardName};
      final HttpsCallableResult result = await callable(ddata);
      print('line 1722: $result');
      print('line 1723 ${result.data}');
      return result;
    } catch (e) {
      print('line 1726 error: $e');
      throw Exception('line 1356  ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> callCancelWOFunction(
      String OrderID,
      String cancellationCode,
      String ClientID,
      String ShiftCode,
      String ShiftDate,
      Map<String, dynamic> cancellationMap,
      BuildContext ctx) async {
    print('line 1936: $OrderID $cancellationCode');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'cancelWO08',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      print('line 1945 in call A  function: $callable');
      dynamic result = await callingCancelWOFunction(
          callable,
          OrderID,
          cancellationCode,
          ClientID,
          ShiftCode,
          ShiftDate,
          cancellationMap,
          ctx);
      print('line 1948: $result');
      return result;
    } catch (e) {
      print('line 1955 error : $e');
      throw Exception('line 1168: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> callingCancelWOFunction(
      HttpsCallable callable,
      String OrderID,
      String cancellationCode,
      String ClientID,
      String ShiftCode,
      String ShiftDate,
      Map<String, dynamic> cancellationMap,
      BuildContext ctx) async {
    try {
      print('line 1750 $OrderID $cancellationCode');
      var data = {
        "OrderID": OrderID,
        "CancellationCode": cancellationCode,
        'ClientID': ClientID,
        'ShiftCode': ShiftCode,
        'ShiftDate': ShiftDate,
        'asmWO': cancellationMap
      };

      final HttpsCallableResult result = await callable(data);
      print('line 1761 ${result.data}');
      var convertedResult = Map<String, dynamic>.from(result.data);
      print('line 1753 $convertedResult');
      return convertedResult;
    } catch (e) {
      print('line 1766 error: $e');
      throw Exception('line 1995  ${e.toString()}');
    }
  }

  Future<String>? cancelConfirmedShiftByClients(
      List<Map<String, dynamic>> items,
      int clientId,
      String canceledBy,
      ctx) async {
    print('line 626: $canceledBy ${items.length}');
    print('line 627: ${items[0]}');

    //Map<String, dynamic> rlm = {};

    //  return realm.query("clientId = $clientId && hcpId == $hcpId && shiftStatus == 'SignedOut' SORT(shiftDate ASC, hcpId ASC, shiftCode ASC)");
    try {
      final db = FirebaseFirestore.instance;
      String asmWorkOrderId = '';
      String orderId = '';
      for (int i = 0; i < items.length; i++) {
        Map<String, dynamic> item = items[i];
        print('line 638: ${item['id']}');
        DateTime nwd = DateTime.now();
        nwd = nwd.subtract(Duration(
            hours: nwd.hour,
            minutes: nwd.minute,
            microseconds: nwd.microsecond,
            milliseconds: nwd.millisecond));
        Timestamp ts = Timestamp.fromDate(nwd);
        asmWorkOrderId = item['asmWorkOrderId'].toString();
        print('line 648: ${item['workOrderId']}');
        // final docRefx = db.collection("ClientWorkOrder").doc(item['id']);
        // docRefx.get().then(
        //   (DocumentSnapshot doc) {
        //     orderId = doc.id;
        //     final data = doc.data() as Map<String, dynamic>;
        //   },
        //   onError: (e) => print("Error getting document: $e"),
        // );
        // docRef.update(tata).then(
        //     (value) => print("line 717 DocumentSnapshot successfully updated!"),
        //     onError: (e) => {returnValue = "Error updating document $e"});

        print('line 661: $asmWorkOrderId ${item['workOrderId']}');

        dynamic documentIdd;

        await FirebaseFirestore.instance
            .collection("ClientHCPWorkOrder")
            .where('woWorkOrderId', isEqualTo: item['id'])
            .get()
            .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            print('line 671: ${docSnapshot.id}');
            documentIdd = docSnapshot.id;
            //  rlm = docSnapshot.data();
            break;
          }
        });
        print('line 676: $documentIdd ${item['id']}');
        List<dynamic> cwkidss = [];
        await FirebaseFirestore.instance
            .collection("ClientWorkOrderCampaign")
            .where('woWorkOrderId', isEqualTo: item['id'])
            .get()
            .then((querySnapshot) {
          print('line 684: ${querySnapshot.docs.length}');
          for (var docSnapshot in querySnapshot.docs) {
            print('line 686: ${docSnapshot.id}');
            cwkidss.add(docSnapshot.id);
          }
        });
        print('line 687 check: ${cwkidss.length}');
        List<String> hcpidss = [];
        await FirebaseFirestore.instance
            .collection("HCPTimeCard")
            .where('woWorkOrderId', isEqualTo: item['id'])
            .get()
            .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            print('line 698: ${docSnapshot.id}');
            hcpidss.add(docSnapshot.id);
          }
        });
        print('line 698: ${hcpidss.length} $documentIdd');
        //updates
        print('line 700: $orderId ${item['id']}');
        WriteBatch batch = db.batch();
        //client work order
        Map<String, dynamic> tata = {
          // 'hcpId': 0,
          // 'hcpName': null,
          "shiftStatus": 'Canceled',
          "shiftStatusDate": ts,
          "canceledBy": canceledBy
        };
        var docRef = FirebaseFirestore.instance
            .collection("ClientWorkOrder")
            .doc(item['id']);
        batch.update(docRef, tata);
        print('line 826 ${item['workOrderId']}');
        //ClientHCPWorkOrder
        Map<String, dynamic> data = {
          "statusId": 'C',
          "statusDate": ts,
          "canceledBy": canceledBy
        };
        print('line 721: $documentIdd');
        if (documentIdd != null) {
          var docRef1 = FirebaseFirestore.instance
              .collection("ClientHCPWorkOrder")
              .doc(documentIdd);
          batch.update(docRef1, data);
        }
        //clientcampaignworkorder

        var cdata = {
          'shiftStatus': 'Canceled',
          'shiftStatusDate': Timestamp.fromDate(DateTime.now()),
          'shiftCanceled': true,
          'shiftCanceledByName': canceledBy
        };
        for (int j = 0; j < cwkidss.length; j++) {
          var docId = cwkidss[j];
          print('line 738: $docId');
          var docRef2 = FirebaseFirestore.instance
              .collection("ClientWorkOrderCampaign")
              .doc(docId);
          batch.update(docRef2, cdata);
        }
        var hdata = {
          'shiftStatus': 'Canceled',
          'shiftStatusDate': Timestamp.fromDate(DateTime.now()),
          'shiftCanceled': true,
          'shiftCanceledByName': canceledBy,
          'shiftCanceledByHCP': false,
          'shiftCanceledHCPDateTime': Timestamp.fromDate(DateTime.now()),
        };

        for (int j = 0; j < hcpidss.length; j++) {
          var docId = hcpidss[j];
          print('line 755: $docId');
          var docRef3 =
              FirebaseFirestore.instance.collection("HCPTimeCard").doc(docId);
          batch.update(docRef3, hdata);
        }
        // int x = 0;
        // if (x == 0) {
        //   batch.commit();
        //   throw Exception('debug exception ');
        // }
        batch.commit();
        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('MM-dd-yyyy');
        final String formatted = formatter.format(now);
        String time = DateFormat.jm().format(now);
        String nbsp = String.fromCharCode(0x00A0);
        time = time.replaceAll(nbsp, ' ');
        print('line 764: $formatted $time');
        dynamic shiftCancellationMapX = {
          "CancelType": item['shiftCancellationType'],
          "LateCancel": false,
          "ReOpen": false,
          "Record": false,
          "CancelReasonCodeID": item['cancelReasonCodeId'],
          "Conf_Emp": false,
          "Conf_Emp_EmailText": false,
          "Conf_Emp_Date": null,
          "Conf_Emp_Time": null,
          "Conf_Emp_Note": null,
          "Conf_Cli": true,
          "Conf_Cli_EmailText": true,
          "Conf_Cli_Date": formatted,
          "Conf_Cli_Time": time,
          "Conf_Cli_Note": item['shiftCancellationReason'],
          "InternalNote": "Mobile cancellation by employee",
          "InvoiceNote": "Shift should not be invoiced"
        };

        print('line 874: $shiftCancellationMapX $asmWorkOrderId');
        String url =
            "https://api.stafferlink.com/asm/Orders/${asmWorkOrderId}/Cancel";

        bool bl = await util.putAnyData(shiftCancellationMapX, url);
        if (bl == false) {
          throw Exception('line 814 bad cancel call');
        }
        // bool bl = await callCancelWO(
        //     asmWorkOrderId.toString(), shiftCancellationMapX, ctx);
        batch.commit();
      }
      print('line 879');
      return 'Success';
    } catch (e) {
      print('line 884 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<String>? cancelWorkOrdersByClient(List<Map<String, dynamic>> items,
      String canceledBy, BuildContext ctx) async {
    print('line 579: $canceledBy ${items.length}');
    print('line 749: ${items[0]}');

    //Map<String, dynamic> rlm = {};

    //  return realm.query("clientId = $clientId && hcpId == $hcpId && shiftStatus == 'SignedOut' SORT(shiftDate ASC, hcpId ASC, shiftCode ASC)");
    try {
      final db = FirebaseFirestore.instance;
      String asmWorkOrderId = '';
      String orderId = '';
      for (int i = 0; i < items.length; i++) {
        Map<String, dynamic> item = items[i];
        print('line 588: ${item['id']}');
        DateTime nwd = DateTime.now();
        nwd = nwd.subtract(Duration(
            hours: nwd.hour,
            minutes: nwd.minute,
            microseconds: nwd.microsecond,
            milliseconds: nwd.millisecond));
        Timestamp ts = Timestamp.fromDate(nwd);
        asmWorkOrderId = item['asmWorkOrderId'].toString();
        dynamic returnValue = null;
        print('line 768: ${item['workOrderId']}');
        final docRefx = db.collection("ClientWorkOrder").doc(item['id']);
        docRefx.get().then(
          (DocumentSnapshot doc) {
            orderId = doc.id;
            final data = doc.data() as Map<String, dynamic>;
          },
          onError: (e) => print("Error getting document: $e"),
        );
        // docRef.update(tata).then(
        //     (value) => print("line 717 DocumentSnapshot successfully updated!"),
        //     onError: (e) => {returnValue = "Error updating document $e"});

        print('line 785: $asmWorkOrderId ${item['workOrderId']}');

        String? documentId;

        await FirebaseFirestore.instance
            .collection("ClientHCPWorkOrder")
            .where('woWorkOrderId', isEqualTo: item['id'])
            .get()
            .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            documentId = docSnapshot.id;
            //  rlm = docSnapshot.data();
            break;
          }
        });
        print('line 800: ${item['id']}');
        List<String> cwkids = [];
        await FirebaseFirestore.instance
            .collection("ClientWorkOrderCampaign")
            .where('woWorkOrderId', isEqualTo: item['id'])
            .get()
            .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            cwkids.add(docSnapshot.id);
          }
        });
        print('line 812 check: ${cwkids.length}');
        List<String> hcpids = [];
        await FirebaseFirestore.instance
            .collection("HCPTimeCard")
            .where('woWorkOrderId', isEqualTo: item['id'])
            .get()
            .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            hcpids.add(docSnapshot.id);
          }
        });
        print('line 820: ${hcpids.length} $documentId');
        //updates
        print('line 822: $orderId ${item['id']}');
        WriteBatch batch = db.batch();
        //client work order
        Map<String, dynamic> tata = {
          'hcpId': 0,
          'hcpName': null,
          "shiftStatus": 'Canceled',
          "shiftStatusDate": ts,
          "canceledBy": canceledBy
        };
        var docRef = FirebaseFirestore.instance
            .collection("ClientWorkOrder")
            .doc(item['id']);
        batch.update(docRef, tata);
        print('line 826 ${item['woWorkOrderId']}');
        //ClientHCPWorkOrder
        Map<String, dynamic> data = {
          "hcpId": 0,
          "hcpName": null,
          "statusId": '*',
          "statusDate": ts,
          "canceledBy": canceledBy
        };
        print('line 840: $documentId');
        if (documentId != null) {
          var docRef1 = FirebaseFirestore.instance
              .collection("ClientHCPWorkOrder")
              .doc(documentId);
          batch.update(docRef1, data);
        }
        //clientcampaignworkorder

        var cdata = {
          'shiftStatus': 'Canceled',
          'shiftStatusDate': Timestamp.fromDate(DateTime.now()),
          'shiftCanceled': true,
          'shiftCanceledByName': canceledBy
        };
        for (int j = 0; j < cwkids.length; j++) {
          var docId = cwkids[j];
          var docRef2 = FirebaseFirestore.instance
              .collection("ClientWorkOrderCampaign")
              .doc(docId);
          batch.update(docRef2, cdata);
        }
        var hdata = {
          'shiftStatus': 'Canceled',
          'shiftStatusDate': Timestamp.fromDate(DateTime.now()),
          'shiftCanceled': true,
          'shiftCanceledByName': canceledBy,
          'shiftCanceledByHCP': false,
          'shiftCanceledHCPDateTime': Timestamp.fromDate(DateTime.now()),
        };

        for (int j = 0; j < hcpids.length; j++) {
          var docId = hcpids[j];
          var docRef3 =
              FirebaseFirestore.instance.collection("HCPTimeCard").doc(docId);
          batch.update(docRef3, hdata);
        }
        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('MM-dd-yyyy');
        final String formatted = formatter.format(now);
        final time = DateFormat.jm().format(now);

        dynamic shiftCancellationMap = {
          "CancelType": item['shiftCancellationType'],
          "LateCancel": false,
          "ReOpen": false,
          "Record": false,
          "CancelReasonCodeID": item['cancelReasonCodeId'],
          "Conf_Emp": false,
          "Conf_Emp_EmailText": false,
          "Conf_Emp_Date": null,
          "Conf_Emp_Time": null,
          "Conf_Emp_Note": null,
          "Conf_Cli": true,
          "Conf_Cli_EmailText": true,
          "Conf_Cli_Date": formatted,
          "Conf_Cli_Time": time,
          "Conf_Cli_Note": item['shiftCancellationNote'],
          "InternalNote": "Mobile cancellation by employee",
          "InvoiceNote": "Shift should not be invoiced"
        };

        print('line 874: $shiftCancellationMap $asmWorkOrderId');
        String url =
            "https://api.stafferlink.com/asm/Orders/${asmWorkOrderId}/Cancel";

        bool bl = await util.putAnyData(shiftCancellationMap, url);
        if (bl == false) {
          throw Exception('line 814 bad cancel call');
        }
        print('line 874: $shiftCancellationMap $asmWorkOrderId');
        //
        // bool bl = await callCancelWO(
        //     asmWorkOrderId.toString(), shiftCancellationMap, ctx);
        batch.commit();
      }
      print('line 879');
      return 'Success';
    } catch (e) {
      print('line 884 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<String>? republishWorkOrdersByClient(List<Map<String, dynamic>> items,
      String republishedBy, BuildContext ctx) async {
    print('line 579: $republishedBy ${items.length}');
    print('line 749: ${items[0]}');
    try {
      //  cdt = cdt.subtract(Duration(hours:cdt.hour,minutes:cdt.minute,
      //  seconds:cdt.second,microseconds: cdt.microsecond,milliseconds: cdt.millisecond);
      print('line 768: ${items[0]['uuid']}');
      String uuid = items[0]['uuid'];
      int clientId = items[0]['clientId'];
      List<Map<String, dynamic>> hcps = [];
      List<int> hcpIds = [];
      List<String> fcmTokens = [];
      FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('clientWorkOrderUuid', isEqualTo: uuid)
          .where('statusId', whereIn: ['Open', 'Accepted', 'Approved'])
          .get()
          .then((querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              var obj = docSnapshot.data();
              DateTime cdt = DateTime.now();
              Timestamp tms = obj['shiftDate'];
              DateTime tmd = tms.toDate();
              tmd = tmd.subtract(Duration(
                  hours: tmd.hour,
                  minutes: tmd.minute,
                  seconds: tmd.second,
                  microseconds: tmd.microsecond,
                  milliseconds: tmd.millisecond));
              Map<String, dynamic> shm = util.getHoursMinutes(obj['startTime']);
              DateTime tmdd = tmd;
              tmd = tmd
                  .add(Duration(hours: shm['hours'], minutes: shm['minutes']));
              print('line 1064: $tmd $cdt');
              if (cdt.millisecondsSinceEpoch > tmd.millisecondsSinceEpoch) {
                continue;
              }
              Map<String, dynamic> mp = {
                "hcpId": obj['hcpId'],
                "hcpName": obj['hcpName'],
                "title": "Shift Republish",
                "clientName": obj['clientName'],
                "shiftDate": tmdd,
                "shiftCode": obj['shiftCode'],
                "fcmToken": null,
              };
              hcps.add(mp);
              hcpIds.add(obj['hcpId']);
            }
            print('line 1079: ${hcps.length}');
            if (hcps.length > 0) {
              //previously scheduled
              FirebaseFirestore.instance
                  .collection('ClientWorkOrderCampaign')
                  .where('clientId', isNotEqualTo: clientId)
                  .where('statusId', isEqualTo: 'Confirmed')
                  .where('hcpId', whereIn: hcpIds)
                  .get()
                  .then((querySnapshot) async {
                for (var docSnapshot in querySnapshot.docs) {
                  var obj = docSnapshot.data();
                  Timestamp cts = obj['shiftDate'];
                  DateTime ctd = cts.toDate();
                  ctd = ctd.subtract(Duration(
                      hours: ctd.hour,
                      minutes: ctd.minute,
                      seconds: ctd.second,
                      microseconds: ctd.microsecond,
                      milliseconds: ctd.millisecond));
                  int q = 0;
                  while (q < hcps.length) {
                    Map<String, dynamic> mp = hcps[q];
                    if (mp['hcpId'] == obj['hcpId'] &&
                        mp['shiftCode'] == obj['shiftCode'] &&
                        mp['shiftDate'] == ctd) {
                      hcpIds.removeAt(q);
                      hcps.removeAt(q);
                      continue;
                    }
                    q += 1;
                  }
                }
                bool flagHaveAtLeastOne = false;
                FirebaseFirestore.instance
                    .collection('users')
                    .where('userId', whereIn: hcpIds)
                    .get()
                    .then((querySnapshot) async {
                  for (var docSnapshot in querySnapshot.docs) {
                    var obj = docSnapshot.data();
                    int q = 0;
                    while (q < hcps.length) {
                      Map<String, dynamic> mp = hcps[q];
                      if (mp['hcpId'] != obj['userId']) {
                        q += 1;
                        continue;
                      }
                      if (obj['fcmToken'] != 'PlaceHolder') {
                        mp['fcmToken'] = obj['fcmToken'];
                        flagHaveAtLeastOne = true;
                        hcps[q] = mp;
                        break;
                      } else {
                        break;
                      }
                    }
                  }
                });
                if (flagHaveAtLeastOne == true) {
                  print('line 1140 had at least one');
                  dynamic result =
                      await callSendRepublishNotificationFunction(hcps, ctx);
                }
              });
            }
          });
      return "Success";
    } catch (e) {
      print('line 1038 error in republish shift: ${e.toString()}');
      throw Exception('line 1039 error in republish shift: ${e.toString()}');
    }
  }

  Future<dynamic> callSendRepublishNotificationFunction(
      List<Map<String, dynamic>> hcps, BuildContext ctx) async {
    print('line 1607:  ${hcps[0]}');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        // 'uploadTimesheetFromStorage',
        'sendMultipleMessages',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );
      print('line 1616 in call A  function: $callable');
      dynamic result =
          await callingSendRepublishNotificationFunction(callable, hcps, ctx);
      print('line 1690');
      return result;
    } catch (e) {
      print('line 1693: $e');
      throw Exception('line 1694: ${e.toString()}');
    }
  }

  Future<dynamic> callingSendRepublishNotificationFunction(
      HttpsCallable callable,
      List<Map<String, dynamic>> hcps,
      BuildContext ctx) async {
    print('line 1304: ${hcps[0]}');
    var ddata = {"data": hcps};
    try {
      final HttpsCallableResult result = await callable(ddata);
      print('line 1722: $result');
      print('line 1723 ${result.data}');
      return result.data;
    } catch (e) {
      print('line 1726 error: $e');
      throw Exception('line 1356  ${e.toString()}');
    }
  }
}
