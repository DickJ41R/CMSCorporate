import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import 'package:client_app/models/hcp_models/hcp_timecard.dart';
import 'dart:core';
import 'package:cms_web/features/shared/services/hcpapp/hcp_timecard_service.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:intl/intl.dart';

//import 'package:client_app/models/client_models/client_user.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';

class ClientWorkOrderCampaignService {
//  late int clientId;
  ClientWorkOrderCampaignService();

  static final _staticVariable = null;

  UtilitiesServices utilitiesServices = UtilitiesServices();
  ClientServices clientServices = ClientServices();
  HCPTimeCardService htc = HCPTimeCardService();
  AuthService authServices = AuthService();

  Future<List<Map<String, dynamic>>>? getClientASMHCPWorkOrdersAll(
      int clientId) async {
    debugPrint('line 22 getallitemsfrom clienthcpwo; $clientId');
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

      debugPrint('line 120: in getallworkorders');
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
      debugPrint('line 153 get cmp all ${listOfCWOMap.length}');
      listOfCWOMap.sort((a, b) {
        debugPrint('line 155: ${a['shiftDate']}');
        int sd = a['shiftDate'].compareTo(b['shiftDate']);
        if (sd == 0) {
          return a['shiftCode'].compareTo(b['shiftCode']); // '-' for descending
        }
        return sd;
      });
      return listOfCWOMap;
    } catch (e) {
      debugPrint('line 164 in get all clienthcpwos: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsAll(
      int hcpId) async {
    debugPrint('line 16 getallitems; $hcpId');
    //  return realm.all<ClientWorkOrderCampaign>();

    DateTime time = DateTime.now();
    int timestamp = time.millisecondsSinceEpoch;
    debugPrint('line 21 tiemstamp $timestamp');
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
          //     debugPrint('line 45: ${lh['shiftDate']} ${lw['shiftDate']}');
          //      debugPrint('line 46: ${lh['shiftCode']} ${lw['shiftCode']}');
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
    debugPrint('line 38 get cmp all ${listOfCWOMap.length}');

    return listOfCWOMap;
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsAllOpenAccepted(
      int hcpId) async {
    debugPrint('line 74 get all not accepted; $hcpId');
    //  return realm.all<ClientWorkOrderCampaign>();

    DateTime currentDate = DateTime.now(); //DateTime
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour + 24,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        milliseconds: currentDate.millisecond,
        microseconds: currentDate.microsecond));
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);
    debugPrint('line 81: ${newDate.timeZoneName} ${newDate.timeZoneOffset}');
    debugPrint('line 82: $newDate $myTimeStamp');
    List<Map<String, dynamic>> listOfCWOMap = [];
    await FirebaseFirestore.instance
        .collection('ClientWorkOrderCampaign')
        .where('hcpId', isEqualTo: hcpId)
        .where('shiftDate', isGreaterThanOrEqualTo: myTimeStamp)
        .where('shiftStatus', whereIn: ['Open','Accepted'])
        .orderBy("shiftDate", descending: false)
        .orderBy("shiftCode", descending: false)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        var doc_id = docSnapshot.id;
        var obj = docSnapshot.data();
        obj['id'] = doc_id;
        debugPrint(
            'line 97: $doc_id ${obj['id']} ${obj['shiftCode']} ${obj['shiftDate']}');
        listOfCWOMap.add(obj);
      }
    });
    return listOfCWOMap;
  }

  // Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsAccepted(
  //     int hcpId) async {
  //   debugPrint('line 99 accept shift $hcpId');
  //   //  return realm.all<ClientWorkOrderCampaign>();
  //   DateTime currentDate = DateTime.now(); //DateTime
  //   DateTime newDate = currentDate.subtract(Duration(
  //       hours: currentDate.hour + 24,
  //       minutes: currentDate.minute,
  //       seconds: currentDate.second,
  //       milliseconds: currentDate.millisecond,
  //       microseconds: currentDate.microsecond));
  //   Timestamp myTimeStamp = Timestamp.fromDate(newDate);
  //
  //   List<Map<String, dynamic>> listOfCWOMap = [];
  //   await FirebaseFirestore.instance
  //       .collection('ClientWorkOrderCampaign')
  //       .where('hcpId', isEqualTo: hcpId)
  //       .where('shiftDate', isGreaterThanOrEqualTo: myTimeStamp)
  //       .where('shiftStatus', isEqualTo: 'Accepted')
  //       .orderBy("shiftDate", descending: false)
  //       .orderBy("hcpId", descending: false)
  //       .orderBy("shiftCode", descending: false)
  //       .get()
  //       .then((querySnapshot) {
  //     for (var docSnapshot in querySnapshot.docs) {
  //       var doc_id = docSnapshot.id;
  //       debugPrint('line 249: doc_id: $doc_id');
  //       var obj = docSnapshot.data();
  //       obj['id'] = doc_id;
  //       listOfCWOMap.add(obj);
  //     }
  //     return listOfCWOMap;
  //   });
  //   debugPrint('line 255: ${listOfCWOMap.length}');
  //   if (listOfCWOMap.length > 0) {
  //     Map<String, dynamic> mp = listOfCWOMap[0];
  //     debugPrint('line 258: ${mp['id']}');
  //   }
  //   return listOfCWOMap;
  // }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsApprovedConfirmed(
      int clientId) async {
    debugPrint('line 623 in getworkordersconfirmed $clientId');
    DateTime currentDate = DateTime.now(); //DateTime
    Timestamp curDateTime = Timestamp.fromDate(currentDate);
    int weekDay = currentDate.weekday;
    int sdays = weekDay - 1;
    Map<String, dynamic>? tvs;
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        milliseconds: currentDate.millisecond,
        microseconds: currentDate.microsecond));
    DateTime firstDate = newDate.subtract(Duration(days: sdays));
    Timestamp fds = Timestamp.fromDate(firstDate);
    DateTime lastDate = newDate.add(Duration(days: 8 - weekDay));
    Timestamp eds = Timestamp.fromDate(lastDate);
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);
    debugPrint('line 654: $firstDate $fds');
    debugPrint('line 655 $lastDate $eds');
    // String fmt = DateFormat.yMEd().add_jms().format(DateTime.now());
    // int adv =0;
    // debugPrint('line 647: $fmt');
    // if (fmt.contains('PM') == true) {
    //   adv = 12;
    // }
    int hours = currentDate.hour;
    hours *= 60;
    int minutes = currentDate.minute;
    int hoursMinutes = hours + minutes;
    hoursMinutes *= 60;
    List<Map<String, dynamic>> clientOT = [];
    bool flagHaveAnOvertime = false;
    List<int> listOfHcps = [];
    List<Map<String, dynamic>> listOfHCPCWOs = [];
    List<List<Map<String, dynamic>>> listOfCWOs = [];
    try {
      List<Map<String, dynamic>> listOfCWOMap = [];
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('clientId', isEqualTo: clientId)
          .where('shiftStatus', whereIn: ['Approved','Confirmed'])
          .where('shiftDate', isGreaterThanOrEqualTo: fds)
          .where('shiftDate', isLessThan: eds)
          .orderBy('shiftStatus', descending: false)
          .orderBy('shiftDate', descending: false)
          .get()
          .then((querySnapshot) async {
            debugPrint('line 313: ${querySnapshot.docs.length}');
            for (var docSnapshot in querySnapshot.docs) {
              var doc_id = docSnapshot.id;
              var obj = docSnapshot.data();
              obj['id'] = doc_id;
              int index = listOfHcps.indexOf(obj['hcpId']);
              if (index == -1) {
                listOfHcps.add(obj['hcpId']);
                listOfHCPCWOs.add(obj);
                listOfCWOs.add(listOfHCPCWOs);
              } else {
                List<Map<String, dynamic>> listh = listOfCWOs[index];
                listh.add(obj);
                listOfCWOs[index] = listh;
              }
            }
          });
      if (listOfHcps.length == 0) {
        return [];
        throw Exception('Error: no client selected hcps for  found');
      }
      //now get hcps for nonclient
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('clientId', isNotEqualTo: clientId)
          .where('hcpId', whereIn: listOfHcps)
          .where('shiftStatus', whereIn: ['Approved','Confirmed'])
          .where('shiftDate', isGreaterThanOrEqualTo: fds)
          .where('shiftDate', isLessThan: eds)
          .orderBy('shiftStatus', descending: false)
          .orderBy('shiftDate', descending: false)
          .get()
          .then((querySnapshot) async {
            debugPrint('line 345: ${querySnapshot.docs.length}');
            for (var docSnapshot in querySnapshot.docs) {
              var doc_id = docSnapshot.id;
              var obj = docSnapshot.data();
              obj['shiftCreatedDate'] = obj['shiftCreatedDate'] == null
                  ? obj['createdDate']
                  : obj['shiftCreatedDate'];
              obj['id'] = doc_id;
              int z = 0;
              int hcpId = obj['hcpId'];
              int index = listOfHcps.indexOf(hcpId);
              if (index == -1) {
                throw Exception('Error: Index must always exist');
              }
              List<Map<String, dynamic>> listh = listOfCWOs[index];
              listh.add(obj);
              listOfCWOs[index] = listh;
            }
          });
      debugPrint('line 361: ${listOfCWOs.length} ${listOfCWOs[0].length}');
      int x = 0;

      int totalWeeklyMinutes = 0;

      int sDiff = 0;
      int sMin = 0;
      int eMin = 0;

      debugPrint('line 697 debug check');
      for (int h = 0; h < listOfCWOs.length; h++) {
        listOfCWOMap = listOfCWOs[h];
        for (int i = 0; i < listOfCWOMap.length; i++) {
          var obj = listOfCWOMap[i];

            sMin = utilitiesServices.getMinutes(obj['startTime']);
            eMin = utilitiesServices.getMinutes(obj['endTime']);
            sDiff = utilitiesServices.calculateShiftHours(
                sMin, eMin, obj['startTime'], obj['endTime'], obj['meals']);
            debugPrint('line 697 debug check: $sDiff');
            if (sDiff == -1) {
              continue;
            }
            totalWeeklyMinutes += sDiff;
        }
        debugPrint('line 716 $totalWeeklyMinutes');
        int overtimeMinutes = 0;
        int regularMinutes = 0;
        if (totalWeeklyMinutes > 2400) {
          overtimeMinutes = totalWeeklyMinutes - 2400;
          regularMinutes = 2400;
        } else {
          regularMinutes = totalWeeklyMinutes;
        }
        debugPrint('line 369: $totalWeeklyMinutes $overtimeMinutes $regularMinutes');
        listOfCWOMap.sort(
            (a, b) => b['shiftCreatedDate'].compareTo(a['shiftCreatedDate']));
        for (int i = 0; i < listOfCWOMap.length; i++) {
          var obj = listOfCWOMap[i];
          sMin = utilitiesServices.getMinutes(obj['startTime']);
          eMin = utilitiesServices.getMinutes(obj['endTime']);
          sDiff = utilitiesServices.calculateShiftHours(
              sMin, eMin, obj['startTime'], obj['endTime'], obj['meals']);
          debugPrint('line 378: $i ${obj['clientId']} ${obj['shiftCreatedDate']}');
          debugPrint('line 379: $sDiff $overtimeMinutes');
          if (overtimeMinutes > 0) {
            if (overtimeMinutes >= sDiff) {
              listOfCWOMap[i]['otMinutes'] = sDiff;
              listOfCWOMap[i]['regularMinutes'] = 0;
              overtimeMinutes -= sDiff;
              listOfCWOMap[i]['requireOvertime'] = true;
              listOfCWOMap[i]['shiftOvertime'] = true;
            } else {
              listOfCWOMap[i]['otMinutes'] = overtimeMinutes;
              listOfCWOMap[i]['regularMinutes'] = sDiff - overtimeMinutes;
              listOfCWOMap[i]['requireOvertime'] = true;
              listOfCWOMap[i]['shiftOvertime'] = true;
              overtimeMinutes = 0;
            }
          } else {
            listOfCWOMap[i]['otMinutes'] = 0;
            listOfCWOMap[i]['regularMinutes'] = sDiff;
            listOfCWOMap[i]['requireOvertime'] = false;
            listOfCWOMap[i]['shiftOvertime'] = false;
          }
        }
        int q = 0;
        while (q < listOfCWOMap.length) {
          if (listOfCWOMap[q]['clientId'] != clientId) {
            listOfCWOMap.removeAt(q);
            q = 0;
            continue;
          }
          q += 1;
        }
        listOfCWOs[h] = listOfCWOMap;
      }
      List<Map<String, dynamic>> lmp = [];
      for (int i = 0; i < listOfCWOs.length; i++) {
        listOfCWOMap = listOfCWOs[i];
        for (int j = 0; j < listOfCWOMap.length; j++) {
          lmp.add(listOfCWOMap[j]);
        }
      }
      return lmp;
    } catch (e) {
      debugPrint('line 779 error $e');
      throw Exception(e.toString());
    }
  }
  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsSignedInSignedOut(
      int clientId) async {
    debugPrint('line 623 in getworkordersconfirmed $clientId');
    DateTime currentDate = DateTime.now(); //DateTime
    Timestamp curDateTime = Timestamp.fromDate(currentDate);
    int weekDay = currentDate.weekday;
    int sdays = weekDay - 1;
    Map<String, dynamic>? tvs;
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        milliseconds: currentDate.millisecond,
        microseconds: currentDate.microsecond));
    DateTime firstDate = newDate.subtract(Duration(days: sdays));
    Timestamp fds = Timestamp.fromDate(firstDate);
    DateTime lastDate = newDate.add(Duration(days: 8 - weekDay));
    Timestamp eds = Timestamp.fromDate(lastDate);
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);
    debugPrint('line 654: $firstDate $fds');
    debugPrint('line 655 $lastDate $eds');
    // String fmt = DateFormat.yMEd().add_jms().format(DateTime.now());
    // int adv =0;
    // debugPrint('line 647: $fmt');
    // if (fmt.contains('PM') == true) {
    //   adv = 12;
    // }
    int hours = currentDate.hour;
    hours *= 60;
    int minutes = currentDate.minute;
    int hoursMinutes = hours + minutes;
    hoursMinutes *= 60;
    List<Map<String, dynamic>> clientOT = [];
    bool flagHaveAnOvertime = false;
    List<int> listOfHcps = [];
    List<Map<String, dynamic>> listOfHCPCWOs = [];
    List<List<Map<String, dynamic>>> listOfCWOs = [];
    try {
      List<Map<String, dynamic>> listOfCWOMap = [];
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('clientId', isEqualTo: clientId)
          .where('shiftStatus', whereIn: ['SignedIn','SignedOut'])
          .where('shiftDate', isGreaterThanOrEqualTo: fds)
          .where('shiftDate', isLessThan: eds)
          .orderBy('shiftStatus', descending: false)
          .orderBy('shiftDate', descending: false)
          .get()
          .then((querySnapshot) async {
        debugPrint('line 313: ${querySnapshot.docs.length}');
        for (var docSnapshot in querySnapshot.docs) {
          var doc_id = docSnapshot.id;
          var obj = docSnapshot.data();
          obj['id'] = doc_id;
          int index = listOfHcps.indexOf(obj['hcpId']);
          if (index == -1) {
            listOfHcps.add(obj['hcpId']);
            listOfHCPCWOs.add(obj);
            listOfCWOs.add(listOfHCPCWOs);
          } else {
            List<Map<String, dynamic>> listh = listOfCWOs[index];
            listh.add(obj);
            listOfCWOs[index] = listh;
          }
        }
      });
      if (listOfHcps.length == 0) {
        return [];
        throw Exception('Error: no client selected hcps for  found');
      }
      //now get hcps for nonclient
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('clientId', isNotEqualTo: clientId)
          .where('hcpId', whereIn: listOfHcps)
          .where('shiftStatus', whereIn: ['SignedIn','SignedOut'])
          .where('shiftDate', isGreaterThanOrEqualTo: fds)
          .where('shiftDate', isLessThan: eds)
          .orderBy('shiftStatus', descending: false)
          .orderBy('shiftDate', descending: false)
          .get()
          .then((querySnapshot) async {
        debugPrint('line 345: ${querySnapshot.docs.length}');
        for (var docSnapshot in querySnapshot.docs) {
          var doc_id = docSnapshot.id;
          var obj = docSnapshot.data();
          obj['shiftCreatedDate'] = obj['shiftCreatedDate'] == null
              ? obj['createdDate']
              : obj['shiftCreatedDate'];
          obj['id'] = doc_id;
          int z = 0;
          int hcpId = obj['hcpId'];
          int index = listOfHcps.indexOf(hcpId);
          if (index == -1) {
            throw Exception('Error: Index must always exist');
          }
          List<Map<String, dynamic>> listh = listOfCWOs[index];
          listh.add(obj);
          listOfCWOs[index] = listh;
        }
      });
      debugPrint('line 361: ${listOfCWOs.length} ${listOfCWOs[0].length}');
      int x = 0;

      int totalWeeklyMinutes = 0;

      int sDiff = 0;
      int sMin = 0;
      int eMin = 0;

      debugPrint('line 697 debug check');
      for (int h = 0; h < listOfCWOs.length; h++) {
        listOfCWOMap = listOfCWOs[h];
        for (int i = 0; i < listOfCWOMap.length; i++) {
          var obj = listOfCWOMap[i];

          sMin = utilitiesServices.getMinutes(obj['startTime']);
          eMin = utilitiesServices.getMinutes(obj['endTime']);
          sDiff = utilitiesServices.calculateShiftHours(
              sMin, eMin, obj['startTime'], obj['endTime'], obj['meals']);
          debugPrint('line 697 debug check: $sDiff');
          if (sDiff == -1) {
            continue;
          }
          totalWeeklyMinutes += sDiff;
        }
        debugPrint('line 716 $totalWeeklyMinutes');
        int overtimeMinutes = 0;
        int regularMinutes = 0;
        if (totalWeeklyMinutes > 2400) {
          overtimeMinutes = totalWeeklyMinutes - 2400;
          regularMinutes = 2400;
        } else {
          regularMinutes = totalWeeklyMinutes;
        }
        debugPrint('line 369: $totalWeeklyMinutes $overtimeMinutes $regularMinutes');
        listOfCWOMap.sort(
                (a, b) => b['shiftCreatedDate'].compareTo(a['shiftCreatedDate']));
        for (int i = 0; i < listOfCWOMap.length; i++) {
          var obj = listOfCWOMap[i];
          sMin = utilitiesServices.getMinutes(obj['startTime']);
          eMin = utilitiesServices.getMinutes(obj['endTime']);
          sDiff = utilitiesServices.calculateShiftHours(
              sMin, eMin, obj['startTime'], obj['endTime'], obj['meals']);
          debugPrint('line 378: $i ${obj['clientId']} ${obj['shiftCreatedDate']}');
          debugPrint('line 379: $sDiff $overtimeMinutes');
          if (overtimeMinutes > 0) {
            if (overtimeMinutes >= sDiff) {
              listOfCWOMap[i]['otMinutes'] = sDiff;
              listOfCWOMap[i]['regularMinutes'] = 0;
              overtimeMinutes -= sDiff;
              listOfCWOMap[i]['requireOvertime'] = true;
              listOfCWOMap[i]['shiftOvertime'] = true;
            } else {
              listOfCWOMap[i]['otMinutes'] = overtimeMinutes;
              listOfCWOMap[i]['regularMinutes'] = sDiff - overtimeMinutes;
              listOfCWOMap[i]['requireOvertime'] = true;
              listOfCWOMap[i]['shiftOvertime'] = true;
              overtimeMinutes = 0;
            }
          } else {
            listOfCWOMap[i]['otMinutes'] = 0;
            listOfCWOMap[i]['regularMinutes'] = sDiff;
            listOfCWOMap[i]['requireOvertime'] = false;
            listOfCWOMap[i]['shiftOvertime'] = false;
          }
        }
        int q = 0;
        while (q < listOfCWOMap.length) {
          if (listOfCWOMap[q]['clientId'] != clientId) {
            listOfCWOMap.removeAt(q);
            q = 0;
            continue;
          }
          q += 1;
        }
        listOfCWOs[h] = listOfCWOMap;
      }
      List<Map<String, dynamic>> lmp = [];
      for (int i = 0; i < listOfCWOs.length; i++) {
        listOfCWOMap = listOfCWOs[i];
        for (int j = 0; j < listOfCWOMap.length; j++) {
          lmp.add(listOfCWOMap[j]);
        }
      }
      return lmp;
    } catch (e) {
      debugPrint('line 779 error $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsConfirmedLegacy(
      int clientId) async {
    debugPrint('line 460 in getworkordercampain confirmed $clientId');
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
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          var doc_id = docSnapshot.id;
          var obj = docSnapshot.data();
          debugPrint('line 158: $obj');
          obj['id'] = doc_id;
          int hcpId = obj['hcpId'];
          Timestamp ts = obj['shiftDate'];
          DateTime dts = ts.toDate();
          dts = dts.subtract(Duration(
              hours: dts.hour,
              minutes: dts.minute,
              seconds: dts.second,
              microseconds: dts.microsecond,
              milliseconds: dts.millisecond));
          int? totalMinutes = await getClosedClientWorkOrders(hcpId, dts);
          debugPrint('line 1381: $totalMinutes');
          int totalOTMinutes = totalMinutes!;
          debugPrint('line 1386: ${totalOTMinutes}');
          obj['requiresOvertime'] = false;
          obj['shiftOvertime'] = false;
          debugPrint('line 1400 check');
          //   List<int> sTimes = getHoursAndMinutes(obj['startTime']);
          int startMinutes = utilitiesServices.getMinutes(obj['startTime']);
          int endMinutes = utilitiesServices.getMinutes(obj['endTime']);

          int sDiff = utilitiesServices.calculateShiftHours(startMinutes,
              endMinutes, obj['startTime'], obj['endTime'], obj['meals']);
          if (sDiff == -1) {
            throw Exception('line 1397: Invalid shift times');
          }
          debugPrint('line 1265: $sDiff $startMinutes $endMinutes');
          //    List<int> eTimes = getHoursAndMinutes(obj['endTime']);
          //     if (startMinutes >= 720 && startMinutes > endMinutes) {
          //       eTimes[0] += 24;
          //     }
          int cMinutes = totalOTMinutes % 60;
          int cHours = totalOTMinutes ~/ 60;
          int shiftPriorHours = totalOTMinutes;
          debugPrint('line 1445: $shiftPriorHours');
          String sMinutes = cMinutes.toString();
          if (sMinutes.length == 1) {
            sMinutes = '0' + sMinutes;
          }
          String sTime = cHours.toString() + ":" + sMinutes;
          debugPrint('line 1422: ${cHours} ${sMinutes}');

          if (sDiff + totalOTMinutes > 2400) {
            obj['requiresOvertime'] = true;
            obj['shiftPriorHoursString'] = sTime;
            obj['shiftOvertime'] = true;
            obj['shiftPriorHours'] = shiftPriorHours;
          } else {
            obj['requiresOvertime'] = false;
            obj['shiftOvertime'] = false;
            obj['shiftPriorHoursString'] = '0.0';
            obj['shiftPriorHours'] = 0;
          }
          debugPrint(
              'line 1466: ${obj['shiftPriorHours']} ${obj['requiresOvertime']} $sTime ${obj['shiftPriorHoursString']} ${obj['shiftOvertime']}');

          listOfCWOMap.add(obj);
        }
      });
      return listOfCWOMap;
    } catch (e) {
      debugPrint('line 164 error $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getWorkOrderCampaignsApproved(
      int hcpId, clientId) async {
    //List<Map<String,dynamic>> mapData = [];
    debugPrint('line 165 in get approved by $hcpId');
    List<Map<String, dynamic>> listC = [];
    DateTime currentDate = DateTime.now(); //DateTime
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        milliseconds: currentDate.millisecond,
        microseconds: currentDate.microsecond));
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);
    debugPrint('line 171: $newDate ${myTimeStamp}');
    await FirebaseFirestore.instance
        .collection('ClientWorkOrderCampaign')
        .where('hcpId', isEqualTo: hcpId)
        .where('clientId', isEqualTo: clientId)
        .where('shiftDate', isGreaterThanOrEqualTo: myTimeStamp)
        .where('shiftStatus', isEqualTo: 'Approved')
        .orderBy("shiftDate", descending: false)
        .orderBy("hcpId", descending: false)
        .orderBy("shiftCode", descending: false)
        .get()
        .then((querySnapshot) {
      //  List<Map<String, dynamic>>mapData = [];
      for (var docSnapshot in querySnapshot.docs) {
        var doc_id = docSnapshot.id;
        var obj = docSnapshot.data();
        obj['id'] = doc_id;

        //  Map<String, dynamic> obj = docSnapshot.data();
        //   ClientWorkOrderCampaign cwn = ClientWorkOrderCampaign.fromFirestore(
        //       docSnapshot, null);
        listC.add(obj);
        debugPrint('line 90 ${listC.length}');
      }
    });
    debugPrint('ine 193: ${listC.length}');
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
    debugPrint('line 371 cancelworkordershift: $shiftcanceledNote');
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
      debugPrint('line 387 error: $e');
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
      debugPrint('line 503: $newStartDate $endDate');
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
      debugPrint('line 502 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>>? getSingleWorkOrderCampaignsForClient(
      int userId, String shiftStatus) async {
    debugPrint('line 440 getallitems; $userId');
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
    debugPrint('line 454: $currentDate $newDate');
    debugPrint('line 455: $myTimeStamp $myTimeStamp1');
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
          debugPrint('line 467: ${obj['shiftDate']} $myTimeStamp $myTimeStamp1');
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
        debugPrint('line 482: $cw');
        return cw;
      });
      debugPrint('line 485: $cw');
      return cw;
    } catch (e) {
      debugPrint('line 488 error: $e');
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
    debugPrint('line 614 update approved: ${item['id']}');
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
        'payRate': item['payRate'],
        'newBillRate': ['itemNewBillRate'],
        'flagWillOweOT': item['flagWillOweOT'],
        'totalPay': item['totalPay']
      });
      debugPrint('line 635 shift approved');
      Future.delayed(const Duration(seconds: 1), () {
        debugPrint('Hello, after 1 seconds of delay');
      });
      debugPrint('line 639: ${item['clientId']}');
      Map<String, dynamic>? clc = await clientServices.getSingleClientUser(
          item['clientId'], item['clientUserId']);
      if (clc!.isEmpty) {
        debugPrint('line 900 clc is empty');
        return false;
      }
      debugPrint('line 903: ${item['hcpId']}');
      Map<String, dynamic>? usc =
          await clientServices.getSingleHCPUser(item['hcpId']);
      if (usc!.isEmpty) {
        debugPrint('line 905 usc is empty');
        return false;
      }
      if (clc.isEmpty) {
        debugPrint('line 1293 did not get clientuser record');
        return true;
      }
      debugPrint('line 911: ${usc}');
      List<String> listOfTokens = [];
      if (usc['iosFcmToken'] != null && usc['iosFcmToken'] != 'Placeholder') {
        listOfTokens.add(usc['iosFcmToken']);
      }
      if (usc['iosFcmTabletToken'] != null &&
          usc['iosFcmTabletToken'] != 'Placeholder') {
        if (listOfTokens.indexOf(usc['iosFcmTabletToken']) == -1) {
          listOfTokens.add(usc['iosFcmTabletToken']);
        }
      }
      if (usc['androidFcmToken'] != null &&
          usc['androidFcmToken'] != 'Placeholder') {
        listOfTokens.add(usc['androidFcmToken']);
      }
      if (usc['androidFcmTabletToken'] != null &&
          usc['androidFcmTabletToken'] != 'Placeholder') {
        if (listOfTokens.indexOf(usc['androidFcmTabletToken']) == -1) {
          listOfTokens.add(usc['androidFcmTabletToken']);
        }
      }
      debugPrint('line 923: $listOfTokens');
      if (listOfTokens.length > 0) {
        Timestamp ts = item['shiftDate'];
        String shiftDate = convertFromTimestamp(ts);
        String body =
            '${clc['fullName']} has approved shift ${item['shiftCode']} for $shiftDate';
        for (int z = 0; z < listOfTokens.length; z++) {
          String fcmToken = listOfTokens[z];
          debugPrint('line 1301: $fcmToken ${body}');
          Map<String, dynamic> parameters = {
            "title": "Shift Approval",
            "body": body,
            "fcmToken": fcmToken
          };
          debugPrint('line 663 ${parameters}');
          await htc.sendSingleMessage(parameters, ctx);
        }
      }

      return true;
    } catch (e) {
      debugPrint('line 953 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<bool>? updateClientWorkOrderCampaignDeclined(Map<String, dynamic> item,
      String shiftApprover, String clientEmail, BuildContext ctx) async {
    debugPrint('line 612 update shift declined: ${item['id']} $shiftApprover');
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
      debugPrint('line 633 shift declined ${authServices.clientId!}');
      Map<String, dynamic>? clc =
          await clientServices.getSingleUserFromEmail(clientEmail);
      if (clc!.isEmpty) {
        return false;
      }
      debugPrint('line 983 debug: ${item['hcpId']}');
      Map<String, dynamic>? usc =
          await clientServices.getSingleHCPUser(item['hcpId']);
      if (usc!.isEmpty) {
        return false;
      }
      debugPrint('line 571: ${clc}');

      Timestamp ts = item['shiftDate'];
      String shiftDate = convertFromTimestamp(ts);
      debugPrint('line 575 just before body creation');
      List<String> listOfTokens = [];
      if (usc['iosFcmToken'] != null && usc['iosFcmToken'] != 'Placeholder') {
        listOfTokens.add(usc['iosFcmToken']);
      }
      if (usc['iosFcmTabletToken'] != null &&
          usc['iosFcmTabletToken'] != 'Placeholder') {
        if (listOfTokens.indexOf(usc['iosFcmTabletToken']) == -1) {
          listOfTokens.add(usc['iosFcmTabletToken']);
        }
      }
      if (usc['androidFcmToken'] != null &&
          usc['androidFcmToken'] != 'Placeholder') {
        listOfTokens.add(usc['androidFcmToken']);
      }
      if (usc['androidFcmTabletToken'] != null &&
          usc['androidFcmTabletToken'] != 'Placeholder') {
        if (listOfTokens.indexOf(usc['androidFcmTabletToken']) == -1) {
          listOfTokens.add(usc['androidFcmTabletToken']);
        }
      }
      debugPrint('line 1623: $listOfTokens');
      if (listOfTokens.length > 0) {
        Timestamp ts = item['shiftDate'];
        String shiftDate = convertFromTimestamp(ts);
        String body =
            '${clc['fullName']},  ${clc['hcpName']} has declined shift ${item['shiftCode']} for $shiftDate';
        debugPrint('line 1301: $listOfTokens ${body}');
        Map<String, dynamic> parameters = {
          "title": "Shift Acceptance",
          "body": body,
          "fcmTokens": listOfTokens
        };
        await htc.sendSingleMessage(parameters, ctx);
      }

      return true;
    } catch (e) {
      debugPrint('line 636 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderRepublishShifts(
      int clientId) async {
    debugPrint('line 633 shifts; $clientId');
    //  return realm.all<ClientWorkOrderCampaign>();
    DateTime currentDate = DateTime.now(); //DateTime
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        microseconds: currentDate.microsecond,
        milliseconds: currentDate.millisecond));
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);
    debugPrint('line 687: $myTimeStamp $newDate ');
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
        debugPrint('line 949: ${querySnapshot.docs.length}');
        for (var docSnapshot in querySnapshot.docs) {
          var doc_id = docSnapshot.id;
          debugPrint('line 958: $doc_id');
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
                    debugPrint('line 1011: $dnw $pnw');
                    if (dnw.millisecondsSinceEpoch ==
                        pnw.millisecondsSinceEpoch) {
                      flagIsDuplicate = true;
                      debugPrint('line 1014 have a dup');
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
        debugPrint('line 836 ${listOfCWOMap.length}');
        return listOfCWOMap;
      });
      return listOfCWOMap;
    } catch (e) {
      debugPrint('line 841 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCancelShifts(
      int clientId) async {
    debugPrint('line 633 shifts; $clientId');
    //  return realm.all<ClientWorkOrderCampaign>();
    DateTime currentDate = DateTime.now(); //DateTime
    DateTime newDate = currentDate.subtract(Duration(
        hours: currentDate.hour,
        minutes: currentDate.minute,
        seconds: currentDate.second,
        microseconds: currentDate.microsecond,
        milliseconds: currentDate.millisecond));
    Timestamp myTimeStamp = Timestamp.fromDate(newDate);
    debugPrint('line 687: $myTimeStamp $newDate ');
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
        debugPrint('line 949: ${querySnapshot.docs.length}');
        for (var docSnapshot in querySnapshot.docs) {
          var doc_id = docSnapshot.id;
          debugPrint('line 958: $doc_id');
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
        debugPrint('line 972: ${listOfCWOMap.length} ${listHCPWorkOrderIds.length}');
        if (listHCPWorkOrderIds.length > 0) {
          for (int i = 0; i < listHCPWorkOrderIds.length; i++) {
            String workOrderId = listHCPWorkOrderIds[i];
            debugPrint('line 1012: $workOrderId');
            await FirebaseFirestore.instance
                .collection('ClientWorkOrderCampaign')
                .where('woWorkOrderId', isEqualTo: workOrderId)
                .get()
                .then((querySnapshot) async {
              for (var docSnapshot in querySnapshot.docs) {
                Map<String, dynamic>? hcpCpg = docSnapshot.data();
                debugPrint('line 1018: ${hcpCpg}');
                debugPrint('line 1019: ${hcpCpg['shiftStatus']}');
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

        debugPrint('line 836 ${listOfCWOMap.length}');
        return listOfCWOMap;
      });
      return listOfCWOMap;
    } catch (e) {
      debugPrint('line 841 error: $e');
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
      debugPrint('line 1214 error: ${e.toString()}');
      throw Exception('line 1215 ${e.toString()}');
    }
  }

  //FIRST DAY OF THE WEEK
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

  Future<int>? getClosedClientWorkOrders(int hcpId, DateTime newDate) async {
    debugPrint('line 1214: getclosedworkorders: $hcpId $newDate');
    try {
      int totalOTMinutes = 0;
      int cday = newDate.weekday;
      int sday = 0;
      int eday = 6;
      int subDays = 0;
      int addDays = 0;
      if (cday > 1) {
        subDays = cday - 1;
        addDays = 7 - cday;
      }
      DateTime startDate = newDate;
      int meals = 30;
      startDate = startDate.subtract(Duration(
          hours: startDate.hour,
          minutes: startDate.minute,
          seconds: startDate.second,
          microseconds: startDate.microsecond,
          milliseconds: startDate.millisecond));
      startDate = startDate.subtract(Duration(days: subDays));
      DateTime endDate = newDate;
      endDate = endDate.subtract(Duration(
          hours: endDate.hour,
          minutes: endDate.minute,
          seconds: endDate.second,
          microseconds: endDate.microsecond,
          milliseconds: endDate.millisecond));
      endDate = endDate.add(Duration(days: addDays));
      int totalMinutes = 0;
      List<Map<String, dynamic>> listClosedShifts = [];
      debugPrint('line 1204: $newDate $startDate $endDate');
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftStatus', isEqualTo: 'Closed')
          .get()
          .then((querySnapshot) async {
        debugPrint('line 1200: ${querySnapshot.docs.length}');
        if (querySnapshot.docs.length > 0) {
          for (var docSnapShot in querySnapshot.docs) {
            var obj = docSnapShot.data();
            int? sMin;
            int? eMin;
            String? objStartTime;
            String? objEndTime;
            Timestamp? ts;
            if (obj['dates'] != null) {
              objStartTime = obj['dates']['rates']['rateDetails']['startTime'];
              objEndTime = obj['dates']['rates']['rateDetails']['endTime'];
              sMin = utilitiesServices.getMinutes(objStartTime!);
              eMin = utilitiesServices.getMinutes(objEndTime!);
              meals = obj['dates']['rates']['rateDetails']['meals'];
              ts = obj['dates']['shiftDateInfo']['shiftDate'];
            } else {
              objStartTime = obj['startTime'];
              objEndTime = obj['endTime'];
              meals = obj['meals'];
              sMin = utilitiesServices.getMinutes(objStartTime!);
              eMin = utilitiesServices.getMinutes(objEndTime!);
              ts = obj['shiftDate'];
            }
            DateTime shiftDate = ts!.toDate();
            debugPrint('line 1230 ${shiftDate} ${newDate}');
            debugPrint(
                'line 1231 ${shiftDate.millisecondsSinceEpoch} ${newDate.millisecondsSinceEpoch}');

            if (shiftDate.millisecondsSinceEpoch <
                    startDate.millisecondsSinceEpoch ||
                shiftDate.millisecondsSinceEpoch >
                    endDate.millisecondsSinceEpoch) {
              continue;
            }
            if (shiftDate.millisecondsSinceEpoch ==
                newDate.millisecondsSinceEpoch) {
              continue;
            }
            if (shiftDate.millisecondsSinceEpoch >
                newDate.millisecondsSinceEpoch) {
              continue;
            }
            // if (sMin > eMin) {
            //   eMin += 1440;
            // }
            //  totalOTMinutes += (eMin - sMin);
            int tl = utilitiesServices.calculateShiftHours(
                sMin, eMin, objStartTime, objEndTime, meals);
            debugPrint('line 1288: $tl');
            if (tl == -1) {
              throw Exception('line 1290: Invalid shfift time');
            }
            totalMinutes += tl;
            // DateTime tsd = ts!.toDate();
            // tsd = tsd.subtract(Duration(
            //     hours: tsd.hour,
            //     minutes: tsd.minute,
            //     seconds: tsd.second,
            //     microseconds: tsd.microsecond,
            //     milliseconds: tsd.millisecond));
            // if (tsd.millisecondsSinceEpoch < newDate.millisecondsSinceEpoch) {
            //   continue;
            // }
            //       bool flagSkip = false;
            //       Map<String, dynamic>? sbj;
            //       DateTime? stt;
            //       debugPrint('line 1225 ${listClosedShifts.length}');
            //       if (listClosedShifts.length > 0) {
            //         for (int j = 0; j < listClosedShifts.length; j++) {
            //           sbj = listClosedShifts[j];
            //           Timestamp? sts;
            //           if (sbj['dates'] != null) {
            //             sts = sbj['dates']['shiftDateInfo']['shiftDate'];
            //           } else {
            //             sts = sbj['shiftDate'];
            //           }
            //           stt = sts!.toDate();
            //           stt = stt.subtract(Duration(
            //               hours: stt.hour,
            //               minutes: stt.minute,
            //               seconds: stt.second,
            //               microseconds: stt.microsecond,
            //               milliseconds: stt.millisecond));
            //           if (stt.millisecondsSinceEpoch ==
            //               shiftDate.millisecondsSinceEpoch) {
            //             if (sbj['dates'] != null) {
            //               if (sbj['dates']['shiftDateInfo']['shiftCode'] ==
            //                   obj['dates']['shiftDateInfo']['shiftCode']) {
            //                 sbj['calculatedShiftCount'] += 1;
            //                 listClosedShifts[j] = sbj;
            //                 flagSkip = true;
            //                 break;
            //               }
            //             } else {
            //               if (sbj['shiftCode'] == obj['shiftCode']) {
            //                 sbj['calculatedShiftCount'] += 1;
            //                 listClosedShifts[j] = sbj;
            //                 flagSkip = true;
            //                 break;
            //               }
            //             }
            //           }
            //         }
            //       } else {
            //         debugPrint('line 1319');
            //         Map<String, dynamic> sbj = Map.from(obj);
            //         sbj['calculatedShiftCount'] = 1;
            //         sbj['shiftDate'] = shiftDate;
            //         if (obj['dates'] != null) {
            //           sbj['shiftCount'] = obj['dates']['shiftDateInfo']['shiftCount'];
            //           sbj['shiftCode'] = obj['dates']['shiftDateInfo']['shiftCode'];
            //         } else {
            //           sbj['shiftCount'] = obj['shiftCount'];
            //           sbj['shiftCode'] = obj['shiftCode'];
            //         }
            //         debugPrint('line 1330');
            //         listClosedShifts.add(sbj);
            //       }
            //     }
            //
            //     listClosedShifts[0]['totalOTMinutes'] = totalOTMinutes;
            //   }
            //   return listClosedShifts;
            // });
          }
        }
      });
      debugPrint('line 1378: $totalMinutes');
      return totalMinutes;
    } catch (e) {
      debugPrint('line 1342: ${e.toString()}');
      throw Exception('line 1254 in closed cwos');
    }
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsAllHCPOpenShifts(
      int hcpId) async {
    debugPrint('line 1192 get accepted shifts; $hcpId');
    //  return realm.all<ClientWorkOrderCampaign>();
    List<Map<String, dynamic>> listOfCWOMap = [];

    try {
      List<Map<String, dynamic>>? listClosedShifts;
      List<Map<String, dynamic>> lookUpShifts = [];
      bool flagSkip = false;
      int totalOTMinutes = 0;
      DateTime dnow = DateTime.now();
      dnow = dnow.subtract(Duration(
          hours: dnow.hour,
          minutes: dnow.minute,
          seconds: dnow.second,
          microseconds: dnow.microsecond,
          milliseconds: dnow.millisecond));
      Timestamp dnows = Timestamp.fromDate(dnow);
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftStatus', isEqualTo: 'Open')
          .where('shiftDate', isGreaterThanOrEqualTo: dnows)
          .orderBy("shiftDate", descending: false)
          .orderBy("hcpId", descending: false)
          .orderBy("shiftCode", descending: false)
          .get()
          .then((querySnapshot) async {
            //   int count = 0;
            debugPrint('line 1389 ${querySnapshot.docs.length}');
            if (querySnapshot.docs.length > 0) {
              for (var docSnapShot in querySnapshot.docs) {
                String doc_id = docSnapShot.id;
                var obj = docSnapShot.data();
                debugPrint('line 1633 ${obj}');
                obj['id'] = doc_id;
                int hcpId = obj['hcpId'];
                Timestamp ts = obj['shiftDate'];
                DateTime dts = ts.toDate();
                dts = dts.subtract(Duration(
                    hours: dts.hour,
                    minutes: dts.minute,
                    seconds: dts.second,
                    microseconds: dts.microsecond,
                    milliseconds: dts.millisecond));

                int min = utilitiesServices.getMinutes(obj['endTime']);
                debugPrint('line 1636: $min');
                dts = dts.add(Duration(minutes: min));
                Timestamp tsm = Timestamp.fromDate(dts);
                //get current time
                DateTime currentDate = DateTime.now(); //DateTime
                Timestamp esm = Timestamp.fromDate(currentDate);

                if (esm.millisecondsSinceEpoch > tsm.millisecondsSinceEpoch) {
                  continue;
                }

                int shiftDay = obj['dayValue'];
                double shiftPriorMinutes = obj['shiftPriorHours'] * 60;
                if (shiftPriorMinutes - 2400 > 0) {
                  obj['shiftOvertime'] = true;
                  obj['otMinutes'] = (shiftPriorMinutes - 2400);
                  obj['requiresOvertime'] = true;
                  obj['shiftPriorHoursString'] =
                      obj['shiftPriorHours'].toString();
                } else {
                  obj['shiftOvertime'] = false;
                  obj['otMinutes'] = 0.0;
                  obj['requiresOvertime'] = false;
                  obj['shiftOvertime'] = false;
                  obj['shiftPriorHoursString'] = '0.0';
                }
                debugPrint('line 1679 check: ${obj}');
                //   List<int> sTimes = getHoursAndMinutes(obj['startTime']);
                // int startMinutes =
                //     utilitiesServices.getMinutes(obj['startTime']);
                // int endMinutes = utilitiesServices.getMinutes(obj['endTime']);

                // int sDiff = utilitiesServices.calculateShiftHours(startMinutes,
                //     endMinutes, obj['startTime'], obj['endTime'], obj['meals']);
                //    List<int> eTimes = getHoursAndMinutes(obj['endTime']);
                //     if (startMinutes >= 720 && startMinutes > endMinutes) {
                //       eTimes[0] += 24;
                //     }
                // int cMinutes = totalOTMinutes % 60;
                // int cHours = totalOTMinutes ~/ 60;
                // int shiftPriorHours = totalOTMinutes;
                // debugPrint('line 1445: $shiftPriorHours');
                // String sMinutes = cMinutes.toString();
                // if (sMinutes.length == 1) {
                //   sMinutes = '0' + sMinutes;
                // }
                // String sTime = cHours.toString() + ":" + sMinutes;
                // debugPrint('line 1422: ${cHours} ${sMinutes}');
                //
                // if (sDiff + totalOTMinutes > 2400) {
                //   obj['requiresOvertime'] = true;
                //   obj['shiftPriorHoursString'] = sTime;
                //   obj['shiftOvertime'] = true;
                //   obj['shiftPriorHours'] = shiftPriorHours;
                // } else {

                //}
                // debugPrint(
                //     'line 1466: ${obj['shiftPriorHours']} ${obj['requiresOvertime']} $sTime ${obj['shiftPriorHoursString']} ${obj['shiftOvertime']}');
                listOfCWOMap.add(obj);
              }
            }
          });
      debugPrint('line 1412 : ${listOfCWOMap.length}');
      return listOfCWOMap;
    } catch (e) {
      debugPrint('line 1415 error: $e');
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
      debugPrint('line 1291 in call A  function: $callable');
      dynamic result = await htc.callingUploadTimesheetFromStorageFunction(
          callable, '916029', '04102025223261timesheet.pdf', ctx);
      debugPrint('line 1294: $result');
      return result;
    } catch (e) {
      debugPrint('line 1297: $e');
      throw Exception('line 1298: ${e.toString()}');
    }
  }

  Future<int> checkForPotentialOT(Map<String, dynamic> item) async {
    debugPrint('line 1721 in checkforpotential ot');
    try {
      int potentialOTMinutes = 0;
      DateTime cdt = DateTime.now();
      Timestamp cdts = Timestamp.fromDate(cdt);

      DateTime sed = item['shiftDate'].toDate();

      int shiftDay = sed.weekday;
      int sMin = utilitiesServices.getMinutes(item['startTime']);
      int eMin = utilitiesServices.getMinutes(item['endTime']);
      if (sMin > eMin) {
        eMin += 1440;
      }
      int shiftMinutes = eMin - sMin;
      int diffDay = shiftDay - 1; //eg
      item['shiftCreatedDate'] = item['shiftCreatedDate'] == null
          ? item['createdDate']
          : item['shiftCreatedDate'];
      DateTime scrdt = item['shiftCreatedDate'].toDate();
      int scrdtmin = scrdt.millisecondsSinceEpoch;
      debugPrint('line 1738: $scrdtmin $shiftMinutes');
      DateTime shiftDate = sed.subtract(Duration(
        hours: sed.hour,
        minutes: sed.minute,
        seconds: sed.second,
        microseconds: sed.microsecond,
        milliseconds: sed.millisecond,
      ));

      DateTime tx = shiftDate.subtract(Duration(days: diffDay));
      int stmps = tx.millisecondsSinceEpoch;
      await FirebaseFirestore.instance
          .collection('HCPWeeklyShift')
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('startOfWorkWeekTimestamp', isEqualTo: stmps)
          .get()
          .then((querySnapshot) async {
        debugPrint('line 1484: ${querySnapshot.docs.length}');
        if (querySnapshot.docs.length > 0) {
          var docSnapshot = querySnapshot.docs[0];
          var obj = docSnapshot.data();
          obj['id'] = docSnapshot.id;
          debugPrint('line 1490: ${obj['cumulativePriorMinutes']}');
          if (obj['cumulativePriorMinutes'] + shiftMinutes > 2400) {
            List<dynamic> listCreatedDates = obj['listOfCreatedDateTimestamps'];
            listCreatedDates.sort((a, b) {
              return b['createdDateTimestamp']
                  .compareTo(a['createdDateTimestamp']);
            });
            debugPrint('line 1497: ${listCreatedDates.length}');
            for (int i = 0; i < listCreatedDates.length; i++) {
              var tbj = listCreatedDates[i];
              debugPrint('line 1500: ${tbj['createdDateTimestamp']}');
              int dtms = int.parse(tbj['createdDateTimestamp'].toString());
              if (dtms >= scrdtmin) {
                continue;
              }
              debugPrint('line 1505: $dtms $scrdtmin');
              List<dynamic> listOfClients = tbj['listOfClients'];
              for (int j = 0; j < listOfClients.length; j++) {
                var cbj = listOfClients[j];
                debugPrint('line 1509 check');
                List<dynamic> listOfWorkShiftDays = cbj['listOfWorkShiftDays'];
                List<dynamic>? listOfShifts;
                debugPrint('line 1512 check ${listOfWorkShiftDays.length}');
                for (int k = 0; k < listOfWorkShiftDays.length; k++) {
                  var lbj = listOfWorkShiftDays[k];
                  listOfShifts = lbj['listOfShifts'];
                  if (listOfShifts == null) {
                    continue;
                  }
                  for (int l = 0; l < listOfShifts.length; l++) {
                    var shift = listOfShifts[l];
                    potentialOTMinutes +=
                        int.parse(shift['shiftMinutes'].toString());
                  }
                }
              }
            }
          }
        }
      });

      debugPrint('line 1808: $potentialOTMinutes');
      return potentialOTMinutes;
    } catch (e) {
      debugPrint('line 1804: error ${e.toString()}');
      throw Exception('line 1532 error: ${e.toString()}');
    }
  }

  Future<int> clearHCPWeeklyData(int hcpId, Timestamp shiftDate) async {
    debugPrint('line 1535 in clearHCPWeeklyShiftData');
    try {
      String? documentId;
      DateTime dtm = shiftDate.toDate();
      int weekDay = dtm.weekday;
      int shiftDay = weekDay - 1;
      DateTime sde = dtm;
      if (shiftDay > 0) {
        sde = sde.subtract(Duration(days: shiftDay));
      }
      sde = sde.subtract(Duration(
          hours: sde.hour,
          minutes: sde.minute,
          seconds: sde.second,
          microseconds: sde.microsecond,
          milliseconds: sde.millisecond));
      int stsm = sde.millisecondsSinceEpoch;
      await FirebaseFirestore.instance
          .collection('HCPWeeklyShift')
          .where('hcpId', isEqualTo: hcpId)
          .where('startOfWorkWeekTimestamp', isEqualTo: stsm)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.docs.length == 0) {
          return stsm;
        }
        var snapShot = querySnapshot.docs[0];
        documentId = snapShot.id;
        await FirebaseFirestore.instance
            .collection('HCPWeeklyShift')
            .doc(documentId)
            .delete();
      });
      return stsm;
    } catch (e) {
      debugPrint('line 1571: error ${e.toString()}');
      throw Exception('line 1540 error: ${e.toString()}');
    }
  }

  // Future<bool> recalculateHCPWeeklyShift(int hcpId, int stsm) async {
  //   debugPrint('line 1850 in recalculatedhcpweeklyshift');
  //   Timestamp sday = Timestamp.fromMillisecondsSinceEpoch(stsm);
  //   DateTime sdtm = sday.toDate();
  //   DateTime edtm = sdtm.add(Duration(days: 6));
  //   debugPrint('line 1581: $sdtm $edtm');
  //   final db = FirebaseFirestore.instance;
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('HCPTimeCard')
  //         .where('hcpId', isEqualTo: hcpId)
  //         .where('shiftStatus', whereIn: ['Confirmed', 'SignedIn', 'SignedOut'])
  //         .orderBy('shiftCreatedDate', descending: false)
  //         .orderBy('shiftCode', descending: false)
  //         .get()
  //         .then((querySnapshot) async {
  //           if (querySnapshot.docs.length == 0) {
  //             debugPrint('line 1576 error not documents returned');
  //             throw Exception('line 1577 Error: No CWOC documents returned');
  //           }
  //           debugPrint('line 1597: ${querySnapshot.docs.length}');
  //           for (var snapShot in querySnapshot.docs) {
  //             var obj = snapShot.data();
  //             obj['id'] = snapShot.id;
  //
  //             Timestamp stm = obj['shiftDate'];
  //             DateTime dstm = stm.toDate();
  //             dstm = dstm.subtract(Duration(
  //                 hours: dstm.hour,
  //                 minutes: dstm.minute,
  //                 seconds: dstm.second,
  //                 microseconds: dstm.microsecond,
  //                 milliseconds: dstm.millisecond));
  //             if (dstm.millisecondsSinceEpoch < stsm ||
  //                 dstm.millisecondsSinceEpoch > edtm.millisecondsSinceEpoch) {
  //               debugPrint(
  //                   'line 1593 skipping on dates: ${stsm} ${dstm.millisecondsSinceEpoch}');
  //               continue;
  //             }
  //
  //             int sMin = utilitiesServices.getMinutes(obj['shiftStartTime']);
  //             int eMin = utilitiesServices.getMinutes(obj['shiftEndTime']);
  //             if (sMin > eMin) {
  //               eMin += 1440;
  //             }
  //             debugPrint('line 1614 $sMin $eMin');
  //             int shiftMinutes = eMin - sMin;
  //             if (obj['shiftMinutes'] != null) {
  //               shiftMinutes = obj['shiftMinutes'];
  //             }
  //             debugPrint('line 1619: ${obj['clientId']} $shiftMinutes');
  //             bl1 = await insertHCPWorkOrderData(item, shiftMinutes, batch);
  //             batch.commit();
  //           }
  //         });
  //     await FirebaseFirestore.instance
  //         .collection('HCPTimeCard')
  //         .where('hcpId', isEqualTo: hcpId)
  //         .where('shiftStatus', whereIn: ['Confirmed', 'SignedIn', 'SignedOut'])
  //         .orderBy('shiftCreatedDate', descending: false)
  //         .orderBy('shiftCode', descending: false)
  //         .get()
  //         .then((querySnapshot) async {
  //           if (querySnapshot.docs.length == 0) {
  //             debugPrint('line 1576 error not documents returned');
  //             throw Exception('line 1577 Error: No CWOC documents returned');
  //           }
  //           debugPrint('line 1597: ${querySnapshot.docs.length}');
  //           for (var snapShot in querySnapshot.docs) {
  //             var obj = snapShot.data();
  //             obj['id'] = snapShot.id;
  //
  //             Timestamp stm = obj['shiftDate'];
  //             DateTime dstm = stm.toDate();
  //             dstm = dstm.subtract(Duration(
  //                 hours: dstm.hour,
  //                 minutes: dstm.minute,
  //                 seconds: dstm.second,
  //                 microseconds: dstm.microsecond,
  //                 milliseconds: dstm.millisecond));
  //             if (dstm.millisecondsSinceEpoch < stsm ||
  //                 dstm.millisecondsSinceEpoch > edtm.millisecondsSinceEpoch) {
  //               debugPrint(
  //                   'line 1593 skipping on dates: ${stsm} ${dstm.millisecondsSinceEpoch}');
  //               continue;
  //             }
  //
  //             int sMin = utilitiesServices.getMinutes(obj['shiftStartTime']);
  //             int eMin = utilitiesServices.getMinutes(obj['shiftEndTime']);
  //             if (sMin > eMin) {
  //               eMin += 1440;
  //             }
  //             debugPrint('line 1614 $sMin $eMin');
  //             int shiftMinutes = eMin - sMin;
  //             if (obj['shiftMinutes'] != null) {
  //               shiftMinutes = obj['shiftMinutes'];
  //             }
  //             debugPrint('line 1619: $shiftMinutes');
  //             await assignOTToShifts(obj);
  //             await updateHCPTimeCard(obj);
  //           }
  //         });
  //
  //     return true;
  //   } catch (e) {
  //     debugPrint('line 1628 error: ${e.toString()}');
  //     throw Exception('line 1628 error: ${e.toString()}');
  //   }
  // }

  Future<void> updateHCPTimeCard(Map<String, dynamic> item) async {
    debugPrint('line 1685 updateHCPTimeCard');
    try {
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .doc(item['id'])
          .set(item, SetOptions(merge: true));
      return;
    } catch (e) {
      debugPrint('line 1689 error: ${e.toString()}');
      throw Exception('line 1690 error: ${e.toString()}');
    }
  }

  Future<bool> assignOTToShifts(Map<String, dynamic> item) async {
    debugPrint('line 1636 assign ot to shifts');
    try {
      bool? bl1;
      DateTime cdt = DateTime.now();
      Timestamp cdts = Timestamp.fromDate(cdt);
      DateTime sed = item['shiftDate'].toDate();

      int shiftDay = sed.weekday;

      int diffDay = shiftDay - 1; //eg

      DateTime shiftDate = sed.subtract(Duration(
        hours: sed.hour,
        minutes: sed.minute,
        seconds: sed.second,
        microseconds: sed.microsecond,
        milliseconds: sed.millisecond,
      ));
      DateTime tx = shiftDate.subtract(Duration(days: diffDay));
      int stmps = tx.millisecondsSinceEpoch;
      int shiftPosition = 0;
      switch (item['shiftCode']) {
        case '1':
          shiftPosition = 0;
          break;
        case '2':
          shiftPosition = 1;
          break;
        case '3':
          shiftPosition = 2;
          break;
        case 'AP':
          shiftPosition = 3;
          break;
        case 'PA':
          shiftPosition = 4;
      }
      int shiftMinutes = 0;
      if (item['shiftMinutes'] != null) {
        shiftMinutes = item['shiftMinutes'];
      }
      if (shiftMinutes == 0) {
        return true;
      }
      int minmod = shiftMinutes % 60;
      double dblmod =
          double.parse(((minmod.toDouble()) / 60.0).toStringAsFixed(2));
      double shrs =
          double.parse(((shiftMinutes.toDouble()) / 60.0).toStringAsFixed(2));
      item['shiftCreatedDate'] = item['shiftCreatedDate'] == null
          ? item['createdDate']
          : item['shiftCreatedDate'];

      debugPrint('line 2022: $shiftMinutes $shrs ${item['shiftCreatedDate']}');
      Timestamp crt = item['shiftCreatedDate'];
      DateTime crtd = crt.toDate();
      int createdDateTimestamp = crtd.millisecondsSinceEpoch;
      String? documentId;
      debugPrint('line 2027 ${item['hcpId']} $stmps ${createdDateTimestamp}');
      await FirebaseFirestore.instance
          .collection('HCPWeeklyShift')
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('startOfWorkWeekTimestamp', isEqualTo: stmps)
          .get()
          .then((querySnapshot) async {
        debugPrint('line 2034: ${querySnapshot.docs.length}');
        if (querySnapshot.docs.length == 0) {
          throw Exception('Line 2036 no HCPWeeklyShifts returned from query');
        }
        var docSnapshot = querySnapshot.docs[0];
        documentId = docSnapshot.id;
        var obj = docSnapshot.data();
        debugPrint('line 2041: $obj');
        obj['id'] = docSnapshot.id;
        if (obj['cumulativePriorMinutes'] <= obj['baseMinutes']) {
          debugPrint('line 2044 skipping on minutes');
          return true;
        }
        debugPrint('line 2047');
        List<dynamic> listOfCreatedDateTimestamps =
            obj['listOfCreatedDateTimestamps'];
        debugPrint('line 2050: ${listOfCreatedDateTimestamps.length}');
        listOfCreatedDateTimestamps.sort((a, b) {
          return b['createdDateTimestamp'].compareTo(a['createdDateTimestamp']);
        });
        debugPrint('line 2054');
        int otMinutes = obj['cumulativePriorMinutes'] - obj['baseMinutes'];
        obj['otMinutes'] = otMinutes;
        double oth = double.parse((obj['otMinutes'] / 60).toStringAsFixed(2));
        debugPrint('line 2058: ${oth}');
        obj['otHours'] = oth;
        obj['weeklyOT'] = true;
        debugPrint('line 2061 ${otMinutes} ${obj['otHours']}');
        obj['cumulativePriorMinutes'] -= otMinutes;
        debugPrint('line 2063 ${otMinutes} ${obj['otHours']}');
        obj['cumulativePriorHours'] -= obj['otHours'];
        obj['cumulativeRegularHours'] -= obj['otHours'];
        debugPrint('line 2066 ${otMinutes}');
        obj['cumulativeRegularMinutes'] -= otMinutes;
        debugPrint(
            'line 2069" ${obj['cumulativePriorMinutes']} ${otMinutes} ${obj['otHours']} ${obj['weeklyOT']}');
        for (int i = 0; i < listOfCreatedDateTimestamps.length; i++) {
          if (otMinutes <= 0) {
            break;
          }
          var tbj = listOfCreatedDateTimestamps[i];
          debugPrint('line 2075: $tbj');
          if (tbj == null) {
            continue;
          }
          List<dynamic> listOfClients = tbj['listOfClients'];
          for (int k = 0; k < listOfClients.length; k++) {
            if (otMinutes == 0) {
              break;
            }
            var rbj = listOfClients[k];
            if (rbj == null) {
              continue;
            }
            if (rbj['clientId'] != item['clientId']) {
              continue;
            }
            debugPrint('line 2091: ${rbj}');
            List<dynamic> listOfWorkShiftDays = rbj['listOfWorkShiftDays'];
            for (int l = 0; l < listOfWorkShiftDays.length; l++) {
              if (otMinutes == 0) {
                break;
              }
              var qbj = listOfWorkShiftDays[l];
              if (qbj == null) {
                continue;
              }
              if (qbj.containsKey('dayOT') == false) {
                continue;
              }
              debugPrint('line 2104 $l ${qbj}');
              List<dynamic> listOfShifts = qbj['listOfShifts'];
              debugPrint('line 2106: ${listOfShifts}');
              if (listOfShifts.length > 1) {
                listOfShifts.sort((a, b) {
                  return b['createdDateTimestamp']
                      .compareTo(a['createdDateTimestamp']);
                });
              }
              debugPrint('line 2113: $otMinutes ${listOfShifts.length}');
              for (int m = 0; m < listOfShifts.length; m++) {
                if (otMinutes == 0) {
                  break;
                }
                debugPrint('line 2118: ${listOfShifts[m]}');
                var wbj = listOfShifts[m];
                debugPrint('line 2120: ${wbj}');
                if (wbj == null) {
                  debugPrint('line 2122 skipping');
                  continue;
                }
                if (wbj.containsKey('shiftMinutes') == false) {
                  debugPrint('line 2126 skipping');
                  continue;
                }
                debugPrint('line 2129 $wbj');
                if (wbj['shiftMinutes'] > otMinutes) {
                  wbj['otMinutes'] = otMinutes;
                  wbj['otHours'] =
                      double.parse((otMinutes / 60).toStringAsFixed((2)));
                  otMinutes = 0;
                  wbj['shiftOvertime'] = true;
                  wbj['shiftHours'] -= wbj['otHours'];
                  wbj['shiftMinutes'] -= wbj['otMinutes'];
                  qbj['dayOT'] = true;
                  rbj['clientOT'] = true;
                } else {
                  wbj['otMinutes'] = otMinutes - wbj['shiftMinutes'];
                  wbj['otHours'] =
                      double.parse(wbj['otMinutes'] / 60.toStringAsFixed(2));
                  rbj['otMinutes'] += wbj['otMinutes'];
                  rbj['otHours'] += wbj['otHours'];
                  otMinutes -= int.parse(wbj['shiftMinutes']);
                  wbj['shiftMinutes'] = 0;
                  wbj['shiftHours'] = 0;
                  wbj['shiftOvertime'] = true;
                  qbj['dayOT'] = true;
                  rbj['clientOT'] = true;
                }
                double dMeals = double.parse((wbj['meals'] / 60).toString());
                dMeals = double.parse(dMeals.toStringAsFixed(2));
                item['otHours'] = wbj['otHours'];
                item['otMinutes'] = wbj['otMinutes'];
                item['signedOutHoursWorked'] -= wbj['otHours'];
                item['signedOutHoursWorked'] -= dMeals;
                item['signedOutHours'] -= wbj['otHours'];
                item['decimalHoursVerified'] = item['signedOutHours'];
                item['signedOutHours'] -= dMeals;
                item['shiftOvertime'] = true;
                item['shiftHoursOverTime'] = wbj['otHours'];
                item['shiftMinutes'] -= wbj['otMinutes'];
                item['shiftMinutes'] -= wbj['meals'];
                item['calculatedHoursWorked'] -= wbj['otHours'];
                item['calculatedHoursWorked'] -= dMeals;
                item['signedOutShiftTimeWorked'] -= wbj['otHours'];
              }
            }
          }
        }
        await FirebaseFirestore.instance
            .collection('HCPWeeklyShift')
            .doc(documentId)
            .set(obj, SetOptions(merge: true));
      });
      return true;
    } catch (e) {
      debugPrint('line 2180 error: ${e.toString()}');
      throw Exception('line 2181 error: ${e.toString()}');
    }
  }
  Future<bool> insertHCPWorkOrderData(
      Map<String, dynamic> item, int shiftMinutes, WriteBatch batch) async {
    bool? bl1;
    debugPrint('line 1383 in insertHPWOrkOrderdata: $shiftMinutes');
    try {
      DateTime cdt = DateTime.now();
      Timestamp cdts = Timestamp.fromDate(cdt);
      Timestamp tsx = item['shiftDate'];
      DateTime sed = tsx.toDate();

      int shiftDay = sed.weekday;

      int diff = shiftDay - 1;
      debugPrint('line 1789: $cdts $tsx $sed $shiftDay $diff');
      DateTime weekStartDate = sed.subtract(Duration(days: diff));
      // weekStartDate = weekStartDate.subtract(Duration(
      //     hours: weekStartDate.hour,
      //     minutes: weekStartDate.minute,
      //     seconds: weekStartDate.second,
      //     microseconds: weekStartDate.microsecondsSinceEpoch,
      //     milliseconds: weekStartDate.millisecondsSinceEpoch));
      debugPrint('ine 1797: $weekStartDate');
      Timestamp tsStartDate = Timestamp.fromDate(weekStartDate);
      debugPrint('line 1798: $tsStartDate');
      int stmps = tsStartDate.millisecondsSinceEpoch;
      DateTime shiftDate = sed.subtract(Duration(
        hours: sed.hour,
        minutes: sed.minute,
        seconds: sed.second,
        microseconds: sed.microsecond,
        milliseconds: sed.millisecond,
      ));
      debugPrint('line 1799 $stmps');

      int shiftPosition = 0;
      switch (item['shiftCode']) {
        case '1':
          shiftPosition = 0;
          break;
        case '2':
          shiftPosition = 1;
          break;
        case '3':
          shiftPosition = 2;
          break;
        case 'AP':
          shiftPosition = 3;
          break;
        case 'PA':
          shiftPosition = 4;
          break;
        default:
          {
            throw Exception('line 1760 invali shiftcode ${item['shiftCode']}');
          }
      }

      int minmod = shiftMinutes % 60;
      double dblmod =
      double.parse(((minmod.toDouble()) / 60.0).toStringAsFixed(2));
      double shrs =
      double.parse(((shiftMinutes.toDouble()) / 60.0).toStringAsFixed(2));
      item['shiftCreatedDate'] = item['shiftCreatedDate'] == null ? item['createdDate'] : item['shiftCreatedDate'];
      Timestamp crt = item['shiftCreatedDate'];
      DateTime crtd = crt.toDate();
      int createdDateTimestamp = crtd.millisecondsSinceEpoch;
      int holdOTMinutes = 0;
      double holdOTHours = 0.0;
      Future.delayed(Duration(seconds: 2), () async {
        debugPrint('line 1832 ${item['hcpId']} $stmps');
        await FirebaseFirestore.instance
            .collection('HCPWeeklyShift')
            .where('hcpId', isEqualTo: item['hcpId'])
            .where('startOfWorkWeekTimestamp', isEqualTo: stmps)
            .get()
            .then((querySnapshot) async {
          if (querySnapshot.docs.length > 0) {
            debugPrint('line 1851 docs leng > 0');
            var docSnapshot = querySnapshot.docs[0];
            var obj = docSnapshot.data();
            obj['id'] = docSnapshot.id;
            debugPrint('line 1840 ${docSnapshot.id}');
            obj['numberOfConfirmedShifts'] += 1;
            obj['cumulativePriorHours'] += shrs;
            obj['cumulativePriorMinutes'] += shiftMinutes;
            obj['cumulativeRegularHours'] += shrs;
            obj['cumulativeRegularMinutes'] += shiftMinutes;
            debugPrint('line 1790: ${obj}');
            if (obj['cumulativePriorMinutes'] > 2400) {
              obj['weeklyOT'] == true;
              int settledOTMinutes = 0;
              double settledOTHours = 0;
              debugPrint('line 1457');
              if (obj['listOfSettledOTMinutes'].length > 0) {
                List<dynamic> lsot = obj['listOfSettledOTMinutes'];
                settledOTMinutes = int.parse(lsot[lsot.length - 1].toString());
                List<dynamic> ldot = obj['listOfSettledOTHours'];
                settledOTHours = double.parse(ldot[ldot.length - 1].toString());
              }
              debugPrint('line 1464');
              obj['otMinutes'] += (obj['cumulativePriorMinutes'] -
                  (obj['baseMinutes'] + settledOTMinutes));
              holdOTMinutes = (obj['cumulativePriorMinutes'] -
                  (obj['baseMinutes'] + settledOTMinutes));
              obj['cumulativeOTMinutes'] = obj['otMinutes'];
              settledOTMinutes += int.parse(obj['otMinutes'].toString());
              obj['listOfSettledOTMinutes'].add(settledOTMinutes);
              double otm = (obj['otMinutes'] / 60).toDouble();
              holdOTHours = otm;
              otm = double.parse(otm.toStringAsFixed(2));
              obj['otHours'] += otm;
              obj['cumulativeOTHours'] = obj['otHours'];

              settledOTHours += otm;
              obj['listOfSettledOTHours'].add(settledOTHours);
            } else {
              obj['weeklyOT'] = false;
            }
            List<dynamic> listOfCreatedDates =
            obj['listOfCreatedDateTimestamps'];
            debugPrint('line 1478: ${listOfCreatedDates.length}');
            Map<String, dynamic>? createdDate;

            debugPrint('line 1486: $createdDate');
            //  if (createdDate == null) {
            //need created date, client , day shift
            Map<String, dynamic> shift = {
              'confirmedShiftNumber': 1,
              'clientId': item['clientId'],
              'weekPosition': shiftDay - 1,
              'weekDay': shiftDay,
              'dateConfirmed': cdts,
              'shiftPosition': shiftPosition,
              'shiftCode': item['shiftCode'],
              'shiftDate': item['shiftDate'],
              'shiftHours': shrs,
              'shiftMinutes': shiftMinutes,
              'startTime': item['startTime'],
              'originalStartTime': item['startTime'],
              'endTime': item['endTime'],
              'originalEndTime': item['endTime'],
              'meals': item['meals'],
              'shiftOvertime': obj['weeklyOT'],
              // 'regularMinutes': 0,
              // 'shiftPriorHours': 0,
              // 'shiftPriorMinutes': 0,
              'otHours': holdOTHours,
              'otMinutes': holdOTMinutes,
            };
            debugPrint('line 1512: check');
            List<Map<String, dynamic>> listOfShifts = [];
            listOfShifts.add(shift);
            Map<String, dynamic> day = {
              'numberOfConfirmedShifts': 1,
              'weekPosition': shiftDay - 1,
              'shiftDate': shiftDate,
              'weekDay': shiftDay,
              'dayOT': obj['weeklyOT'],
              'otHours': holdOTHours,
              'otMinutes': holdOTMinutes,
              'listOfShifts': listOfShifts
            };
            List<Map<String, dynamic>> listDays = [];
            listDays.add(day);
            debugPrint('line 1867 debug');
            Map<String, dynamic> clm = {
              'clientId': item['clientId'],
              'numberOfConfirmedShifts': 1,
              'baseHours': 40,
              'baseMinutes': 2400,
              'cumulativePriorHours': 0,
              'cumulativePriorMinutes': 0,
              'cumulativeOTHours': 0,
              'cumulativeOTMinutes': 0,
              'cumulativeRegularHours': shrs,
              'cumulativeRegularMinutes': shiftMinutes,
              'listOfWorkShiftDays': listDays,
              'clientOT': obj['weeklyOT'],
              'otHours': holdOTHours,
              'otMinutes': holdOTMinutes
            };
            createdDate = {
              'createdDateTimestamp': createdDateTimestamp,
              'listOfClients': []
            };
            debugPrint('line 1548:');
            createdDate['listOfClients'].add(clm);
            obj['listOfCreatedDateTimestamps'].add(createdDate);
            final docRefx = await FirebaseFirestore.instance
                .collection('HCPWeeklyShift')
                .doc(obj['id']);
            batch.set(docRefx, obj, SetOptions(merge: true));

            //       listT.sort((b, a) {
            //         return b['confirmedShiftNumber'].compareTo(b['shiftDate']);
            // if (cmp != 0) return cmp;
            //  return a['shiftCode'].compareTo(b['shiftCode']);
            // });
          } else {
            //no match on weekly data
            debugPrint('line 1632 no match for weekly data');
            List<dynamic> listOfCreatedDates = [];
            List<dynamic> listDays = [{}, {}, {}, {}, {}, {}, {}];
            List<Map<String, dynamic>> listOfShifts = [];
            List<Map<String, dynamic>> listOfClients = [];
            Map<String, dynamic> shift = {
              'confirmedShiftNumber': 1,
              'clientId': item['clientId'],
              'dateConfirmed': cdts,
              'weekPosition': shiftDay - 1,
              'weekDay': shiftDay,
              'shiftPosition': shiftPosition,
              'shiftCode': item['shiftCode'],
              'shiftDate': item['shiftDate'],
              'shiftHours': shrs,
              'shiftMinutes': shiftMinutes,
              'startTime': item['startTime'],
              'originalStartTime': item['startTime'],
              'endTime': item['endTime'],
              'originalEndTime': item['endTime'],
              'meals': item['meals'],
              'shiftOverTime': false,
              'otHOurs': 0,
              'otMinutes': 0,
            };
            debugPrint('line 1655 ${shift}');
            listOfShifts.add(shift);
            Map<String, dynamic> day = {
              'numberOfConfirmedShifts': 1,
              'weekPosition': shiftDay - 1,
              'shiftDate': shiftDate,
              'weekDay': shiftDay,
              'dayOT': false,
              'otHours': 0,
              'otMinutes': 0,
              'listOfShifts': listOfShifts
            };
            debugPrint('lihe 1667: ${day}');
            listDays[shiftDay - 1] = day;
            Map<String, dynamic> clm = {
              'clientId': item['clientId'],
              'numberOfConfirmedShifts': 1,
              'baseHours': 40,
              'baseMinutes': 2400,
              'cumulativePriorHours': shrs,
              'cumulativePriorMinutes': shiftMinutes,
              'cumulativeOTHours': 0,
              'cumulativeOTMinutes': 0,
              'cumulativeRegularHours': shrs,
              'cumulativeRegularMinutes': shiftMinutes,
              'listOfWorkShiftDays': listDays,
              'clientOT': false,
              'otHours': 0,
              'otMinutes': 0
            };
            debugPrint('line 1685: ${clm}');
            Map<String, dynamic> crtdate = {
              'createdDateTimestamp': createdDateTimestamp,
              'listOfClients': [clm]
            };
            Map<String, dynamic> hcpWo = {
              'hcpId': item['hcpId'],
              'startOfWorkWeekTimestamp': stmps,
              'numberOfConfirmedShifts': 1,
              'baseHours': 40,
              'baseMinutes': 2400,
              'listOfSettledOTHours': [],
              'listOfSettledOTMinutes': [],
              'cumulativePriorHours': shrs,
              'cumulativePriorMinutes': shiftMinutes,
              'cumulativeOTHours': 0,
              'cumulativeOTMinutes': 0,
              'cumulativeRegularHours': shrs,
              'cumulativeRegularMinutes': shiftMinutes,
              'weeklyOT': false,
              'otHours': 0,
              'otMinutes': 0,
              'listOfCreatedDateTimestamps': [crtdate],
            };
            debugPrint('line 1706: ${hcpWo}');
            final docRefp = await FirebaseFirestore.instance
                .collection('HCPWeeklyShift')
                .doc();
            batch.set(docRefp, hcpWo);
          }
        });
      });
      // listOfCreatedDates.sort( (a,b) {
      //   return b['createdDateTimestamp'].compareTo(a['createdDateTimestamp']);
      //   });
      return true;
    } catch (e) {
      debugPrint('line 2052: error ${e.toString()}');
      throw Exception('Error inserting HCP work order data');
    }
  }

  Future<bool> updateClientWorkOrderCampaign(
      String documentId, String startTime, String endTime) async {
    debugPrint('line 1889 in updateCWOC');
    try {
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .doc(documentId)
          .update({'startTime': startTime, 'endTime': endTime});
      return true;
    } catch (e) {
      debugPrint('line 1893: error ${e.toString()}');
      throw Exception('line 1895 error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> determineIfShiftRequiresOT(
      Map<String, dynamic> item, int potentialOTMinutes) async {
    debugPrint('line 1212 determine ot:  ${item}');

    double otHours = 0.0;
    try {
      int sMin = utilitiesServices.getMinutes(item['startTime']);
      int eMin = utilitiesServices.getMinutes(item['endTime']);

      int eDiff = utilitiesServices.calculateShiftHours(
          sMin, eMin, item['startTime'], item['endTime'], item['meals']);
      if (eDiff == -1) {
        throw Exception('line 1141: Invalid shift code times');
      }
      var shours = (eDiff / 60).toStringAsFixed(2);
      double rhrs = double.parse(shours);
      debugPrint('line 1146 check ');
      double div = 40.0;
      Map<String, dynamic>? holdMCWO;
      Map<String, dynamic> mp = item;

      Timestamp ts = item['createdDate'];
      DateTime dtm = ts.toDate();
      Timestamp sts = item['shiftDate'];
      DateTime xtm = sts.toDate();

      double dhrs = double.parse(potentialOTMinutes.toString());
      String shrs = dhrs.toStringAsFixed(2);
      dhrs = double.parse(shrs);
      mp['flagWillOweOT'] = item['shiftOvertime'];
      mp['otHours'] = dhrs;
      mp['regularHours'] = rhrs;
      mp['otPay'] = 0.0;
      mp['regularPay'] = 0.0;
      double totalHours = rhrs + dhrs;
      debugPrint(
          'line 1166: ${mp['id']} ${item['id']} $xtm ${mp['clientId']} $dtm $div $totalHours');
      if (totalHours - div > 0) {
        otHours = totalHours - div;
        if (mp['meals'] > 0) {
          double val = .5;
          mp['regularHours'] -= val;
          otHours -= val;
        }
        debugPrint('line 1176 $otHours');
        mp['otHours'] = otHours;
        double opv = mp['otHours'] * mp['payOTRate'] * mp['payRate'];
        mp['otPay'] = opv;
        mp['OtPayRate'] = mp['payOTRate'] * mp['payRate'];
        debugPrint('line 1166 check');
        mp['regularHours'] -= otHours;
        mp['regularPay'] = mp['regularHours'] * mp['payRate'];
        mp['flagWillOweOT'] = true;
        debugPrint('line 1169 check');
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
      if (mp['id'] == item['id']) {
        holdMCWO = mp;
      }

      debugPrint('line 1198: ${holdMCWO!['id']} ${holdMCWO['flagWillOweOT']} ');
      return holdMCWO;
    } catch (e) {
      debugPrint('line 1201: ${e.toString()}');
      throw Exception('line 1334: ${e.toString()}');
    }
  }
  Future<List<Map<String, dynamic>>>? getClientWorkOrdersAll(
      int clientId) async {
    debugPrint('line 22 getallitemsfrom clienthcpwo; $clientId');
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
      debugPrint('line 120: in getallworkorders');
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
          debugPrint('line 148: $sDay $sMonth $sYear $cDay $cMonth $cYear');
          if (sMonth < cMonth) {
            continue;
          }
          if (sYear < cYear) {
            continue;
          }

          if (obj['meals'] == null) {
            obj['meals'] = 0;
          }
          // debugPrint('line 174: ${obj['hcpName']}');
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
          // debugPrint(
          //     'line 176: ${obj['shiftDate']} ${obj['shiftCode']} ${obj['isWeekend']} ${obj['isHoliday']} ${obj['startTime']} ${obj['endTime']} ${obj['billRate']}');
          // debugPrint(
          //     'line 177: ${obj['disciplineName']} ${obj['clientName']} ${obj['departmentName']} ${obj['hcpId']} ${obj['hcpName']} ${obj['meals']}');
          x = 1;

          listOfCWOMap.add(obj);
        }
      });
      debugPrint('line 153 get cmp all ${listOfCWOMap.length}');
      // for (int i = 0; i < listOfCWOMap.length; i++) {
      //   Map<String, dynamic> mp = listOfCWOMap[i];
      //   debugPrint('line 202: $i, ${mp['shiftDate']} ${mp['asmWorkOrderId']}');
      // }
      listOfCWOMap.sort((a, b) {
        debugPrint('line 155: ${a['shiftDate']} ${b['shiftDate']}');
        int sd = a['shiftDate'].compareTo(b['shiftDate']);
        debugPrint('line 203: $sd');
        if (sd == 0) {
          return a['shiftCode'].compareTo(b['shiftCode']); // '-' for descending
        }
        return sd;
      });
      return listOfCWOMap;
    } catch (e) {
      debugPrint('line 164 in get all clienthcpwos: $e');
      throw Exception(e.toString());
    }
  }
  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsShiftsWithRequiredOT(
      int clientId) async {
    debugPrint('lline 214 in getwosc for ot mitigation');
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
      debugPrint('line 218 error: ${e.toString()}');
      return [];
    }
  }
  Future<bool> updateClientMitigateOTForShift(String docId) async {
    debugPrint('line 30 in updateclientmitigation');
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
      debugPrint('line 34 error: ${e.toString()}');
      return false;
    }
  }
  Future<String> getCurrentWorkOrder(String wkid) async {
    String rtn = 'OK';
    debugPrint('line 1553: $wkid');
    await FirebaseFirestore.instance
        .collection('ClientWorkOrder')
        .doc(wkid)
        .get()
        .then((querySnapshot) {
      var obj = querySnapshot.data();
      debugPrint('line 1513: ${obj!['shiftStatus']}');
      if (obj['shiftStatus'].contains('O') == true) {
        rtn = "OK";
      }
      if (obj['shiftStatus'].contains('S') == true) {
        rtn = "Shift already scheduled";
      }
      if (obj['shiftStatus'].contains('C') == true) {
        rtn = "Shift cancelled by coordinator";
      }
      if (obj['shiftStatus'].contains('*') == true) {
        rtn = "Shift cancelled by client";
      }
      return;
    });
    debugPrint('line 1530: $rtn');
    return rtn;
  }

  Future<bool>? updateClientWorkOrderCampaignAccepted(
      Map<String, dynamic> item, dynamic data, BuildContext ctx) async {
    debugPrint('line 1201: ${item['id']} $data ${item}');
    bool flagIsAccepted = false;
    String? clientUserEmail;
    try {
      DateTime currentDate = DateTime.now(); //DateTime
      Timestamp myTimeStamp = Timestamp.fromDate(currentDate); //To TimeStamp
      String woWorkOrderId = item['clientWorkOrderId'];

      String wkr = await getCurrentWorkOrder(woWorkOrderId);
      if (wkr != 'OK') {
        throw Exception("Problem: " + wkr);
      }

      var updateShiftStatus = 'Accepted';
      Map<String, dynamic>? clnt =
      await clientServices.getClient(item['clientId']);
      if (clnt == null) {
        debugPrint('line 1221 did not get client record');
        return true;
      }

      String weekStartDay = 'Mon';
      Timestamp cts = item['shiftDate'];
      DateTime targetDate = cts.toDate();

      bool flagWeeklyOvertime = data['shiftOvertime'];
      debugPrint('line 1250: ${data}');

      String shiftApprovalNote = "";
      DateTime ctm = cts.toDate();



      if (clnt['gpoClient'] == true) {
        updateShiftStatus = 'Approved';
      }

      debugPrint(
          'line 1268: ${updateShiftStatus} ${flagWeeklyOvertime} ${updateShiftStatus} ${item['id']}');
      double dHours = data['regularHours'];
      await FirebaseFirestore.instance
          .collection("ClientWorkOrderCampaign")
          .doc(item['id'])
          .set({
        'shiftStatus': updateShiftStatus,
        'shiftStatusDate': myTimeStamp,
        'shiftAccepted': true,
        'shiftAcceptedActionDate': myTimeStamp,
        'woWorkOrderId': null,
        'shiftOvertime': flagWeeklyOvertime,
        'shiftApprovalNote': shiftApprovalNote,
        'shiftPriorHours': data['forwardHours'],
        'forwardHours': data['forwardHours'],
        'totalHours': data['totalHours'],
        'otHours': data['otHours'],
        'regularHours': data['regularHours'],
        'flagWeeklyOvertime': flagWeeklyOvertime,
        'shiftApproved': updateShiftStatus == 'Approved' ? true : false
      },SetOptions(merge:true));

      debugPrint('line 1284 returned true');
      await Future.delayed(const Duration(milliseconds: 100), () {
        debugPrint('line 1286 Hello, after 100 milliseconds of delay');
      });
      flagIsAccepted = true;
      debugPrint('line 1288: ${item['clientId']}');

      Map<String, dynamic>? clc = await clientServices
          .getSingleClientUserWithClientId(item['clientId']);
      if (clc!.isEmpty) {
        debugPrint('line 1293 did not get clientuser record');
        return true;
      }
      debugPrint('line 1602: ${clc}');
      List<String> listOfTokens = [];
      if (clc['iosFcmToken'] != null && clc['iosFcmToken'] != 'Placeholder') {
        listOfTokens.add(clc['iosFcmToken']);
      }
      if (clc['iosFcmTabletToken'] != null &&
          clc['iosFcmTabletToken'] != 'Placeholder') {
        if (listOfTokens.indexOf(clc['iosFcmTabletToken']) == -1) {
          listOfTokens.add(clc['iosFcmTabletToken']);
        }
      }
      if (clc['androidFcmToken'] != null &&
          clc['androidFcmToken'] != 'Placeholder') {
        listOfTokens.add(clc['androidFcmToken']);
      }
      if (clc['androidFcmTabletToken'] != null &&
          clc['androidFcmTabletToken'] != 'Placeholder') {
        if (listOfTokens.indexOf(clc['androidFcmTabletToken']) == -1) {
          listOfTokens.add(clc['androidFcmTabletToken']);
        }
      }
      debugPrint('line 1623: $listOfTokens');
      if (listOfTokens.length > 0) {
        Timestamp ts = item['shiftDate'];
        Map<String,dynamic>nullMap = {};
        String shiftDate = convertFromTimestamp(ts);
        String body =
            '${clc['fullName']},  ${item['hcpName']} has accepted shift ${item['shiftCode']} for $shiftDate';
        debugPrint('line 1301: $listOfTokens ${body}');
        Map<String, dynamic> parameters = {
          "title": "Shift Acceptance",
          "body": body,
          "fcmTokens": listOfTokens,
          "data": nullMap
        };
        await htc.sendSingleMessage(parameters, ctx);
      }
      return true;
    } catch (e) {
      if (flagIsAccepted == true) {
        return true;
      }
      debugPrint('line 1311 error: ${item['id']} $e');
      int idx = e.toString().indexOf('Exception: ');
      int rdx = e.toString().indexOf('Exception: ', idx);
      if (rdx == -1) {
        rdx = idx;
      }
      String ee = e.toString();
      if (rdx != -1) {
        rdx += 11;
        ee = e.toString().substring(rdx, e.toString().length);
      }
      throw Exception(ee);
    }
  }
  Future<int> getDailyTimeInMinutes(
      Timestamp shiftDateTimeStamp, int hcpId) async {
    int dMin = 0;
    try {
      DateTime shiftDate = shiftDateTimeStamp.toDate();
      int weekDay = shiftDate.weekday;
//      int diffDay = weekDay - (weekDay - 1);
      //     DateTime newShiftDate = shiftDate.subtract(Duration(days: diffDay));
      debugPrint('line 1724: $shiftDate $shiftDateTimeStamp');
      shiftDate = shiftDate.subtract(Duration(
          hours: shiftDate.hour,
          minutes: shiftDate.minute,
          seconds: shiftDate.second,
          microseconds: shiftDate.microsecond,
          milliseconds: shiftDate.millisecond));
      Timestamp fds = Timestamp.fromDate(shiftDate);
      DateTime endDate = shiftDate.add(Duration(days: 1));
      endDate = endDate.subtract(Duration(
          hours: endDate.hour,
          minutes: endDate.minute,
          seconds: endDate.second,
          microseconds: endDate.microsecond,
          milliseconds: endDate.millisecond));
      Timestamp eds = Timestamp.fromDate(endDate);
      debugPrint('line 1733 $fds $eds $shiftDate $endDate');
      int tMin = 0;
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftStatus', whereIn: ['Confirmed', 'SignedIn', 'SignedOut'])
          .where('shiftDate', isGreaterThanOrEqualTo: fds)
          .where('shiftDate', isLessThan: eds)
          .get()
          .then((querySnapshot) {
        debugPrint('line 1233: ${querySnapshot.docs.length}');
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          Timestamp ts = obj['shiftDate'];
          DateTime stm = ts.toDate();
          int sMin = utilitiesServices.getMinutes(obj['startTime']);
          int eMin = utilitiesServices.getMinutes(obj['endTime']);
          // if (sMin > eMin) {
          //   eMin += 1440;
          // }
          // dMin += (eMin - sMin);
          int meals = obj['meals'];
          if (obj['shiftStatus'] == 'SignedOut') {
            dMin = int.parse(
                (60 * obj['signedOutShiftTimeWorked']).round().toString());
            int meals = int.parse(obj['meals'].toString());
            if (dMin > meals) {
              dMin -= meals;
            }
            tMin += dMin;
          } else {
            dMin = utilitiesServices.calculateShiftHours(
                sMin, eMin, obj['startTime'], obj['endTime'], meals);
            if (dMin == -1) {
              throw Exception('Line 1392: Invalid shift codes');
            }
            tMin += dMin;
          }
        }
      });
      debugPrint('line 1771: $tMin');
      return tMin;
    } catch (e) {
      debugPrint('line 1230 error: ${e.toString()}');
      throw Exception('line 1231 error: ${e.toString()}');
    }
  }
  Future<int> getFutureShiftTimeInMinutes(
      Timestamp ts, int hcpId, String shiftCode,List<String>listOfShiftCodes) async {
    try {
      debugPrint('line 2440 in getfutureshifttimeinminutes');
      DateTime dte = ts.toDate();
      dte = dte.add(Duration(days: 1));

      dte = dte.subtract(Duration(
          hours: dte.hour,
          minutes: dte.minute,
          seconds: dte.second,
          microseconds: dte.microsecond,
          milliseconds: dte.millisecond));
      Timestamp ts1 = Timestamp.fromDate(dte);
      debugPrint('line 2458: ${ts1}');
      int futureMinutes = 0;

      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftCode',whereIn: listOfShiftCodes)
          .where('shiftDate', isGreaterThanOrEqualTo: ts1)
          .where('shiftDate', isLessThanOrEqualTo: ts1)
          .where('shiftStatus', whereIn: ['Confirmed', 'SignedIn', 'SignedOut'])
          .orderBy('shiftCode')
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.docs.length == 0) {
          futureMinutes = 0;
          return futureMinutes;
        }
        debugPrint('line 2474: ${querySnapshot.docs.length}');
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> obj = docSnapshot.data();

          int sMin = utilitiesServices.getMinutes(obj['startTime']);
          int eMin = utilitiesServices.getMinutes(obj['endTime']);
          if (sMin > eMin) {
            eMin +=1440;
          }
          int diff = eMin - sMin;
          debugPrint('line 2495: $shiftCode ${obj['shiftCode']} $diff');
          futureMinutes += diff;
        }
      });
      debugPrint('line 2539 $futureMinutes');
      return futureMinutes;
    } catch (e) {
      debugPrint('line 2471 error: ${e.toString()}');
      return 0;
    }
  }
  Future<int> getCurrentShiftTimeInMinutes(
      Timestamp ts, int hcpId, String shiftCode,List<String>listOfShiftCodes) async {
    try {
      debugPrint('line 2440 in getfutureshifttimeinminutes');
      DateTime dte = ts.toDate();
      dte = dte.subtract(Duration(
          hours: dte.hour,
          minutes: dte.minute,
          seconds: dte.second,
          microseconds: dte.microsecond,
          milliseconds: dte.millisecond));
      Timestamp ts1 = Timestamp.fromDate(dte);
      debugPrint('line 2503: ${ts1}');
      int currentMinutes = 0;
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftCode',whereIn: listOfShiftCodes)
          .where('shiftDate', isGreaterThanOrEqualTo: ts1)
          .where('shiftDate', isLessThanOrEqualTo: ts1)
          .where('shiftStatus', whereIn: ['Confirmed', 'SignedIn', 'SignedOut'])
          .orderBy('shiftCode')
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.docs.length == 0) {
          currentMinutes = 0;
          return currentMinutes;
        }
        debugPrint('line 2474: ${querySnapshot.docs.length}');
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> obj = docSnapshot.data();

          int sMin = utilitiesServices.getMinutes(obj['startTime']);
          int eMin = utilitiesServices.getMinutes(obj['endTime']);
          if (sMin > eMin) {
            eMin +=1440;
          }
          int diff = eMin - sMin;
          debugPrint('line 2495: $shiftCode ${obj['shiftCode']} $diff');
          currentMinutes += diff;
        }
      });
      debugPrint('line 2539 $currentMinutes');
      return currentMinutes;
    } catch (e) {
      debugPrint('line 2471 error: ${e.toString()}');
      return 0;
    }
  }

  Future<int> getPriorShiftTime(
      int hcpId, String shiftCode, Timestamp shiftDate) async {
    int fMin = 0;
    try {
      DateTime dte = shiftDate.toDate();
      dte = dte.add(Duration(days: 1));
      Timestamp ts0 = Timestamp.fromDate(dte);
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftDate', isGreaterThanOrEqualTo: shiftDate)
          .where('shiftDate', isLessThan: ts0)
          .where('shiftStatus', isEqualTo: 'Confirmed')
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.docs.length == 0) {
          return 0;
        }
        var snapshot = querySnapshot.docs[0];
        Map<String, dynamic> obj = snapshot.data();
        int sMin = utilitiesServices.getMinutes(obj['startTime']);
        int eMin = utilitiesServices.getMinutes(obj['endTime']);
        if (sMin > eMin) {
          eMin += 1440;
        }
        fMin = eMin - sMin;
      });
      return fMin;
    } catch (e) {
      debugPrint('line 2570 ERROR in getpriorshifttimes: ${e.toString()}');
      return 0;
    }
  }

  Future<int> getPastShiftTimeInInMinutes(
      Timestamp ts, int hcpId, String shiftCode,List<String>listOfShiftCodes) async {
    try {
      debugPrint('line 2578 in getpasthifttimeinminutes');
      DateTime dte = ts.toDate();
      dte = dte.subtract(Duration(days: 1));

      dte = dte.subtract(Duration(
          hours: dte.hour,
          minutes: dte.minute,
          seconds: dte.second,
          microseconds: dte.microsecond,
          milliseconds: dte.millisecond));
      Timestamp ts1 = Timestamp.fromDate(dte);
      debugPrint('line 2589: ${ts1} ');
      int pastMinutes = 0;

      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftCode',whereIn: listOfShiftCodes)
          .where('shiftDate', isGreaterThanOrEqualTo: ts1)
          .where('shiftDate', isLessThanOrEqualTo: ts1)
          .where('shiftStatus', whereIn: ['Confirmed', 'SignedIn', 'SignedOut'])
          .orderBy('shiftCode')
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.docs.length == 0) {
          pastMinutes = 0;
          return pastMinutes;
        }
        debugPrint('line 2474: ${querySnapshot.docs.length}');
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> obj = docSnapshot.data();

          int sMin = utilitiesServices.getMinutes(obj['startTime']);
          int eMin = utilitiesServices.getMinutes(obj['endTime']);
          if (sMin > eMin) {
            eMin +=1440;
          }
          int diff = eMin - sMin;
          debugPrint('line 2616: $shiftCode ${obj['shiftCode']} $diff');
          pastMinutes += diff;
        }
      });
      debugPrint('line 2620 $pastMinutes');
      return pastMinutes;
    } catch (e) {
      debugPrint('line 2623 error: ${e.toString()}');
      return 0;
    }
  }

  Future<dynamic>? updateClientWorkOrderCampaignConfirmed(
      Map<String, dynamic> item,
      dynamic data,
      String clientWorkOrderUuid,
      BuildContext ctx) async {
    debugPrint('line 1202 $data ${item}');

    if (data['shiftStatus'] == 'Declined') {
      DateTime dte = DateTime.now();
      Timestamp myTimeStamp = Timestamp.fromDate(dte);
      try {
        FirebaseFirestore.instance
            .collection('ClientWorkOrderCampaign')
            .doc(item['id'])
            .update({
          'shiftStatus': 'Dismissed',
          'shiftConfirmed': data['shiftConfirmed'],
          'shiftConfirmedActionDate': myTimeStamp,
          'shiftStatusDate': myTimeStamp
        }); //close
        return "Declined shift removed";
      } catch (e) {
        debugPrint('line 2239 Error dismissing shift: ${e.toString()}');
        throw Exception('line 2239: ${e.toString()}');
      }
    }
    debugPrint('line 2695 $item,');
    String shiftCode = item['shiftCode'];
    String workOrderId = item['clientWorkOrderId'];
    String wkr = await getCurrentWorkOrder(workOrderId);
    debugPrint('line 2698: $wkr');
    bool flagCaughtIssue = false;
    if (wkr != 'OK') {
      flagCaughtIssue = true;
      throw Exception("Problem: " + wkr);
    }

    debugPrint('line 2242  shift status: ${data['shiftStatus']}');
    Map<String, dynamic>? client =
    await clientServices.getClient(item['clientId']);
    if (client!.isEmpty) {
      throw Exception('line 2246 failed to get client record');
    }
    authServices.client = client;
    authServices.clientId = client['clientId'];
    item['clientLatitude'] = client['latitude'];
    item['clientLongitude'] = client['longitude'] > 0
        ? client['longitude'] * -1
        : client['longitude'];

    if (data['shiftStatus'] != 'Confirmed') {
      debugPrint(
          'line 2256 skipping because invalid shift status: ${data['shiftStatus']}');
      return "ERROR: invalid shiftStatus";
    }
    debugPrint('line 2570: ${item['shiftDate']}');
    int shiftDailyMinutes =
    await getDailyTimeInMinutes(item['shiftDate'], item['hcpId']);
    int sMin = utilitiesServices.getMinutes(item['startTime']);
    int eMin = UtilitiesServices().getMinutes(item['endTime']);
    if (sMin > eMin) {
      eMin += 1440;
    }
    int shiftTime = eMin - sMin;
    debugPrint('line 2546: ${shiftDailyMinutes} ${shiftTime}');

    if (shiftDailyMinutes + shiftTime > 960) {
      return "ERROR: Shift time would result in more thant 16 hours in a day.";
    }
    int pastTimes = 0;
    //shiftCode == 1

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
    debugPrint('line 2282: $nt1s ${item['id']}');

    String clientWorkOrderUUid = '';
    var woDocumentId = null;
    var documentId = null;
    String? hdcDocumentId;
    bool flagWeeklyOvertime = false;

    try {
      //line 873a
      final db = FirebaseFirestore.instance;

      final String dId = item['id'];
      debugPrint('line 2296: $dId');
      List<int> dailyMinutes = [0, 0, 0, 0, 0, 0, 0];
      String? processMessage;
      bool flagBatchWasCommitted = false;

      final _documentRef = db.collection('ClientWorkOrderCampaign').doc(dId);
      DocumentSnapshot documentSnapshot = await _documentRef.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? dta =
        documentSnapshot.data() as Map<String, dynamic>?;
        if (dta!['bookShift'] == true) {
          if (dta['shiftStatus'] != 'Approved' &&
              dta['shiftStatus'] != 'Dismissed') {
            return "ERROR: HCP incorrect status for scheduling.";
          }
        }
      } else {
        return "ERROR: No record for the HCP";
      }
      debugPrint('line 2315');
      Timestamp its = item['shiftDate'];
      DateTime itd = its.toDate();

      itd = itd.subtract(Duration(
          hours: itd.hour,
          minutes: itd.minute,
          seconds: itd.second,
          microseconds: itd.microsecond,
          milliseconds: itd.millisecond));
      debugPrint('line 2325: $itd');
      Timestamp cts = item['shiftDate'];
      DateTime ctd = cts.toDate();
      ctd = ctd.subtract(Duration(
          hours: ctd.hour,
          minutes: ctd.minute,
          seconds: ctd.second,
          microseconds: ctd.microsecond,
          milliseconds: ctd.millisecond));
      debugPrint('line 2334: $itd $ctd');
      DateTime targetDate = ctd;

      int sMin = utilitiesServices.getMinutes(item['startTime']);
      int eMin = utilitiesServices.getMinutes(item['endTime']);
      debugPrint('line 2339: $sMin $eMin');
      // if (sMin > eMin) {
      //   eMin += 1440;
      // }
      // int shiftMinutes = eMin - sMin;
      int meals = item['meals'];
      int shiftMinutes = utilitiesServices.calculateShiftHours(
          sMin, eMin, item['startTime'], item['endTime'], meals);
      shiftTime = shiftMinutes;
      if (shiftMinutes == -1) {
        throw Exception('line 2348: Invalid shift minutes');
      }
      debugPrint('line 2350: $shiftMinutes $shiftDailyMinutes');
      // if (shiftDailyMinutes + shiftMinutes > 990) {
      //   // return "Not Confirmed:  Hours Limit on Day";
      //   debugPrint('line 2353 hours limit on day ignore for debug');
      // }

      // if (item['shiftCode'] == '1' ||
      //     item['shiftCode'] == '3' ||
      //     item['shiftCode'] == 'PA') {
      Map<String, dynamic> args = {
        'clientId': item['clientId'],
        'disciplineName': item['disciplineName'],
        'branchId': item['branchId'],
        'hcpId': item['hcpId'],
        'shiftDate': ctd,
        'shiftMinutes': shiftMinutes,
        'shiftCode': item['shiftCode']
      };
      // ProcessTreeNodes ptn = ProcessTreeNodes();
      // Map<String, dynamic> mp = await ptn.startProcess(args);
      //rule 1
      //
      // int previousMinutes = mp['previousMinutes'];
      // int nextMinutes = mp['nextMinutes'];
      // int currentMinutes = shiftMinutes;
      // if (item['shiftCode'] == 'PA') {
      //   //Rules a,c
      //   if (shiftMinutes + nextMinutes > 960) {
      //     debugPrint('line 2378 not confirmed: $shiftMinutes ');
      //     return "Not Confirmed: Would exceed the 16 consecutive hours limit.";
      //   }
      // } else if (item['shiftCode'] == '3') {
      //   //Rules b, d, i,j
      //   if (currentMinutes + shiftMinutes + nextMinutes > 960) {
      //     debugPrint('line 2384 not confirmed: $shiftMinutes ');
      //     return "Not Confirmed: Would exceed the 16 consecutive hours limit.";
      //   }
      // } else if (item['shiftCode'] == '1') {
      //   //Rules: e, f, g, h,k,l
      //   if (shiftMinutes + previousMinutes > 960) {
      //     debugPrint('line 2390 not confirmed: $shiftMinutes ');
      //     return "Not Confirmed: Would exceed the 16 consecutive hours limit.";
      //   } else if (currentMinutes + shiftMinutes + nextMinutes > 960) {
      //     debugPrint('line 233 not confirmed: $shiftMinutes ');
      //     return "Not Confirmed: Would exceed the 16 consecutive hours limit.";
      //   }
      // }
      int currentTimes = 0;
      int futureTimes =0;
      if (shiftCode == '1') {
        currentTimes = await getCurrentShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['2','3']);
        if (currentTimes +  shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }
        pastTimes = await getPastShiftTimeInInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['3']);
        currentTimes = await getCurrentShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['2']);
        if (pastTimes > 0 && currentTimes > 0) {
          if (currentTimes + pastTimes + shiftTime > 960) {
            return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
          }
        }
        pastTimes = await getPastShiftTimeInInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['PA']);
        if (pastTimes + shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }

      } else if (shiftCode == '2') {
        currentTimes = await getCurrentShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['1','3']);
        debugPrint('line 2854: ${currentTimes} ${shiftTime}');
        if (currentTimes +  shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }
        pastTimes = await getPastShiftTimeInInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['3']);

        currentTimes = await getCurrentShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['1']);
        debugPrint('line 2863: ${currentTimes} ${pastTimes} ${shiftTime}');
        if (currentTimes + pastTimes + shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }
        currentTimes = await getCurrentShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['3']);
        futureTimes = await getFutureShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['1']);
        debugPrint('line 2871: ${currentTimes} ${futureTimes} ${shiftTime}');
        if (futureTimes + currentTimes + shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }
        if (currentTimes > 0) {
          futureTimes = await getFutureShiftTimeInMinutes(
              item['shiftDate'], item['hcpId'], item['shiftCode'],['AP']);
          debugPrint('line 2876 ${currentTimes} ${futureTimes} ${shiftTime}');
          if (futureTimes + currentTimes + shiftTime > 960) {
            return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
          }
        }
      } else if (shiftCode == '3' ) {
        currentTimes = await getCurrentShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['1','2']);
        if (currentTimes + shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }
        currentTimes = await getCurrentShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['AP']);
        if (currentTimes + shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }

        futureTimes = await getFutureShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['1','2']);
        if (futureTimes + shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }
        futureTimes = await getFutureShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['AP']);
        if (futureTimes + shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }
      } else if (shiftCode == 'AP') {
        pastTimes = await getPastShiftTimeInInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['3']);
        if (pastTimes + shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }
        pastTimes = await getPastShiftTimeInInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['PA']);
        if (pastTimes + shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }
        currentTimes = await getCurrentShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['3']);
        if (currentTimes + shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }
        currentTimes = await getCurrentShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['PA']);
        if (currentTimes + shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }
      } else if (shiftCode == 'PA') {
        currentTimes = await getCurrentShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['2']);
        if (currentTimes + shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }
        futureTimes = await getFutureShiftTimeInMinutes(
            item['shiftDate'], item['hcpId'], item['shiftCode'],['1']);
        if (futureTimes + shiftTime > 960) {
          return "ERROR: Shift time would result in more than 16 hours consecutive hours.";
        }
      }

      debugPrint('line 2398 $shiftMinutes');
      WriteBatch batch = db.batch();
      bool flagSkip = false;
      if (flagSkip == false) {
        // debugPrint('line 1644 $cts $weekStartDay $shiftMinutes $totalMinutes');

//        debugPrint('line 1646 $dailyMinutes');
        late var obj;
        int orderId = 0;
        String checkStatus = 'Open';
        bool isGpoClient = false;
        bool flagHasHCPTimecard = false;
        if (item['scheduleNotes'] == "GPO Client") {
          if (item['bookShift'] == null || item['bookShift'] == false) {
            checkStatus = 'Closed';
          }
          flagHasHCPTimecard = true;
          isGpoClient = true;
        }
        debugPrint('line 2527: ${item['hcpId']} $checkStatus ${item['clientId']}');
        await FirebaseFirestore.instance
            .collection('ClientWorkOrder')
            .where('clientId', isEqualTo: item['clientId'])
            .where('shiftStatus', isEqualTo: checkStatus)
            .where('disciplineName', isEqualTo: item['disciplineName'])
            .get()
            .then((querySnapshot) async {
          debugPrint('line 2425: ${querySnapshot.docs.length}');
          for (var docSnapshot in querySnapshot.docs) {
            documentId = docSnapshot.id;
            obj = docSnapshot.data();
            if (obj['dates'] == null) {
              if (obj['shiftCode'] != item['shiftCode']) {
                debugPrint('line 2431 skipping on shiftcode');
                continue;
              }
            } else {
              if (item['shiftCode'] !=
                  obj['dates']['shiftDateInfo']['shiftCode']) {
                debugPrint('line 2437skipping of shiftcode');
                continue;
              }
            }

            bool flagSkip = false;
            //if (obj['hcpId'] != item['hcpId']) {
            //   continue;
            // }
            isGpoClient = false;
            debugPrint('line 2447: ${obj['isGPOClient']}');
            if (obj['isGPOClient'] == null) {
              obj['isGPOClient'] = false;
              obj['bookShift'] = true;
              isGpoClient = false;
            } else {
              // if (obj['hcpId'] != item['hcpId']) {
              //   debugPrint('line 2130 skipping on gpo with hcpid');
              //   continue;
              // }
              if (obj['isGPOClient'] == true) {
                isGpoClient = true;
              }
            }

            if (obj['shiftCode'] != null) {
              if (obj['shiftCode'] != item['shiftCode']) {
                debugPrint('line 2464: ${obj['shiftCode']} ${item['shiftCode']}');
                flagSkip = true;
              }
            } else {
              if (obj['dates']['shiftDateInfo']['shiftCode'] !=
                  item['shiftCode']) {
                debugPrint(
                    'line 2471: ${obj['dates']['shiftDateInfo']['shiftCode']} ${item['shiftCode']}');
                flagSkip = true;
              }
            }
            if (flagSkip == true) {
              debugPrint('line 2576: skipping on shiftcode');
              continue;
            }
            debugPrint('line 2479: ${obj['workOrderId']} $documentId ');

            Timestamp? cts;

            if (isGpoClient == false) {
              cts = obj['dates']['shiftDateInfo']['shiftDate'];
            } else {
              cts = obj['shiftDate'];
            }
            debugPrint('line 2488: $isGpoClient $cts');
            DateTime ctd = cts!.toDate();
            ctd = ctd.subtract(Duration(
                hours: ctd.hour,
                minutes: ctd.minute,
                seconds: ctd.second,
                microseconds: ctd.microsecond,
                milliseconds: ctd.millisecond));
            debugPrint('line 2496: $itd $ctd');
            if (itd.millisecondsSinceEpoch == ctd.millisecondsSinceEpoch) {
              debugPrint('line 2498');
              bool flagCheck = true;
              if (isGpoClient == false) {
                if (obj['dates']['shiftDateInfo']['shiftCode'] !=
                    item['shiftCode']) {
                  flagCheck = false;
                }
              } else if (obj['shiftCode'] != item['shiftCode']) {
                flagCheck = false;
              }
              if (flagCheck == true) {
                debugPrint('line 2509 $documentId ${obj['orderId']}');
                if (obj['orderId'] == null) {
                  obj['orderId'] = obj['asmWorkOrderId'];
                }
                orderId = obj['orderId'];
                if (obj['asmWorkOrderId'] == null) {
                  debugPrint('line 2515 asmworkorderid should not be null');
                  throw Exception('ERROR: Asmworkorderid is null');
                }
                asmWorkOrderId = obj['asmWorkOrderId'];
                // debugPrint(
                //     'line 1533: ${obj['clientId']} ${obj['shiftCode']}  ${obj['dates']['shiftDateInfo']['shiftDate']}');break;

                debugPrint('line 2522: $asmWorkOrderId $documentId $woDocumentId');

                if (asmWorkOrderId == -1) {
                  debugPrint('line 2525 skipping on asmWorkOrderId');
                  return 'ERROR: No shift found to confirm.';
                }

                Timestamp tis = item['shiftDate'];
                DateTime tdis = tis.toDate();
                tdis = tdis.subtract(Duration(
                    hours: tdis.hour,
                    minutes: tdis.minute,
                    seconds: tdis.second,
                    microseconds: tdis.microsecond,
                    milliseconds: tdis.millisecond));
                Timestamp ts = item['shiftDate'];
                DateTime ds = ts.toDate();
                if (ds.hour > 0) {
                  ds = ds.subtract(Duration(
                      hours: ds.hour,
                      minutes: ds.minute,
                      seconds: ds.second,
                      microseconds: ds.microsecond,
                      milliseconds: ds.millisecond));
                }
                ts = Timestamp.fromDate(ds);
                DateTime ds1 = ts.toDate();
                ds1 = ds1.add(Duration(days: 1));
                Timestamp tse = Timestamp.fromDate(ds1);
                debugPrint('line 2551: ${item['shiftDate']}, ${ts} ${tse}');
                debugPrint(
                    'line 2553: ${item['branchId']} ${item['clientId']} ${item['shiftCode']} ${item['disciplineName']}');
                await FirebaseFirestore.instance
                    .collection('ClientHCPWorkOrder')
                    .where('statusId', isEqualTo: 'O')
                    .where('disciplineName',
                    arrayContains: item['disciplineName'])
                    .where('branchId', isEqualTo: item['branchId'])
                    .where('clientId', isEqualTo: item['clientId'])
                    .where('shiftCode', isEqualTo: item['shiftCode'])
                    .where('shiftDate', isGreaterThanOrEqualTo: ts)
                    .where('shiftDate', isLessThan: tse)
                    .orderBy('statusId', descending: false)
                    .orderBy('disciplineName', descending: false)
                    .orderBy('branchId', descending: false)
                    .orderBy('clientId', descending: false)
                    .orderBy('shiftCode', descending: false)
                    .orderBy('shiftDate', descending: false)
                    .get()
                    .then((querySnapshot) {
                  debugPrint('line 2572: ${querySnapshot.docs}');
                  debugPrint('line 2573 ${querySnapshot.docs.length}');
                  for (var docSnapshot in querySnapshot.docs) {
                    var hco = docSnapshot.data();
                    Timestamp hcs = hco['shiftDate'];
                    DateTime hdc = hcs.toDate();
                    hdc = hdc.subtract(Duration(
                        hours: hdc.hour,
                        minutes: hdc.minute,
                        seconds: hdc.second,
                        microseconds: hdc.microsecond,
                        milliseconds: hdc.millisecond));
                    debugPrint(
                        'line 2585: ${tdis.millisecondsSinceEpoch} ${hdc.millisecondsSinceEpoch}');
                    if (tdis.millisecondsSinceEpoch ==
                        hdc.millisecondsSinceEpoch) {
                      hdcDocumentId = docSnapshot.id;
                      break;
                    }
                  }
                });
                if (hdcDocumentId == null) {
                  throw Exception('ERROR: HdcDocumentId is null');
                }

                final docRefz =
                await db.collection('ClientWorkOrder').doc(documentId);
                batch.update(docRefz, {
                  'shiftStatus': 'Closed',
                  'statusId': 'Closed',
                  'hcpId': item['hcpId'],
                  'hcpName': item['hcpName'],
                  'workOrderId': workOrderId
                });
                final docRef5 = await db
                    .collection('ClientHCPWorkOrder')
                    .doc(hdcDocumentId);
                batch.update(docRef5, {
                  'clientWorkOrderCampaignId': item['id'],
                  'hcpId': item['hcpId'],
                  'hcpName': item['hcpName'],
                  'woWorkOrderId': documentId,
                  'workOrderId': workOrderId,
                  'order': orderId,
                  'asmWorkOrderId': asmWorkOrderId,
                  "statusId": 'S',
                  'statusDate': Timestamp.fromDate(DateTime.now())
                });
                debugPrint('line 2620 ${item['id']}');
                final docRef1 = await db
                    .collection('ClientWorkOrderCampaign')
                    .doc(item['id']);
                flagHasHCPTimecard = true;
                batch.update(docRef1, {
                  'flagHasHCPTimecard': flagHasHCPTimecard,
                  'shiftStatus': "Confirmed",
                  'shiftConfirmed': data['shiftConfirmed'],
                  'shiftConfirmedActionDate': myTimeStamp,
                  'shiftStatusDate': myTimeStamp,
                  'woWorkOrderId': documentId,
                  'workOrderId': workOrderId,
                  'asmWorkOrderId': asmWorkOrderId
                }); //closed
                debugPrint(
                    'line 2636 ${item['clientId']} ${data['shiftStatus']} ${item['shiftCode']}');
                orderId = 0;
                //903a
                item['workOrderId'] = workOrderId;
                item['asmWorkOrderId'] = asmWorkOrderId;
                item['woWorkOrderId'] = documentId;
                item['shiftStatus'] = 'Confirmed';
                item['shiftStatusDate'] = myTimeStamp;
                item['orderId'] = asmWorkOrderId;
                bool bl1 = await htc.insertHCPTimeCard(item, batch);
                if (bl1 == false) {
                  throw Exception('ERROR: Unable to insert a time card');
                }
                bl1 = await insertHCPWorkOrderData(item, shiftMinutes, batch);
                batch.commit();
                flagBatchWasCommitted = true;
                debugPrint('line 2653 just before batch commit: $bl1');
                break;
              }
            }
          }
        });
      }
      if (flagBatchWasCommitted == false) {
        debugPrint('line 2661 batch not committed');
        throw Exception('ERROR: line 2304 batch not committed');
      }

      debugPrint('line 2665 just before commit check');
      authServices.clientId = item['clientId'];
      debugPrint(
          'line 2668: $asmWorkOrderId $woDocumentId $workOrderId $clientWorkOrderUUid');

      debugPrint('line 2670: ${item['id']}');

      var doc_id = null;
      debugPrint('line 2673 $workOrderId ${item['clientWorkOrderUuid']}');

      DateFormat formatter = DateFormat('MM-dd-yyyy');

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
      debugPrint('line 2690 $asmWorkOrderId, $asmWO');
      //step 1 book shift
      if (item['bookShift'] == true) {
        Timestamp ts = item['shiftDate'];
        DateTime dtz = ts.toDate();
        String sdtz = dtz.toString();
        Map<String, dynamic> data = {
          "shiftDate": sdtz,
          'branchId': item['branchId'].toString(),
          'hcpId': item['hcpId'].toString(),
          'orderId': asmWorkOrderId.toString()
        };
        dynamic result = await callBookShiftFunction(data, ctx);
        debugPrint('line 2703: $result $asmWorkOrderId $hcpId');
        if (result == null ||
            result.toString().toLowerCase().contains("error") == true) {
          await cleanUpHCPData(item);
          return result;
        }
        debugPrint('line 2347 check $result');
        asmHCPTimeCardId = int.parse(result);
        debugPrint('line 2349: $asmHCPTimeCardId, $result');
      } else {
        //have to read asmHCPTimeCardId from db
        Timestamp ts = item['shiftDate'];
        DateTime dtz = ts.toDate();
        String sdtz = dtz.toString();
        Map<String, dynamic> data = {
          "shiftDate": sdtz,
          'branchId': item['branchId'].toString(),
          'hcpId': item['hcpId'].toString(),
          'orderId': item['orderId'].toString()
        };
        debugPrint('line 2723: $data');
        String? rslt = await getHTCData(data, ctx);
        if (rslt.isEmpty || rslt == '') {
          await cleanUpHCPData(item);
          throw Exception('ERROR: Nothing returned from TimeCard get');
        }
        if (rslt.toLowerCase().contains('error') == true) {
          throw Exception('line 2730 on return for getHTC: ${rslt}');
        }
        debugPrint('line 2732: $rslt');
        asmHCPTimeCardId = int.parse(rslt);
      }
      //step 2 confirm shift
      if (item['bookShift'] == true) {
        var rdata = {"OrderID": asmWorkOrderId, "asmWO": asmWO};

        dynamic rslt = await callASMWOFunction(rdata, ctx);
        debugPrint('line 2740 : $rslt ${item['hcpId']} $hcpId');
        if (rslt == null || rslt.contains("Unsuccessful") == true) {
          debugPrint('line 2742 error');
          await cleanUpHCPData(item);
          return rslt;
        }
      }

      DateTime dtm = item['shiftDate'].toDate();
      dtm = dtm.subtract(Duration(
          hours: dtm.hour,
          minutes: dtm.minute,
          seconds: dtm.second,
          microseconds: dtm.microsecond,
          milliseconds: dtm.millisecond));
      Timestamp nowTm = Timestamp.fromDate(dtm);
      debugPrint('line 2756: $asmHCPTimeCardId, ${item['shiftCode']} ${nowTm}');
      debugPrint('line 2757: ${item['clientId']} ${item['hcpId']}');
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('clientId', isEqualTo: item['clientId'])
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('shiftCode', isEqualTo: item['shiftCode'])
          .get()
          .then((querySnapshot) async {
        var docId;
        bool flatGotHit = false;
        debugPrint('line 2767 ${querySnapshot.docs.length}');
        if (querySnapshot.docs.length == 0) {
          await cleanUpHCPData(item);
          throw Exception('ERROR: Htptimecard does not exist yet');
        }
        for (var docSnapshot in querySnapshot.docs) {
          docId = docSnapshot.id;
          debugPrint('line 2774 $docId');
          Map<String, dynamic> obj = docSnapshot.data();
          debugPrint('line 2776: ${obj}');
          Timestamp shiftDate = obj['shiftDate'];
          DateTime shiftDateTime = shiftDate.toDate();
          shiftDateTime = shiftDateTime.subtract(Duration(
              hours: shiftDateTime.hour,
              minutes: shiftDateTime.minute,
              seconds: shiftDateTime.second,
              microseconds: shiftDateTime.microsecond,
              milliseconds: shiftDateTime.millisecond));
          shiftDate = Timestamp.fromDate(shiftDateTime);
          debugPrint('line 2786: ${dtm} ${shiftDateTime}');
          debugPrint(
              'line 2788 ${nowTm.millisecondsSinceEpoch} ${shiftDate.millisecondsSinceEpoch}');
          if (nowTm.millisecondsSinceEpoch ==
              shiftDate.millisecondsSinceEpoch) {
            debugPrint(
                'line 2792: got hit $asmHCPTimeCardId $asmWorkOrderId $docId');
            await FirebaseFirestore.instance
                .collection('HCPTimeCard')
                .doc(docId)
                .update({
              'asmWorkOrderId': asmWorkOrderId,
              'asmHCPTimeCardId': asmHCPTimeCardId
            });
            // await FirebaseFirestore.instance
            //     .collection('HCPTimeCard')
            //     .doc(docId)
            //     .update({
            //   'asmWorkOrderId': asmWorkOrderId,
            //   'asmHCPTimeCardId': asmHCPTimeCardId
            // });
          }
        }
      });
      if (item['bookShift'] == true) {
        var datae = {"OrderID": asmWorkOrderId, "asmWO": asmWO};
        dynamic rslts = await callASMWOFunction(datae, ctx);
        debugPrint('line 2813: $rslts $hcpId');
        if (rslts == null || rslts == "Unsuccessful") {
          debugPrint('line 2815 error');
          await cleanUpHCPData(item);
          throw Exception('ERROR: Exception on asm confirmation');
        }
      }
      debugPrint('line 2820 ${asmWO}');
      if (item['clientUserId'] == null) {
        item['clientUserId'] = 1;
      }
      Map<String, dynamic>? clc = await clientServices
          .getSingleClientUserWithClientId(item['clientId']);
      if (clc!.isEmpty) {
        debugPrint('line 2827 error getitng client user');
        return "Clean Run - No Push Notification";
      }
      debugPrint('line 2831 ${clc} ${clc['fcmToken']}');
      List<String> fcmTokens = [];
      if (clc['iosFcmToken'] != null && clc['iosFcmToken'] != 'Placeholder') {
        debugPrint('line 2836 debug');
        fcmTokens.add(clc['iosFcmToken']);
        if (clc['iosFcmTabletToken'] != null &&
            clc['iosFcmTabletToken'] != 'Placeholder' &&
            clc['iosFcmTabletToken'] != clc['iosFcmToken']) {
          debugPrint('line 2841 debug');
          fcmTokens.add(clc['iosFcmTabletToken']);
        }
      } else if (clc['iosFcmTabletToken'] != null &&
          clc['iosFcmTabletToken'] != 'Placeholder') {
        debugPrint('line 2846 debug');
        fcmTokens.add(clc['iosFcmTabletToken']);
      }
      if (clc['androidFcmToken'] != null &&
          clc['androidFcmToken'] != 'Placeholder') {
        debugPrint('line 2851 debug');
        fcmTokens.add(clc['androidFcmToken']);
        if (clc['androidFcmTabletToken'] != null &&
            clc['androidFcmTabletToken'] != 'Placeholder' &&
            clc['androidFcmTabletToken'] != clc['androidFcmToken']) {
          debugPrint('line 2856 debug');
          fcmTokens.add(clc['androidFcmTabletToken']);
        }
      } else if (clc['androidFcmTabletToken'] != null &&
          clc['androidFcmTabletToken'] != 'Placeholder') {
        debugPrint('line 2861 debug');
        fcmTokens.add(clc['androidFcmTabletToken']);
      }
      debugPrint('line 2864 debug');
      if (clc['fcmToken'] != null &&
          clc['fcmToken'] != 'Placeholder' &&
          fcmTokens.contains(clc['fcmToken']) == false) {
        fcmTokens.add(clc['fcmToken']);
      }
      debugPrint('line 2864 debug ${fcmTokens}');
      if (fcmTokens.length > 0) {
        Timestamp ts = item['shiftDate'];
        String shiftDates = convertFromTimestamp(ts);
        debugPrint('line 2864 $shiftDates');
        String body =
            '${clc['fullName']},  ${item['hcpName']} has confirmed shift ${item['shiftCode']} for $shiftDates';
        Map<String, dynamic> parameters = {
          "title": "Shift Confirmation",
          "body": body,
          "fcmTokens": fcmTokens,
          "data": {}
        };
        try {
          bool flagRet = await htc.sendSingleMessage(parameters, ctx);
          if (flagRet == true) {
            return "Clean Run";
          } else {
            return "Clean Run - No Push Notification";
          }
        } catch (e) {
          debugPrint('line 2875 error on sending message');
          return "Clean Run - No Push Notification";
        }
        if (flagWeeklyOvertime == true) {
          return "Clean Run with weekly overtime limit reached.";
        }
        debugPrint('line 2881');

        return "Clean Run";
      } else {
        processMessage = "Clean Run.";
      }
      debugPrint('line 2887');
      return processMessage;
    } catch (e) {
      debugPrint('line 2889 error: $e');
      if (flagCaughtIssue == false) {
        await cleanUpHCPData(item);
        return e.toString();
      } else {
        debugPrint('line 1311 error: ${item['id']} $e');
        int idx = e.toString().indexOf('Exception: ');
        int rdx = e.toString().indexOf('Exception: ', idx);
        if (rdx == -1) {
          rdx = idx;
        }
        String ee = e.toString();
        if (rdx != -1) {
          rdx += 11;
          ee = e.toString().substring(rdx, e.toString().length);
        }
        throw Exception(ee);
      }
    }
  }
  Future<String> getHTCData(Map<String, dynamic> data, BuildContext ctx) async {
    try {
      String rslt = await callGetHTCFunction(data, ctx);
      if (rslt.isEmpty) {
        debugPrint('line 2195 error');
        return '';
      }
      debugPrint('line 2198: $rslt');
      return rslt;
    } catch (e) {
      debugPrint('line 2201 error: ${e.toString()}');
      return e.toString();
    }
  }

  Future<String> callGetHTCFunction(Map<String, dynamic> data, ctx) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'retrieveASMTimeCard03',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      debugPrint('line 2204 in call A  function: $callable');
      debugPrint('line 2205 : ${data}');

      HttpsCallableResult? result =
      await callingGetHTCFunction(callable, data, ctx);
      debugPrint('line 2209 : $result');
      debugPrint('line 2210: ${result.data.toString()}');
      return result.data.toString();
    } catch (e) {
      debugPrint('line 2224: $e');
      return "ERROR: ${e.toString()}";
      // throw Exception('line 1168: ${e.toString()}');
    }
  }

  Future<HttpsCallableResult> callingGetHTCFunction(HttpsCallable callable,
      Map<String, dynamic> datas, BuildContext ctx) async {
    try {
      var data = datas;
      final HttpsCallableResult? result = await callable(data);
      debugPrint('line 2239 ${result!.data}');
      return result;
    } catch (e) {
      debugPrint('line 2235 error: $e');
      throw Exception('line 2236  ${e.toString()}');
    }
  }

  Future<String> callCreateMobileWOFunction(
      Map<String, dynamic> data, ctx) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'writemobilewo',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      debugPrint('line 1971 in call A  function: $callable');
      debugPrint('line 1972: ${data}');

      dynamic result = await callingCreateWOFunction(callable, data, ctx);
      debugPrint('line 1975 : $result');
      if (result == null) {
        return "ERROR: Null returned by function";
      }
      if (result.contains('Unsuccessful') == true) {
        debugPrint('line 1980: Error writing work order to asm');
        return result;
      }
      debugPrint('line 1983 mobile WORK ORDER WRITTEN');
      return result;
    } catch (e) {
      debugPrint('line 1986: $e');
      return "ERROR: ${e.toString()}";
      // throw Exception('line 1168: ${e.toString()}');
    }
  }

  Future<dynamic> callingCreateWOFunction(HttpsCallable callable,
      Map<String, dynamic> asmWO, BuildContext ctx) async {
    try {
      var data = asmWO;
      final HttpsCallableResult result = await callable(data);
      debugPrint('line 1997 ${result.data}');
      return result.data.toString();
    } catch (e) {
      debugPrint('line 2000 error: $e');
      throw Exception('line 2001  ${e.toString()}');
    }
  }
  Future<dynamic> callingASMWOFunction(HttpsCallable callable,
      Map<String, dynamic> asmWO, BuildContext ctx) async {
    try {
      var data = asmWO;
      final HttpsCallableResult result = await callable(data);
      debugPrint('line 2095 ${result.data}');
      return result.data.toString();
    } catch (e) {
      debugPrint('line 2098 error: $e');
      throw Exception('line 2099  ${e.toString()}');
    }
  }
  Future<String> callASMWOFunction(Map<String, dynamic> data, ctx) async {
    debugPrint('line 2006 callASMWOFunction');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'confirmWO',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      debugPrint('line 2015 in call A  function: $callable');
      dynamic result = await callingASMWOFunction(callable, data, ctx);
      debugPrint('line 2017: $result');
      if (result == null) {
        return "ERROR: Null returned by function";
      }
      if (result.contains('Unsuccessful') == true) {
        debugPrint('line 2022: Error writing work order to asm');
        return result;
      }
      debugPrint('line 2085 ASM WORK ORDER WRITTEN');
      return result;
    } catch (e) {
      debugPrint('line 2028: $e');
      return "ERROR: ${e.toString()}";
      // throw Exception('line 1168: ${e.toString()}');
    }
  }

  Future<void> cleanUpHCPData(Map<String, dynamic> item) async {
    debugPrint('line 2896 in clean up hcp data');
    try {
      Timestamp its = item['shiftDate'];
      DateTime dits = its.toDate();
      dits = dits.subtract(Duration(
          hours: dits.hour,
          minutes: dits.minute,
          seconds: dits.second,
          microseconds: dits.microsecond,
          milliseconds: dits.millisecond));
      DateTime eits = dits;
      its = Timestamp.fromDate(dits);
      eits = eits.add(Duration(days: 1));
      Timestamp dts = Timestamp.fromDate(eits);
      String? documentId;
      debugPrint('line 2911: $its $dts');
      await FirebaseFirestore.instance
          .collection('ClientHCPWorkOrder')
          .where('clientId', isEqualTo: item['clientId'])
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('shiftCode', isEqualTo: item['shiftCode'])
          .where('shiftDate', isGreaterThanOrEqualTo: its)
          .where('shiftDate', isLessThan: dts)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.docs.length > 0) {
          documentId = querySnapshot.docs[0].id;
          debugPrint('line 2923: $documentId');
          await FirebaseFirestore.instance
              .collection('ClientHCPWorkOrder')
              .doc(documentId)
              .update({'statusId': 'O', 'hcpId': 0, 'hcpName': ''});
        }
      });
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .where('clientId', isEqualTo: item['clientId'])
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('shiftCode', isEqualTo: item['shiftCode'])
          .where('shiftDate', isGreaterThanOrEqualTo: its)
          .where('shiftDate', isLessThan: dts)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.docs.length > 0) {
          documentId = querySnapshot.docs[0].id;
          debugPrint('line 2941: $documentId');
          await FirebaseFirestore.instance
              .collection('ClientWorkOrderCampaign')
              .doc(documentId)
              .update({'shiftStatus': 'Approved'});
        }
      });
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('clientId', isEqualTo: item['clientId'])
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('shiftCode', isEqualTo: item['shiftCode'])
          .where('shiftDate', isGreaterThanOrEqualTo: its)
          .where('shiftDate', isLessThan: dts)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.docs.length > 0) {
          documentId = querySnapshot.docs[0].id;
          debugPrint('line 2959: $documentId');
          await FirebaseFirestore.instance
              .collection('HCPTimeCard')
              .doc(documentId)
              .delete();
        }
      });
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('clientId', isEqualTo: item['clientId'])
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('dates.shiftDateInfo.shiftCode', isEqualTo: item['shiftCode'])
          .where('dates.shiftDateInfo.shiftDate', isGreaterThanOrEqualTo: its)
          .where('dates.shiftDateInfo.shiftDate', isLessThan: dts)
          .orderBy('clientId', descending: false)
          .orderBy('hcpId', descending: false)
          .orderBy('dates.shiftDateInfo.shiftCode', descending: false)
          .orderBy('dates.shiftDateInfo.shiftDate', descending: false)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.docs.length > 0) {
          debugPrint('line 2980: ${querySnapshot.docs.length}');
          documentId = querySnapshot.docs[0].id;
          debugPrint('line 2982: $documentId');
          await FirebaseFirestore.instance
              .collection('ClientWorkOrder')
              .doc(documentId)
              .update({
            'shiftStatus': 'Open',
            'hcpId': 0,
            'hcpName': '',
            'statusId': 'Open'
          });
        }
      });
      return;
    } catch (e) {
      debugPrint('line 2996 error: ${e.toString()}');
      throw Exception('line 2997 error cleaning up hcp data: ${e.toString()}');
    }
  }

  Future<String> callBookShiftFunction(
      Map<String, dynamic> data, BuildContext ctx) async {
    debugPrint('line 1936: ${data}');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'bookShift09',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 300),
        ),
      );

      debugPrint('line 1945 in call A  function: $callable');
      dynamic result = await callingBookShiftFunction(callable, data, ctx);
      debugPrint('line 1948: $result');
      if (int.tryParse(result.toString()) == null) {
        throw Exception(result);
      }
      debugPrint('line 1952 ASM WORK ORDER WRITTEN');
      return result.toString();
    } catch (e) {
      debugPrint('line 1955 error : $e');
      return e.toString();
      // throw Exception('line 1168: ${e.toString()}');
    }
  }
  Future<dynamic> callingBookShiftFunction(HttpsCallable callable,
      Map<String, dynamic> data, BuildContext ctx) async {
    try {
      debugPrint('line 2072 $data');
      final HttpsCallableResult result = await callable(data);
      debugPrint('line 2075 ${result.data}');
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
        debugPrint('line 2081 ${e.toString()}');
        return result.data[0];
      }
    } catch (e) {
      debugPrint('line 1994 error: $e');
      throw Exception('line 1995  ${e.toString()}');
    }
  }
  Future<bool>? cancelHCPWorkOrderShift(
      Map<String, dynamic> item, int hcpId, BuildContext ctx) async {
    debugPrint('line 642 cancelworkordershift: ${item['id']} $hcpId');
    bool bl = true;
    String? documentId;
    DateTime currentDate = DateTime.now(); //DateTime
    Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
    Map<String, dynamic>? asmWO;
    Map<String, dynamic>? hcpWO;
    try {
      debugPrint('line 648 ${item['workOrderId']}');

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
      debugPrint('line 1018 $hcpProf');
      FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .doc(item['id'])
          .set(hcpProf!, SetOptions(merge: true));
      asmWO = {};
      //asmWO['asmWorkOrderId'] = 0;
      asmWO['hcpId'] = 0;
      asmWO['hcpName'] = null;
      asmWO['shiftStatus'] = 'Open';
      debugPrint('line 1028');
      await FirebaseFirestore.instance
          .collection("ClientWorkOrder")
          .doc(item['woWorkOrderId'])
          .get()
          .then((querySnapshot) async {
        var wobj = querySnapshot.data();
        debugPrint('line 1035: $wobj');
        clientHCPWorkOrderId = wobj!['clientHCPWorkOrderId'];
        asmWorkOrderId = wobj['asmWorkOrderId'];
        await FirebaseFirestore.instance
            .collection("ClientWorkOrder")
            .doc(item['woWorkOrderId'])
            .set(asmWO!, SetOptions(merge: true));
      });
      debugPrint('line 1041: ${item['id']} $asmWorkOrderId');
      item['asmWorkOrderId'] = asmWorkOrderId;
      Map<String, dynamic> st = {
        "asmWorkOrderId": asmWorkOrderId,
      };
      await FirebaseFirestore.instance
          .collection("ClientWorkOrderCampaign")
          .doc(item['id'])
          .set(st, SetOptions(merge: true));
      debugPrint('line 697: $asmWO');
      hcpWO = {};
      hcpWO['hcpId'] = 0;
      hcpWO['hcpName'] = null;
      hcpWO['statusId'] = 'O';
      hcpWO['statusDate'] = Timestamp.fromDate(DateTime.now());
      debugPrint('line 1058: ${clientHCPWorkOrderId}');
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
      debugPrint('line 686: $hcpTimeCardId $workOrderId $woWorkOrderId');
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
      debugPrint('line 697: ${woWorkOrderId}');
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
      debugPrint('line 715');
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
      // debugPrint('line 786: ${item['shiftCancellationCodeId']}');
      // bool bl = await htc.callCancelWO(
      //     asmWorkOrderId.toString(), shiftCancellationMap, ctx);
      // if (bl == false) {
      //   debugPrint('line 759 error canceling shift');
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
      // debugPrint('line 820');
      // // Map<String, dynamic>? clc = await clientServices.getSingleClientUser(
      // //     item['clientId'], 'ClientScheduler');
      // // if (clc!.isEmpty) {
      // //   throw Exception(('line 780 unable to get client record'));
      // // }
      // return true;
    } catch (e) {
      debugPrint('line 1210 $e');
      if (e.toString().toLowerCase().contains('debug') == true) {
        return true;
      }
      return false;
    }
  }
