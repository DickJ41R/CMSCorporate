import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_timecard_service.dart';
//import 'package:hcp_app/models/client_models/client_work_order_campaign.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cms_web/features/shared/services/clientapp/client_work_order_campaign_service.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ProcessFunctionsApp extends StatefulWidget {
  final Map<String, dynamic> args;
  const ProcessFunctionsApp({super.key, required this.args});

  @override
  _ProcessFunctionsAppState createState() => _ProcessFunctionsAppState();
}

class _ProcessFunctionsAppState extends State<ProcessFunctionsApp> {
  dynamic hcpUser;
  Users? user;
  dynamic currentUser;
  ClientWorkOrderCampaignService clw = ClientWorkOrderCampaignService();
  HCPTimeCardService hcpTimeCardService = HCPTimeCardService();
  HCPServices hcpUserServices = HCPServices();

  AuthService authService = AuthService();
  int? hcpId;
  String? gEmail;

  _ProcessFunctionsAppState();

  Future<void>? loadPdf() async {
    int x = 0;
    if (x == 0) {
      return;
    }
    try {
      //  dynamic result = await loadPdfFileToStafferLink('/Users/richardrovinelli/Downloads/logo.png', 903276);
      //    debugPrint('line 135: $result');
      return;
    } catch (e) {
      debugPrint('line 146 $e');
    }
    return;
  }

  Future<List<int>> _readData(String name, int type) async {
    debugPrint('line 384 readdata: $name');
    if (name.contains('logo') == true) {
      final ByteData data = await rootBundle.load('assets/$name');
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    } else if (name.contains('signature') == true) {
      final ByteData data = await rootBundle.load(name);
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    } else {
      final ByteData data = await rootBundle.load(name);
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    }
  }

  Future<File>? readFileData(String name) async {
    File? file = await File(name);
    return file;
  }

  Future<FormData> createFormData(String pdfFileName, String fileName) async {
    return FormData.fromMap({
      "name": 'dio',
      'date': DateTime.now().toIso8601String(),
      'files': [
        await MultipartFile.fromFileSync(pdfFileName, filename: fileName),
      ],
    });
  }

  Map<String, dynamic>? arguments;
  @override
  void initState() {
    super.initState();

    arguments = widget.args;
    hcpId = arguments!['hcpId'];
    debugPrint('line 39: ${hcpId!} $clw');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('line 63 didchange');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;

  double h = 1.0;
  double fontSize = 18;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    double? hh = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    h = hh!;
    if (h < 1.0) {
      h = 1.0;
    }
    fontSize = 18;
    fontSize /= h;
    double smallFontSize = 14;
    smallFontSize /= h;
    debugPrint('line 40 icall a function');
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: Text(
          "Call A function",
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black87,
          ),
        ),
        leading: GestureDetector(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () {
              final navigator = Navigator.of(context)
                  .pushNamed(landingPageWeb, arguments: arguments!);
            },
          ),
        ),
      ),
      body: Container(
        height: 40,
        width: screenWidth - 10,
        child: SizedBox(
          height: 10,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color2, // const Color(0xff0D6EFD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              minimumSize: const Size(double.infinity, 60),
              elevation: 0,
            ),
            onPressed: () async {
              // int iv = await callAFunction (context);
              loadPdf();
              debugPrint('line 319');
            },
            child: Container(
                height: 32,
                width: screenWidth - 10,
                child: Text("Call A Function",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
          ),
        ),
      ),
    );
  }
}
