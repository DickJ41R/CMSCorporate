// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
//
// class MyFileDownloadPage extends StatefulWidget {
//   const MyFileDownloadPage({super.key, required this.pdfUrl});
//   final String pdfUrl;
//   @override
//   State<MyFileDownloadPage> createState() => _MyFileDownloadPageState();
// }
// class _MyFileDownloadPageState extends State<MyFileDownloadPage> {
//   late String pdfUrl;
//   @override
//   void initState () {
//     super.initState();
//     pdfUrl = widget.pdfUrl;
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text('PDF Download'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'Download PDF:',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             SizedBox(
//               child: DownloadWidget(pdfUrl:pdfUrl),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
// class DownloadWidget extends StatefulWidget {
//   final String pdfUrl;
//
//   DownloadWidget({super.key, required this.pdfUrl})
//
//   @override
//   _DownloadWidgetState createState() => _DownloadWidgetState();
// }
// class _DownloadWidgetState extends State<DownloadWidget> {
//   double _progress = 0.0;
//   bool _isDownloading = false;
//   late String pdfUrl;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   @override
//   void initState() {
//     super.initState();
//     pdfUrl = widget.pdfUrl;
//
//     _initializeNotifications();
//   }
//   final netImage = await networkI
//
//   pdf.addPage(pw.Page(build: (pw.Context context) {
//   return pw.Center(
//   child: pw.Image(netImage),
//   ); // Center
//   })); // Page
//   Future<void> _initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//     _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         if (response.payload != null) {
//           await _handleNotificationClick(response.payload);
//         }
//       },
//     );
//   }
//   Future<void> _handleNotificationClick(String? payload) async {
//     if (payload != null) {
//       OpenFile.open(payload);
//     }
//   }
//   Future<void> _showDownloadCompleteNotification(String filePath) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'id',
//       'name',
//       channelDescription: 'PDF Document',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       'Download Complete',
//       'Your PDF has been downloaded.',
//       platformChannelSpecifics,
//       payload: filePath,
//     );
//   }
//   Future<void> _downloadPDF() async {
//     setState(() {
//       _isDownloading = true;
//       _progress = 0.0;
//     });
//     try {
//       for (int i = 0; i <= 100; i++) {
//         await Future.delayed(Duration(milliseconds: 50));
//         setState(() {
//           _progress = i / 100;
//         });
//       }
//       final pdf = pw.Document();
//       pdf.addPage(
//         pw.Page(
//           build: (pw.Context context) {
//             return pw.Center(
//               child: pw.Text('Hello, PDF!'),
//             );
//           },
//         ),
//       );
//       final output = await getExternalStorageDirectory();
//       final filePath = '${output!.path}/invoice.pdf';
//       final file = File(filePath);
//       await file.writeAsBytes(await pdf.save());
//       setState(() {
//         _isDownloading = false;
//         _progress = 1.0;
//       });
//       await _showDownloadCompleteNotification(filePath);
//     } catch (e) {
//       setState(() {
//         _isDownloading = false;
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return CircularPercentIndicator(
//       radius: 25.0,
//       lineWidth: 5.0,
//       percent: _progress,
//       center: _isDownloading
//           ? Text("${(_progress * 100).toStringAsFixed(0)}%")
//           : IconButton(
//         icon: Icon(
//           Icons.file_download_outlined,
//           color: Colors.blue,
//         ),
//         iconSize: 25.0,
//         onPressed: _downloadPDF,
//       ),
//       progressColor: Colors.blue,
//       backgroundColor: Colors.grey[200]!,
//       circularStrokeCap: CircularStrokeCap.round,
//     );
//   }
// }