// Future<Map<String, dynamic>> updateShiftTime(
//     Map<String, dynamic> item, Map<String, dynamic> data) async {
//   try {
//     debugPrint('line 1538 in updateshifttime: $data');
//     int potentialOTMinutes = 0;
//     double potentialOTHours = 0.0;
//     DateTime cdt = DateTime.now();
//     Timestamp cdts = Timestamp.fromDate(cdt);
//     debugPrint('line 1543');
//     Timestamp xt = item['shiftDate'];
//     DateTime sed = xt.toDate();
//     DateTime sht = sed.subtract(Duration(
//         hours: sed.hour,
//         minutes: sed.minute,
//         seconds: sed.second,
//         microseconds: sed.microsecond,
//         milliseconds: sed.millisecond));
//
//     int shiftDay = sed.weekday;
//     debugPrint(
//         'line 1554: ${item['shiftStatus']} ${item['clientId']} ${item['shiftCreatedDate']}');
//     int diffDay = shiftDay - 1; //eg
//     Timestamp ts = item['shiftCreatedDate'];
//     DateTime scrdt = ts.toDate();
//     int scrdtmin = scrdt.millisecondsSinceEpoch;
//     debugPrint('line 1560: $scrdtmin');
//     String str = scrdtmin.toString();
//     str = str.substring(0, str.length - 3);
//     str += '000';
//     scrdtmin = int.parse(str);
//     DateTime shiftDate = sed.subtract(Duration(
//       hours: sed.hour,
//       minutes: sed.minute,
//       seconds: sed.second,
//       microseconds: sed.microsecond,
//       milliseconds: sed.millisecond,
//     ));
//     String shiftStartTime = '';
//     String shiftEndTime = '';
//     double shiftOTHours = 0.0;
//     bool shiftOvertime = false;
//     String documentId = '';
//     Map<String, dynamic> hcpWo = {};
//     DateTime tx = shiftDate.subtract(Duration(days: diffDay));
//     int stmps = tx.millisecondsSinceEpoch;
//     double shiftHours = 0.0;
//     debugPrint('line 1573');
//     await FirebaseFirestore.instance
//         .collection('HCPWeeklyShift')
//         .where('hcpId', isEqualTo: item['hcpId'])
//         .where('startOfWorkWeekTimestamp', isEqualTo: stmps)
//         .get()
//         .then((querySnapshot) async {
//       if (querySnapshot.docs.length > 0) {
//         var docSnapshot = querySnapshot.docs[0];
//         var obj = docSnapshot.data();
//         obj['id'] = docSnapshot.id;
//         hcpWo = obj;
//         documentId = obj['id'];
//         debugPrint('line 1586: ${obj['cumulativePriorMinutes']}');
//         List<dynamic> listCreatedDates = obj['listOfCreatedDateTimestamps'];
//         debugPrint('line 1592: ${listCreatedDates.length}');
//         for (int i = 0; i < listCreatedDates.length; i++) {
//           var tbj = listCreatedDates[i];
//           debugPrint('line 1708: ${tbj['createdDateTimestamp']}');
//           String str = tbj['createdDateTimestamp'].toString();
//           str = str.substring(0, str.length - 3);
//           str += '000';
//           int dtms = int.parse(str);
//           debugPrint('line 1598: $dtms $scrdtmin');
//           if (dtms != scrdtmin) {
//             debugPrint('line 1600: $dtms $scrdtmin');
//             continue;
//           }
//           debugPrint('line 1603: $dtms $scrdtmin');
//           List<dynamic> listOfClients = tbj['listOfClients'];
//           for (int j = 0; j < listOfClients.length; j++) {
//             var cbj = listOfClients[j];
//             debugPrint('line 1607 check');
//             List<dynamic> listOfWorkShiftDays = cbj['listOfWorkShiftDays'];
//             List<dynamic>? listOfShifts;
//             debugPrint('line 1610 check');
//             for (int k = 0; k < listOfWorkShiftDays.length; k++) {
//               var lbj = listOfWorkShiftDays[k];
//               listOfShifts = lbj['listOfShifts'];
//               for (int l = 0; l < listOfShifts!.length; l++) {
//                 var shift = listOfShifts[l];
//                 if (shift == null) {
//                   continue;
//                 }
//                 Timestamp sts = shift['shiftDate'];
//                 DateTime sdt = sts.toDate();
//                 sdt = sdt.subtract(Duration(
//                     hours: sdt.hour,
//                     minutes: sdt.minute,
//                     seconds: sdt.second,
//                     microseconds: sdt.microsecond,
//                     milliseconds: sdt.millisecond));
//                 if (sdt.millisecondsSinceEpoch ==
//                         sht.millisecondsSinceEpoch &&
//                     shift['shiftCode'] == item['shiftCode']) {
//                   shift['startTime'] =
//                       data['signedInInitialStartTimeChanged'];
//                   shiftStartTime = shift['startTime'];
//                   shift['endTime'] = data['signedOutInitialEndTimeChanged'];
//                   shiftEndTime = shift['endTime'];
//                   int sMin = utilitiesServices.getMinutes(shift['startTime']);
//                   int eMin = utilitiesServices.getMinutes(shift['endTime']);
//                   if (sMin > eMin) {
//                     eMin += 1440;
//                   }
//                   int sDiff = eMin - sMin;
//                   shift['shiftMinutes'] = sDiff;
//                   double hours =
//                       double.parse((sDiff / 60).toStringAsFixed(2));
//                   shiftHours = hours;
//                   shift['shiftHours'] = hours;
//                   if (shift['shiftOvertime'] == false) {
//                     shiftOTHours = 0;
//                   } else {
//                     shiftOTHours = double.parse(shift['otHours'].toString());
//                     shiftOTHours =
//                         double.parse(shiftOTHours.toStringAsFixed(2));
//                     shiftOvertime = true;
//                   }
//                 }
//                 potentialOTMinutes +=
//                     int.parse(shift['shiftMinutes'].toString());
//                 potentialOTHours =
//                     double.parse((potentialOTMinutes/60).toString());
//                 potentialOTHours =
//                     double.parse(potentialOTHours.toStringAsFixed(2));
//               }
//             }
//           }
//         }
//       }
//     });
//     await FirebaseFirestore.instance
//         .collection('HCPWeeklyShift')
//         .doc(documentId)
//         .set(hcpWo, SetOptions(merge: true));
//
//     debugPrint('line 1672: $potentialOTHours $potentialOTMinutes');
//     Map<String, dynamic> mp = {
//       'shiftHours': shiftHours,
//       'otHours': shiftOTHours,
//       'shiftOverTime': shiftOvertime,
//       'startTime': shiftStartTime,
//       'endTime': shiftEndTime,
//     };
//     debugPrint('line 1680: ${mp}');
//     return mp;
//   } catch (e) {
//     debugPrint('line 1683: error ${e.toString()}');
//     throw Exception('line 1683 error: ${e.toString()}');
//   }
// }
}
