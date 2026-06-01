import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import 'package:client_app/models/hcp_models/hcp_timecard.dart';
import 'dart:core';
import 'package:client_app/services/hcp_timecard_service.dart';
import 'package:client_app/services/client_services.dart';
import 'package:intl/intl.dart';

//import 'package:client_app/models/client_models/client_user.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/services/utilities.dart';

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
        print('line 249: doc_id: $doc_id');
        var obj = docSnapshot.data();
        obj['id'] = doc_id;
        listOfCWOMap.add(obj);
      }
      return listOfCWOMap;
    });
    print('line 255: ${listOfCWOMap.length}');
    if (listOfCWOMap.length > 0) {
      Map<String, dynamic> mp = listOfCWOMap[0];
      print('line 258: ${mp['id']}');
    }
    return listOfCWOMap;
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsConfirmed(
      int clientId) async {
    print('line 623 in getworkordersconfirmed $clientId');
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
    print('line 654: $firstDate $fds');
    print('line 655 $lastDate $eds');
    // String fmt = DateFormat.yMEd().add_jms().format(DateTime.now());
    // int adv =0;
    // print('line 647: $fmt');
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
          .where('shiftStatus', whereIn: ['Confirmed', 'SignedIn', 'SignedOut'])
          .where('shiftDate', isGreaterThanOrEqualTo: fds)
          .where('shiftDate', isLessThan: eds)
          .orderBy('shiftStatus', descending: false)
          .orderBy('shiftDate', descending: false)
          .get()
          .then((querySnapshot) async {
            print('line 313: ${querySnapshot.docs.length}');
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
          .where('shiftStatus', whereIn: ['Confirmed', 'SignedIn', 'SignedOut'])
          .where('shiftDate', isGreaterThanOrEqualTo: fds)
          .where('shiftDate', isLessThan: eds)
          .orderBy('shiftStatus', descending: false)
          .orderBy('shiftDate', descending: false)
          .get()
          .then((querySnapshot) async {
            print('line 345: ${querySnapshot.docs.length}');
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
      print('line 361: ${listOfCWOs.length} ${listOfCWOs[0].length}');
      int x = 0;

      int totalWeeklyMinutes = 0;

      int sDiff = 0;
      int sMin = 0;
      int eMin = 0;

      print('line 697 debug check');
      for (int h = 0; h < listOfCWOs.length; h++) {
        listOfCWOMap = listOfCWOs[h];
        for (int i = 0; i < listOfCWOMap.length; i++) {
          var obj = listOfCWOMap[i];
          if (listOfCWOMap[i]['shiftStatus'] == 'SignedOut') {
            sDiff = int.parse(
                (60 * listOfCWOMap[i]['signedOutHours']).round().toString());
            totalWeeklyMinutes += sDiff;
          } else {
            sMin = utilitiesServices.getMinutes(obj['startTime']);
            eMin = utilitiesServices.getMinutes(obj['endTime']);
            sDiff = utilitiesServices.calculateShiftHours(
                sMin, eMin, obj['startTime'], obj['endTime'], obj['meals']);
            print('line 697 debug check: $sDiff');
            if (sDiff == -1) {
              continue;
            }
            totalWeeklyMinutes += sDiff;
          }
        }
        print('line 716 $totalWeeklyMinutes');
        int overtimeMinutes = 0;
        int regularMinutes = 0;
        if (totalWeeklyMinutes > 2400) {
          overtimeMinutes = totalWeeklyMinutes - 2400;
          regularMinutes = 2400;
        } else {
          regularMinutes = totalWeeklyMinutes;
        }
        print('line 369: $totalWeeklyMinutes $overtimeMinutes $regularMinutes');
        listOfCWOMap.sort(
            (a, b) => b['shiftCreatedDate'].compareTo(a['shiftCreatedDate']));
        for (int i = 0; i < listOfCWOMap.length; i++) {
          var obj = listOfCWOMap[i];
          sMin = utilitiesServices.getMinutes(obj['startTime']);
          eMin = utilitiesServices.getMinutes(obj['endTime']);
          sDiff = utilitiesServices.calculateShiftHours(
              sMin, eMin, obj['startTime'], obj['endTime'], obj['meals']);
          print('line 378: $i ${obj['clientId']} ${obj['shiftCreatedDate']}');
          print('line 379: $sDiff $overtimeMinutes');
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
      print('line 779 error $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsConfirmedLegacy(
      int clientId) async {
    print('line 460 in getworkordercampain confirmed $clientId');
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
          print('line 158: $obj');
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
          print('line 1381: $totalMinutes');
          int totalOTMinutes = totalMinutes!;
          print('line 1386: ${totalOTMinutes}');
          obj['requiresOvertime'] = false;
          obj['shiftOvertime'] = false;
          print('line 1400 check');
          //   List<int> sTimes = getHoursAndMinutes(obj['startTime']);
          int startMinutes = utilitiesServices.getMinutes(obj['startTime']);
          int endMinutes = utilitiesServices.getMinutes(obj['endTime']);

          int sDiff = utilitiesServices.calculateShiftHours(startMinutes,
              endMinutes, obj['startTime'], obj['endTime'], obj['meals']);
          if (sDiff == -1) {
            throw Exception('line 1397: Invalid shift times');
          }
          print('line 1265: $sDiff $startMinutes $endMinutes');
          //    List<int> eTimes = getHoursAndMinutes(obj['endTime']);
          //     if (startMinutes >= 720 && startMinutes > endMinutes) {
          //       eTimes[0] += 24;
          //     }
          int cMinutes = totalOTMinutes % 60;
          int cHours = totalOTMinutes ~/ 60;
          int shiftPriorHours = totalOTMinutes;
          print('line 1445: $shiftPriorHours');
          String sMinutes = cMinutes.toString();
          if (sMinutes.length == 1) {
            sMinutes = '0' + sMinutes;
          }
          String sTime = cHours.toString() + ":" + sMinutes;
          print('line 1422: ${cHours} ${sMinutes}');

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
          print(
              'line 1466: ${obj['shiftPriorHours']} ${obj['requiresOvertime']} $sTime ${obj['shiftPriorHoursString']} ${obj['shiftOvertime']}');

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
      int hcpId, clientId) async {
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
    print('line 614 update approved: ${item['id']}');
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
      print('line 635 shift approved');
      Future.delayed(const Duration(seconds: 1), () {
        print('Hello, after 1 seconds of delay');
      });
      print('line 639: ${item['clientId']}');
      Map<String, dynamic>? clc = await clientServices.getSingleClientUser(
          item['clientId'], item['clientUserId']);
      if (clc!.isEmpty) {
        print('line 900 clc is empty');
        return false;
      }
      print('line 903: ${item['hcpId']}');
      Map<String, dynamic>? usc =
          await clientServices.getSingleHCPUser(item['hcpId']);
      if (usc!.isEmpty) {
        print('line 905 usc is empty');
        return false;
      }
      if (clc.isEmpty) {
        print('line 1293 did not get clientuser record');
        return true;
      }
      print('line 911: ${usc}');
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
      print('line 923: $listOfTokens');
      if (listOfTokens.length > 0) {
        Timestamp ts = item['shiftDate'];
        String shiftDate = convertFromTimestamp(ts);
        String body =
            '${clc['fullName']} has approved shift ${item['shiftCode']} for $shiftDate';
        for (int z = 0; z < listOfTokens.length; z++) {
          String fcmToken = listOfTokens[z];
          print('line 1301: $fcmToken ${body}');
          Map<String, dynamic> parameters = {
            "title": "Shift Approval",
            "body": body,
            "fcmToken": fcmToken
          };
          print('line 663 ${parameters}');
          await htc.sendSingleMessage(parameters, ctx);
        }
      }

      return true;
    } catch (e) {
      print('line 953 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<bool>? updateClientWorkOrderCampaignDeclined(Map<String, dynamic> item,
      String shiftApprover, String clientEmail, BuildContext ctx) async {
    print('line 612 update shift declined: ${item['id']} $shiftApprover');
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
      print('line 633 shift declined ${authServices.clientId!}');
      Map<String, dynamic>? clc =
          await clientServices.getSingleUserFromEmail(clientEmail);
      if (clc!.isEmpty) {
        return false;
      }
      print('line 983 debug: ${item['hcpId']}');
      Map<String, dynamic>? usc =
          await clientServices.getSingleHCPUser(item['hcpId']);
      if (usc!.isEmpty) {
        return false;
      }
      print('line 571: ${clc}');

      Timestamp ts = item['shiftDate'];
      String shiftDate = convertFromTimestamp(ts);
      print('line 575 just before body creation');
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
      print('line 1623: $listOfTokens');
      if (listOfTokens.length > 0) {
        Timestamp ts = item['shiftDate'];
        String shiftDate = convertFromTimestamp(ts);
        String body =
            '${clc['fullName']},  ${clc['hcpName']} has declined shift ${item['shiftCode']} for $shiftDate';
        print('line 1301: $listOfTokens ${body}');
        Map<String, dynamic> parameters = {
          "title": "Shift Acceptance",
          "body": body,
          "fcmTokens": listOfTokens
        };
        await htc.sendSingleMessage(parameters, ctx);
      }

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
                print('line 1019: ${hcpCpg['shiftStatus']}');
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

  Future<Map<String, dynamic>> determineIfShiftRequiresOT(
      Map<String, dynamic> item, int potentialOTMinutes) async {
    print('line 1212 determine ot:  ${item}');

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
      print('line 1146 check ');
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
      print(
          'line 1166: ${mp['id']} ${item['id']} $xtm ${mp['clientId']} $dtm $div $totalHours');
      if (totalHours - div > 0) {
        otHours = totalHours - div;
        if (mp['meals'] > 0) {
          double val = .5;
          mp['regularHours'] -= val;
          otHours -= val;
        }
        print('line 1176 $otHours');
        mp['otHours'] = otHours;
        double opv = mp['otHours'] * mp['payOTRate'] * mp['payRate'];
        mp['otPay'] = opv;
        mp['OtPayRate'] = mp['payOTRate'] * mp['payRate'];
        print('line 1166 check');
        mp['regularHours'] -= otHours;
        mp['regularPay'] = mp['regularHours'] * mp['payRate'];
        mp['flagWillOweOT'] = true;
        print('line 1169 check');
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

      print('line 1198: ${holdMCWO!['id']} ${holdMCWO['flagWillOweOT']} ');
      return holdMCWO;
    } catch (e) {
      print('line 1201: ${e.toString()}');
      throw Exception('line 1334: ${e.toString()}');
    }
  }

  Future<int>? getClosedClientWorkOrders(int hcpId, DateTime newDate) async {
    print('line 1214: getclosedworkorders: $hcpId $newDate');
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
      print('line 1204: $newDate $startDate $endDate');
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftStatus', isEqualTo: 'Closed')
          .get()
          .then((querySnapshot) async {
        print('line 1200: ${querySnapshot.docs.length}');
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
            print('line 1230 ${shiftDate} ${newDate}');
            print(
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
            print('line 1288: $tl');
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
            //       print('line 1225 ${listClosedShifts.length}');
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
            //         print('line 1319');
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
            //         print('line 1330');
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
      print('line 1378: $totalMinutes');
      return totalMinutes;
    } catch (e) {
      print('line 1342: ${e.toString()}');
      throw Exception('line 1254 in closed cwos');
    }
  }

  Future<List<Map<String, dynamic>>>? getWorkOrderCampaignsAcceptedShifts(
      int clientId, String startWeekDay) async {
    print('line 1192 get accepted shifts; $clientId');
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
          .where('clientId', isEqualTo: clientId)
          .where('shiftStatus', whereIn: ['Accepted', 'Approved'])
          .where('shiftDate', isGreaterThanOrEqualTo: dnows)
          .orderBy("shiftDate", descending: false)
          .orderBy("hcpId", descending: false)
          .orderBy("shiftCode", descending: false)
          .get()
          .then((querySnapshot) async {
            //   int count = 0;
            print('line 1389 ${querySnapshot.docs.length}');
            if (querySnapshot.docs.length > 0) {
              for (var docSnapShot in querySnapshot.docs) {
                String doc_id = docSnapShot.id;
                var obj = docSnapShot.data();
                print('line 1633 ${obj}');
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
                print('line 1636: $min');
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
                print('line 1679 check: ${obj}');
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
                // print('line 1445: $shiftPriorHours');
                // String sMinutes = cMinutes.toString();
                // if (sMinutes.length == 1) {
                //   sMinutes = '0' + sMinutes;
                // }
                // String sTime = cHours.toString() + ":" + sMinutes;
                // print('line 1422: ${cHours} ${sMinutes}');
                //
                // if (sDiff + totalOTMinutes > 2400) {
                //   obj['requiresOvertime'] = true;
                //   obj['shiftPriorHoursString'] = sTime;
                //   obj['shiftOvertime'] = true;
                //   obj['shiftPriorHours'] = shiftPriorHours;
                // } else {

                //}
                // print(
                //     'line 1466: ${obj['shiftPriorHours']} ${obj['requiresOvertime']} $sTime ${obj['shiftPriorHoursString']} ${obj['shiftOvertime']}');
                listOfCWOMap.add(obj);
              }
            }
          });
      print('line 1412 : ${listOfCWOMap.length}');
      return listOfCWOMap;
    } catch (e) {
      print('line 1415 error: $e');
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

  Future<int> checkForPotentialOT(Map<String, dynamic> item) async {
    print('line 1721 in checkforpotential ot');
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
      print('line 1738: $scrdtmin $shiftMinutes');
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
        print('line 1484: ${querySnapshot.docs.length}');
        if (querySnapshot.docs.length > 0) {
          var docSnapshot = querySnapshot.docs[0];
          var obj = docSnapshot.data();
          obj['id'] = docSnapshot.id;
          print('line 1490: ${obj['cumulativePriorMinutes']}');
          if (obj['cumulativePriorMinutes'] + shiftMinutes > 2400) {
            List<dynamic> listCreatedDates = obj['listOfCreatedDateTimestamps'];
            listCreatedDates.sort((a, b) {
              return b['createdDateTimestamp']
                  .compareTo(a['createdDateTimestamp']);
            });
            print('line 1497: ${listCreatedDates.length}');
            for (int i = 0; i < listCreatedDates.length; i++) {
              var tbj = listCreatedDates[i];
              print('line 1500: ${tbj['createdDateTimestamp']}');
              int dtms = int.parse(tbj['createdDateTimestamp'].toString());
              if (dtms >= scrdtmin) {
                continue;
              }
              print('line 1505: $dtms $scrdtmin');
              List<dynamic> listOfClients = tbj['listOfClients'];
              for (int j = 0; j < listOfClients.length; j++) {
                var cbj = listOfClients[j];
                print('line 1509 check');
                List<dynamic> listOfWorkShiftDays = cbj['listOfWorkShiftDays'];
                List<dynamic>? listOfShifts;
                print('line 1512 check ${listOfWorkShiftDays.length}');
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

      print('line 1808: $potentialOTMinutes');
      return potentialOTMinutes;
    } catch (e) {
      print('line 1804: error ${e.toString()}');
      throw Exception('line 1532 error: ${e.toString()}');
    }
  }

  Future<int> clearHCPWeeklyData(int hcpId, Timestamp shiftDate) async {
    print('line 1535 in clearHCPWeeklyShiftData');
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
      print('line 1571: error ${e.toString()}');
      throw Exception('line 1540 error: ${e.toString()}');
    }
  }

  Future<bool> recalculateHCPWeeklyShift(int hcpId, int stsm) async {
    print('line 1850 in recalculatedhcpweeklyshift');
    Timestamp sday = Timestamp.fromMillisecondsSinceEpoch(stsm);
    DateTime sdtm = sday.toDate();
    DateTime edtm = sdtm.add(Duration(days: 6));
    print('line 1581: $sdtm $edtm');
    final db = FirebaseFirestore.instance;
    try {
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftStatus', whereIn: ['Confirmed', 'SignedIn', 'SignedOut'])
          .orderBy('shiftCreatedDate', descending: false)
          .orderBy('shiftCode', descending: false)
          .get()
          .then((querySnapshot) async {
            if (querySnapshot.docs.length == 0) {
              print('line 1576 error not documents returned');
              throw Exception('line 1577 Error: No CWOC documents returned');
            }
            print('line 1597: ${querySnapshot.docs.length}');
            for (var snapShot in querySnapshot.docs) {
              var obj = snapShot.data();
              obj['id'] = snapShot.id;

              Timestamp stm = obj['shiftDate'];
              DateTime dstm = stm.toDate();
              dstm = dstm.subtract(Duration(
                  hours: dstm.hour,
                  minutes: dstm.minute,
                  seconds: dstm.second,
                  microseconds: dstm.microsecond,
                  milliseconds: dstm.millisecond));
              if (dstm.millisecondsSinceEpoch < stsm ||
                  dstm.millisecondsSinceEpoch > edtm.millisecondsSinceEpoch) {
                print(
                    'line 1593 skipping on dates: ${stsm} ${dstm.millisecondsSinceEpoch}');
                continue;
              }

              int sMin = utilitiesServices.getMinutes(obj['shiftStartTime']);
              int eMin = utilitiesServices.getMinutes(obj['shiftEndTime']);
              if (sMin > eMin) {
                eMin += 1440;
              }
              print('line 1614 $sMin $eMin');
              int shiftMinutes = eMin - sMin;
              if (obj['shiftMinutes'] != null) {
                shiftMinutes = obj['shiftMinutes'];
              }
              print('line 1619: ${obj['clientId']} $shiftMinutes');
              await insertHCPWorkOrderData(obj, shiftMinutes);
            }
          });
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftStatus', whereIn: ['Confirmed', 'SignedIn', 'SignedOut'])
          .orderBy('shiftCreatedDate', descending: false)
          .orderBy('shiftCode', descending: false)
          .get()
          .then((querySnapshot) async {
            if (querySnapshot.docs.length == 0) {
              print('line 1576 error not documents returned');
              throw Exception('line 1577 Error: No CWOC documents returned');
            }
            print('line 1597: ${querySnapshot.docs.length}');
            for (var snapShot in querySnapshot.docs) {
              var obj = snapShot.data();
              obj['id'] = snapShot.id;

              Timestamp stm = obj['shiftDate'];
              DateTime dstm = stm.toDate();
              dstm = dstm.subtract(Duration(
                  hours: dstm.hour,
                  minutes: dstm.minute,
                  seconds: dstm.second,
                  microseconds: dstm.microsecond,
                  milliseconds: dstm.millisecond));
              if (dstm.millisecondsSinceEpoch < stsm ||
                  dstm.millisecondsSinceEpoch > edtm.millisecondsSinceEpoch) {
                print(
                    'line 1593 skipping on dates: ${stsm} ${dstm.millisecondsSinceEpoch}');
                continue;
              }

              int sMin = utilitiesServices.getMinutes(obj['shiftStartTime']);
              int eMin = utilitiesServices.getMinutes(obj['shiftEndTime']);
              if (sMin > eMin) {
                eMin += 1440;
              }
              print('line 1614 $sMin $eMin');
              int shiftMinutes = eMin - sMin;
              if (obj['shiftMinutes'] != null) {
                shiftMinutes = obj['shiftMinutes'];
              }
              print('line 1619: $shiftMinutes');
              await assignOTToShifts(obj);
              await updateHCPTimeCard(obj);
            }
          });

      return true;
    } catch (e) {
      print('line 1628 error: ${e.toString()}');
      throw Exception('line 1628 error: ${e.toString()}');
    }
  }

  Future<void> updateHCPTimeCard(Map<String, dynamic> item) async {
    print('line 1685 updateHCPTimeCard');
    try {
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .doc(item['id'])
          .set(item, SetOptions(merge: true));
      return;
    } catch (e) {
      print('line 1689 error: ${e.toString()}');
      throw Exception('line 1690 error: ${e.toString()}');
    }
  }

  Future<bool> assignOTToShifts(Map<String, dynamic> item) async {
    print('line 1636 assign ot to shifts');
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

      print('line 2022: $shiftMinutes $shrs ${item['shiftCreatedDate']}');
      Timestamp crt = item['shiftCreatedDate'];
      DateTime crtd = crt.toDate();
      int createdDateTimestamp = crtd.millisecondsSinceEpoch;
      String? documentId;
      print('line 2027 ${item['hcpId']} $stmps ${createdDateTimestamp}');
      await FirebaseFirestore.instance
          .collection('HCPWeeklyShift')
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('startOfWorkWeekTimestamp', isEqualTo: stmps)
          .get()
          .then((querySnapshot) async {
        print('line 2034: ${querySnapshot.docs.length}');
        if (querySnapshot.docs.length == 0) {
          throw Exception('Line 2036 no HCPWeeklyShifts returned from query');
        }
        var docSnapshot = querySnapshot.docs[0];
        documentId = docSnapshot.id;
        var obj = docSnapshot.data();
        print('line 2041: $obj');
        obj['id'] = docSnapshot.id;
        if (obj['cumulativePriorMinutes'] <= obj['baseMinutes']) {
          print('line 2044 skipping on minutes');
          return true;
        }
        print('line 2047');
        List<dynamic> listOfCreatedDateTimestamps =
            obj['listOfCreatedDateTimestamps'];
        print('line 2050: ${listOfCreatedDateTimestamps.length}');
        listOfCreatedDateTimestamps.sort((a, b) {
          return b['createdDateTimestamp'].compareTo(a['createdDateTimestamp']);
        });
        print('line 2054');
        int otMinutes = obj['cumulativePriorMinutes'] - obj['baseMinutes'];
        obj['otMinutes'] = otMinutes;
        double oth = double.parse((obj['otMinutes'] / 60).toStringAsFixed(2));
        print('line 2058: ${oth}');
        obj['otHours'] = oth;
        obj['weeklyOT'] = true;
        print('line 2061 ${otMinutes} ${obj['otHours']}');
        obj['cumulativePriorMinutes'] -= otMinutes;
        print('line 2063 ${otMinutes} ${obj['otHours']}');
        obj['cumulativePriorHours'] -= obj['otHours'];
        obj['cumulativeRegularHours'] -= obj['otHours'];
        print('line 2066 ${otMinutes}');
        obj['cumulativeRegularMinutes'] -= otMinutes;
        print(
            'line 2069" ${obj['cumulativePriorMinutes']} ${otMinutes} ${obj['otHours']} ${obj['weeklyOT']}');
        for (int i = 0; i < listOfCreatedDateTimestamps.length; i++) {
          if (otMinutes <= 0) {
            break;
          }
          var tbj = listOfCreatedDateTimestamps[i];
          print('line 2075: $tbj');
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
            print('line 2091: ${rbj}');
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
              print('line 2104 $l ${qbj}');
              List<dynamic> listOfShifts = qbj['listOfShifts'];
              print('line 2106: ${listOfShifts}');
              if (listOfShifts.length > 1) {
                listOfShifts.sort((a, b) {
                  return b['createdDateTimestamp']
                      .compareTo(a['createdDateTimestamp']);
                });
              }
              print('line 2113: $otMinutes ${listOfShifts.length}');
              for (int m = 0; m < listOfShifts.length; m++) {
                if (otMinutes == 0) {
                  break;
                }
                print('line 2118: ${listOfShifts[m]}');
                var wbj = listOfShifts[m];
                print('line 2120: ${wbj}');
                if (wbj == null) {
                  print('line 2122 skipping');
                  continue;
                }
                if (wbj.containsKey('shiftMinutes') == false) {
                  print('line 2126 skipping');
                  continue;
                }
                print('line 2129 $wbj');
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
      print('line 2180 error: ${e.toString()}');
      throw Exception('line 2181 error: ${e.toString()}');
    }
  }

  Future<bool> insertHCPWorkOrderData(
      Map<String, dynamic> item, int shiftMinutes) async {
    bool? bl1;
    print('line 1634 in insertHPWOrkOrderdata: $shiftMinutes');
    try {
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

      int minmod = shiftMinutes % 60;
      double dblmod =
          double.parse(((minmod.toDouble()) / 60.0).toStringAsFixed(2));
      double shrs =
          double.parse(((shiftMinutes.toDouble()) / 60.0).toStringAsFixed(2));
      item['shiftCreatedDate'] = item['shiftCreatedDate'] == null
          ? item['createdDate']
          : item['shiftCreatedDate'];
      print('line 1677: $shiftMinutes $shrs ${item['shiftCreatedDate']}');
      Timestamp crt = item['shiftCreatedDate'];
      DateTime crtd = crt.toDate();
      int createdDateTimestamp = crtd.millisecondsSinceEpoch;
      int holdOTMinutes = 0;
      double holdOTHours = 0.0;
      print('line 2236 ${item['hcpId']} $stmps ${createdDateTimestamp}');
      await FirebaseFirestore.instance
          .collection('HCPWeeklyShift')
          .where('hcpId', isEqualTo: item['hcpId'])
          .where('startOfWorkWeekTimestamp', isEqualTo: stmps)
          .get()
          .then((querySnapshot) async {
        print('line 2243: ${querySnapshot.docs.length}');
        if (querySnapshot.docs.length > 0) {
          var docSnapshot = querySnapshot.docs[0];
          var obj = docSnapshot.data();
          print('line 1692: $obj');
          obj['id'] = docSnapshot.id;
          obj['numberOfConfirmedShifts'] += 1;
          obj['cumulativePriorHours'] += shrs;
          obj['cumulativePriorMinutes'] += shiftMinutes;
          obj['cumulativeRegularHours'] += shrs;
          obj['cumulativeRegularMinutes'] += shiftMinutes;

          // if (obj['cumulativePriorMinutes'] > 2400) {
          //   obj['weeklyOT'] == true;
          //   int settledOTMinutes = 0;
          //   double settledOTHours = 0;
          //   print('line 1457');
          //   if (obj['listOfSettledOTMinutes'].length > 0) {
          //     List<dynamic> lsot = obj['listOfSettledOTMinutes'];
          //     settledOTMinutes = int.parse(lsot[lsot.length - 1].toString());
          //     List<dynamic> ldot = obj['listOfSettledOTHours'];
          //     settledOTHours = double.parse(ldot[ldot.length - 1].toString());
          //   }
          //   print('line 1464');
          //   obj['otMinutes'] += (obj['cumulativePriorMinutes'] -
          //       (obj['baseMinutes'] + settledOTMinutes));
          //   holdOTMinutes = (obj['cumulativePriorMinutes'] -
          //       (obj['baseMinutes'] + settledOTMinutes));
          //   obj['cumulativeOTMinutes'] = obj['otMinutes'];
          //   settledOTMinutes += int.parse(obj['otMinutes'].toString());
          //   obj['listOfSettledOTMinutes'].add(settledOTMinutes);
          //   double otm = (obj['otMinutes'] / 60).toDouble();
          //   holdOTHours = otm;
          //   otm = double.parse(otm.toStringAsFixed(2));
          //   obj['otHours'] += otm;
          //   obj['cumulativeOTHours'] = obj['otHours'];
          //
          //   settledOTHours += otm;
          //   obj['listOfSettledOTHours'].add(settledOTHours);
          // } else {
          obj['listOfSettledOTMinutes'] = [];
          obj['listOfSettledOTHours'] = [];
          obj['otMinutes'] = 0;
          obj['otHours'] = 0;
          obj['weeklyOT'] = false;
          //   }
          List<dynamic> listOfCreatedDates = obj['listOfCreatedDateTimestamps'];
          print('line 1478: ${listOfCreatedDates.length}');
          Map<String, dynamic>? createdDate;

          //  if (createdDate == null) {
          //need created date, client , day shift
          Map<String, dynamic> shift = {
            'confirmedShiftNumber': 1,
            'clientId': item['clientId'],
            'weekPosition': diffDay,
            'weekDay': shiftDay,
            'dateConfirmed': cdts,
            'createdDateTimestamp': createdDateTimestamp,
            'shiftPosition': shiftPosition,
            'shiftCode': item['shiftCode'],
            'shiftDate': item['shiftDate'],
            'shiftHours': shrs,
            'shiftMinutes': shiftMinutes,
            'startTime': item['shiftStartTime'],
            'originalStartTime': item['shiftStartTime'],
            'endTime': item['shiftEndTime'],
            'originalEndTime': item['shiftEndTime'],
            'meals': item['meals'],
            'shiftOvertime': obj['weeklyOT'],
            // 'regularMinutes': 0,
            // 'shiftPriorHours': 0,
            // 'shiftPriorMinutes': 0,
            'otHours': holdOTHours,
            'otMinutes': holdOTMinutes,
          };
          print('line 1512: check');
          List<Map<String, dynamic>> listOfShifts = [];
          listOfShifts.add(shift);
          Map<String, dynamic> day = {
            'numberOfConfirmedShifts': 1,
            'weekPosition': diffDay,
            'shiftDate': shiftDate,
            'weekDay': shiftDay,
            'dayOT': obj['weeklyOT'],
            'otHours': holdOTHours,
            'otMinutes': holdOTMinutes,
            'listOfShifts': listOfShifts
          };
          List<Map<String, dynamic>> listDays = [];
          listDays.add(day);

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
          print('line 1548: ${createdDate}');
          createdDate['listOfClients'].add(clm);
          obj['listOfCreatedDateTimestamps'].add(createdDate);
          final docRefx = await FirebaseFirestore.instance
              .collection('HCPWeeklyShift')
              .doc(obj['id']);
          docRefx.set(obj, SetOptions(merge: true));
          //       listT.sort((a, a) {
          //         return b['confirmedShiftNumber'].compareTo(b['shiftDate']);
          // if (cmp != 0) return cmp;
          //  return a['shiftCode'].compareTo(b['shiftCode']);
          // });
        } else {
          //no match on weekly data
          print('line 1632 no match for weekly data');
          List<dynamic> listDays = [{}, {}, {}, {}, {}, {}, {}];
          List<Map<String, dynamic>> listOfShifts = [];
          Map<String, dynamic> shift = {
            'confirmedShiftNumber': 1,
            'clientId': item['clientId'],
            'dateConfirmed': cdts,
            'weekPosition': diffDay,
            'weekDay': shiftDay,
            'createdDateTimestamp': createdDateTimestamp,
            'shiftPosition': shiftPosition,
            'shiftCode': item['shiftCode'],
            'shiftDate': item['shiftDate'],
            'shiftHours': shrs,
            'shiftMinutes': shiftMinutes,
            'startTime': item['shiftStartTime'],
            'originalStartTime': item['shiftStartTime'],
            'endTime': item['shiftEndTime'],
            'originalEndTime': item['shiftEndTime'],
            'meals': item['meals'],
            'shiftOverTime': false,
            'otHOurs': 0,
            'otMinutes': 0,
          };
          print('line 1655 ${shift}');
          listOfShifts.add(shift);
          Map<String, dynamic> day = {
            'numberOfConfirmedShifts': 1,
            'weekPosition': diffDay,
            'shiftDate': shiftDate,
            'weekDay': shiftDay,
            'dayOT': false,
            'otHours': 0,
            'otMinutes': 0,
            'listOfShifts': listOfShifts
          };
          print('line 1667: ${day}');
          listDays[diffDay] = day;
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
          print('line 1685: ${clm}');
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
          print('line 1706: ${hcpWo}');
          final docRefp = await FirebaseFirestore.instance
              .collection('HCPWeeklyShift')
              .doc();
          docRefp.set(hcpWo);
        }
      });
      // listOfCreatedDates.sort( (a,b) {
      //   return b['createdDateTimestamp'].compareTo(a['createdDateTimestamp']);
      //   });

      return true;
    } catch (e) {
      print('line 1711: error ${e.toString()}');
      throw Exception('Error inserting HCP work order data');
    }
  }

  Future<bool> updateClientWorkOrderCampaign(
      String documentId, String startTime, String endTime) async {
    print('line 1889 in updateCWOC');
    try {
      await FirebaseFirestore.instance
          .collection('ClientWorkOrderCampaign')
          .doc(documentId)
          .update({'startTime': startTime, 'endTime': endTime});
      return true;
    } catch (e) {
      print('line 1893: error ${e.toString()}');
      throw Exception('line 1895 error: ${e.toString()}');
    }
  }
// Future<Map<String, dynamic>> updateShiftTime(
//     Map<String, dynamic> item, Map<String, dynamic> data) async {
//   try {
//     print('line 1538 in updateshifttime: $data');
//     int potentialOTMinutes = 0;
//     double potentialOTHours = 0.0;
//     DateTime cdt = DateTime.now();
//     Timestamp cdts = Timestamp.fromDate(cdt);
//     print('line 1543');
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
//     print(
//         'line 1554: ${item['shiftStatus']} ${item['clientId']} ${item['shiftCreatedDate']}');
//     int diffDay = shiftDay - 1; //eg
//     Timestamp ts = item['shiftCreatedDate'];
//     DateTime scrdt = ts.toDate();
//     int scrdtmin = scrdt.millisecondsSinceEpoch;
//     print('line 1560: $scrdtmin');
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
//     print('line 1573');
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
//         print('line 1586: ${obj['cumulativePriorMinutes']}');
//         List<dynamic> listCreatedDates = obj['listOfCreatedDateTimestamps'];
//         print('line 1592: ${listCreatedDates.length}');
//         for (int i = 0; i < listCreatedDates.length; i++) {
//           var tbj = listCreatedDates[i];
//           print('line 1708: ${tbj['createdDateTimestamp']}');
//           String str = tbj['createdDateTimestamp'].toString();
//           str = str.substring(0, str.length - 3);
//           str += '000';
//           int dtms = int.parse(str);
//           print('line 1598: $dtms $scrdtmin');
//           if (dtms != scrdtmin) {
//             print('line 1600: $dtms $scrdtmin');
//             continue;
//           }
//           print('line 1603: $dtms $scrdtmin');
//           List<dynamic> listOfClients = tbj['listOfClients'];
//           for (int j = 0; j < listOfClients.length; j++) {
//             var cbj = listOfClients[j];
//             print('line 1607 check');
//             List<dynamic> listOfWorkShiftDays = cbj['listOfWorkShiftDays'];
//             List<dynamic>? listOfShifts;
//             print('line 1610 check');
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
//     print('line 1672: $potentialOTHours $potentialOTMinutes');
//     Map<String, dynamic> mp = {
//       'shiftHours': shiftHours,
//       'otHours': shiftOTHours,
//       'shiftOverTime': shiftOvertime,
//       'startTime': shiftStartTime,
//       'endTime': shiftEndTime,
//     };
//     print('line 1680: ${mp}');
//     return mp;
//   } catch (e) {
//     print('line 1683: error ${e.toString()}');
//     throw Exception('line 1683 error: ${e.toString()}');
//   }
// }
}
