import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/hcpapp/payment_api_request.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class HCPShowPaymentPDF extends StatefulWidget {
  final Map<String,dynamic>args;
  const HCPShowPaymentPDF(
      {super.key,
        required this.args});


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

  int? hcpId;
  String? checkRegisterId;
  String? orgId;
  BuildContext? ctx;
  Map<String,dynamic>?menuArgs;
  Map<String, dynamic>? arguments;

  Future<dynamic> getAsyncData(BuildContext ctx) async {
    HCPPaymentDataService hcps = HCPPaymentDataService();
    // dynamic imageData;
    try {
      debugPrint('line 37: checkregisterID ${checkRegisterId!}');
      imgData = await hcps.getHCPPaymentPDF(
          checkRegisterId!, orgId!, ctx);
      if (imgData == null) {
        throw Exception('line 39 imgdata == null');
      }
      debugPrint('line 41: ${imgData.length}');
      return imgData;
    } catch (e) {
      debugPrint('line 43 nothing returned from gethcppaymentpdf ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('line 55 ${widget.args}');
    arguments = widget.args;
    hcpId = int.parse(arguments!['hcpId'].toString());
    checkRegisterId = arguments!['checkRegisterId'].toString();
    orgId = arguments!['orgId'];
    ctx = arguments!['ctx'];
    menuArgs = arguments!['menuArgs'];
    debugPrint('line 62: $hcpId');
    debugPrint('line 63: $checkRegisterId');

  }

  //  void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   HCPPaymentDataService hcps = HCPPaymentDataService();
  //
  //   try {
  //    imgData =  await hcps.getHCPPaymentPDF(widget.checkRegisterId);
  //    debugPrint('line 41: ${imgData['imageData'].length}');
  //    isReady = true;
  //   } catch (e) {
  //     debugPrint('line 65 error: $e');
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
      body: SizedBox(
        height: 1024,
        width: screenWidth! -10,
        child: Column(
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
                   //   debugPrint('line 140 has data $data');
                      // debugPrint('line 137: $data');
                        return SizedBox(
                        height: 1000,
                        width: screenWidth! - 10,

                        // child: SfPdfViewer.network("https://api.stafferlink.com/asm/Payroll/Stub/2570211"
                         child: SfPdfViewer.memory(data,
                         onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                          print('${details.error}');
                          print('${details.description}');
                        }),
                        );
                         //                       child: SfPdfViewer.memory(data),

                      //SizedBox(height: 5);
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
                      return SizedBox(
                         height: 150,
                        child: Column(
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
                                    arguments: menuArgs!);
                              },
                              child: Center(
                                child: Container(
                                  height: 40,
                                  width: 80,
                                  child: Center(
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
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return Container(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
                future: getAsyncData(context))
          ],
        ),
      ),
    );
  }
}
