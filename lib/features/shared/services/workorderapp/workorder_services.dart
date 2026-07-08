//workorder services
import 'package:flutter/material.dart';


class WorkOrderServices {
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


}