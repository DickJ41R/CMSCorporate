import 'package:cloud_functions/cloud_functions.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:cms_web/features/clientapp/services/client_services.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:cms_web/features/clientapp/services/save_file_mobile_and_desktop.dart';
//import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PDFService {
  //final storageRef = FirebaseStorage.instanceFor(bucket: "gs://cmsproject-8e245.appspot.com");
  final storageRef = FirebaseStorage.instance.ref();
  bool isAndroid = false;
  String imageFileName = '';

  ClientServices clientServices = ClientServices();
  double documentNotesLength = 0;

  Future<Map<String, dynamic>> createPdfAndPublishPdf(
      Map<String, dynamic> item, isAndroid) async {
    this.isAndroid = isAndroid;
    String pdfFileName = await _convertImageToPDF(item);
    //read and write to storage
    print('line 32: $pdfFileName');
    pdfFileName = pdfFileName.replaceAll('files\'', 'files');
    File file = File.fromUri(Uri.parse(pdfFileName));
    //  File file = await File(pdfFileName);
    print('line 36: $file');
    List<String> splits = pdfFileName.split('/');
    String timesheetFilename = splits[splits.length - 1];

    print('line 34: $timesheetFilename $pdfFileName');
    print('line 35: ${file} ${file.uri}');

    try {
      if (!file.existsSync()) {
        print('line 41: $file');
        throw 'line 42 File not found';
      }
// Create the file metadata

      Uint8List? bytes = await file.readAsBytes(); //THIS LINE
      if (bytes.length == 0) {
        print('line 47 read 0 bytes');
        throw Exception('still have 0 bytes');
      }
      final metadata = SettableMetadata(contentType: "application/pdf");
// Upload file and metadata to the path 'images/mountains.jpg'
      print('line 53: ${timesheetFilename}');
      await storageRef
          .child('timesheets/${timesheetFilename}')
          .putFile(file, metadata);
      print('line 57 check');
// Listen for state changes, errors, and completion of the upload.
//       uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
//         switch (taskSnapshot.state) {
//           case TaskState.running:
//              print('line 53: ${taskSnapshot.bytesTransferred} ${taskSnapshot.totalBytes}');
//             final progress =
//                 100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
//             print("line 56 Upload is $progress% complete.");
//             break;
//           case TaskState.paused:
//             print("line 59 Upload is paused.");
//             break;
//           case TaskState.canceled:
//             print("line 62 Upload was canceled");
//             break;
//           case TaskState.error:
//           // Handle unsuccessful uploads
//           print('line 65 error: ${TaskState.error}');
//             break;
//           case TaskState.success:
//             print('line 68 success');
//           // Handle successful uploads on complete
//           // ...
//             break;
//         }
//       });
      //     final timesheetRef = storageRef.child('timesheets/${timesheetFilename}');
      //  await timesheetRef.putFile(file,SettableMetadata(contentType: 'application/pdf'));

      Map<String, dynamic>? rx;
      return rx = {
        "fileAndPathName": pdfFileName,
        "timesheetFilename": timesheetFilename
      };
    } catch (e) {
      print('line 82 error storing signature file $e');
      throw Exception('line 82: ${e.toString()}');
    }
  }

  Future<String> _convertImageToPDF(Map<String, dynamic> item) async {
    print('line 93 in _convertImageToPDF');
    List<String> dayValues = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
      'Total Regular Hours',
      'Total Overtime Hours',
      "Verified Regular Hours"
    ];
    //Create a new PDF document
    PdfDocument document = PdfDocument();

//Add a page to the document
    PdfGridCellStyle cellStyle = new PdfGridCellStyle();
    cellStyle.backgroundBrush = PdfBrushes.pink;
    PdfGridCellStyle cellStyle1 = new PdfGridCellStyle();
    cellStyle1.backgroundBrush = PdfBrushes.white;

    PdfPage page = document.pages.add();

    Size size = page.getClientSize();
    double width = size.width;
    width = (width / 2) - 25;
    print('line 83: $width ${page.getClientSize()}');
    page.graphics.drawImage(PdfBitmap(await _readData('logo.png')),
        Rect.fromLTWH(width, 0, 50, 50));

