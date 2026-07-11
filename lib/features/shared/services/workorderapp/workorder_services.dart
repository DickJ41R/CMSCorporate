import "package:cloud_firestore/cloud_firestore.dart";
//workorder services
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkOrderServices {

  String getFormattedDate(DateTime dte) {
    DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(dte);
    return formatted;
  }
  String  deriveShiftTime(String shiftCode,String calcType,String startTime,String endTime,int meals) {
  String shiftTime = shiftCode;
  shiftTime += '[' + calcType + ']';
  int sidx = startTime.indexOf('AM');
  String sampm = 'A';
  String  ampm='P';
  if (sidx == -1) {
  sampm = 'P';

  sidx = startTime.indexOf('PM');
  }
  int idx = endTime.indexOf('PM');
  if (idx == -1) {
  ampm = 'A';
  idx = endTime.indexOf('AM');
  }

  String st = startTime.substring(0,sidx);
  st = st.trim();
  List<String>lst = st.split(':');
  if (lst.length == 1) {
  shiftTime += lst[0];
  shiftTime += sampm;
  } else {
  if (lst[1] == '00') {
  shiftTime += lst[0];
  shiftTime += sampm;
  } else {
  shiftTime += (lst[0]+':' + lst[1]+ sampm);
  }
  }
  shiftTime += '-';
  String et = endTime.substring(0,idx);
  et = et.trim();
  List<String> etl = et.split(':');
  if (etl.length == 1) {
  shiftTime += etl[0];
  shiftTime += ampm;
  } else {
  if (etl[1] == '00') {
  shiftTime += etl[0];
  shiftTime += ampm;
  } else {
  shiftTime += (etl[0]+':' + etl[1]+ ampm);
  }
  }
  shiftTime += '(' + meals.toString() + ')';
  return shiftTime;
  }

  Future<List<Map<String,dynamic>>>? getQueryData(Query query) async {
    List<Map<String,dynamic>>? listOfWorkOrders;
    try {

      listOfWorkOrders = [];
      QuerySnapshot querySnapshot = await query.get();

      for (var docSnapShot in querySnapshot.docs) {
        debugPrint('line 3041: ${querySnapshot.docs.length}');
        Map<String, dynamic> obj = docSnapShot.data() as Map<String, dynamic>;
        obj['id'] = docSnapShot.id;
      //  debugPrint('line 3044 in querysnapshot: $obj');
        Timestamp sdts = obj['dates']['rates']['rateDetails']['shiftDate'];
        DateTime dts = sdts.toDate();
        String fdts = getFormattedDate(dts);
        obj['shiftDate'] = fdts;
        if (obj['hcpName'] == null || obj['hcpName'] == '') {
          obj['hcpName'] = 'Shift is Open';
        }
        if (obj['dates']['rates']['rateDetails']['isAHoliday']) {

          obj['grossMargin'] = (obj['dates']['rates']['rateDetails']['marginWE']).toStringAsFixed(2);
        } else {
          obj['grossMargin'] = (obj['dates']['rates']['rateDetails']['margin']).toStringAsFixed(2);
        }
        String shiftDateTime = deriveShiftTime(obj['dates']['rates']['rateDetails']['shiftCode'],
           obj['dates']['rates']['rateDetails']['calcType'],
           obj['dates']['rates']['rateDetails']['startTime'],
            obj['dates']['rates']['rateDetails']['endTime'],
            obj['dates']['rates']['rateDetails']['meals']);
        obj['shiftDateTime'] = shiftDateTime;
        debugPrint('line 91: wrko: $fdts $shiftDateTime ${obj['grossMargin']}');
        listOfWorkOrders.add(obj);
       debugPrint('line 3110: $obj');
      }
            debugPrint('line 3123 ${listOfWorkOrders.length}');
      return listOfWorkOrders;

    } catch(e) {
      debugPrint('line 3116 error: ${e.toString()}');
      return [];

    }

  }
  Future<Map<String,dynamic>>? getWorkOrder(int orderId) async {
    List<Map<String,dynamic>>? listOfWorkOrders;
    try {

      Map<String, dynamic>? obj;
      await FirebaseFirestore.instance.collection('ClientWorkOrder')
        .where('orderId',isEqualTo: orderId)
        .get()
        .then( (querySnapshot) {
         for (var docSnapShot in querySnapshot.docs) {
           debugPrint('line 3041: ${querySnapshot.docs.length}');
            obj = docSnapShot.data();
           obj!['id'] = docSnapShot.id;
           //  debugPrint('line 3044 in querysnapshot: $obj');
           Timestamp sdts = obj!['dates']['rates']['rateDetails']['shiftDate'];
           DateTime dts = sdts.toDate();
           String fdts = getFormattedDate(dts);
           obj!['shiftDate'] = fdts;
           if (obj!['hcpName'] == null || obj!['hcpName'] == '') {
             obj!['hcpName'] = 'Shift is Open';
           }
           if (obj!['dates']['rates']['rateDetails']['isAHoliday']) {
             obj!['grossMargin'] =
                 (obj!['dates']['rates']['rateDetails']['marginWE'])
                     .toStringAsFixed(2);
           } else {
             obj!['grossMargin'] =
                 (obj!['dates']['rates']['rateDetails']['margin'])
                     .toStringAsFixed(2);
           }
           String shiftDateTime = deriveShiftTime(
               obj!['dates']['rates']['rateDetails']['shiftCode'],
               obj!['dates']['rates']['rateDetails']['calcType'],
               obj!['dates']['rates']['rateDetails']['startTime'],
               obj!['dates']['rates']['rateDetails']['endTime'],
               obj!['dates']['rates']['rateDetails']['meals']);
           obj!['shiftDateTime'] = shiftDateTime;
           debugPrint(
               'line 91: wrko: $fdts $shiftDateTime ${obj!['grossMargin']}');
           debugPrint('line 3110: $obj');
         }
       });
      debugPrint('line 3123 $obj');
      return obj!;

    } catch(e) {
      debugPrint('line 3116 error: ${e.toString()}');
      throw Exception('line 155 error getting workorder');

    }

  }



}