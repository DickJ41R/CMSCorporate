//client app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'package:cms_web/features/hcpapp/services/hcp_timecard_service.dart';
import 'package:cms_web/features/clientapp/services/client_services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cms_web/features/shared/services/utility_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:cms_web/features/clientapp/models/client_work_order_campaign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/shared/services/dropdown_codes.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:cms_web/features/authentication/services/auth_service.dart';

class ClientWorkOrderCampaignService {
//  late int clientId;
  ClientWorkOrderCampaignService();

  HCPTimeCardService htc = HCPTimeCardService();
  ClientServices clientServices = ClientServices();
  UtilitiesServices utilitiesServices = UtilitiesServices();
  AuthService authServices = AuthService();

  Future<bool> updateClientMitigateOTForShift(String docId) async {
    print('line 30 in updateclientmitigation');
    try {
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .doc(docId)
          .update({
        'flagMitigateOT': true,
        'flagWillOweOT': false,
        'otHours': 0.0,
        'otPay': 0.0
      });
      return true;
    } catch (e) {
      print('line 34 error: ${e.toString()}');
      return false;
    }
  }

//new client
  Future<List<Map<String, dynamic>>>? getClientASMHCPWorkOrdersAll(
      int clientId) async {
    print('line 22 getallitemsfrom clienthcpwo; $clientId');
    //  return realm.all<ClientWorkOrderCampaign>();
    try {
      List<Map<String, dynamic>> listOfCWOMap = [];
      // int weekStartDay = 0;
      // DateTime currentDate = DateTime.now(); //DateTime
      // DateTime newDate = currentDate.subtract(Duration(hours: 12,
      //     minutes: currentDate.minute,
      //     seconds: currentDate.second,
      //     milliseconds: currentDate.millisecond,
      //     microseconds: currentDate.microsecond));
      // Timestamp myTimeStamp = Timestamp.fromDate(newDate);
      List<Map<String, dynamic>> listOfHolidays = [];
      await FirebaseFirestore.instance
          .collection('ClientHoliday')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> obj = docSnapshot.data();
          String sdt = obj['startDate'];
          sdt = sdt.replaceAll('\/', '\-');
          List<String> ls = sdt.split('-');
          String ndt = ls[2] + '-' + ls[0] + '-' + ls[1];
          DateTime tme = DateTime.parse(ndt);
          Map<String, dynamic> shm =
              utilitiesServices.getHoursMinutes(obj['startTime']);
          tme = tme.subtract(Duration(
              hours: tme.hour,
              minutes: tme.minute,
              seconds: tme.second,
              microseconds: tme.microsecond,
              milliseconds: tme.millisecond));
          DateTime nextDay = tme.add(Duration(days: 1));
          tme = tme.add(Duration(hours: shm['hours'], minutes: shm['minutes']));
          var tbj = {"date": tme, "nextDay": nextDay};
          listOfHolidays.add(tbj);
        }
      });
      int feb = 28;
      DateTime workDate = DateTime.now();
      if (workDate.year % 4 == 0) {
        feb = 29;
      }
      List<int> daysInMonth = [31, feb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
      int lastDayInMonth = daysInMonth[workDate.month - 1];
      DateTime startDate = new DateTime(workDate.year, workDate.month, 1);
      DateTime lastDate =
          new DateTime(workDate.year, workDate.month, lastDayInMonth);

      print('line 120: in getallworkorders');
      await FirebaseFirestore.instance
          .collection('ClientHCPWorkOrder')
          .where('clientId', isEqualTo: clientId)
          .where('statusId', whereNotIn: ['C', '*', 'E'])
          .orderBy("shiftDate", descending: false)
          .orderBy("shiftCode", descending: false)
          .orderBy("hcpId", descending: false)
          .get()
          .then((querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              var doc_id = docSnapshot.id;
              var obj = docSnapshot.data();
              Timestamp dts = obj['shiftDate'];
              DateTime dtd = dts.toDate();
              dtd = dtd.subtract(Duration(
                  hours: dtd.hour,
                  minutes: dtd.minute,
                  seconds: dtd.second,
                  microseconds: dtd.microsecond,
                  milliseconds: dtd.millisecond));
              // DateTime dtx = utilitiesServices.getValidDate(dte);
              if (dtd.millisecondsSinceEpoch <
                      startDate.millisecondsSinceEpoch ||
                  dtd.millisecondsSinceEpoch >
                      lastDate.millisecondsSinceEpoch) {
                continue;
              }

              obj['id'] = doc_id;
              listOfCWOMap.add(obj);
            }
          });
      print('line 153 get cmp all ${listOfCWOMap.length}');
      listOfCWOMap.sort((a, b) {
        print('line 155: ${a['shiftDate']}');
        int sd = a['shiftDate'].compareTo(b['shiftDate']);
        if (sd == 0) {
          return a['shiftCode'].compareTo(b['shiftCode']); // '-' for descending
        }
        return sd;
      });
      return listOfCWOMap;
    } catch (e) {
      print('line 164 in get all clienthcpwos: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsAll(
      int hcpId) async {
    print('line 16 getallitems; $hcpId');
    //  return realm.all<ClientWorkOrderCampaign>();

    DateTime time = DateTime.now();
    int timestamp = time.millisecondsSinceEpoch;
    print('line 21 tiemstamp $timestamp');
    List<Map<String, dynamic>> listOfCWOMap = [];
    DateTime currentDate = DateTime.now(); //DateTime
    DateTime newDate = currentDate.subtract(Duration(
        hours: 12,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        milliseconds: currentDate.millisecond,
        microseconds: currentDate.microsecond));
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);
    await FirebaseFirestore.instance
        .collection('ClientWorkOrderCampaign')
        .where('hcpId', isEqualTo: hcpId)
        .where('shiftDate', isGreaterThanOrEqualTo: myTimeStamp)
        .orderBy("shiftDate", descending: false)
        .orderBy("hcpId", descending: false)
        .orderBy("shiftCode", descending: false)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        var doc_id = docSnapshot.id;
        var obj = docSnapshot.data();
        obj['id'] = doc_id;
        listOfCWOMap.add(obj);
      }
    });
    List<Map<dynamic, dynamic>> hld = [];
    int i = 0;
    bool bFlag = false;
    while (i < listOfCWOMap.length) {
      Map<dynamic, dynamic> lw = listOfCWOMap[i];
      if (hld.length > 0) {
        bFlag = false;
        for (int j = 0; j < hld.length; j++) {
          Map<dynamic, dynamic> lh = hld[j];
          //     print('line 45: ${lh['shiftDate']} ${lw['shiftDate']}');
          //      print('line 46: ${lh['shiftCode']} ${lw['shiftCode']}');
          if (lh['shiftDate'] == lw['shiftDate'] &&
              lh['shiftCode'] == lw['shiftCode']) {
            listOfCWOMap.removeAt(i);
            bFlag = true;
            break;
          }
        }
      }
      if (bFlag == true) {
        continue;
      }
      hld.add(lw);
      i += 1;
    }
    print('line 38 get cmp all ${listOfCWOMap.length}');

    return listOfCWOMap;
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsShiftsWithRequiredOT(
      int clientId) async {
    print('lline 214 in getwosc for ot mitigation');
    List<Map<String, dynamic>> listOfCWOs = [];
    try {
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('clientId', isEqualTo: clientId)
          .where('flagWillOweOT', isEqualTo: true)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var doc_id = docSnapshot.id;
          var obj = docSnapshot.data();
          obj['id'] = doc_id;
          listOfCWOs.add(obj);
        }
      });
      return listOfCWOs;
    } catch (e) {
      print('line 218 error: ${e.toString()}');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsAllNotAccepted(
      int hcpId) async {
    print('line 74 get all not accepted; $hcpId');
    //  return realm.all<ClientWorkOrderCampaign>();

    DateTime currentDate = DateTime.now(); //DateTime
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour + 24,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        milliseconds: currentDate.millisecond,
        microseconds: currentDate.microsecond));
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);
    print('line 81: ${newDate.timeZoneName} ${newDate.timeZoneOffset}');
    print('line 82: $newDate $myTimeStamp');
    List<Map<String, dynamic>> listOfCWOMap = [];
    await FirebaseFirestore.instance
        .collection('ClientWorkOrderCampaign')
        .where('hcpId', isEqualTo: hcpId)
        .where('shiftDate', isGreaterThanOrEqualTo: myTimeStamp)
        .where('shiftAccepted', isEqualTo: false)
        .orderBy("shiftDate", descending: false)
        .orderBy("shiftCode", descending: false)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        var doc_id = docSnapshot.id;
        var obj = docSnapshot.data();
        obj['id'] = doc_id;
        print(
            'line 97: $doc_id ${obj['id']} ${obj['shiftCode']} ${obj['shiftDate']}');
        listOfCWOMap.add(obj);
      }
    });
    return listOfCWOMap;
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsAccepted(
      int hcpId) async {
    print('line 99 accept shift $hcpId');
    //  return realm.all<ClientWorkOrderCampaign>();
    DateTime currentDate = DateTime.now(); //DateTime
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour + 24,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        milliseconds: currentDate.millisecond,
        microseconds: currentDate.microsecond));
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);

    List<Map<String, dynamic>> listOfCWOMap = [];
    await FirebaseFirestore.instance
        .collection('ClientWorkOrderCampaign')
        .where('hcpId', isEqualTo: hcpId)
        .where('shiftDate', isGreaterThanOrEqualTo: myTimeStamp)
        .where('shiftStatus', isEqualTo: 'Accepted')
        .orderBy("shiftDate", descending: false)
        .orderBy("hcpId", descending: false)
        .orderBy("shiftCode", descending: false)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        var doc_id = docSnapshot.id;
        var obj = docSnapshot.data();
        obj['id'] = doc_id;
        listOfCWOMap.add(obj);
      }
    });
    return listOfCWOMap;
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsConfirmed(
      int clientId) async {
    print('line 138 in getworkordersconfirmed $clientId');
    DateTime currentDate = DateTime.now(); //DateTime
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        milliseconds: currentDate.millisecond,
        microseconds: currentDate.microsecond));
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);
    try {
      List<Map<String, dynamic>> listOfCWOMap = [];
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('clientId', isEqualTo: clientId)
          .where('shiftStatus', isEqualTo: 'Confirmed')
          .where('shiftDate', isGreaterThanOrEqualTo: myTimeStamp)
          .orderBy("shiftDate", descending: false)
          .orderBy("hcpId", descending: false)
          .orderBy("shiftCode", descending: false)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var doc_id = docSnapshot.id;
          var obj = docSnapshot.data();
          print('line 158: $obj');
          obj['id'] = doc_id;
          listOfCWOMap.add(obj);
        }
      });
      return listOfCWOMap;
    } catch (e) {
      print('line 164 error $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getWorkOrderCampaignsApproved(
      {int? clientId, int? hcpId = null}) async {
    //List<Map<String,dynamic>> mapData = [];
    print('line 165 in get approved by $hcpId');
    List<Map<String, dynamic>> listC = [];
    DateTime currentDate = DateTime.now(); //DateTime
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        milliseconds: currentDate.millisecond,
        microseconds: currentDate.microsecond));
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);
    print('line 171: $newDate ${myTimeStamp}');
    var docRef;
    if (clientId == null) {
      docRef = FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftDate', isGreaterThanOrEqualTo: myTimeStamp)
          .where('shiftStatus', isEqualTo: 'Approved')
          .orderBy("shiftDate", descending: false)
          .orderBy("hcpId", descending: false)
          .orderBy("shiftCode", descending: false);
    } else {
      docRef = FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('clientId', isEqualTo: clientId)
          .where('shiftDate', isGreaterThanOrEqualTo: myTimeStamp)
          .where('shiftStatus', isEqualTo: 'Approved')
          .orderBy("shiftDate", descending: false)
          .orderBy("hcpId", descending: false)
          .orderBy("shiftCode", descending: false);
    }
    // await FirebaseFirestore.instance
    //     .collection('ClientWorkOrderCampaign')
    //     .where('hcpId', isEqualTo: hcpId)
    //     .where('clientId', isEqualTo: clientId)
    //     .where('shiftDate', isGreaterThanOrEqualTo: myTimeStamp)
    //     .where('shiftStatus', isEqualTo: 'Approved')
    //     .orderBy("shiftDate", descending: false)
    //     .orderBy("hcpId", descending: false)
    //     .orderBy("shiftCode", descending: false)
    docRef.get().then((querySnapshot) {
      //  List<Map<String, dynamic>>mapData = [];
      for (var docSnapshot in querySnapshot.docs) {
        var doc_id = docSnapshot.id;
        var obj = docSnapshot.data();
        obj['id'] = doc_id;

        //  Map<String, dynamic> obj = docSnapshot.data();
        //   ClientWorkOrderCampaign cwn = ClientWorkOrderCampaign.fromFirestore(
        //       docSnapshot, null);
        listC.add(obj);
        print('line 90 ${listC.length}');
      }
    });
    print('ine 193: ${listC.length}');
    return listC;

    //  return mapData;
  }

  Future<List<Map<String, dynamic>>>? getClientWorkOrderCampaign(
      int hcpId) async {
    List<Map<String, dynamic>>? cgs;
    DateTime currentDate = DateTime.now(); //DateTime
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour + 24,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        milliseconds: currentDate.millisecond,
        microseconds: currentDate.microsecond));
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);

    await FirebaseFirestore.instance
        .collection('ClientWorkOrderCampaign')
        .where('hcpId', isEqualTo: hcpId)
        .where('shiftDate', isGreaterThanOrEqualTo: myTimeStamp)
        .where('shiftAccepted', isEqualTo: true)
        .where('shiftApproved', isEqualTo: true)
        .where('shiftConfirmed', isEqualTo: true)
        .get()
        .then((querySnapshot) {
      cgs = [];
      for (var docSnapshot in querySnapshot.docs) {
        var doc_id = docSnapshot.id;
        var obj = docSnapshot.data();
        obj['id'] = doc_id;
        cgs!.add(obj);
      }
    });
    return cgs!;
  }

  Future<bool>? cancelWorkOrderShift(
      Map<String, dynamic> item,
      int clientUserId,
      String clientUserName,
      String? shiftcanceledNote) async {
    bool bl = true;

    String? documentId = item['id'];
    DateTime currentDate = DateTime.now(); //DateTime
    Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
    print('line 371 cancelworkordershift: $shiftcanceledNote');
    FirebaseFirestore.instance
        .collection("ClientWorkOrderCampaign")
        .doc(documentId)
        .update({
      'shiftStatus': 'canceled',
      'shiftStatusDate': myTimeStamp,
      'shiftCanceled': true,
      "shiftActionCanceledData": myTimeStamp,
      "shiftCanceledById": clientUserId,
      "shiftCanceledByName": clientUserName,
      "shiftCanceledNote": shiftcanceledNote
    });

    return bl;
  }

  Future<bool>? cancelTimecardShift(
      Map<String, dynamic> item, int hcpId, String? shiftcanceledNote) async {
    bool bl = true;
    DateTime currentDate = DateTime.now(); //DateTime
    Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
    await FirebaseFirestore.instance
        .collection("HCPTmeCard")
        .where('id', isEqualTo: item['id'])
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        String documentId = docSnapshot.id;
        FirebaseFirestore.instance
            .collection("HCPTmeCard")
            .doc(documentId)
            .update({
          'shiftStatus': 'Canceled',
          'shiftStatusDate': myTimeStamp,
          'shiftcanceled': true,
          'shiftcanceledById': hcpId,
          'shiftcanceledActionDate': myTimeStamp,
          'shiftcanceledNote': shiftcanceledNote
        });
      }
    });
    return bl;
  }

  Future<List<Map<String, dynamic>>>? getRelatedHCPTimeCards(
      int clientId) async {
    List<Map<String, dynamic>> tcs = [];
    try {
      await FirebaseFirestore.instance
          .collection("HCPTimeCard")
          .where('clientId', isEqualTo: clientId)
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
      print('line 387 error: $e');
      throw Exception(e.toString());
    }
  }

  Map<String, dynamic> getStartEndDates(String startTime, String endTime) {
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
      //List<String> ett = ets[0].split(':');
      if (stt.length != 2) {
        return {};
      }
      int endHours = int.parse(stt[0]);
      int endMinutes = int.parse(stt[1]);
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

      endDate = endDate
          .add(Duration(days: addEndDay, hours: endHours, minutes: endMinutes));
      print('line 503: $newStartDate $endDate');
      return {
        "startDate": newStartDate,
        "endDate": endDate,
        "startHours": startHours,
        "startMinutes": startMinutes,
        "compareStartHours": compareStartHours,
        "compareStartMinutes": compareStartMinutes,
        "endHours": endHours,
        "endMinutes": endMinutes,
        "addEndDay": addEndDay
      };
    } catch (e) {
      print('line 502 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>>? getSingleWorkOrderCampaignsForClient(
      int userId, String shiftStatus) async {
    print('line 440 getallitems; $userId');
    //  return realm.all<ClientWorkOrderCampaign>();
    DateTime dte = DateTime.now();
    // DateTime dte1 = DateTime(dte.year,dte.month,dte.day,dte.hour,dte.minute,0,0,0);
    // DateTime dte2 = DateTime(dte.year,dte.month,dte.day,dte.hour+12,0,0,0,0); //12 shift length
    // DateTime dte1 = DateTime(dte.year,dte.month,dte.day-1,24,0,0,0,0);
    // DateTime dte2 = DateTime(dte.year,dte.month,dte.day+1,0,0,0,0,0); //12 shift len
    // Timestamp timestamp1 = Timestamp.fromDate(dte1);
    // Timestamp timestamp2 = Timestamp.fromDate(dte2);

    DateTime currentDate =
        new DateTime(dte.year, dte.month, dte.day, 6, 45, 0, 0);
    Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
    DateTime newDate = new DateTime(2024, 12, 23, 15, 0, 0);
    Timestamp myTimeStamp1 = Timestamp.fromDate(newDate);
    print('line 454: $currentDate $newDate');
    print('line 455: $myTimeStamp $myTimeStamp1');
    Map<String, dynamic> cw = {};
    try {
      //"hcpId == \$0 SORT(shiftDate ASC, shiftCode ASC)",[userId]);
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('hcpId', isEqualTo: userId)
          .where('shiftStatus', isEqualTo: shiftStatus)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          Map<String, dynamic> dates =
              getStartEndDates(obj['startTime'], obj['endTime']);
          print('line 467: ${obj['shiftDate']} $myTimeStamp $myTimeStamp1');
          Timestamp tms = obj['shiftDate'] as Timestamp;
          DateTime sd = DateTime.parse(tms.toDate().toString());
          sd = sd.subtract(Duration(
              hours: sd.hour,
              minutes: sd.minute,
              seconds: sd.second,
              milliseconds: sd.millisecond,
              microseconds: sd.microsecond));
          sd = sd.add(Duration(
              hours: dates['startHours'], minutes: dates['startMinutes']));
          Timestamp startTimeStamp = Timestamp.fromDate(sd);
          Timestamp compareStartTimeStamp =
              Timestamp.fromDate(dates['startDate']);
          Timestamp compareEndTimeStamp = Timestamp.fromDate(dates['endDate']);
          if (compareStartTimeStamp.seconds <= startTimeStamp.seconds &&
              startTimeStamp.seconds < compareEndTimeStamp.seconds) {
            cw = obj;
            break;
          }
        }
        print('line 482: $cw');
        return cw;
      });
      print('line 485: $cw');
      return cw;
    } catch (e) {
      print('line 488 error: $e');
      throw Exception(e.toString());
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

  Future<bool>? updateClientWorkOrderCampaignApproved(
      Map<String, dynamic> item, String shiftApprover, BuildContext ctx) async {
    print('line 590 update approved: ${item['id']}');
    try {
      DateTime time = DateTime.now();
      Timestamp myTimeStamp = Timestamp.fromDate(time);
      await FirebaseFirestore.instance
          .collection("ClientWorkOrderCampaign")
          .doc(item['id'])
          .update({
        'shiftApproved': true,
        'shiftApprovedActionDate': myTimeStamp,
        'shiftStatus': 'Approved',
        'shiftStatusDate': myTimeStamp,
        'shiftApprovedBy': shiftApprover,
        'otHours': item['otHours'],
        'otPay': item['otPay'],
        'regularHours': item['regularHours'],
        'regularPay': item['regularPay'],
        'flagWillOweOT': item['flagWillOweOT'],
        'totalPay': item['totalPay']
      });
      print('line 603 shift approved');
      Future.delayed(const Duration(seconds: 1), () {
        print('Hello, after 1 seconds of delay');
      });
      print('line 566: ${item['clientId']}');
      Map<String, dynamic>? clc = await clientServices.getSingleClientUser(
          item['clientId'], authServices.clientUserId!);
      if (clc!.isEmpty) {
        return false;
      }
      Map<String, dynamic>? usc =
          await clientServices.getSingleUser(item['hcpId']);
      if (usc!.isEmpty) {
        return false;
      }
      print('line 571: ${clc}');
      String fcmToken = usc['fcmToken'];
      Timestamp ts = item['shiftDate'];
      print('line 574: $fcmToken ${item['shiftDate']}');
      String shiftDate = convertFromTimestamp(ts);
      print('line 575 just before body creation');
      String body =
          '${clc['fullName']} has approved shift ${item['shiftCode']} for $shiftDate';
      Map<String, dynamic> parameters = {
        "title": "Shift Acceptance for: ${item['hcpName']}",
        "body": body,
        "fcmToken": fcmToken
      };
      print('line 581 ${parameters}');
      await htc.sendSingleMessage(parameters, ctx);
      return true;
    } catch (e) {
      print('line 586 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<bool>? updateClientWorkOrderCampaignDeclined(
      Map<String, dynamic> item, String shiftApprover, BuildContext ctx) async {
    print('line 612 update shift declined: ${item['id']}');
    try {
      DateTime time = DateTime.now();
      Timestamp myTimeStamp = Timestamp.fromDate(time);
      await FirebaseFirestore.instance
          .collection("ClientWorkOrderCampaign")
          .doc(item['id'])
          .update({
        'shiftApproved': false,
        'shiftApprovedActionDate': myTimeStamp,
        'shiftStatus': 'Declined',
        'shiftStatusDate': myTimeStamp,
        'shiftDeclinedBy': shiftApprover
      });
      print('line 633 shift declined');
      Map<String, dynamic>? clc = await clientServices.getSingleClientUser(
          item['clientId'], authServices.clientUserId!);
      if (clc!.isEmpty) {
        return false;
      }
      Map<String, dynamic>? usc =
          await clientServices.getSingleUser(item['hcpId']);
      if (usc!.isEmpty) {
        return false;
      }
      print('line 571: ${clc}');
      String fcmToken = usc['fcmToken'];
      Timestamp ts = item['shiftDate'];
      print('line 574: $fcmToken ${item['shiftDate']}');
      String shiftDate = convertFromTimestamp(ts);
      print('line 575 just before body creation');
      String body =
          '${clc['fullName']} has declined your acceptance of  ${item['shiftCode']} for $shiftDate';
      Map<String, dynamic> parameters = {
        "title": "Shift Declined for: ${item['hcpName']}",
        "body": body,
        "fcmToken": fcmToken
      };
      print('line 581 ${parameters}');
      await htc.sendSingleMessage(parameters, ctx);

      return true;
    } catch (e) {
      print('line 636 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderRepublishShifts(
      int clientId) async {
    print('line 633 shifts; $clientId');
    //  return realm.all<ClientWorkOrderCampaign>();
    DateTime currentDate = DateTime.now(); //DateTime
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        microseconds: currentDate.microsecond,
        milliseconds: currentDate.millisecond));
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);
    print('line 687: $myTimeStamp $newDate ');
    try {
      List<Map<String, dynamic>> listOfCWOMap = [];
      List<String> listWorkOrderIds = [];
      List<String> listHCPWorkOrderIds = [];
      List<String> shiftTypes = [
        'Open',
        'Accepted',
        'Approved',
      ];
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('clientId', isEqualTo: clientId)
          .where('shiftStatus', whereIn: shiftTypes)
          .where('dates.shiftDateInfo.shiftDate',
              isGreaterThanOrEqualTo: myTimeStamp)
          .orderBy("dates.shiftDateInfo.shiftDate", descending: false)
          .orderBy("dates.shiftDateInfo.shiftCode", descending: false)
          .get()
          .then((querySnapshot) async {
        print('line 949: ${querySnapshot.docs.length}');
        for (var docSnapshot in querySnapshot.docs) {
          var doc_id = docSnapshot.id;
          print('line 958: $doc_id');
          var obj = docSnapshot.data();
          obj['id'] = doc_id;
          // Timestamp tms = obj['shiftDateInfo']['shiftDate'];
          // DateTime dt = tms.toDate();
          // dt = dt.subtract(Duration(hours:dt.hour,minutes:dt.minute,seconds: dt.second,
          //     microseconds: dt.microsecond,milliseconds: dt.millisecond));
          // tms = Timestamp.fromDate(dt);
          // if (tms.millisecondsSinceEpoch >= myTimeStamp.millisecondsSinceEpoch) {
          //   continue;
          // }
          bool flagIsDuplicate = false;
          if (listOfCWOMap.length > 0) {
            for (int i = 0; i < listOfCWOMap.length; i++) {
              Map<String, dynamic> mp = listOfCWOMap[i];
              if (obj['clientId'] == mp['clientId']) {
                if (obj['disciplineName'] == mp['disciplineName']) {
                  if (obj['dates']['shiftDateInfo']['shiftCode'] ==
                      mp['dates']['shiftDateInfo']['shiftCode']) {
                    Timestamp tnw = obj['dates']['shiftDateInfo']['shiftDate'];
                    Timestamp mnw = mp['dates']['shiftDateInfo']['shiftDate'];
                    DateTime dnw = tnw.toDate();
                    DateTime pnw = mnw.toDate();
                    dnw = dnw.subtract(Duration(
                        hours: dnw.hour,
                        minutes: dnw.minute,
                        seconds: dnw.second,
                        microseconds: dnw.microsecond,
                        milliseconds: dnw.millisecond));
                    pnw = pnw.subtract(Duration(
                        hours: pnw.hour,
                        minutes: pnw.minute,
                        seconds: pnw.second,
                        microseconds: pnw.microsecond,
                        milliseconds: pnw.millisecond));
                    print('line 1011: $dnw $pnw');
                    if (dnw.millisecondsSinceEpoch ==
                        pnw.millisecondsSinceEpoch) {
                      flagIsDuplicate = true;
                      print('line 1014 have a dup');
                      break;
                    }
                  }
                }
              }
            }
          }
          if (flagIsDuplicate == false) {
            listOfCWOMap.add(obj);
          }
        }
        print('line 836 ${listOfCWOMap.length}');
        return listOfCWOMap;
      });
      return listOfCWOMap;
    } catch (e) {
      print('line 841 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCancelShifts(
      int clientId) async {
    print('line 633 shifts; $clientId');
    //  return realm.all<ClientWorkOrderCampaign>();
    DateTime currentDate = DateTime.now(); //DateTime
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        microseconds: currentDate.microsecond,
        milliseconds: currentDate.millisecond));
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);
    print('line 687: $myTimeStamp $newDate ');
    try {
      List<Map<String, dynamic>> listOfCWOMap = [];
      List<String> listWorkOrderIds = [];
      List<String> listHCPWorkOrderIds = [];
      List<String> shiftTypes = [
        'Open',
        'Closed',
        'Accepted',
        'Approved',
        'Confirmed',
        'SignedIn'
      ];
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('clientId', isEqualTo: clientId)
          //  .where('shiftStatus', whereNotIn: shiftTypes)
          .where('dates.shiftDateInfo.shiftDate',
              isGreaterThanOrEqualTo: myTimeStamp)
          .orderBy("dates.shiftDateInfo.shiftDate", descending: false)
          .orderBy("dates.shiftDateInfo.shiftCode", descending: false)
          .get()
          .then((querySnapshot) async {
        print('line 949: ${querySnapshot.docs.length}');
        for (var docSnapshot in querySnapshot.docs) {
          var doc_id = docSnapshot.id;
          print('line 958: $doc_id');
          var obj = docSnapshot.data();
          if (obj['shiftStatus'] == 'Canceled') {
            continue;
          }

          if (obj['shiftStatus'] == 'Closed') {
            listWorkOrderIds.add(doc_id);
            listHCPWorkOrderIds.add(doc_id);
          }
          obj['id'] = doc_id;
          // Timestamp tms = obj['shiftDateInfo']['shiftDate'];
          // DateTime dt = tms.toDate();
          // dt = dt.subtract(Duration(hours:dt.hour,minutes:dt.minute,seconds: dt.second,
          //     microseconds: dt.microsecond,milliseconds: dt.millisecond));
          // tms = Timestamp.fromDate(dt);
          // if (tms.millisecondsSinceEpoch >= myTimeStamp.millisecondsSinceEpoch) {
          //   continue;
          // }
          listOfCWOMap.add(obj);
        }
        print('line 972: ${listOfCWOMap.length} ${listHCPWorkOrderIds.length}');
        if (listHCPWorkOrderIds.length > 0) {
          for (int i = 0; i < listHCPWorkOrderIds.length; i++) {
            String workOrderId = listHCPWorkOrderIds[i];
            print('line 1012: $workOrderId');
            await FirebaseFirestore.instance
                .collection('ClientWorkOrderCampaign')
                .where('woWorkOrderId', isEqualTo: workOrderId)
                .get()
                .then((querySnapshot) async {
              for (var docSnapshot in querySnapshot.docs) {
                Map<String, dynamic>? hcpCpg = docSnapshot.data();
                print('line 1018: ${hcpCpg}');
                print('line 1019: ${hcpCpg!['shiftStatus']}');
                var woWorkOrderId = hcpCpg['woWorkOrderId'];
                if (hcpCpg['shiftStatus'] == 'SignedOut' ||
                    hcpCpg['shiftStatus'] == 'Canceled') {
                  int j = 0;
                  while (j < listOfCWOMap.length) {
                    var tbj = listOfCWOMap[j];
                    if (tbj['id'] == woWorkOrderId) {
                      listOfCWOMap.removeAt(j);
                      continue;
                    }
                    j += 1;
                  }
                } else {
                  int j = 0;
                  while (j < listOfCWOMap.length) {
                    var tbj = listOfCWOMap[j];
                    if (tbj['id'] == woWorkOrderId) {
                      tbj['workOrderCampaignShiftStatus'] =
                          hcpCpg['shiftStatus'];
                      break;
                    }
                    j += 1;
                  }
                }
              }
            });
          }
        }

        print('line 836 ${listOfCWOMap.length}');
        return listOfCWOMap;
      });
      return listOfCWOMap;
    } catch (e) {
      print('line 841 error: $e');
      throw Exception(e.toString());
    }
  }

  List<String> daysOfTheWeek = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];
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

  Future<Map<String, dynamic>> _getPotentialOverTime() async {
    try {
      DateTime dtm = DateTime.now();
      int dv = dtm.day;
      int wv = dtm.weekday;
      int diffDay = wv - 1;
      int ms = dtm.millisecondsSinceEpoch;
      int dms = ms - (diffDay * 24 * 60 * 60 * 1000);
      DateTime initialDate = new DateTime.fromMillisecondsSinceEpoch(dms);
      int difday = 7 - wv;
      int edms = ms + (difday * 24 * 60 * 60 * 1000);
      DateTime endDate = new DateTime.fromMillisecondsSinceEpoch(edms);
      int iday = initialDate.day;
      int eday = endDate.day;

      Map<String, dynamic> cm = {
        "initialDate": initialDate,
        "endDate": endDate,
        "initialDay": iday,
        "endDay": eday,
        "weekDay": dtm.weekday,
        "monthDay": dtm.day,
        "month": dtm.month,
        "year": dtm.year,
      };
      return cm;
    } catch (e) {
      print('line 1214 error: ${e.toString()}');
      throw Exception('line 1215 ${e.toString()}');
    }
  }

  //FIRST DAY OF WEE
  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  //LAST DAY OF THE WEEK
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }
  //LAST DAY OF THE MONTH

  DateTime findLastDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1, 0);
  }
  //FIRST DAY OF THE MONTH

  DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }
  //LAST DAY OF THE YEAR

  DateTime findLastDateOfTheYear(DateTime dateTime) {
    return DateTime(dateTime.year, 12, 31);
  }
  // FIRST DAY OF THE YEAR

  DateTime findFirstDateOfTheYear(DateTime dateTime) {
    return DateTime(dateTime.year, 1, 1);
  }

  int _getLastDayOfMonth(int month, int year) {
    int feb = 28;
    int mod = year % 4;
    if (mod == 0) {
      feb = 29;
    }
    List<int> mths = [31, feb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return mths[month - 1];
  }

  Future<Map<String, dynamic>> determineIfShiftRequiresOT(
      int clientId, Map<String, dynamic> mcwo) async {
    print('line 1212 determine ot: $clientId ${mcwo}');
    double totalHours = 0.0;
    double priorHours = 0.0;
    double otHours = 0.0;
    List<int> clientIds = [];
    Map<String, dynamic>? hcwo = await _getPotentialOverTime();
    print('line 1321: $hcwo');
    Timestamp tsd = mcwo['shiftDate'];
    DateTime cdtm = tsd.toDate();
    DateTime fdm = findFirstDateOfTheMonth(cdtm);
    DateTime ldm = findLastDateOfTheMonth(cdtm);
    int lastDayOfMonth = ldm.day;
    int cday = cdtm.day;
    int cweekday = cdtm.weekday;
    int cmonth = cdtm.month;
    int cyear = cdtm.year;
    int startDay = cdtm.day;

    int endDay = ldm.day;
    DateTime fdw = findFirstDateOfTheWeek(cdtm);
    cday = fdw.day;
    cweekday = fdw.weekday;
    DateTime fdl = findLastDateOfTheWeek(cdtm);
    int ceday = fdl.day;

    int firstDayOfWeek = fdw.weekday;
    int lastDayOfWeek = fdl.weekday;
    startDay = fdw.day;
    endDay = fdl.day;
    int startMonth = fdw.month;
    int endMonth = fdl.month;
    print('line 1048: $cday, $cweekday $startMonth $endMonth');
    print(
        'line 1233: $cdtm $fdw $fdl $startDay, $endDay, $firstDayOfWeek, $lastDayOfWeek');

    List<String> docIds = [];
    docIds.add(mcwo['id']);
    if (mcwo['createdDate'] == null) {
      mcwo['createdDate'] = mcwo['date'];
    }
    List<Map<String, dynamic>> docObjs = [];
    docObjs.add(mcwo);
    Map<String, dynamic> otDate = {};
    Timestamp oldCreatedDate = Timestamp.fromDate(DateTime(cyear, 12, 31));
    try {
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('hcpId', isEqualTo: mcwo['hcpId'])
          .where('shiftStatus', whereIn: ['Confirmed', 'SignedIn', 'SignedOut'])
          .orderBy("shiftDate", descending: false)
          .orderBy("hcpId", descending: false)
          .orderBy("shiftCode", descending: false)
          .get()
          .then((querySnapshot) async {
            print('line 1244: ${querySnapshot.docs.length}');
            for (var docSnapshot in querySnapshot.docs) {
              var docId = docSnapshot.id;
              var obj = docSnapshot.data();
              if (docId == mcwo['id']) {
                continue;
              }
              obj['id'] = docId;
              Timestamp sts = obj['shiftDate'];
              DateTime stm = sts.toDate();
              int sday = stm.day;
              int sweekday = stm.weekday;
              int smonth = stm.month;
              int syear = stm.year;
              if (syear < cyear) {
                continue;
              }
              if (smonth < cmonth) {
                continue;
              }

              print('line 1267: $smonth $cmonth');
              if (smonth > cmonth) {
                if (smonth - cmonth > 1) {
                  //cant be sep dec
                  continue;
                }
              }
              print('line 1272: $startDay $endDay $sday  $lastDayOfMonth');
              if (smonth < cmonth) {
                if (sday < cday) {
                  print('line 1106 skipping sday < cday $sday $cday');
                  continue;
                }
              } else {
                if (sday > endDay) {
                  print('line 1111 skipping sday > endday $sday $endDay');
                }
              }
              if (obj['createdDate'] == null) {
                obj['createdDate'] = obj['date'];
              }
              docObjs.add(obj);
            }
          });
      if (docObjs.length == 0) {
        return {};
      }
      docObjs.sort((a, b) => a['createdDate'].compareTo(b['createdDate']));
      totalHours = 0;
      print('line 1292 after sort ${docObjs.length}');
      double div = 40.0;
      Map<String, dynamic>? holdMCWO;
      for (int i = 0; i < docObjs.length; i++) {
        Map<String, dynamic> mp = docObjs[i];
        Timestamp ts = mp['createdDate'];
        DateTime dtm = ts.toDate();
        Timestamp sts = mp['shiftDate'];
        DateTime xtm = sts.toDate();
        mp['flagWillOweOT'] = false;
        mp['otHours'] = 0.0;
        mp['regularHours'] = mp['hours'];
        mp['otPay'] = 0.0;
        mp['regularPay'] = 0.0;
        totalHours += mp['hours'];
        print(
            'line 1302: ${mp['id']} ${mcwo['id']} $xtm ${mp['clientId']} $dtm $div $totalHours');
        if (totalHours - div > 0) {
          otHours = totalHours - div;
          // if (mp['meals'] > 0) {
          //   double val = .5;
          //   mp['regularHours'] += val;
          //   otHours -= val;
          // }
          mp['otHours'] = otHours;
          double opv = mp['otHours'] * mp['payRateOT'] * mp['payRate'];
          mp['otPay'] = opv;
          mp['OtPayRate'] = mp['payRateOT'] * mp['payRate'];
          mp['regularHours'] -= otHours;
          mp['regularPay'] = mp['regularHours'] * mp['payRate'];
          mp['flagWillOweOT'] = true;
          mp['totalPay'] = mp['otPay'] + mp['regularPay'];
          div = totalHours;
        } else {
          mp['otHours'] = 0.0;
          mp['otPay'] = 0.0;
          mp['OtPayRate'] = mp['payRate'];
          mp['regularPay'] = mp['regularHours'] * mp['payRate'];
          mp['totalPay'] = mp['regularPay'];
          mp['flagWillOweOT'] = false;
        }
        if (mp['id'] == mcwo['id']) {
          holdMCWO = mp;
        }
      }

      print('line 1313: ${holdMCWO!['id']} ${holdMCWO['flagWillOweOT']} ');
      return holdMCWO;
    } catch (e) {
      print('line 1333: ${e.toString()}');
      throw Exception('line 1334: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsAcceptedShifts(
      int clientId, String startWeekDay) async {
    print('line 1212 get accepted shifts; $clientId');
    //  return realm.all<ClientWorkOrderCampaign>();
    DateTime currentDate = DateTime.now(); //DateTime
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        milliseconds: currentDate.millisecond,
        microseconds: currentDate.microsecond));
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);
    try {
      List<Map<String, dynamic>> listOfCWOMap = [];
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('clientId', isEqualTo: clientId)
          .where('shiftStatus', whereIn: ['Accepted', 'Approved'])
          .orderBy("shiftDate", descending: false)
          .orderBy("hcpId", descending: false)
          .orderBy("shiftCode", descending: false)
          .get()
          .then((querySnapshot) async {
            //   int count = 0;
            print('line 1219 ${querySnapshot.docs.length}');
            for (var docSnapshot in querySnapshot.docs) {
              var doc_id = docSnapshot.id;
              var obj = docSnapshot.data();
              print('line 1223: $doc_id $obj');
              //     count += 1;
              obj['id'] = doc_id;
              Timestamp tbx = obj['shiftDate'];
              DateTime dbx = tbx.toDate();
              dbx = dbx.subtract(Duration(
                  hours: dbx.hour,
                  minutes: dbx.minute,
                  seconds: dbx.second,
                  microseconds: dbx.microsecond,
                  milliseconds: dbx.millisecond));
              tbx = Timestamp.fromDate(dbx);
              print(
                  'line 1235: ${tbx.millisecondsSinceEpoch} ${myTimeStamp.millisecondsSinceEpoch}');
              if (tbx.millisecondsSinceEpoch >=
                  myTimeStamp.millisecondsSinceEpoch) {
                print('line 1237 check');
                obj['requiresOvertime'] = false;
                obj['shiftOvertime'] = false;
                DateTime dbxx = dbx;
                List<int> sTimes = getHoursAndMinutes(obj['startTime']);
                int startMinutes =
                    utilitiesServices.getMinutes(obj['startTime']);
                int endMinutes = utilitiesServices.getMinutes(obj['endTime']);
                print('line 1265: $startMinutes $endMinutes');
                List<int> eTimes = getHoursAndMinutes(obj['endTime']);
                if (startMinutes >= 720 && startMinutes > endMinutes) {
                  eTimes[0] += 24;
                }
                print(
                    'line 1262 etimes:  ${obj['startTime']} $sTimes ${obj['endTime']} $eTimes');
                dbxx = dbxx.add(Duration(hours: eTimes[0], minutes: eTimes[1]));
                if (currentDate.millisecondsSinceEpoch >=
                    dbxx.millisecondsSinceEpoch) {
                  print(
                      'line 1260 ${currentDate.millisecondsSinceEpoch} ${dbxx.millisecondsSinceEpoch}');
                } else {
                  listOfCWOMap.add(obj);
                }
              }
            }
          });

      print('line 1247: ${listOfCWOMap.length}');
      return listOfCWOMap;
    } catch (e) {
      print('line 750 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> testFunction(BuildContext ctx) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        // 'uploadTimesheetFromStorage',
        'uploadTimesheetFromStorage',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );
      print('line 1291 in call A  function: $callable');
      dynamic result = await htc.callingUploadTimesheetFromStorageFunction(
          callable, '916029', '04102025223261timesheet.pdf', ctx);
      print('line 1294: $result');
      return result;
    } catch (e) {
      print('line 1297: $e');
      throw Exception('line 1298: ${e.toString()}');
    }
  }

  //old cms_web
  Future<List<Map<String, dynamic>>>? getClientWorkOrdersAll(
      int clientId) async {
    print('line 22 getallitemsfrom clienthcpwo; $clientId');
    //  return realm.all<ClientWorkOrderCampaign>();
    try {
      List<Map<String, dynamic>> listOfCWOMap = [];
      // int weekStartDay = 0;
      // DateTime currentDate = DateTime.now(); //DateTime
      // DateTime newDate = currentDate.subtract(Duration(hours: 12,
      //     minutes: currentDate.minute,
      //     seconds: currentDate.second,
      //     milliseconds: currentDate.millisecond,
      //     microseconds: currentDate.microsecond));
      // Timestamp myTimeStamp = Timestamp.fromDate(newDate);
      List<Map<String, dynamic>> listOfHolidays = [];
      await FirebaseFirestore.instance
          .collection('ClientHoliday')
          .where('clientId', isEqualTo: clientId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> obj = docSnapshot.data();
          String sdt = obj['startDate'];
          sdt = sdt.replaceAll('\/', '\-');
          List<String> ls = sdt.split('-');
          String ndt = ls[2] + '-' + ls[0] + '-' + ls[1];
          DateTime tme = DateTime.parse(ndt);
          Map<String, dynamic> shm =
              utilitiesServices.getHoursMinutes(obj['startTime']);
          tme = tme.subtract(Duration(
              hours: tme.hour,
              minutes: tme.minute,
              seconds: tme.second,
              microseconds: tme.microsecond,
              milliseconds: tme.millisecond));
          DateTime nextDay = tme.add(Duration(days: 1));
          tme = tme.add(Duration(hours: shm['hours'], minutes: shm['minutes']));
          var tbj = {"date": tme, "nextDay": nextDay};
          listOfHolidays.add(tbj);
        }
      });
      int feb = 28;
      DateTime workDate = DateTime.now();
      int cDay = workDate.day;
      int cMonth = workDate.month;
      int cYear = workDate.year;

      if (workDate.year % 4 == 0) {
        feb = 29;
      }
      List<int> daysInMonth = [31, feb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
      int lastDayInMonth = daysInMonth[workDate.month - 1];
      DateTime startDate = new DateTime(workDate.year, workDate.month, 1);
      DateTime lastDate =
          new DateTime(workDate.year, workDate.month, lastDayInMonth);

      int x = 0;
      print('line 120: in getallworkorders');
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('clientId', isEqualTo: clientId)
          .orderBy("dates.shiftDateInfo.shiftDate", descending: false)
          .orderBy("dates.rates.rateDetails.shiftCode", descending: false)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var doc_id = docSnapshot.id;
          var obj = docSnapshot.data();
          Timestamp dts = obj['dates']['shiftDateInfo']['shiftDate'];
          DateTime dtd = dts.toDate();
          int sDay = dtd.day;
          int sMonth = dtd.month;
          int sYear = dtd.year;
          print('line 148: $sDay $sMonth $sYear $cDay $cMonth $cYear');
          if (sMonth < cMonth) {
            continue;
          }
          if (sYear < cYear) {
            continue;
          }

          if (obj['meals'] == null) {
            obj['meals'] = 0;
          }
          // print('line 174: ${obj['hcpName']}');
          if (obj['hcpName'] == null ||
              obj['hcpName'] == "" ||
              obj['hcpName'] == '') {
            obj['hcpName'] = "Open";
          }
          obj['shiftDate'] = obj['dates']['shiftDateInfo']['shiftDate'];
          obj['shiftCode'] = obj['dates']['rates']['rateDetails']['shiftCode'];
          obj['id'] = doc_id;
          obj['isWeekend'] = obj['dates']['shiftDateInfo']['weekend'];
          obj['isHoliday'] = obj['dates']['shiftDateInfo']['holiday'];
          obj['startTime'] = obj['dates']['rates']['rateDetails']['startTime'];
          obj['endTime'] = obj['dates']['rates']['rateDetails']['endTime'];
          obj['billRate'] = obj['dates']['rates']['rateDetails']['billRate'];
          // print(
          //     'line 176: ${obj['shiftDate']} ${obj['shiftCode']} ${obj['isWeekend']} ${obj['isHoliday']} ${obj['startTime']} ${obj['endTime']} ${obj['billRate']}');
          // print(
          //     'line 177: ${obj['disciplineName']} ${obj['clientName']} ${obj['departmentName']} ${obj['hcpId']} ${obj['hcpName']} ${obj['meals']}');
          x = 1;

          listOfCWOMap.add(obj);
        }
      });
      print('line 153 get cmp all ${listOfCWOMap.length}');
      // for (int i = 0; i < listOfCWOMap.length; i++) {
      //   Map<String, dynamic> mp = listOfCWOMap[i];
      //   print('line 202: $i, ${mp['shiftDate']} ${mp['asmWorkOrderId']}');
      // }
      listOfCWOMap.sort((a, b) {
        print('line 155: ${a['shiftDate']} ${b['shiftDate']}');
        int sd = a['shiftDate'].compareTo(b['shiftDate']);
        print('line 203: $sd');
        if (sd == 0) {
          return a['shiftCode'].compareTo(b['shiftCode']); // '-' for descending
        }
        return sd;
      });
      return listOfCWOMap;
    } catch (e) {
      print('line 164 in get all clienthcpwos: $e');
      throw Exception(e.toString());
    }
  }

  Future<bool>? updateClientWorkOrderCampaignAccepted(
      Map<String, dynamic> item, dynamic data, BuildContext ctx) async {
    print('line 1251: ${item['id']} $data ${item}');
    try {
      DateTime currentDate = DateTime.now(); //DateTime
      Timestamp myTimeStamp = Timestamp.fromDate(currentDate); //To TimeStamp

      var updateShiftStatus = 'Accepted';
      Map<String, dynamic>? clnt =
          await clientServices.getClient(item['clientId']);
      if (clnt == null) {
        print('line 1263 did not get client record');
        return true;
      }
      int sMin = utilitiesServices.getMinutes(item['startTime']);
      int eMin = utilitiesServices.getMinutes(item['endTime']);
      print('line 1452: $sMin $eMin');
      int shiftMinutes = 0;
      if (sMin >= 720 && eMin >= 720) {
        // 13:00 to 23:00
        shiftMinutes += (eMin - sMin);
      } else if (sMin >= 720 && sMin > eMin) {
        //13:00 to 7:00
        eMin += 24 * 60;
        sMin = eMin - sMin;
        shiftMinutes += sMin;
      } else if (sMin < 720) {
        //7:00 am to 15:00
        shiftMinutes += (eMin - sMin);
      }
      String weekStartDay = 'Mon';
      Timestamp cts = item['shiftDate'];
      Map<String, dynamic> tvs = await utilitiesServices.checkWeeklyHours(
          item['hcpId'], cts, weekStartDay);
      bool flagWeeklyOvertime = false;
      int dailyMinutes = int.parse(tvs['dailyScheduledMinutes'].toString());
      int weeklyMinutes = int.parse(tvs['weeklyScheduledMinutes'].toString());
      String shiftApprovalNote = "";
      print('line 1483 $dailyMinutes $weeklyMinutes');
      if (weeklyMinutes + dailyMinutes > 2400) {
        flagWeeklyOvertime = true;
        shiftApprovalNote = "OT";
      }
      print('line 1491: $dailyMinutes $weeklyMinutes');

      if (clnt['gpoClient'] == true) {
        updateShiftStatus = 'Approved';
      }

      print('line 1277: ${updateShiftStatus} ${item['id']}');
      await FirebaseFirestore.instance
          .collection("ClientWorkOrderCampaign")
          .doc(item['id'])
          .update({
        'shiftStatus': updateShiftStatus,
        'shiftStatusDte': myTimeStamp,
        'shiftAccepted': true,
        'shiftAcceptedActionDate': myTimeStamp,
        'woWorkOrderId': null,
        'shiftOvertime': flagWeeklyOvertime,
        'shiftApprovalNote': shiftApprovalNote,
        'shiftApproved': updateShiftStatus == 'Approved' ? true : false
      });
      print('line 1289 returned true');
      await Future.delayed(const Duration(milliseconds: 100), () {
        print('line 1291 Hello, after 100 milliseconds of delay');
      });
      print('line 1293: ${item['clientId']}');

      Map<String, dynamic>? clc = await clientServices.getSingleClientUser(
          item['clientId'], item['clientUserId']);
      if (clc!.isEmpty) {
        print('line 1298 did not get clientuser record');
        return true;
      }
      print('line 1301: ${clc}');
      String fcmToken = clc['fcmToken'];
      Timestamp ts = item['shiftDate'];
      String shiftDate = convertFromTimestamp(ts);
      String body =
          '${clc['fullName']},  ${item['hcpName']} has accepted shift ${item['shiftCode']} for $shiftDate';
      print('line 1307: $fcmToken ${body}');
      Map<String, dynamic> parameters = {
        "title": "Shift Acceptance",
        "body": body,
        "fcmToken": fcmToken
      };
      await htc.sendSingleMessage(parameters, ctx);
      return true;
    } catch (e) {
      print('line 1316 error: ${item['id']} $e');
      throw Exception(e.toString());
    }
  }

  Future<dynamic>? updateClientWorkOrderCampaignConfirmed(
      Map<String, dynamic> item,
      dynamic data,
      String clientWorkOrderUUid,
      BuildContext ctx) async {
    print('line 1328 $data ${item}');
    if (data['shiftStatus'] != 'Confirmed') {
      print(
          'line 1330 skipping because invalid shift status: ${data['shiftStatus']}');
      return "ERROR: invalid shiftStatus";
    }

    int asmWorkOrderId = -1;
    int asmHCPTimeCardId = -1;
    int hcpId = -1;
    Map<String, dynamic>? asmWO;
    DateTime currentDate = DateTime.now(); //DateTime
    Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
    String weekStartDay = 'Mon';
    DateTime nt = DateTime.now();
    nt = nt.subtract(Duration(
        hours: nt.hour,
        minutes: nt.minute,
        seconds: nt.second,
        microseconds: nt.microsecond,
        milliseconds: nt.millisecond));
    Timestamp ntt = Timestamp.fromDate(nt);
    DateTime nt1 = nt;
    //  nt1 = nt1.add(Duration(days: 1));
    Timestamp nt1s = Timestamp.fromDate(nt1);
    print('line 1349: $nt1s ${item['id']}');

    String clientWorkOrderUUid = '';
    var woDocumentId = null;
    var workOrderId = null;
    var documentId = null;
    bool flagWeeklyOvertime = false;

    try {
      //line 873a
      final db = FirebaseFirestore.instance;
      final String dId = item['id'];
      print('line 1361: $dId');
      final _documentRef = db.collection('ClientWorkOrderCampaign').doc(dId);
      DocumentSnapshot documentSnapshot = await _documentRef.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? dta =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (dta!['shiftStatus'] != 'Approved' &&
            dta['shiftStatus'] != 'Dismissed') {
          return "ERROR: HCP already scheduled.";
        }
      } else {
        return "ERROR: No record for the HCP";
      }

      bool isSLGenerated = false;
      int slGeneratedWorkOrderId = 0;
      String slGeneratedId = '';

      if (data['shiftStatus'] == 'Dismissed') {
        WriteBatch batch = db.batch();
        final docRef1 =
            db.collection('ClientWorkOrderCampaign').doc(item['id']);
        batch.update(docRef1, {
          'shiftStatus': data['shiftStatus'],
          'shiftConfirmed': data['shiftConfirmed'],
          'shiftConfirmedActionDate': myTimeStamp,
          'shiftStatusDate': myTimeStamp
        }); //close
        batch.commit();
        return "OK";
      }

      Timestamp its = item['shiftDate'];
      DateTime itd = its.toDate();
      itd = itd.subtract(Duration(
          hours: itd.hour,
          minutes: itd.minute,
          seconds: itd.second,
          microseconds: itd.microsecond,
          milliseconds: itd.millisecond));
      print('line 1401: $itd');
      Timestamp cts = item['shiftDate'];
      DateTime ctd = cts.toDate();
      ctd = ctd.subtract(Duration(
          hours: ctd.hour,
          minutes: ctd.minute,
          seconds: ctd.second,
          microseconds: ctd.microsecond,
          milliseconds: ctd.millisecond));
      print('line 1410: $itd $ctd');
      String msg = '';

      // //check campaign work orders first time lag issue
      int totalMinutes = await utilitiesServices.checkTimeLimits(
          item['clientId'],
          item['hcpId'],
          item['meals'],
          item['clientWorkOrderUuid'],
          cts);
      print('line 1451: $totalMinutes');
      int sMin = utilitiesServices.getMinutes(item['startTime']);
      int eMin = utilitiesServices.getMinutes(item['endTime']);
      print('line 13454: $sMin $eMin');
      int shiftMinutes = 0;
      if (sMin >= 720 && eMin >= 720) {
        // 13:00 to 23:00
        shiftMinutes += (eMin - sMin);
      } else if (sMin >= 720 && sMin > eMin) {
        //13:00 to 7:00
        eMin += 24 * 60;
        sMin = eMin - sMin;
        shiftMinutes += sMin;
      } else if (sMin < 720) {
        //7:00 am to 15:00
        shiftMinutes += (eMin - sMin);
      }
      print('line 1468 $shiftMinutes $totalMinutes');
      if (shiftMinutes + totalMinutes > 960) {
        print('line 1470 not confirmed: $shiftMinutes $totalMinutes');
        return "Not Confirmed:  Hours Limit on Day";
      }
      print('line 1473 $cts $weekStartDay $shiftMinutes $totalMinutes');
      Map<String, dynamic> tvs = await utilitiesServices.checkWeeklyHours(
          item['hcpId'], cts, weekStartDay);

      // Map<String, dynamic> tvs = {
      //   "dailyScheduledMinutes": 0,
      //   "weeklyScheduledMinutes": 0
      // };
      int dailyMinutes = int.parse(tvs['dailyScheduledMinutes'].toString());
      int weeklyMinutes = int.parse(tvs['weeklyScheduledMinutes'].toString());
      print('line 1483 $dailyMinutes $weeklyMinutes');
      if (weeklyMinutes + dailyMinutes > 2400) {
        print('line 1485: $weeklyMinutes $dailyMinutes');
        flagWeeklyOvertime = true;
        // return "Not Confirmed: Weekly Overtime Limit on week";
      }
      if (dailyMinutes + shiftMinutes > 960) {
        print('line 1490 $dailyMinutes');
        return "Not Confirmed:  Hours Limit on day";
      }
      print('line 1493: $dailyMinutes $weeklyMinutes');
      int totalDayBeforeMinutes = 0;
      if (item['shiftCode'] == '1') {
        totalDayBeforeMinutes =
            await utilitiesServices.getDayBeforeMinutes(item['hcpId'], ctd);
      }
      if (totalDayBeforeMinutes + shiftMinutes > 960) {
        print('line 1572 totalDayBeforeMinutes: $totalDayBeforeMinutes');
        return "Not Confirmed:  From prior day, consecutive hours > 960";
      }
      late var obj;
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('clientId', isEqualTo: item['clientId'])
          .where('dates.shiftDateInfo.shiftCode', isEqualTo: item['shiftCode'])
          .where('shiftStatus', isEqualTo: 'Open')
          .get()
          .then((querySnapshot) async {
        print('line 1504: ${querySnapshot.docs.length}');
        for (var docSnapshot in querySnapshot.docs) {
          documentId = docSnapshot.id;
          slGeneratedId = docSnapshot.id;
          obj = docSnapshot.data();
          print('line 1509: ${obj['asmWorkOrderId']} $documentId ');
          Timestamp cts = obj['dates']['shiftDateInfo']['shiftDate'];
          DateTime ctd = cts.toDate();
          ctd = ctd.subtract(Duration(
              hours: ctd.hour,
              minutes: ctd.minute,
              seconds: ctd.second,
              microseconds: ctd.microsecond,
              milliseconds: ctd.millisecond));
          print('line 1027: $itd $ctd');
          if (itd.millisecondsSinceEpoch != ctd.millisecondsSinceEpoch) {
            continue;
          }
          if (obj['disciplineName'] != item['disciplineName']) {
            continue;
          }

          if (obj['dates']['shiftDateInfo']['shiftCode'] != item['shiftCode']) {
            continue;
          }

          woDocumentId = documentId;
          asmWorkOrderId = obj['asmWorkOrderId'];
          print(
              'line 1533: ${obj['clientId']} ${obj['shiftCode']}  ${obj['dates']['shiftDateInfo']['shiftDate']}');
          break;
        }
      });
      print('line 1537: $asmWorkOrderId $documentId $woDocumentId');

      if (asmWorkOrderId == -1) {
        return 'ERROR: No shift found to confirm.';
      }
      if (obj['quoteId'] != null && obj['quoteId'] == '99') {
        isSLGenerated = true;
        slGeneratedWorkOrderId = obj['orderId'];
      }
      WriteBatch batch = db.batch();
      final docRefz = await db.collection('ClientWorkOrder').doc(documentId);
      batch.update(docRefz, {
        'shiftStatus': 'Closed',
        'woWorkOrderId': documentId,
      });
      final docRef1 =
          await db.collection('ClientWorkOrderCampaign').doc(item['id']);
      print('line 1554 ${item['id']}');
      batch.update(docRef1, {
        'shiftStatus': "Confirmed",
        'shiftConfirmed': data['shiftConfirmed'],
        'shiftConfirmedActionDate': myTimeStamp,
        'shiftStatusDate': myTimeStamp,
        'workOrderId': woDocumentId
      }); //closed
      // await FirebaseFirestore.instance
      //     .collection("ClientWorkOrderCampaign")
      //     .doc(item['id'])
      //     .update({
      //   'shiftStatus': data['shiftStatus'],
      //   'shiftConfirmed': data['shiftConfirmed'],
      //   'shiftConfirmedActionDate': myTimeStamp,
      //   'shiftStatusDate': myTimeStamp
      // });
      print(
          'line 1572 ${item['clientId']} ${data['shiftStatus']} ${item['shiftCode']}');
      int shiftCount = 0;
      int shiftScheduleCount = -1;
      int orderId = 0;
      //903a
      final docRef3 =
          await db.collection('ClientWorkOrderCampaign').doc(item['id']);
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('clientId', isEqualTo: item['clientId'])
          .where('uuid', isEqualTo: item['clientWorkOrderUuid'])
          .where('shiftStatus', isEqualTo: 'Open')
          .where('dates.shiftDateInfo.shiftCode', isEqualTo: item['shiftCode'])
          .get()
          .then((querySnapshot) async {
        shiftScheduleCount = querySnapshot.docs.length;
        for (var docSnapshot in querySnapshot.docs) {
          woDocumentId = docSnapshot.id;
          var obj = docSnapshot.data();
          if (obj['disciplineName'] != item['disciplineName']) {
            continue;
          }
          print('line 1595: ${obj['dates']} ');
          print('line 1596: ${obj['dates']['shiftDateInfo']}');
          print(
              'line 1598: $nt1s ${obj['dates']['shiftDateInfo']['shiftDate']}');
          Timestamp tss =
              obj['dates']['shiftDateInfo']['shiftDate'] as Timestamp;
          shiftCount = obj['dates']['rates']['rateDetails']['shiftCount'];
          print(
              'line 1603: ${tss.millisecondsSinceEpoch} ${ntt.millisecondsSinceEpoch - 15 * 60 * 1000}');
          if (tss.millisecondsSinceEpoch < nt1s.millisecondsSinceEpoch) {
            print('line 1605: $tss $nt1s');
            //920a
            // if (obj['dates']['shiftDateInfo']['shiftCode'] == '3' ||
            //     obj['dates']['shiftDateInfo']['shiftCode'] == 'AP') {
            //   nt = nt.subtract(Duration(days: 1));
            //   Timestamp nds = Timestamp.fromDate(nt);
            //   if (nds.millisecondsSinceEpoch !=
            //       tss.millisecondsSinceEpoch) {
            continue;
          } else {
            //928b
            // } else {
            //   continue;
            // }
            //  }

            print('line 1621: $nt');

            workOrderId = obj['workOrderId'];
            clientWorkOrderUUid = obj['uuid'];
            asmWorkOrderId = obj['asmWorkOrderId'];
            obj['orderId'] = obj['asmWorkOrderId'];
            orderId = obj['orderId'];
            print('line 1628: $workOrderId $clientWorkOrderUUid');
            break;
          } //940c
        }
      });
      item['asmWorkOrderId'] = asmWorkOrderId;
      print(
          'line 1554: $asmWorkOrderId $woDocumentId $workOrderId $clientWorkOrderUUid');

      if (woDocumentId != null) {
        List<dynamic> listDocIds = [];

        if (shiftScheduleCount == -1) {
          print('line 1649 no Work Orders but an acceptance request.');
          throw Exception('No Work Orders but an acceptance request');
        }
        if (shiftScheduleCount > 0) {
          //984a
          print('line 1654: ${item['clientWorkOrderUuid']}');
        }
      } else {
        throw Exception('line 1686 should not be able to get here');
      }
      print('line 1688: ${item['id']}');
      // int x = 0;
      // if (x == 0) {
      //   throw Exception('line 1108 debug');
      // }
      bool bl1 = await htc.insertHCPTimeCard(item, batch);
      if (bl1 == false) {
        throw Exception('line 1695 unable to insert a time card');
      }
      print('line 1697 $bl1');
      Map<String, dynamic>? client =
          await clientServices.getClient(item['clientId']);
      if (client!.isEmpty) {
        throw Exception('line 1701 failed to get client record');
      }
      item['clientLatitude'] = client['latitude'];
      item['clientLongitude'] = -client['longitude'];
      var doc_id = null;
      print('line 1708 $bl1 $workOrderId ${item['clientWorkOrderUuid']}');
      int departmentId = 0;
      int disciplineId = 0;
      String disciplineName = '';
      String shiftCode = '';
      double payRate = 0.0;
      double payRateWE = 0.0;
      double billRate = 0.0;
      double billRateWE = 0.0;
      bool orientation = false;
      String startTime = '';
      String endTime = '';
      String shiftDate = '';
      DateFormat formatter = DateFormat('MM-dd-yyyy');
      int meals = 0;
      bool? overrideRates;
      print('line 1724: $workOrderId');
      await FirebaseFirestore.instance
          .collection('ClientHCPWorkOrder')
          .where('workOrderId', isEqualTo: workOrderId)
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          print('line 1731 check');
          doc_id = docSnapshot.id;
          Map<String, dynamic> obj = docSnapshot.data();
          print('line 1734: ${obj}');
          print('line 1735: ${obj['disciplineId']} ${obj['disciplineName']}');
          departmentId = obj['departmentId'] as int;
          disciplineId = obj['disciplineId'][0] as int;
          disciplineName = obj['disciplineName'][0] as String;
          shiftCode = obj['shiftCode'];
          payRate = double.parse(obj['payRate'].toString());
          payRateWE = double.parse(obj['payRateWE'].toString());
          billRate = double.parse(obj['billRate'].toString());
          billRateWE = double.parse(obj['billRateWE'].toString());
          orientation = obj['orientation'];
          startTime = obj['startTime'];
          endTime = obj['endTime'];
          hcpId = item['hcpId'];
          meals = obj['meals'];
          orderId = orderId;
          asmWorkOrderId = asmWorkOrderId;
          overrideRates = obj['overrideRates'] == true;
          shiftDate = formatter.format(obj['shiftDate'].toDate());
          break;
        }
      });
      print('line 1756 $doc_id, ${item['id']}');

      final docRef5 = await db.collection('ClientHCPWorkOrder').doc(doc_id);
      batch.update(docRef5, {
        'clientWorkOrderCampaignId': item['id'],
        'hcpId': item['hcpId'],
        'hcpName': item['hcpName'],
        'woWorkOrderId': woDocumentId,
        'order': orderId,
        'asmWorkOrderId': asmWorkOrderId,
        "statusId": 'S',
        'statusDate': Timestamp.fromDate(DateTime.now())
      });

      print('line 1770: $workOrderId $woDocumentId');
      batch.update(docRef3, {
        'workOrderId': workOrderId,
        'woWorkOrderId': woDocumentId,
      });

      print('line 1776');
      final docRef6 = await db.collection('ClientWorkOrder').doc(woDocumentId);
      batch.update(docRef6, {
        'clientHCPWorkOrderId': doc_id,
        'workOrderId': workOrderId,
        'orderId': asmWorkOrderId,
        'woWorkOrderId': woDocumentId,
        'hcpId': item['hcpId'],
        'hcpName': item['hcpName'],
      });
      batch.commit();

      //write the asm data
      String dts = utilitiesServices.convertFromTimestamp(item['shiftDate']);
      String dte = item['startTime'];

      asmWO = {
        "Conf_Emp": true,
        "Conf_Emp_Date": dts,
        "Conf_Emp_Time": item['endTime'],
        "Conf_Emp_Note": "Confirmed",
        "Conf_Cli": true,
        "Conf_Cli_Date": dts,
        "Conf_Cli_Time": item['startTime'],
        "Conf_Cli_Note": "Confirmed"
      };
      print('line 1806: $asmWorkOrderId, $asmWO');
      //step 1 book shift

      dynamic result = await callBookShiftFunction(
          asmWorkOrderId.toString(), item['hcpId'].toString(), ctx);
      print('line 1811: $result $asmWorkOrderId $hcpId');
      if (result == null || result.contains("ERROR") == true) {
        return result;
      }
      print('line 1815 check $result');
      asmHCPTimeCardId = int.parse(result);
      print('line 1817: $asmHCPTimeCardId, $result');
      //step 2 confirm shift
      var rdata = {"OrderID": asmWorkOrderId, "asmWO": asmWO};
      dynamic rslt = await callASMWOFunction(rdata, ctx);
      print('line 1821 : $rslt ${item['hcpId']} $hcpId');
      if (rslt == null || rslt.contains("Unsuccessful") == true) {
        print('line 1823 error');
        return rslt;
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        print('line 1827 Hello, confirmed after 100 milliseconds of delay');
      });
      DateTime dtm = item['shiftDate'].toDate();
      dtm = dtm.subtract(Duration(
          hours: dtm.hour,
          minutes: dtm.minute,
          seconds: dtm.second,
          microseconds: dtm.microsecond,
          milliseconds: dtm.millisecond));
      Timestamp nowTm = Timestamp.fromDate(dtm);
      print('line 1837: $asmHCPTimeCardId, ${item['shiftCode']} ${nowTm}');
      print('line 1838: ${item['clientId']} ${item['hcpId']}');
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('clientId', isEqualTo: item['clientId'])
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('shiftCode', isEqualTo: item['shiftCode'])
          .get()
          .then((querySnapshot) async {
        var docId;
        bool flatGotHit = false;
        print('line 1848 ${querySnapshot.docs.length}');
        if (querySnapshot.docs.length == 0) {
          throw Exception('line 1212 htptimecard does not exist yet');
        }
        for (var docSnapshot in querySnapshot.docs) {
          docId = docSnapshot.id;
          print('line 1854 $docId');
          Map<String, dynamic> obj = docSnapshot.data();
          print('line 1856: ${obj}');
          Timestamp shiftDate = obj['shiftDate'];
          DateTime shiftDateTime = shiftDate.toDate();
          shiftDateTime = shiftDateTime.subtract(Duration(
              hours: shiftDateTime.hour,
              minutes: shiftDateTime.minute,
              seconds: shiftDateTime.second,
              microseconds: shiftDateTime.microsecond,
              milliseconds: shiftDateTime.millisecond));
          shiftDate = Timestamp.fromDate(shiftDateTime);
          print('line 1866: ${dtm} ${shiftDateTime}');
          print(
              'line 1868 ${nowTm.millisecondsSinceEpoch} ${shiftDate.millisecondsSinceEpoch}');
          if (nowTm.millisecondsSinceEpoch ==
              shiftDate.millisecondsSinceEpoch) {
            print(
                'line 1872: got hit $asmHCPTimeCardId $asmWorkOrderId $docId');
            await FirebaseFirestore.instance
                .collection('HCPTimeCard')
                .doc(docId)
                .update({
              'asmWorkOrderId': asmWorkOrderId,
              'asmHCPTimeCardId': asmHCPTimeCardId
            });
            ;
          }
        }
      });

      var datae = {"OrderID": asmWorkOrderId, "asmWO": asmWO};
      dynamic rslts = await callASMWOFunction(datae, ctx);
      print('line 1893: $rslts $hcpId');
      if (rslts == null || rslts == "Unsuccessful") {
        print('line 1895 error');
        throw Exception('line 1421 exception on asm confirmation');
      }
      print('line 1898 ${asmWO}');
      Map<String, dynamic>? clc = await clientServices.getSingleClientUser(
          item['clientId'], item['clientUserId']);
      if (clc!.isEmpty) {
        print('line 1902 error getitng client user');
        return "ERROR";
      }

      print('line 1906 ${clc} ${clc['fcmToken']}');
      String fcmToken = clc['fcmToken'];
      if (fcmToken != 'PlaceHolder') {
        Timestamp ts = item['shiftDate'];
        String shiftDates = convertFromTimestamp(ts);
        String body =
            '${clc['fullName']},  ${item['hcpName']} has confirmed shift ${item['shiftCode']} for $shiftDates';
        Map<String, dynamic> parameters = {
          "title": "Shift Confirmation",
          "body": body,
          "fcmToken": fcmToken
        };

        await htc.sendSingleMessage(parameters, ctx);
        if (flagWeeklyOvertime == true) {
          return "Clean Run with weekly overtime limit reached.";
        }
        return "Clean Run";
      }
      return 'Clean Run';
    } catch (e) {
      print('line 1927 error: $e');
      int index = e.toString().indexOf('F5');
      String ee = e.toString().substring(0, index);
      return ("ERROR: ${ee}");
    }
  }

  Future<String> callBookShiftFunction(
      String OrderID, String RegID, BuildContext ctx) async {
    print('line 1936: $OrderID $RegID');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'bookShift04',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      print('line 1945 in call A  function: $callable');
      dynamic result =
          await callingBookShiftFunction(callable, OrderID, RegID, ctx);
      print('line 1948: $result');
      if (int.tryParse(result.toString()) == null) {
        throw Exception(result);
      }
      print('line 1952 ASM WORK ORDER WRITTEN');
      return result.toString();
    } catch (e) {
      print('line 1955 error : $e');
      return e.toString();
      // throw Exception('line 1168: ${e.toString()}');
    }
  }

  //more functions
  Future<String> callCreateMobileWOFunction(
      Map<String, dynamic> data, ctx) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'writemobilewo',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      print('line 1971 in call A  function: $callable');
      print('line 1972: ${data}');

      dynamic result = await callingCreateWOFunction(callable, data, ctx);
      print('line 1975 : $result');
      if (result == null) {
        return "ERROR: Null returned by function";
      }
      if (result.contains('Unsuccessful') == true) {
        print('line 1980: Error writing work order to asm');
        return result;
      }
      print('line 1983 mobile WORK ORDER WRITTEN');
      return result;
    } catch (e) {
      print('line 1986: $e');
      return "ERROR: ${e.toString()}";
      // throw Exception('line 1168: ${e.toString()}');
    }
  }

  Future<dynamic> callingCreateWOFunction(HttpsCallable callable,
      Map<String, dynamic> asmWO, BuildContext ctx) async {
    try {
      var data = asmWO;
      final HttpsCallableResult result = await callable(data);
      print('line 1997 ${result.data}');
      return result.data.toString();
    } catch (e) {
      print('line 2000 error: $e');
      throw Exception('line 2001  ${e.toString()}');
    }
  }

  Future<String> callASMWOFunction(Map<String, dynamic> data, ctx) async {
    print('line 2006 callASMWOFunction');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'confirmWO',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      print('line 2015 in call A  function: $callable');
      dynamic result = await callingASMWOFunction(callable, data, ctx);
      print('line 2017: $result');
      if (result == null) {
        return "ERROR: Null returned by function";
      }
      if (result.contains('Unsuccessful') == true) {
        print('line 2022: Error writing work order to asm');
        return result;
      }
      print('line 2085 ASM WORK ORDER WRITTEN');
      return result;
    } catch (e) {
      print('line 2028: $e');
      return "ERROR: ${e.toString()}";
      // throw Exception('line 1168: ${e.toString()}');
    }
  }

  Future<dynamic> callingBookShiftFunction(HttpsCallable callable,
      String OrderID, String RegID, BuildContext ctx) async {
    try {
      print('line 2072 $OrderID $RegID');
      var data = {"OrderID": OrderID, "RegID": RegID};
      final HttpsCallableResult result = await callable(data);
      print('line 2075 ${result.data}');
      try {
        if (result.data is List) {
          return result.data[0];
        } else {
          if (int.tryParse(result.data) != null) {
            return result.data.toString();
          } else {
            return null;
          }
        }
      } catch (e) {
        print('line 2081 ${e.toString()}');
        return result.data[0];
      }
    } catch (e) {
      print('line 1994 error: $e');
      throw Exception('line 1995  ${e.toString()}');
    }
  }

  Future<dynamic> callingASMWOFunction(HttpsCallable callable,
      Map<String, dynamic> asmWO, BuildContext ctx) async {
    try {
      var data = asmWO;
      final HttpsCallableResult result = await callable(data);
      print('line 2095 ${result.data}');
      return result.data.toString();
    } catch (e) {
      print('line 2098 error: $e');
      throw Exception('line 2099  ${e.toString()}');
    }
  }

  Future<bool>? updateClientWorkOrderCampaignSignedIn(
      Map<String, dynamic> item, Map<String, dynamic> data) async {
    //  print('line 746: ${item['workOrderId']} $data');
    print('line 2149: ${item['tc_id']} $data');
    bool retv = false;
    DateTime currentDate = DateTime.now(); //DateTime
    currentDate = currentDate.subtract(Duration(
        hours: currentDate.hour,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        microseconds: currentDate.microsecond,
        milliseconds: currentDate.millisecond));
    try {
      print('line 2159: ${item['tc_id']}');
      await FirebaseFirestore.instance
          .collection("ClientWorkOrderCampaign")
          .doc(item['tc_id'])
          .update(data);
      print('line 2164 ok');
      retv = true;
      return retv;
    } catch (e) {
      print('line 2168 error: $e');
      throw Exception(e.toString());
    }
    return retv;
  }

  Future<bool>? updateClientWorkOrderCampaignSignedOut(
      Map<String, dynamic> item, dynamic data, String clwDocumentId) async {
    print('line 2176: ${item['id']}');
    DateTime currentDate = DateTime.now(); //DateTime
    currentDate = currentDate.subtract(Duration(
        hours: currentDate.hour,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        microseconds: currentDate.microsecond,
        milliseconds: currentDate.millisecond));
    Timestamp myTimeStamp = Timestamp.fromDate(currentDate);

    try {
      final docRef = FirebaseFirestore.instance
          .collection("ClientWorkOrderCampaign")
          .doc(clwDocumentId);
      docRef.update(data).then(
          (value) => print("line 818 DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));

      // await FirebaseFirestore.instance.collection("ClientWorkOrderCampaign")
      //             .doc(item['id']).update(data);
      print('line 2208: just before call hcptimecoard update');
      await htc.updateHCPTimeCardSignOut(item, data);
      return true;
    } catch (e) {
      print('line 2212 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>>? getSignInWorkOrderCampaignsForClient(
      int userId, String shiftStatus) async {
    print('line 2237 getsignedworkordercampaign; $userId $shiftStatus');
    //  return realm.all<ClientWorkOrderCampaign>();
    DateTime dte = DateTime.now();
    if (shiftStatus != 'Confirmed') {
      print('line 2241 continuing: $shiftStatus');
      return {};
    }
    DateTime currentDate = new DateTime.now();
    // String fmt = DateFormat.yMEd().add_jms().format(DateTime.now());
    // int adv =0;
    // print('line 647: $fmt');
    // if (fmt.contains('PM') == true) {
    //   adv = 12;
    // }
    Duration deviceDuration = currentDate.timeZoneOffset;
    int deviceOffset = deviceDuration.inHours;
    String deviceTimeZoneName = currentDate.timeZoneName;
    print('line 2254  ${currentDate} $userId');
    DateTime nt = DateTime.now();
    DateTime myDt = DateTime.now();
    Map<String, dynamic>? cw;

    try {
      //"hcpId == \$0 SORT(shiftDate ASC, shiftCode ASC)",[userId]);
      bool gotAValidShift = false;
      var obj;
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('hcpId', isEqualTo: userId)
          .where('shiftStatus', isEqualTo: shiftStatus)
          .get()
          .then((querySnapshot) async {
        print('line 2267: ${querySnapshot.docs.length}');

        for (var docSnapshot in querySnapshot.docs) {
          var doc_id = docSnapshot.id;
          obj = docSnapshot.data();
          print(
              'line 2271: $doc_id ${obj['hcpId']} ${obj['hcpName']} ${obj['shiftCode']}');
          obj['id'] = doc_id;

          Timestamp tbx = obj['shiftDate'];
          DateTime dbx = tbx.toDate();
          //  String shiftDateTmeZoneName = dbx.timeZoneName;
          //  Duration shiftDateDuration = dbx.timeZoneOffset;
          //  int shiftDateOffset = shiftDateDuration.inHours;
          //   print('line 1553: $deviceTimeZoneName $shiftDateTmeZoneName');
          //   print('line 1554: $deviceOffset $shiftDateOffset');
          dbx = dbx.subtract(Duration(
              hours: dbx.hour,
              minutes: dbx.minute,
              seconds: dbx.second,
              microseconds: dbx.microsecond,
              milliseconds: dbx.millisecond));
          DateTime myt = myDt;
          myt = myt.subtract(Duration(
              hours: myt.hour,
              minutes: myt.minute,
              seconds: myt.second,
              microseconds: myt.microsecond,
              milliseconds: myt.millisecond));
          print(
              'line 2349: ${dbx.millisecondsSinceEpoch} ${myt.millisecondsSinceEpoch}');

          int startMinutes = utilitiesServices.getMinutes(obj['startTime']);
          int endMinutes = utilitiesServices.getMinutes(obj['endTime']);
          print('line 2300: $startMinutes $endMinutes');
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
            if (myt.millisecondsSinceEpoch > dbx2.millisecondsSinceEpoch) {
              print(
                  'line 2371 did not pass time check for late shift: ${myt.millisecondsSinceEpoch} ${dbx2.millisecondsSinceEpoch}');
              continue;
            }

            if (dbx.millisecondsSinceEpoch < myt.millisecondsSinceEpoch) {
              print(
                  'line  2375 failed start time: ${dbx.millisecondsSinceEpoch} ${myt.millisecondsSinceEpoch}');
            }
          } else {
            dbx2 = dbx2.add(Duration(
                hours: 0,
                minutes: endMinutes,
                seconds: 0,
                microseconds: 0,
                milliseconds: 0));
            if (myDt.millisecondsSinceEpoch > dbx2.millisecondsSinceEpoch) {
              print(
                  'line 2384 did not pass time check for early shift: ${myt.millisecondsSinceEpoch} ${dbx2.millisecondsSinceEpoch}');

              continue;
            }
            print(
                'line 2490: ${dbx.millisecondsSinceEpoch} ${myt.millisecondsSinceEpoch}');
            if (dbx.millisecondsSinceEpoch > myDt.millisecondsSinceEpoch) {
              print(
                  'line 2389 failed start time: ${dbx.millisecondsSinceEpoch} ${myt.millisecondsSinceEpoch}');

              continue;
            }
          }
          //  we know that shift ends before the current date
          // is current time after start time

          print(
              'line 2326: ${dbx2.millisecondsSinceEpoch} ${myDt.millisecondsSinceEpoch}');
          print(
              'line 2344: $dbx ${obj['shiftCode']} ${tbx.millisecondsSinceEpoch}');
          print(
              'line 2346 ${obj['shiftDate']} ${obj['shiftCode']}, ${obj['startTime']} ${obj['endTime']}');
          print('line 2347 good $obj');
          if (authServices.clientMap == null) {
            Map<String, dynamic>? client =
                await clientServices.getClient(obj['clientId']);
            if (client!.isEmpty) {
              throw Exception('line 2199 unable to get client');
            }
            authServices.clientMap = client;
          }
          print('line 2358: $obj');
          gotAValidShift = true;
          break;

          //  }
        }
        if (gotAValidShift == true) {
          return obj;
        } else {
          return null;
        }
      });
      print('line 2449: $cw');
      if (gotAValidShift == true) {
        return obj;
      } else {
        return {};
      }
    } catch (e) {
      print('line 2366 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>>? getSignOutWorkOrderCampaignsForClient(
      int userId, String shiftStatus) async {
    print('line 2373 getsignedworkordercampaign; $userId');
    //  return realm.all<ClientWorkOrderCampaign>();
    DateTime dte = DateTime.now();

    DateTime currentDate = new DateTime.now();
    // String fmt = DateFormat.yMEd().add_jms().format(DateTime.now());
    // int adv =0;
    // print('line 647: $fmt');
    // if (fmt.contains('PM') == true) {
    //   adv = 12;
    // }

    print('line 2385:  ${currentDate}');

    DateTime myDt = DateTime.now();
//        new DateTime(currentDate.year, currentDate.month, currentDate.day);
    // Timestamp myTimeStamp1 = Timestamp.fromDate(nt);
    Map<String, dynamic> cw = {};
    //  DateTime myDt = DateTime.now();
    try {
      //"hcpId == \$0 SORT(shiftDate ASC, shiftCode ASC)",[userId]);
      print('line 2394 $shiftStatus');
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('hcpId', isEqualTo: userId)
          .where('shiftStatus', isEqualTo: shiftStatus)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var documentId = docSnapshot.id;
          var obj = docSnapshot.data();
          obj['id'] = documentId;
          print(
              'line 2406 ${obj['shiftDate']} ${obj['shiftCode']}, ${obj['startTime']} ${obj['endTime']}');

          int startMinutes = utilitiesServices.getMinutes(obj['startTime']);
          int endMinutes = utilitiesServices.getMinutes(obj['endTime']);
          Timestamp tbx = obj['shiftDate'];
          DateTime dbx = tbx.toDate();
          print('line 2412: $startMinutes $endMinutes');
          dbx = dbx.subtract(Duration(
              hours: dbx.hour,
              minutes: dbx.minute,
              seconds: dbx.second,
              microseconds: dbx.microsecond,
              milliseconds: dbx.millisecond));
          DateTime myt = myDt;
          myt = myt.subtract(Duration(
              hours: myt.hour,
              minutes: myt.minute,
              seconds: myt.second,
              microseconds: myt.microsecond,
              milliseconds: myt.millisecond));

          print('line 2427: $startMinutes $endMinutes');
          DateTime dbx2 = dbx;
          DateTime hdbx = dbx;
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
                minutes: 0,
                seconds: 0,
                microseconds: 0,
                milliseconds: 0));
            if (dbx2.millisecondsSinceEpoch < myt.millisecondsSinceEpoch) {
              print('line 2445 bad date: $dbx2 $myt');
              continue;
            }
          } else {
            dbx2 = dbx2.add(Duration(
                hours: 0,
                minutes: endMinutes,
                seconds: 0,
                microseconds: 0,
                milliseconds: 0));
            DateTime ndt = DateTime.now();
            //   DateTime ldbx = dbx.subtract(Duration(minutes: 20));
            if (ndt.millisecondsSinceEpoch >= dbx2.millisecondsSinceEpoch) {
              print('line 2458 passed 1st check');
            } else {
              if (dbx.millisecondsSinceEpoch > ndt.millisecondsSinceEpoch) {
                print('line 2461 failed 1st check');
                continue;
              }
            }
          }
          print('line 2466 good $obj');
          cw = obj;
          break;
          //          }
        }
        return;
      });
      print('line 2472 $cw');
      return cw;
    } catch (e) {
      print('line 2475 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getTodaysClientWorkOrderCampaign(
      int hcpId, String shiftStatus) async {
    print('line 2558: $hcpId $shiftStatus');
    try {
      DateTime dtm = DateTime.now();
      dtm = dtm.subtract(Duration(
          hours: dtm.hour,
          minutes: dtm.minute,
          seconds: dtm.second,
          microseconds: dtm.microsecond,
          milliseconds: dtm.millisecond));
      Timestamp currentDate = Timestamp.fromDate(dtm);
      print('line 2567: $dtm $currentDate');
      Map<String, dynamic>? myData;
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftStatus', isEqualTo: shiftStatus)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          Map<String, dynamic> dates =
              getStartEndDates(obj['startTime'], obj['endTime']);
          print('line 2579: ${obj['shiftDate']} ${currentDate}');
          Timestamp tms = obj['shiftDate'] as Timestamp;
          DateTime sdt = tms.toDate();
          sdt = sdt.subtract(Duration(
              hours: sdt.hour,
              minutes: sdt.minute,
              seconds: sdt.second,
              microseconds: sdt.microsecond,
              milliseconds: sdt.millisecond));
          int startMinutes = utilitiesServices.getMinutes(obj['startTime']);
          int endMinutes = utilitiesServices.getMinutes(obj['endTime']);
          print('line 2671: $startMinutes $endMinutes');
          if (startMinutes > 720 && startMinutes > endMinutes) {
//        if (obj['shiftCode'] == '3' || obj['shiftCode'] == 'PA') {
            sdt = sdt.add(Duration(days: 1));
            print('line 2595 $sdt $dtm');
            if (sdt.millisecondsSinceEpoch < dtm.millisecondsSinceEpoch) {
              print('line 2597 date issue: $sdt $dtm');
              continue;
            }
          } else {
            DateTime xdt = sdt;
            xdt = xdt.add(Duration(minutes: endMinutes));
            if (dtm.millisecondsSinceEpoch >= xdt.millisecondsSinceEpoch) {
              print(
                  'line 2684 would have skipped: ${dtm.millisecondsSinceEpoch} ${xdt.millisecondsSinceEpoch}');
            }
          }
          print('line 2606: $obj');
          myData = obj;
          break;
        }
        return;
      });
      print('line 2694: $myData');
      return myData!;
    } catch (e) {
      print('line 2694 error: ${e.toString()}');
      throw Exception('line 2694 error: ${e.toString()}');
    }
  }

  Future<bool>? cancelHCPWorkOrderShift(
      Map<String, dynamic> item, int hcpId, BuildContext ctx) async {
    print('line 642 cancelworkordershift: ${item['id']} $hcpId');
    bool bl = true;
    String? documentId;
    DateTime currentDate = DateTime.now(); //DateTime
    Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
    Map<String, dynamic>? asmWO;
    Map<String, dynamic>? hcpWO;
    try {
      print('line 648 ${item['workOrderId']}');

      //reopen shift
      String? workOrderId;
      int? asmWorkOrderId;
      String? woWorkOrderId;
      String? clientHCPWorkOrderId;
      String? hcpTimeCardId;
      Map<String, dynamic>? hcpProf;
      await FirebaseFirestore.instance
          .collection("ClientWorkOrderCampaign")
          .doc(item['id'])
          .get()
          .then((querySnapshot) async {
        var docSnapshot = querySnapshot.data();
        hcpProf = docSnapshot;
      });
      hcpProf = {
        'shiftStatus': 'Canceled',
        'clientWorkOrderUuid': null,
        'shiftStatusDate': Timestamp.fromDate(DateTime.now()),
        'shiftAccepted': false,
        'shiftAcceptedActionDate': null,
        'shiftApprovedBy': null,
        'shiftCanceled': true,
        'shiftCanceledById': 0,
        'shiftCanceledNote': null,
        'shiftCancellationCodeId': 0,
        'shiftCancellationNote': null,
        'shiftCancelledActionDate': null,
        'shiftConfirmed': false,
        'shiftConfirmedActionDate': null,
        'woWorkOrderId': null,
      };
      print('line 1018 $hcpProf');
      FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .doc(item['id'])
          .set(hcpProf!, SetOptions(merge: true));
      asmWO = {};
      //asmWO['asmWorkOrderId'] = 0;
      asmWO['hcpId'] = 0;
      asmWO['hcpName'] = null;
      asmWO['shiftStatus'] = 'Open';
      print('line 1028');
      await FirebaseFirestore.instance
          .collection("ClientWorkOrder")
          .doc(item['woWorkOrderId'])
          .get()
          .then((querySnapshot) async {
        var wobj = querySnapshot.data();
        print('line 1035: $wobj');
        clientHCPWorkOrderId = wobj!['clientHCPWorkOrderId'];
        asmWorkOrderId = wobj['asmWorkOrderId'];
        await FirebaseFirestore.instance
            .collection("ClientWorkOrder")
            .doc(item['woWorkOrderId'])
            .set(asmWO!, SetOptions(merge: true));
      });
      print('line 1041: ${item['id']} $asmWorkOrderId');
      item['asmWorkOrderId'] = asmWorkOrderId;
      Map<String, dynamic> st = {
        "asmWorkOrderId": asmWorkOrderId,
      };
      await FirebaseFirestore.instance
          .collection("ClientWorkOrderCampaign")
          .doc(item['id'])
          .set(st, SetOptions(merge: true));
      print('line 697: $asmWO');
      hcpWO = {};
      hcpWO['hcpId'] = 0;
      hcpWO['hcpName'] = null;
      hcpWO['statusId'] = 'O';
      hcpWO['statusDate'] = Timestamp.fromDate(DateTime.now());
      print('line 1058: ${clientHCPWorkOrderId}');
      await FirebaseFirestore.instance
          .collection("ClientHCPWorkOrder")
          .doc(clientHCPWorkOrderId)
          .set(hcpWO, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('shiftStatus', isEqualTo: 'Confirmed')
          .where('shiftCode', isEqualTo: item['shiftCode'])
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          hcpTimeCardId = docSnapshot.id;
          Timestamp ts1 = item['shiftDate'];
          Timestamp ts2 = obj['shiftDate'];
          DateTime ds1 = ts1.toDate();
          DateTime ds2 = ts2.toDate();
          ds1 = ds1.subtract(Duration(
              hours: ds1.hour,
              minutes: ds1.minute,
              seconds: ds1.second,
              microseconds: ds1.microsecond,
              milliseconds: ds1.millisecond));
          ds2 = ds2.subtract(Duration(
              hours: ds2.hour,
              minutes: ds2.minute,
              seconds: ds2.second,
              microseconds: ds2.microsecond,
              milliseconds: ds2.millisecond));
          if (ds1.millisecondsSinceEpoch == ds2.millisecondsSinceEpoch) {
            hcpTimeCardId = docSnapshot.id;
            break;
          }
        }
      });
      print('line 686: $hcpTimeCardId $workOrderId $woWorkOrderId');
      final db = FirebaseFirestore.instance;
      WriteBatch batch = db.batch();
      final docRefa = FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .doc(woWorkOrderId);
      batch.set(
          docRefa,
          {
            "shiftStatus": "Closed",
            "shiftStatusDate": Timestamp.fromDate(DateTime.now())
          },
          SetOptions(merge: true));
      print('line 697: ${woWorkOrderId}');
      final docRefb = FirebaseFirestore.instance
          .collection('ClientHCPWorkOrder')
          .doc(clientHCPWorkOrderId);
      batch.set(
          docRefb,
          {"statusId": "E", "statusDate": Timestamp.fromDate(DateTime.now())},
          SetOptions(merge: true));
      final docRefc = db.collection('HCPTimeCard').doc(hcpTimeCardId);
      batch.delete(docRefc);

      //ClientWorkOrderCampaign
      print('line 715');
      final docRefd = FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .doc(item['id']);
      batch.set(
          docRefd,
          {
            'shiftStatus': 'Canceled',
            'shiftCanceledNote': item['shiftCanceledNote'],
            'shiftCancellationCode': item['shiftCancellationCodeId'],
            'shiftCancellationCodeId': item['cancelReasonCodeId'],
            'shiftStatusDate': Timestamp.fromDate(DateTime.now()),
            'shiftCanceled': true,
            'shiftConfirmed': false,
            'shiftCanceledById': hcpId,
            'shiftCanceledByName': item['hcpName'],
            'shiftCancellationNote': item['shiftCancellationNote'],
            'shiftCancelledActionDate': myTimeStamp
          },
          SetOptions(merge: true));
      return true;
      //ClientWorkOrder
      // print('line 786: ${item['shiftCancellationCodeId']}');
      // bool bl = await htc.callCancelWO(
      //     asmWorkOrderId.toString(), shiftCancellationMap, ctx);
      // if (bl == false) {
      //   print('line 759 error canceling shift');
      //   throw Exception('Error on canceling shift');
      // }
      // Uuid uuid = Uuid();
      // String und = uuid.v4();
      // asmWO!['uuid'] = und;
      // asmWO!['workOrderId'] = und;
      // bool? bll = await createMobileWOFunction(asmWO!);
      // if (bll! == false) {
      //   throw Exception('Unable to create Work order for a cancellation');
      // }
      // String? cid;
      // FirebaseFirestore.instance
      //     .collection('ClientWorkOrder')
      //     .where('workOrderId', isEqualTo: und)
      //     .get()
      //     .then((querySnapshot) async {
      //   for (var docSnapshot in querySnapshot.docs) {
      //     cid = docSnapshot.id;
      //     break;
      //   }
      //   FirebaseFirestore.instance
      //       .collection('ClientWorkOrder')
      //       .doc(cid)
      //       .update({'woWorkOrderId': cid});
      //   hcpWO!['woWorkOrderId'] = cid;
      //   hcpWO!['workOrderId'] = und;
      //   hcpWO!['uuid'] = und;
      //   hcpWO!['statusId'] = 'O';
      //   FirebaseFirestore.instance
      //       .collection('ClientHCPWorkOrder')
      //       .doc()
      //       .set(hcpWO!);
      // });
      // print('line 820');
      // // Map<String, dynamic>? clc = await clientServices.getSingleClientUser(
      // //     item['clientId'], 'ClientScheduler');
      // // if (clc!.isEmpty) {
      // //   throw Exception(('line 780 unable to get client record'));
      // // }
      // return true;
    } catch (e) {
      print('line 1210 $e');
      if (e.toString().toLowerCase().contains('debug') == true) {
        return true;
      }
      return false;
    }
  }
}
