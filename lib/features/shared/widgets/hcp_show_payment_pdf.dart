import 'package:flutter/material.dart';
import 'package:cms_web/features/hcpapp/services/payment_api_request.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class HCPShowPaymentPDF extends StatefulWidget {
  const HCPShowPaymentPDF(
      {super.key,
      required this.hcpId,
      required this.checkRegisterId,
      required this.orgId,
      required this.args});

  final String hcpId;
  final String checkRegisterId;
  final String orgId;
  final Map<String, dynamic> args;
  //final Uint8List imageData;

  @override
  State<HCPShowPaymentPDF> createState() => _HCPShowPaymentPDFState();
}

class _HCPShowPaymentPDFState extends State<HCPShowPaymentPDF> {
  String pathPDF = "";
  String landscapePathPdf = "";
  String remotePDFPath = "";
  String corruptedPathPDF = "";
  late dynamic token;
  late dynamic imgData;
  late dynamic data;

  Future<dynamic> getAsyncData(BuildContext ctx) async {
    HCPPaymentDataService hcps = HCPPaymentDataService();
    // dynamic imageData;
    try {
      print('line 37: checkregisterID ${widget.checkRegisterId}');
      imgData = await hcps.getHCPPaymentPDF(
          widget.checkRegisterId, widget.orgId, ctx);
      if (imgData == null) {
        throw Exception('line 39 imgdata == null');
      }
      print('line 41: ${imgData.length}');
      return imgData;
    } catch (e) {
      print('line 43 nothing returned from gethcppaymentpdf ${e.toString()}');
    }
  }

  Map<String, dynamic>? arguments;
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
  }

  //  void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   HCPPaymentDataService hcps = HCPPaymentDataService();
  //
  //   try {
  //    imgData =  await hcps.getHCPPaymentPDF(widget.checkRegisterId);
  //    print('line 41: ${imgData['imageData'].length}');
  //    isReady = true;
  //   } catch (e) {
  //     print('line 65 error: $e');
  //     throw Exception('Error parsing pdf file!');
  //   }
  // }
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double? screenWidth;
  double? screenHeight;
  double fontSize = 18;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 18;
    fontSize /= h;
    double smallFontSize = 16;
    smallFontSize /= h;

    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color.fromARGB(255, 13, 125, 103),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                //getMessageStream();
                Navigator.pop(context);
              }),
        ],
        title: const Text("HCP Payment Document"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              builder: (ctx, AsyncSnapshot snapshot) {
                // Checking if future is resolved or not
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: TextStyle(fontSize: fontSize),
                      ),
                    );
                    // if we got our data
                  } else if (snapshot.hasData) {
                    // Extracting data from snapshot object
                    data = snapshot.data;
                    return SingleChildScrollView(
                      child: Container(
                        height: screenHeight! - 150,
                        width: screenWidth! - 10,
                        child: SfPdfViewer.memory(data),
                      ),
                    );
                    // SizedBox(height: 5);
                    // Container(
                    //   height: 24,
                    //   child: const Center(
                    //     child: Text(
                    //       "(Horizontal Scrolling Of Pages)",
                    //       style: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold,
                    //           color: Color.fromARGB(255, 19, 125, 103)),
                    //     ),
                    //   ),
                    // );
                    // SizedBox(height: 5);
                    // Container(
                    //   height: 24,
                    //   child: const Center(
                    //     child: Text(
                    //       "Use Escape Key to Exit Viewer)",
                    //       style: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold,
                    //           color: Color.fromARGB(255, 19, 125, 103)),
                    //     ),
                    //   ),
                    // );
                  } else {
                    return Column(
                      children: [
                        Container(
                            height: 40,
                            width: screenWidth! - 10,
                            child: Center(
                              child: Text('No PDF Data'),
                            )),
                        ElevatedButton(
                          onPressed: () {
                            final navigator = Navigator.of(context).pushNamed(
                                hcpSchedulingMenu,
                                arguments: arguments!);
                          },
                          child: Container(
                            height: 40,
                            width: screenWidth! - 10,
                            child: Text(
                              'Exit',
                              style: TextStyle(
                                fontSize: smallFontSize,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              future: getAsyncData(context))
        ],
      ),
    );
  }
}