//Load the paragraph text into PdfTextElement with standard font
    String str = "Consolidated Medical Staffing";
    //Measure the text
    PdfFont font =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    Size ssize = font.measureString(str);
    double leftMargin = (size.width / 2) - (ssize.width / 4);
    leftMargin -= 35;
//Draw the text
    print('line 64: ${ssize.width} $leftMargin');
    double startHeight = 50 + (ssize.height / 2);
    page.graphics.drawString(str, font,
        bounds:
            Rect.fromLTWH(leftMargin, startHeight, size.width, size.height));
    str = "Generated Employee Timesheet";
    ssize = font.measureString(str);
    leftMargin = (size.width / 2) - (ssize.width / 4);
    leftMargin -= 35;
    double height = startHeight + (ssize.height / 2);
    startHeight += ssize.height;
    page.graphics.drawString(str, font,
        bounds:
            Rect.fromLTWH(leftMargin, startHeight, ssize.width, ssize.height));
    str = "Generated on: " + getFormattedDate(DateTime.now());
    ssize = font.measureString(str);
    leftMargin = (size.width / 2) - (ssize.width / 4);
    leftMargin -= 35;
    startHeight += ssize.height;
    page.graphics.drawString(str, font,
        bounds:
            Rect.fromLTWH(leftMargin, startHeight, ssize.width, ssize.height));
//Draw the paragraph text on page and maintain the position in PdfLayoutResult
    startHeight += 10;
    Timestamp tms = item['shiftDate'] as Timestamp;
    DateTime shiftDateTime = tms.toDate();
    print('line 90: $shiftDateTime');
    String shiftDateString = getFormattedDate(shiftDateTime);
    print('line 91: $shiftDateString');
    int weekDay = shiftDateTime.weekday;
    if (weekDay == 0) {
      weekDay = 6;
    } else {
      weekDay -= 1;
    }
    font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    str = "Employee Id:   ${item['hcpId']} Name: ${item['hcpName']}";
    ssize = font.measureString(str);
    PdfTextElement textElement = PdfTextElement(text: str, font: font);
    startHeight += ssize.height;
    print('line 112 $startHeight');
    PdfLayoutResult layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, startHeight, ssize.width, ssize.height))!;
    // str = "Administrator Id: ${item['supervisorId']} ${item['supervisorName']}";
    str = "Supervisor: ${item['supervisorName']}";

    ssize = font.measureString(str);
    textElement = PdfTextElement(text: str, font: font);
    startHeight += ssize.height;
    layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, startHeight, ssize.width, ssize.height))!;
    print('line 118 $startHeight');
    str = "Facility Name: ${item['clientName']}";
    ssize = font.measureString(str);
    textElement = PdfTextElement(text: str, font: font);
    startHeight += ssize.height;
    layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, startHeight, ssize.width, ssize.height))!;
    str = "Assigned Department: ${item['departmentName']}";
    ssize = font.measureString(str);
    print('line 208: $ssize.height');
    textElement = PdfTextElement(brush: PdfBrushes.pink, text: str, font: font);
    print('line 133: $str');
    startHeight += ssize.height;
    layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, startHeight, ssize.width, ssize.height))!;
    str = "Unit/Floor: CAC";
    ssize = font.measureString(str);
    textElement = PdfTextElement(text: str, font: font);
    startHeight += ssize.height;
    layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, startHeight, ssize.width, ssize.height))!;
    //grid
