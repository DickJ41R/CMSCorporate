import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class ClientInvoiceShowPDF extends StatefulWidget {
  const ClientInvoiceShowPDF({super.key, required this.invoiceUrl});

  final String invoiceUrl;

  @override
  State<ClientInvoiceShowPDF> createState() => _ClientInvoiceShowPDFState();
}

class _ClientInvoiceShowPDFState extends State<ClientInvoiceShowPDF> {
  // late PdfViewerController _pdfViewerController;
  // final GlobalKey<
  //     SfPdfViewerState> _pdfViewerStateKey = GlobalKey(); //"Ngo9BigBOggjHTQxAR8/V1NAaF5cWWJCfEx1WmFZfVpgdVdMZFxbR3NPIiBoS35RckViW3hfcnBVRWVcWEV3";
  //
  String pathPDF = "";
  String landscapePathPdf = "";
  String remotePDFPath = "";
  String corruptedPathPDF = "";
  late String invoiceUrl;

  @override
  void initState() {
    super.initState();
    // createFileOfPdfUrl().then((f) {
    //   print('line 34: ${f.path}');
    //   setState(() {
    //     remotePDFPath = f.path;
    //   });
    // });
    invoiceUrl = widget.invoiceUrl;
  }

  // Future<File> createFileOfPdfUrl() async {
  //   Completer<File> completer = Completer();
  //   print("Start download file from internet!");
  //   try {
  //     // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
  //     // final url = "https://pdfkit.org/docs/guide.pdf";
  //     final url = widget.invoiceURL;

  // final filename = url.substring(url.lastIndexOf("/") + 1);
  // var request = await HttpClient().getUrl(Uri.parse(url));
  // var response = await request.close();
  // print('line 50: $response');
  // var bytes = await consolidateHttpClientResponseBytes(response);
  // var dir = await getApplicationDocumentsDirectory();
  // print("line 52 Download files $url $dir");
  // print("${dir.path}/$filename");
  // File file = File("${dir.path}/$filename");
  // print('line 60: ${bytes.length}');
  // await file.writeAsBytes(bytes, flush: true);
  // completer.complete(file);
  //   completer.future.then( (value) {
  //     print('line 60 completerutue: $value');
  //   }).catchError( (error) {
  //     print('error: $error');
  // });
  //     print('line 63 exiting');
  //   } catch (e) {
  //     print('line 65 error: $e');
  //     throw Exception('Error parsing pdf file!');
  //   }
  //
  // //  return completer.future;
  // }
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
    fontSize = 16;
    fontSize /= h;
    return Scaffold(
      backgroundColor: color1,
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
        title: const Text("Invoice Document"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 160,
              width: screenWidth - 10,
              // child: ElevatedButton(
              // style:
              //   ButtonStyle(
              //   backgroundColor: WidgetStateProperty.resolveWith<Color>(
              //   (Set<WidgetState> states) {
              //   if (states.contains(WidgetState.pressed))
              //   return color2;
              //   return color1; // Use the component's default.
              //   },
              //   ),
              //   ),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: screenWidth - 10,
                    child: Text(
                      "After you press the button below, follow the presented instructions.",
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // SizedBox(height: 20),
                  // Container(
                  //   height: 80,
                  //   width: screenWidth - 10,
                  //   child: SelectableText("$invoiceURL",
                  //     showCursor: true,
                  //     cursorWidth: 2,
                  //     cursorColor: color2,
                  //     maxLines: 4,
                  //     cursorRadius: Radius.circular(2),
                  //     style: TextStyle(
                  //       fontSize: fontSize,
                  //       color: Colors.black87,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  Container(
                    height: 32,
                    width: screenWidth - 10,
                    decoration: BoxDecoration(
                        color: color1,
                        border: Border.all(color: color2),
                        borderRadius: BorderRadius.circular(12)),
                    child: ElevatedButton(
                      onPressed: () {
                        final Uri _url = Uri.parse(invoiceUrl);
                        launch(invoiceUrl);
                      },
                      child: Text(
                        'Press to View Invoice PDF',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      //     body: SfPdfViewer.network(
      //         widget.invoiceURL,
      //         controller: _pdfViewerController,
      //         key: _pdfViewerStateKey),
      //     appBar: AppBar(
      //         title: Text('Invoice Details PDF',
      //             style: TextStyle(
      //               fontSize: 24,
      //               fontWeight: FontWeight.bold,
      //               color: Theme
      //                   .of(context)
      //                   .colorScheme
      //                   .onBackground,
      //             )),
      //         leading: IconButton(icon: const Icon(Icons.arrow_back),
      //           onPressed: () {
      //             Navigator.pop(context);
      //           },
      //         ),
      //     //     actions: [
      //     //       IconButton(
      //     //           onPressed: () {
      //     //             _pdfViewerStateKey.currentState!.openBookmarkView();
      //     //           },
      //     //           icon: const Icon(
      //     //             Icons.bookmark,
      //     //             color: Colors.white,
      //     //             semanticLabel: "Click to show PDF!",
      //     //           )),
      //     // ],
    );
  }

  Future<void> launch(String url, {bool isNewTab = true}) async {
    await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String? path;

  PDFScreen({Key? key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? total = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("PDF of Invoice")),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            SizedBox(height: 50),
            PDFView(
              filePath: widget.path,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: currentPage!,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation:
                  false, // if set to true the link is handled in flutter
              onRender: (_pages) {
                setState(() {
                  pages = _pages;
                  print('line 173: $_pages');
                  currentPage = 0;
                  isReady = true;
                });
              },
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
                print(error.toString());
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$page: ${error.toString()}';
                });
                print('$page: ${error.toString()}');
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onLinkHandler: (String? uri) {
                print('goto uri: $uri');
              },
              onPageChanged: (int? page, int? total) {
                //  print('page change: $page/$total');
                setState(() {
                  currentPage = page;
                });
              },
            ),
            errorMessage.isEmpty
                ? !isReady
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container()
                : Center(
                    child: Text(errorMessage),
                  )
          ],
        ),
        floatingActionButton: FutureBuilder<PDFViewController>(
          future: _controller.future,
          builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
            if (snapshot.hasData) {
              return Container(); //FloatingActionButton.extended(
              //   label:  Text('Next Page: $pages'),
              //   onPressed: () async {
              //     pages = pages! +1;
              //     await snapshot.data!.setPage(pages!);
              //   },
              // );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
