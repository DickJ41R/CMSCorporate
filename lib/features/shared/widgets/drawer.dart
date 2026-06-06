// import 'package:cms_web/apps/clientresponsive_screens/mobile_dashboard.dart';
// import 'package:cms_web/apps/clientresponsive_screens/tablet_dashboard.dart';
// import 'package:cms_web/apps/clientresponsive_screens/laptop_dashboard.dart';
//
// import 'package:cms_web/apps/clientresponsive_screens/mobile_profile.dart';
// import 'package:cms_web/apps/clientresponsive_screens/tablet_profile.dart';
// import 'package:cms_web/apps/clientresponsive_screens/laptop_profile.dart';

// import 'package:cms_web/apps/clientresponsive_screens/mobile_client_invoice_screen.dart';
// import 'package:cms_web/apps/clientresponsive_screens/tablet_client_invoice_screen.dart';
// import 'package:cms_web/apps/clientresponsive_screens/laptop_client_invoice_screen.dart';
//
// import 'package:cms_web/apps/clientresponsive_screens/tablet_schedule_workorder_screen.dart';
// import 'package:cms_web/apps/clientresponsive_screens/tablet_publish_workorder_screen.dart';
//
// import 'package:cms_web/apps/clientresponsive_screens/tablet_schedule_template_screen.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class MyDrawer extends StatefulWidget {
//
//   final Color color;
//   const MyDrawer({Key? key,required this.color}) : super(key:key);
//
//   @override
//   State<MyDrawer> createState() => _MyDrawerState();
//
// }

