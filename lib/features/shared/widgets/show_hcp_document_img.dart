import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowHCPDocumentImage extends StatefulWidget {
  const ShowHCPDocumentImage({super.key, required this.imageData});

  final Uint8List imageData;

  @override
  State<ShowHCPDocumentImage> createState() => _ShowHCPDocumentImageState();
}

class _ShowHCPDocumentImageState extends State<ShowHCPDocumentImage> {
  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();
  //
  //   return directory.path;
  // }
  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   debugPrint('line 24: $path');
  //   return File('$path/my_image.jpg');
  // }

  @override
  void initState() {
    super.initState();
//SystemChannels.textInput.invokeMethod("TextInput.show");
    debugPrint('line in init state of show docu image');
  }

  @override
  void dispose() {
    super.dispose();
// SystemChannels.textInput.invokeMethod("TextInput.hide");
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery
    //     .of(context)
    //     .size
    //     .width;;
    double screenWidth = MediaQuery.of(context).size.width;

    debugPrint('line 32: ${widget.imageData}');
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color.fromARGB(255, 13, 125, 103),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                //getMessageStream();
                Navigator.of(context).pop();
              }),
        ],
        title: const Text("HCP Credential Document"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 80,
              width: screenWidth - 10,
              child: Center(
                child: TextButton(
                  onPressed: (() {
                    debugPrint('line 62 in show image ${widget.imageData.length}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          barrierDismissible: true,
                          builder: (context) => Image.memory(
                              semanticLabel: 'Dismiss Image',
                              fit: BoxFit.contain,
                              // height: 300,
                              //  width:300,
                              widget.imageData)),
                    );
                  }),
                  child: Container(
                    height: 40,
                    width: screenWidth - 10,
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: const Text(
                      "Press to Show Credential Image",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 19, 125, 103)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 40,
              width: screenWidth - 10,
              padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: const Center(
                child: Text(
                  "Horizontal Scrolling of Pages)",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 19, 125, 103)),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 40,
              width: screenWidth - 10,
              padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Text(
                "Drag the left image border to dismiss.",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 19, 125, 103)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