//Initialize PdfGrid for drawing the table
    PdfGrid grid = PdfGrid();
    PdfStringFormat format = PdfStringFormat();
    print('line 225 $format ${layoutResult.bounds.bottom}');
    format.alignment = PdfTextAlignment.center;
    print('line 227 check');
    format.lineAlignment = PdfVerticalAlignment.bottom;
    //Create a grid style

    // PdfGridStyle gridStyle = PdfGridStyle(
    //   cellSpacing: 2,
    //   cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
    //   borderOverlapStyle: PdfBorderOverlapStyle.inside,
    //   backgroundBrush: PdfBrushes.lightGray,
    //   textPen: PdfPens.black,
    //   textBrush: PdfBrushes.white,
    //   font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    // );

    grid.columns.add(count: 7);

    grid.headers.add(2);
    grid.columns[0].width = 150;
    grid.columns[1].width = 80;
    grid.columns[1].format = format;
    grid.columns[2].width = 60;
    grid.columns[2].format = format;
    grid.columns[3].width = 60;
    grid.columns[3].format = format;
    grid.columns[4].width = 50;
    grid.columns[4].format = format;
    grid.columns[5].width = 50;
    grid.columns[5].format = format;
    grid.columns[6].width = 60;
    grid.columns[6].format = format;

    PdfGridRow header = grid.headers[0];

    header.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.green,
        textPen: PdfPens.white,
        textBrush: PdfBrushes.darkOrange,
        font: PdfStandardFont(PdfFontFamily.helvetica, 12));
    header.cells[0].value = '';
    header.cells[1].value = 'Date';
    header.cells[2].value = 'Time';
    header.cells[3].value = 'Time';
    header.cells[4].value = '';
    header.cells[5].value = 'Total';
    header.cells[6].value = 'Has';

    header = grid.headers[1];
    header.cells[0].value = 'Worked';
    header.cells[1].value = 'Days';
    header.cells[2].value = 'In';
    header.cells[3].value = 'Out';
    header.cells[4].value = 'Break';
    header.cells[5].value = 'Hours';
    header.cells[6].value = 'Initial';
    header.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.green,
        textPen: PdfPens.white,
        textBrush: PdfBrushes.darkOrange,
        font: PdfStandardFont(PdfFontFamily.helvetica, 12));
    double otMealHour = 0.0;

    if (item['otHours'] != null && item['otHours'] > 0) {
      if (item['regularHours'] == 0) {
        otMealHour = .5;
        item['otHours'] -= .5;
      }
    }
    PdfGridRow row1 = grid.rows.add();
    row1.style =
        PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 12));
    for (int i = 0; i < 9; i++) {
      PdfGridRow row = grid.rows.add();
      if (weekDay == i) {
        DateTime std = item['signedInDeviceDateTime'].toDate();
        String st = DateFormat("MM-dd-yyyy hh:mm a").format(std);
        List<String> sts = st.split(' ');
        // std = item['shiftSignedOutActionDate'].toDate();
        // st =  DateFormat("MM-dd-yyyy hh:mm a").format(std);
        // List<String>ets = st.split(' ');
        if (item['signedOutInitialValuesChanged'] == false) {
          row.cells[0].value = dayValues[i];
          row.cells[1].value = sts[0];
          row.cells[2].value = item['signedInShiftStartTime'];
          row1.cells[2].style = cellStyle1;
          row.cells[3].value = item['signedOutShiftEndTime'];
          row1.cells[3].style = cellStyle1;
          row.cells[4].value = item['signedOutMeals'].toString();
          row1.cells[4].style = cellStyle1;
          row.cells[5].value = item['decimalHoursVerified'].toStringAsFixed(2);
          row1.cells[5].style = cellStyle1;
          row.cells[6].value =
              item['signedOutInitialVerification'] == true ? 'Yes' : 'No';
        } else {
          String cStartTime = item['signedInInitialStartTimeChanged'];
          String cEndTime = item['signedOutInitialEndTimeChanged'];
          PdfGridRow row1 = grid.rows.add();
          print('line 242');
          row1.cells[0].value = dayValues[i];
          row1.cells[1].value = sts[0];
          row1.cells[2].value = cStartTime; //item['dateTimeSignedOutValue'];
          row1.cells[2].style = cellStyle;
          row1.cells[3].value = cEndTime; //item['dateTimeSignedOutValue'];
          row1.cells[3].style = cellStyle;
          row1.cells[4].value = item['signedOutInitialMealsChanged'].toString();
          row1.cells[4].style = cellStyle;
          row1.cells[5].value =
              item['signedOutInitialDecimalHoursChanged'].toStringAsFixed(2);
          row1.cells[5].style = cellStyle;
          row1.cells[6].value =
              item['signedOutInitialVerification'] == true ? 'Yes' : 'No';
        }
        // } else if (i < 7 ){
        //     row.cells[0].value = dayValues[i];
        //     row.cells[1].value = '';
        //     row.cells[2].value = '';
        //     row.cells[3].value = '';
        //     row.cells[4].value = '';
        //     row.cells[5].value = '';
        //     row.cells[6].value = '';
      } else if (i == 7) {
        if (item['signedOutInitialValuesChanged'] == false) {
          row.cells[0].value = dayValues[i];
          row.cells[0].style = PdfGridCellStyle(
              backgroundBrush: PdfBrushes.green, textPen: PdfPens.white);
          print('line 265');
          row.cells[1].value = '';
          row.cells[2].value = '';
          row.cells[3].value = '';
          row.cells[4].value = item['signedOutMeals'].toString();
          row1.cells[4].style = cellStyle1;
          row.cells[5].value = item['decimalHours'].toStringAsFixed(2);
          row1.cells[5].style = cellStyle1;
          row.cells[6].value =
              item['signedOutInitialVerification'] == true ? 'Yes' : 'No';
          print('line 272->: ${dayValues.length}');
        } else {
          PdfGridRow row1 = grid.rows.add();
          row1.cells[0].value = dayValues[i + 2];
          row1.cells[0].style = PdfGridCellStyle(
              backgroundBrush: PdfBrushes.green, textPen: PdfPens.white);
          row1.cells[1].value = '';
          row1.cells[2].value = '';
          row1.cells[3].value = '';
          row1.cells[4].value = item['signedOutInitialMealsChanged'].toString();
          row1.cells[4].style = cellStyle;
          row1.cells[5].value =
              item['signedOutInitialDecimalHoursChanged'].toStringAsFixed(2);
          row1.cells[5].style = cellStyle;
          row1.cells[6].value =
              item['signedOutInitialVerification'] == true ? 'Yes' : 'No';
        }
      } else if (i == 8) {
        if (item['otHours'] != null && item['otHours'] > 0.0) {
          row.cells[0].value = dayValues[i];
          row.cells[0].style = PdfGridCellStyle(
              backgroundBrush: PdfBrushes.green, textPen: PdfPens.white);
          row.cells[1].value = '';
          row.cells[2].value = '';
          row.cells[3].value = '';
          row.cells[4].value = otMealHour.toString();
          row.cells[5].value = item['otHours'].toStringAsFixed(2);
          row.cells[6].value =
              item['signedOutInitialVerification'] == true ? 'Yes' : 'No';
        } else {
          row.cells[0].value = dayValues[i];
          row.cells[0].style = PdfGridCellStyle(
              backgroundBrush: PdfBrushes.green, textPen: PdfPens.white);
          row.cells[1].value = '';
          row.cells[2].value = '';
          row.cells[3].value = '';
          row.cells[4].value = '0';
          row.cells[5].value = '0';
          row.cells[6].value = '';
        }
      }
    }
    print('line 257 ${layoutResult.bounds.bottom}');