// class _MyDrawerState extends State<MyDrawer> {
//
//   bool showLoginPage = true;
//
//   void toggleScreens() {
//     setState ( () {
//       showLoginPage = !showLoginPage;
//     });
//   }
//   Widget _createListTile(String text, Widget screen1) {
//     debugPrint('line 49 createlisttile: $screen1');
//    if (MediaQuery.of(context).size.width > 400) {
//      // double width2 = MediaQuery
//      //     .of(context)
//      //     .size
//      //     .width * .20;
//      return ListTile(
//          leading: Icon(Icons.settings,
//           color: widget.color),
//          title: Text(text,
//            style: const TextStyle(
//              color: Color.fromARGB(255, 19, 125, 103),
//              fontWeight: FontWeight.bold,
//              fontSize: 20,
//            ),
//
//          ),
//          onTap: () {
//            Navigator.of(context).push(
//                MaterialPageRoute(
//                    builder: (context) => screen1,
//                    ));
//          }
//      );
//    } else {
//      return Text('$text not available on small devices.');
//    }
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Drawer(
//         backgroundColor: widget.color,
//         child: ListView(
//             children: <Widget>[
//               // DrawerHeader(
//               //     child: Icon(Icons.favorite)
//               // ),
//               ListTile(
//                 leading: Icon(Icons.dashboard,
//                  color: Colors.black),
//                 title: const Text('Dashboard',
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 19, 125, 103),
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//                 onTap: () {
//                   // Navigator.of(context).push(
//                   //     MaterialPageRoute(
//                   //         builder: (context) => ResponsiveLayout(
//                   //             mobileLayout: MobileDashboard(),
//                   //             tabletLayout: TabletDashboard(),
//                   //             laptopLayout: LaptopDashboard()
//                   //         )));
//                 },
//               ), //list tile
//               ListTile(
//                   leading: Icon(Icons.chat),
//                   title: const Text('Profile',
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 19, 125, 103),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       )),
//                   onTap: () {
//                     // Navigator.of(context).push(
//                     //     MaterialPageRoute(
//                     //         builder: (context) => ResponsiveLayout(
//                     //             mobileLayout: MobileProfile(),
//                     //             tabletLayout: TabletProfile(),
//                     //             laptopLayout: LaptopProfile()
//                     //         )));
//                   }
//               ),
//               // ListTile(
//               //     leading: Icon(Icons.chat),
//               //     title: const Text('Create Work Schedule',
//               //         style: TextStyle(
//               //           color: Color.fromARGB(255, 19, 125, 103),
//               //           fontWeight: FontWeight.bold,
//               //           fontSize: 20,
//               //         )),
//               //     onTap: () {
//               //       Navigator.of(context).push(
//               //           MaterialPageRoute(
//               //               builder: (context) => ScheduleWorkOrderResponsive(
//               //                   tabletScheduleWorkOrderResponsive: TabletScheduleWorkOrderScreen()
//               //               )));
//               //     }
//               // ),
//               ListTile(
//                   leading: Icon(Icons.work),
//                   title: const Text('Create Work Schedule',
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 19, 125, 103),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       )),
//                   onTap: () {
//                     // Navigator.of(context).push(
//                     //     MaterialPageRoute(
//                     //         builder: (context) => ResponsiveLayout(
//                     //             mobileLayout: MobileScheduleWorkOrderScreen(),
//                     //             tabletLayout: TabletScheduleWorkOrderScreen(),
//                     //             laptopLayout: TabletScheduleWorkOrderScreen()
//                     //         )));
//                   }
//               ),
//               //createListTile('Create Work Schedule', ScheduleWorkOrderResponsive(tabletScheduleWorkOrderResponsive: TabletScheduleWorkOrderScreen())),
//               _createListTile('Create/Edit Schedule Template', ScheduleTemplateResponsive(tabletScheduleTemplate: TabletScheduleTemplateScreen())),
//               _createListTile('Edit/Publish Work Schedule', PublishWorkOrderResponsive(tabletPublishWorkOrderResponsive: TabletPublishWorkOrderScreen())),
//
//
//               ListTile(
//                   leading: Icon(Icons.money),
//                   title: const Text('Invoice List',
//                     style: TextStyle(
//                       color: Color.fromARGB(255, 19, 125, 103),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                   onTap: () {
//                     List<ClientInvoice> clientInvoices = [];
//                     // Navigator.of(context).push(
//                     //     MaterialPageRoute(
//                     //         builder: (context) => ClientInvoiceResponsive(
//                     //             mobileClientInvoiceScreen: MobileClientInvoiceScreen(clientInvoices: clientInvoices),
//                     //             tabletClientInvoiceScreen: TabletClientInvoiceScreen(clientInvoices: clientInvoices),
//                     //             laptopClientInvoiceScreen: LaptopClientInvoiceScreen(clientInvoices: clientInvoices)
//                     //         )));
//                   }
//               ),
//               ListTile(
//                   leading: Icon(Icons.settings),
//                   title: const Text('Work List',
//                     style: TextStyle(
//                       color: Color.fromARGB(255, 19, 125, 103),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                   onTap: () {
//                     // Navigator.of(context).push(
//                     //     MaterialPageRoute(
//                     //         builder: (context) => ResponsiveLayout(
//                     //             mobileLayout: MobileProfile(),
//                     //             tabletLayout: TabletProfile(),
//                     //             laptopLayout: LaptopProfile()
//                     //         )));
//                   }
//               ),
//
//
//               ListTile(
//                 leading: Icon(Icons.logout),
//                 title: const Text('L O G O U T',
//                   style: TextStyle(
//                       color: Color.fromARGB(255, 19, 125, 103),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24
//                   ),
//                 ),
//                 onTap: () {
//                   // FirebaseAuth.instance.signOut();
//                   // showDialog(context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           content: Text('You are signed out.'),
//                           actions: [
//                             ElevatedButton(
//                                 child: const Text("Ok",
//                                     style: TextStyle(
//                                       color: Color.fromARGB(255, 19, 125, 103),
//                                       fontWeight: FontWeight.bold,
//                                     )
//                                 ),
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                   Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                   builder: (context) =>
//                                   // LoginScreen(
//                                   // showChangePasswordPage: toggleScreens)));
//                                   // }
//                             ),
//                           ],
//                         );
//                       });
//                   // Timer(Duration(seconds: 4), () {
//                   //   Navigator.of(context).push(
//                   //       MaterialPageRoute(
//                   //           builder: (context) =>
//                   //               LoginScreen(
//                   //                   showChangePasswordPage: toggleScreens)));
//                   // });
//                 },
//               ),
//             ]
//         ),
//       ),
//       appBar: AppBar(
//         title: Text('Navigation Drawer'),
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//     );
//
//   }
// }
