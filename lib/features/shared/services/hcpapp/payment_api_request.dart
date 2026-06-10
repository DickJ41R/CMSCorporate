//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'dart:js_interop';
import 'package:web/web.dart';

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
     // debugPrint('line 22: $result');
      var retv = result[0];
      debugPrint('line 24: $retv');
      if (retv['error'] != null) {
        debugPrint('line 26 $retv');
        return [];
      }
      List<dynamic> ld = retv['payData'];
      return ld;
    } catch (e) {
      debugPrint('line 32 error: ${e.toString()}');
      return [];
    }
  }

  Future<dynamic> getHCPPaymentPDF(
      String checkRegisterId, String orgId, BuildContext ctx) async {
    try {
      dynamic result = await callGetPayDataPDFFromCheckRegisterFunction(
          checkRegisterId, orgId, ctx);
     // debugPrint('line 43: $result');
      return result;
    } catch (e) {
      debugPrint('line 46 error: ${e.toString()}');
      return [];
    }
  }

  // Future<dynamic>? getToken(String orgId) async {
  //   var client = http.Client();
  //   // const ura = 'https://api.stafferlink.com/asm/authenticate';
  //   // var orgId = dotenv.env['ASM_DB2'];
  //   var url = Uri.https('api.stafferlink.com', 'asm/authenticate');
  //   debugPrint('url:  $url');
  //
  //   Map data = {
  //     'key': '30c39597a9604a979e9430ee5794fab6',
  //     'secret': 'a594b1ede33b48e7bed9418c6fd50e43',
  //     'orgId': orgId
  //   };
  //   var body = json.encode(data);
  //   debugPrint('body: $body');
  //   // headers: {"Content-Type": "application/json"},
  //   try {
  //     http.Response response = await client.post(url,
  //         headers: {"Content-Type": "application/json", 'Access-Control-Allow-Origin': 'true', "Accept": "*/*"}, body: body);
  //     if (response.statusCode == 200) {
  //       String data = response.body;
  //       var jsonDecodedData = json.decode(data);
  //       debugPrint('jsonDecodedData with access token: $jsonDecodedData');
  //       var token = jsonDecodedData['accessToken'];
  //       debugPrint('Data:  $token');
  //       return token;
  //     }
  //   } catch (e) {
  //     debugPrint('line 76: ${e.toString()}');
  //     return null;
  //   }
  // }
  Future<dynamic> callGetPayDataPDFFromCheckRegisterFunction(
      String checkRegisterId,String orgId, ctx) async {
    Uint8List? uint;
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'getCheckRegisterPdfFile16',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      debugPrint('line 95 in call A  function: $callable');
      debugPrint('line 96: $checkRegisterId');

      dynamic imageData = await callingGetPayDataPDFFromCheckRegisterFunction(callable, checkRegisterId.toString(), ctx);
    //  debugPrint('line 99 : ${imageData} ');
        return imageData;

    } catch (e) {
      debugPrint('line 1986: $e');
      return  uint;
      // throw Exception('line 1168: ${e.toString()}');
    }
  }

  Future<dynamic> callingGetPayDataPDFFromCheckRegisterFunction(HttpsCallable callable,
      String checkRegisterId, BuildContext ctx) async {
    try {
      var data = {
        'checkRegisterId': checkRegisterId
      };
      final HttpsCallableResult result = await callable(data);
   //   debugPrint('line 116 returned with data: ${result.data}');
      debugPrint('line 117:  ${result.data.runtimeType}');
      final bytes = List<int>.from(result.data.values);
      dynamic uint = Uint8List.fromList(bytes);
  //    print('line 120 $uint');
      return uint;
      // dynamic imageData = result.data;
      //
      // Uint8List uint8List = Uint8List.view(imageData);
      // return  uint8List;
    } catch (e) {
      debugPrint('line 122 error: $e');
      throw Exception('line 123  ${e.toString()}');
    }
  }

  // Future<List<dynamic>> callingGetPayDataPDFFromCheckRegisterFunction(
  //     HttpsCallable callable, String checkRegisterId, BuildContext ctx) async {
  //   try {
  //     debugPrint('line 133 $checkRegisterId ');
  //     var data = {"checkRegisterId": checkRegisterId};
  //
  //     final HttpsCallableResult result = await callable(data);
  //     debugPrint('line 137 ${result.data}');
  //     var convertedResult = result.data;
  //     debugPrint('line 139 $convertedResult');
  //     return convertedResult;
  //   } catch (e) {
  //     debugPrint('line 142 error: $e');
  //     throw Exception('line 143  ${e.toString()}');
  //   }
  // }

  Future<List<dynamic>> callGetPayDataFromCheckRegisterFunction(
      int regId, String fromDate, String toDate, BuildContext ctx) async {
    debugPrint('line 1936: $regId ');
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'getHCPPaymentData06',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 300),
        ),
      );

      debugPrint('line 90 in call A  function: $callable');
      dynamic result = await callingGetPayDataFromCheckRegisterFunction(
          callable, regId, fromDate, toDate, ctx);
      //debugPrint('line 93: $result');
      return result;
    } catch (e) {
      debugPrint('line 96 error : $e');
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
      debugPrint('line 108 $regId ');
      var data = {"hcpId": regId, "fromDate": fromDate, 'toDate': toDate};

      final HttpsCallableResult result = await callable(data);
      //debugPrint('line 112 ${result.data}');
      var convertedResult = result.data;
//      debugPrint('line 114 $convertedResult');
      return convertedResult;
    } catch (e) {
      debugPrint('line 117 error: $e');
      throw Exception('line 118  ${e.toString()}');
    }
  }
  Future<Uint8List> convertBlobToUint8List(Blob blob) async {
    // 1. Get the ArrayBuffer from the Blob (returns a JSPromise)
    try {
      debugPrint('line 189');

      final jsPromise = blob.arrayBuffer();
      debugPrint('line 192');
      // 2. Await the JS promise and convert it to a Dart object
      final jsArrayBuffer = await jsPromise.toDart;
      debugPrint('line 195');
      // 3. Cast the ArrayBuffer buffer directly into a Dart Uint8List view
      return Uint8List.view(jsArrayBuffer.toDart);
      debugPrint('line 198');
    } catch(e) {
      debugPrint('line 200: ${e.toString()}');
      throw Exception(e.toString());
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
//     debugPrint('Hdrs: $hdrs');
//
//     var url = 'https://api.stafferlink.com/asm/Payroll/Stub/$checkRegisterId';
//     debugPrint('url: $url');
//     http.Response response2 = await client.get(
//       Uri.parse(url),
//       headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
//       // headers: {
//       //   HttpHeaders.authorizationHeader: 'Bearer $token',
//       // },
//     );
//     debugPrint('line 64:res list prvd getRegistrant ${response2.statusCode}');
//     dynamic jsonDecodedData;
//     if (response2.statusCode == 200) {
//       String data = response2.body;
//       jsonDecodedData = json.decode(data);
//       // debugPrint(jsonDecodedData);
//       dynamic paymentData = jsonDecodedData[0];
//       debugPrint('payments: $paymentData');
//       dynamic details = {
//         "paymentData": paymentData,
//       };
//       return details;
//     } else {
//       debugPrint('rsp2 body: ${response2.body}');
//       debugPrint('Error: ${response2.statusCode} : ${response2.reasonPhrase}');
//       return null;
//     }
//   }
//
// }
}
