import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class ShowHCPDocumentPDF extends StatefulWidget {
  const ShowHCPDocumentPDF({super.key, required this.imageData});

  final Uint8List imageData;

  @override
  State<ShowHCPDocumentPDF> createState() => _ShowHCPDocumentPDFState();
}

class _ShowHCPDocumentPDFState extends State<ShowHCPDocumentPDF> {
  // late PdfViewerController _pdfViewerController;
  // final GlobalKey<
  //     SfPdfViewerState> _pdfViewerStateKey = GlobalKey(); //"Ngo9BigBOggjHTQxAR8/V1NAaF5cWWJCfEx1WmFZfVpgdVdMZFxbR3NPIiBoS35RckViW3hfcnBVRWVcWEV3";
  //
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  String pathPDF = "";
  String landscapePathPdf = "";
  String remotePDFPath = "";
  String corruptedPathPDF = "";

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      print('line 34: ${f.path}');
      setState(() {
        remotePDFPath = f.path;
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("creating file pdf from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";

      Uint8List bytes = widget.imageData;
      var dir = await getApplicationDocumentsDirectory();
      var filename = 'my_pdf.pdf';
      print("line 49 pdf hcp: ${dir.path}/$filename");
      File file = File("${dir.path}/$filename");
      print('line 51: ${bytes.length}');
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
      //   completer.future.then( (value) {
      //     print('line 60 completerutue: $value');
      //   }).catchError( (error) {
      //     print('error: $error');
      // });
      print('line 63 exiting ${file.path}');
    } catch (e) {
      print('line 65 error: $e');
      throw Exception('Error parsing pdf file!');
    }

    return completer.future;
  }

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery
    //     .of(context)
    //     .size
    //     .width;
    return SafeArea(
      child: Scaffold(
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
          title: const Text("Client Credential Document"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              height: 40,
              child: Center(
                child: TextButton(
                  child: const Text(
                    "Press to Show Credential PDF",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 19, 125, 103)),
                  ),
                  onPressed: () {
                    print('line 76: $remotePDFPath');
                    if (remotePDFPath != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFView(
                            filePath: remotePDFPath,
                            enableSwipe: true,
                            swipeHorizontal: true,
                            autoSpacing: false,
                            pageFling: true,
                            pageSnap: true,
                            defaultPage: currentPage!,
                            fitPolicy: FitPolicy.BOTH,
                            preventLinkNavigation: false,
                            onRender: (_pages) {
                              setState(() {
                                pages = _pages;
                                currentPage = 0;
                                isReady = true;
                              });
                            },
                            onError: (error) {
                              print(error.toString());
                            },
                            onPageError: (page, error) {
                              print('$page: ${error.toString()}');
                            },
                            onViewCreated:
                                (PDFViewController pdfViewController) {
                              _controller.complete(pdfViewController);
                            },
                            // onPageChanged: (int page, int total) {
                            //   print('page change: $page/$total');
                            // },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 40,
              child: const Center(
                child: Text(
                  "(Horizontal Scrolling Of Pages)",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 19, 125, 103)),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 40,
              padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
              child: Text(
                "Drag the left image border to exit.)",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 19, 125, 103)),
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
      ),
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
          title: Center(child: Text("PDF of Credential")),
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
