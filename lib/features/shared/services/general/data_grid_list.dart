//dagaridg list
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:cms_web/features/shared/services/workorderapp/workorder_services.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';


class DataGridList {
  UtilitiesServices util = UtilitiesServices();
  ClientServices clientServices = ClientServices();
  HCPServices hcpServices = HCPServices();

  Future<List<Map<String, dynamic>>>? getQueriedData(
      Map<String, dynamic>arguments, String targetValue) async {
    debugPrint('line 10 in datagrid list: $arguments $targetValue');
    List<Map<String, dynamic>>? clm;
    try {
      Query query = util.buildDynamicQuery(arguments!);
      debugPrint('line 182: $query');
      if (targetValue == 'Client') {
        clm = await clientServices.getQueryData(query);
      } else if (targetValue == 'HCProfessional') {
        //  clm = await hcpServices.getQueryData(query);

      } else {
        //work orders
        // clm = await workOrderServices.getQueryData(query);
      }

      return clm!;
    } catch (e) {
      debugPrint('line 262: ${e.toString()}');
      throw Exception('line 124 Error getting client data');
    }
  }

}