//Draws the grid
    layoutResult = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, layoutResult.bounds.bottom + 20, 0, 0))!;
    font = PdfStandardFont(PdfFontFamily.helvetica, 10);
    String elc = item['signedOutInitialVerification'] == true ? 'Yes' : 'No';
    str = "Employee Electronically Validated Hours: $elc";
    ssize = font.measureString(str);
    textElement = PdfTextElement(text: str, font: font);
    layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, layoutResult.bounds.bottom + 5, ssize.width, ssize.height))!;
    print('line 272');
    font = PdfStandardFont(PdfFontFamily.helvetica, 10);
    const String footerContent0 =
        "Client Company and Consolidated Medical Staffing, each certify that hours stated are correct.  Client Company " +
            "agrees to the terms and conditions on the Time Sheet.  By providing the electronic signature, the supervisor validates " +
            "the information on the Time Sheet.";
    ssize = font.measureString(footerContent0);
    textElement = PdfTextElement(text: footerContent0, font: font);
    layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, layoutResult.bounds.bottom + 10,
            page.getClientSize().width, page.getClientSize().height))!;

    print(
        'line 286 ${layoutResult.bounds.bottom} ${page.getClientSize().width} ${page.getClientSize().height}');
    font = PdfStandardFont(PdfFontFamily.helvetica, 10);
    str = "Supervisor Signature: ";
    ssize = font.measureString(str);
    textElement = PdfTextElement(text: str, font: font);
    height = layoutResult.bounds.bottom;
    leftMargin = ssize.width;
    double dateHeight = layoutResult.bounds.bottom + 20;
    layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, layoutResult.bounds.bottom + 20, ssize.width, ssize.height))!;
    imageFileName = item['signatureFileName'];
    print('line 299: ${layoutResult.bounds.bottom} $imageFileName');
    print('line 308: $leftMargin $height');
    height += 5;
    leftMargin += 100;
    page.graphics.drawImage(PdfBitmap(await _readData2(imageFileName)),
        Rect.fromLTWH(leftMargin, height, 150, 50));

    leftMargin += 180;

    str = "Date: $shiftDateString";
    height += 10;
    ssize = font.measureString(str);
    textElement = PdfTextElement(text: str, font: font);

    layoutResult = textElement.draw(
        page: page,
        bounds:
            Rect.fromLTWH(leftMargin, dateHeight, ssize.width, ssize.height))!;
    print('line 328: $dateHeight, $height ${ssize.width} ${ssize.height}');

    str = "Supervisor Name: ${item['supervisorName']}";
    height += 30;
    ssize = font.measureString(str);
    print('line 328: $str $ssize $height');
    textElement = PdfTextElement(text: str, font: font);
    layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, height, ssize.width, ssize.height))!;
    height += 30;
    print('line 339 $height');
    font = PdfStandardFont(PdfFontFamily.helvetica, 10);
    const String footerContent1 = "Terms and Conditions: After interview Client Company may not directly or indirectly hire the CMS field employee for any " +
        "position for a period of 90 days for the position without CMS\'s written consent.  Client hereby agrees that if the " +
        "Client breaches the above terms or the Client sells the business to a third party which breaches the above terms, Client " +
        "will pay CMS a settlement fee equal to 144 hours times said field staff\'s bill rate.  Hours worked by field staff prior to " +
        "hire or written notification will not apply to the above 144 hours.  Client shall pay all reasonable attorney\'s fees and " +
        "other costs incurred by CMS in enforcement the agreement.  Client shall adhere to all contract payment provisions and " +
        "by providing the electronic signature for this time sheet shall guarantee payment of the time sheet within the terms " +
        "specified in the Client and Consolidated Medical Staffing contract.  No oral statement shall modify or affect the " +
        "above Terms and Conditions.";

    ssize = font.measureString(footerContent1);
    print(
        'line 353: $ssize ${ssize.width} ${ssize.height} ${page.getClientSize().width} ${page.getClientSize().height}');
    textElement = PdfTextElement(text: footerContent1, font: font);
    layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, height, page.getClientSize().width,
            page.getClientSize().height))!;
    // height += ssize.height;
    height += ssize.height;
    height += 10;
    print('line 359 height: $height');
    double keepHeight = height;
    // page = document.pages[1];
    // Create a reference with an initial file path and name

    if (item['signedOutHCPSignatureFileName'] == null) {
      print('ine 363 hcpsignarute file name = null');
      throw Exception('No registrant signature file');
    }
    List<String> sfns = item['signedOutHCPSignatureFileName'].split('/');
    String sfn = sfns[sfns.length - 1];
    final hcpImageFileName = "images/" + sfn;

    print('line 405: $hcpImageFileName');

    try {
      height += 100;
      keepHeight = height;
      str = "Employee Signature: ";
      ssize = font.measureString(str);
      textElement = PdfTextElement(text: str, font: font);

      leftMargin = ssize.width;
      layoutResult = textElement.draw(
          page: page,
          bounds: Rect.fromLTWH(0, height, ssize.width, ssize.height))!;

      const noBytes = 1024 * 100;
      print('line 503: $hcpImageFileName');
      final signatureRef = storageRef.child(hcpImageFileName);
      print('line 410: $signatureRef');
      final Uint8List? data = await signatureRef.getData(noBytes);
      signatureRef.putData(data!);
      // Data for "images/island.jpg" is returned, use this as needed.
      List<int> dta = data as List<int>;
      leftMargin = 200;

      page.graphics.drawImage(
          PdfBitmap(dta), Rect.fromLTWH(leftMargin, height, 100, 50));
      leftMargin += 180;

      str = "Date: $shiftDateString";
      height += 10;
      ssize = font.measureString(str);
      textElement = PdfTextElement(text: str, font: font);

      layoutResult = textElement.draw(
          page: page,
          bounds:
              Rect.fromLTWH(leftMargin, height, ssize.width, ssize.height))!;

      height += 50;
      keepHeight = height;
      font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      String stx = "HCP Name: ${item['hcpName']}";
      print('line 422: $stx');
      leftMargin = 0;
      ssize = font.measureString(stx);
      textElement = PdfTextElement(text: stx, font: font);
      layoutResult = textElement.draw(
          page: page,
          bounds: Rect.fromLTWH(0, height, ssize.width, ssize.height))!;
      height += ssize.height;
      keepHeight = height;
      String yesNo = item['signedInGeofenceAvailable'] == true ? "Yes" : "No";
      String geoNotes = 'Clocked In Geofencing was available:  ' + yesNo;
      leftMargin = 0;
      ssize = font.measureString(geoNotes);
      textElement = PdfTextElement(text: geoNotes, font: font);
      layoutResult = textElement.draw(
          page: page,
          bounds: Rect.fromLTWH(0, height, ssize.width, ssize.height))!;
      leftMargin = 0;
      height += ssize.height;
      keepHeight = height;
      yesNo = item['signedInGeofenceVerified'] == true ? "Yes" : "No";
      geoNotes = 'Clocked In Geofencing Verified:  ' + yesNo;
      ssize = font.measureString(geoNotes);
      textElement = PdfTextElement(text: geoNotes, font: font);
      layoutResult = textElement.draw(
          page: page,
          bounds:
              Rect.fromLTWH(leftMargin, height, ssize.width, ssize.height))!;
      height += ssize.height;
      keepHeight = height;
      yesNo = item['signedOutGeofenceAvailable'] == true ? "Yes" : "No";
      geoNotes = 'Clocked Out Geofencing was available:  ' + yesNo;
      leftMargin = 0;
      ssize = font.measureString(geoNotes);
      textElement = PdfTextElement(text: geoNotes, font: font);
      layoutResult = textElement.draw(
          page: page,
          bounds: Rect.fromLTWH(0, height, ssize.width, ssize.height))!;
      leftMargin = 0;
      height += ssize.height;
      keepHeight = height;
      yesNo = item['signedOutGeofenceVerified'] == true ? "Yes" : "No";
      geoNotes = 'Clocked Out Geofencing Verified:  ' + yesNo;
      ssize = font.measureString(geoNotes);
      textElement = PdfTextElement(text: geoNotes, font: font);
      layoutResult = textElement.draw(
          page: page,
          bounds:
              Rect.fromLTWH(leftMargin, height, ssize.width, ssize.height))!;
      height += ssize.height;
      keepHeight = height;
      leftMargin = 0;

      String notes = 'Verify Notes: ';
      if (item['signedOutInitialSupervisorNotes'] != null) {
        notes += item['signedOutInitialSupervisorNotes'];
      }
      ssize = font.measureString(notes);
      documentNotesLength += ssize.height;
      textElement = PdfTextElement(text: notes, font: font);
      layoutResult = textElement.draw(
          page: page,
          bounds: Rect.fromLTWH(0, height, ssize.width, ssize.height))!;
      height += ssize.height;
      keepHeight = height;
      leftMargin = 0;
      String eNotes = 'Employee Clock In Notes: ';
      if (item['signedInHCPNotes'] != null) {
        eNotes += item['signedInHCPNotes'];
      }
      ssize = font.measureString(eNotes);
      documentNotesLength += ssize.height;
      textElement = PdfTextElement(text: eNotes, font: font);
      layoutResult = textElement.draw(
          page: page,
          bounds: Rect.fromLTWH(0, height, ssize.width, ssize.height))!;
      height += ssize.height;
      keepHeight = height;
      leftMargin = 0;
      String oNotes = 'Employee CLock Out Notes: ';
      if (item['signedOutHCPNotes'] != null) {
        oNotes += item['signedOutHCPNotes'];
      }
      ssize = font.measureString(oNotes);
      textElement = PdfTextElement(text: oNotes, font: font);
      layoutResult = textElement.draw(
          page: page,
          bounds: Rect.fromLTWH(0, height, ssize.width, ssize.height))!;
      print('line 603 ${ssize.height} $documentNotesLength');
      height += ssize.height;
      keepHeight = height;
      documentNotesLength += ssize.height;
      if (keepHeight < page.getClientSize().height) {
        //Gets the second page of the document
        print('line 605 ${keepHeight}');
        print('line 607: ${document.pages.count}');
        PdfPage page2 = document.pages[1];
        print('line 624 ${page2}');
//Removes the second page from the document
        document.pages.removeAt(1);
        print('line 627: ${document.pages.count}');
      }
      List<int> bytes = await document.save();

      //Disposes the document
      document.dispose();
      String sdte = shiftDateString.replaceAll('-', '');
      String fileName =
          '$sdte${item['shiftCode']}${item['hcpId']}timesheet.pdf';
      //Save the file and launch/download.
      print('line 588: $fileName');
      //put to cloud storate

      //end of put to file storage
      SaveFile.saveAndLaunchFile(bytes, fileName);
      Directory dir = await path_provider.getApplicationSupportDirectory();
      String pathAndFile = '$dir\/$fileName';
      pathAndFile = pathAndFile.replaceAll("Support'", "Support");
      int idx = pathAndFile.indexOf(':');
      pathAndFile = pathAndFile.substring(idx + 1).trim();
      pathAndFile = pathAndFile.substring(1);
      print('line 595 $pathAndFile');

      //here we should send to asm ******* ASM ******

      //DateTime dte = item['shiftDate'].toDate();
      //String sdtes = getFormattedDate(dte);
      // Map<String,dynamic> asm = {
      //   "shiftDate": sdtes,
      //   "orderId": item['orderId']
      // };
      // await loadPdfFileToStafferLink(pathAndFile,asm,
      //     item['hcpId'], dte, item['shiftCode'],item['clientId']);

      return pathAndFile;
    } catch (e) {
      print('line 374 error: $e');
      return '';
    }
  }

  String getFormattedDate(DateTime dte) {
    DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(dte);
    return formatted;
  }

  Future<List<int>> _readData2(String name) async {
    var file = new File(name);
    List<int> imageBytes = await file.readAsBytes();
    return imageBytes;
  }

  Future<List<int>> _readData(String name) async {
    print('line 384 readdata: $name');
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
}
