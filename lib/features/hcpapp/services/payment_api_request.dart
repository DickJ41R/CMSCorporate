import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class HCPPaymentDataService {
  HCPPaymentDataService();

  var stopTimerCount = 0;
  bool stopTimer = false;
  dynamic token;
  Timer? periodicTimer;

  Future<List<dynamic>> getPaymentData(
      String fromDate, String toDate, int hcpId, BuildContext ctx) async {
    try {
      List<dynamic> result = await callGetPayDataFromCheckRegisterFunction(
          hcpId, fromDate, toDate, ctx);
      print('line 22: $result');
      var retv = result[0];
      print('line 24: $retv');
      if (retv['error'] != null) {
        print('line 26 $retv');
        return [];
      }
      List<dynamic> ld = retv['payData'];
      return ld;
    } catch (e) {
      print('line 32 error: ${e.toString()}');
      return [];
    }
  }

  Future<dynamic> getHCPPaymentPDF(
      String checkRegisterId, String orgId, BuildContext ctx) async {
    try {
      dynamic result = await callGetPayDataPDFFromCheckRegisterFunction(
          checkRegisterId, orgId, ctx);
      print('line 43: $result');
      return result;
    } catch (e) {
      print('line 46 error: ${e.toString()}');
      return [];
    }
  }

  Future<dynamic>? getToken(String orgId) async {
    var client = http.Client();
    // const ura = 'https://api.stafferlink.com/asm/authenticate';
    // var orgId = dotenv.env['ASM_DB2'];
    var url = Uri.https('api.stafferlink.com', 'asm/authenticate');
    print('url:  $url');

    Map data = {
      'key': '30c39597a9604a979e9430ee5794fab6',
      'secret': 'a594b1ede33b48e7bed9418c6fd50e43',
      'orgId': orgId
    };
    var body = json.encode(data);
    print('body: $body');
    // headers: {"Content-Type": "application/json"},
    try {
      http.Response response = await client.post(url,
          headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        String data = response.body;
        var jsonDecodedData = json.decode(data);
        print('jsonDecodedData with access token: $jsonDecodedData');
        var token = jsonDecodedData['accessToken'];
        print('Data:  $token');
        return token;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> callGetPayDataPDFFromCheckRegisterFunction(
      String checkRegisterId, String orgId, BuildContext ctx) async {
    try {
      var client = http.Client();
      dynamic token = await getToken(orgId);
      Map<String, String>? hdrs = {
        "Accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };

      //  var encodedHeaders = json.encode(hdrs);
      print('Hdrs: $hdrs');

      var url = 'https://api.stafferlink.com/asm/Payroll/Stub/$checkRegisterId';
      http.Response response = await client.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
      });
      print('line 107: ${response.headers}');
      dynamic imageData;
      if (response.statusCode == 200) {
        print('line 110: ${response.headers}');
        print('line 111: ${response.headers['content-type']}');
        if (response.headers['content-type'] == 'application/pdf') {
          // Display image
          print('line 114: ${response.bodyBytes}');
          imageData = response.bodyBytes;

          return imageData;
        } else {
          print('line 119: ${response.bodyBytes}');
          imageData = response.bodyBytes;
          // File ff = await _localFile;
          //
          // ff.writeAsBytes(imageData);
          return imageData;
        }
      } else {
        throw Exception('line 127 bad status code: ${response.statusCode}');
      }
// Display image
    } catch (e) {
      print('line 131 $e');
      throw Exception(e);
    }
  }

  // Future<List<dynamic>> callingGetPayDataPDFFromCheckRegisterFunction(
  //     HttpsCallable callable, String checkRegisterId, BuildContext ctx) async {
  //   try {
  //     print('line 133 $checkRegisterId ');
  //     var data = {"checkRegisterId": checkRegisterId};
  //
  //     final HttpsCallableResult result = await callable(data);
  //     print('line 137 ${result.data}');
  //     var convertedResult = result.data;
  //     print('line 139 $convertedResult');
  //     return convertedResult;
  //   } catch (e) {
  //     print('line 142 error: $e');
  //     throw Exception('line 143  ${e.toString()}');
  //   }
  // }

  Future<List<dynamic>> callGetPayDataFromCheckRegisterFunction(
      int regId, String fromDate, String toDate, BuildContext ctx) async {
    print('line 1936: $regId ');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'getHCPPaymentData06',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      print('line 90 in call A  function: $callable');
      dynamic result = await callingGetPayDataFromCheckRegisterFunction(
          callable, regId, fromDate, toDate, ctx);
      print('line 93: $result');
      return result;
    } catch (e) {
      print('line 96 error : $e');
      throw Exception('line 97: ${e.toString()}');
    }
  }

  Future<List<dynamic>> callingGetPayDataFromCheckRegisterFunction(
      HttpsCallable callable,
      int regId,
      String fromDate,
      String toDate,
      BuildContext ctx) async {
    try {
      print('line 108 $regId ');
      var data = {"hcpId": regId, "fromDate": fromDate, 'toDate': toDate};

      final HttpsCallableResult result = await callable(data);
      print('line 112 ${result.data}');
      var convertedResult = result.data;
      print('line 114 $convertedResult');
      return convertedResult;
    } catch (e) {
      print('line 117 error: $e');
      throw Exception('line 118  ${e.toString()}');
    }
  }

//   var client = http.Client();
//   {
//     dynamic token = await getToken();
//
//     Map<String, String>? hdrs = {
//       "Accept": "*/*",
//       "Content-Type": "application/json",
//       "Authorization": "Bearer $token"
//     };
//
//     //  var encodedHeaders = json.encode(hdrs);
//     print('Hdrs: $hdrs');
//
//     var url = 'https://api.stafferlink.com/asm/Payroll/Stub/$checkRegisterId';
//     print('url: $url');
//     http.Response response2 = await client.get(
//       Uri.parse(url),
//       headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
//       // headers: {
//       //   HttpHeaders.authorizationHeader: 'Bearer $token',
//       // },
//     );
//     print('line 64:res list prvd getRegistrant ${response2.statusCode}');
//     dynamic jsonDecodedData;
//     if (response2.statusCode == 200) {
//       String data = response2.body;
//       jsonDecodedData = json.decode(data);
//       // print(jsonDecodedData);
//       dynamic paymentData = jsonDecodedData[0];
//       print('payments: $paymentData');
//       dynamic details = {
//         "paymentData": paymentData,
//       };
//       return details;
//     } else {
//       print('rsp2 body: ${response2.body}');
//       print('Error: ${response2.statusCode} : ${response2.reasonPhrase}');
//       return null;
//     }
//   }
//
// }
}
