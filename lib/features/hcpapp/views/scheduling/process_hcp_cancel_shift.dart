import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_timecard_service.dart';
//import 'package:hcp_app/models/client_models/client_work_order_campaign.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cms_web/features/shared/services/clientapp/client_work_order_campaign_service.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/hcpapp/views/hcp_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/shared/utils/dropdown_codes.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ProcessHCPCancelShifts extends StatefulWidget {
  final Map<String, dynamic> args;
  const ProcessHCPCancelShifts({super.key, required this.args});

  @override
  _ProcessHCPCancelShiftsState createState() => _ProcessHCPCancelShiftsState();
}

class _ProcessHCPCancelShiftsState extends State<ProcessHCPCancelShifts> {
  Map<String,dynamic>? hcpUser;
  Users? user;
  dynamic currentUser;
  ClientWorkOrderCampaignService clw = ClientWorkOrderCampaignService();
  HCPTimeCardService hcpTimeCardService = HCPTimeCardService();
  HCPServices hcpServices = HCPServices();
  UtilitiesServices utilitiesServices = UtilitiesServices();
  DropDownCodes dropDownCodes = DropDownCodes();

  AuthService authService = AuthService();
  int? hcpId;
  String? gEmail;
  _ProcessHCPCancelShiftsState();

  Future<List<Map<String, dynamic>>> _getAllConfirmedShifts() async {
    debugPrint('line 122 in getAvailable shiftgs');
    try {
      List<Map<String, dynamic>>? lm =
          await clw.getWorkOrderCampaignsApprovedConfirmed(hcpId!);
      debugPrint('line 58 in get all confirmed');
      if (lm == null) {
        return [];
      }

      return lm;
    } catch (e) {
      debugPrint('line 66 erro in cancel shifts: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> getHCPUserX() async {
    await getHCPUser();
  }
  Future<void> getHCPUser() async {
    debugPrint('line 50 gethcpuser available cancel: $hcpServices');
    try {
      Map<String, dynamic>? lm = await hcpServices.getHCPUser(hcpId!);

      if (lm.isEmpty) {
        debugPrint('line 54 lm i septy');
        return;
      }
      debugPrint('line 57 in cancel shifts gethcpuser $lm');
      fullName = lm['legalName'];
      hcpUser = lm;
    } catch (e) {
      debugPrint('line 63 error: $e');
      throw Exception(e.toString());
    }
  }
  String? cancelReason;
  String? fullName;
  Map<String, dynamic>? arguments;
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    hcpId = arguments!['hcpId'];
    debugPrint('line 84 initstate cancel shifts $arguments');
    getRegistrantCancelReasons();
    debugPrint('line 86: $currentUser $clw');
    debugPrint('line 87 initstate');
    getHCPUserX();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _showDialog(
      BuildContext context, String title, String? description) async {
    debugPrint('line 12 showdialog');
    // Future.delayed(Duration(seconds: 3), () {
    //   Navigator.of(context).pop(); // Close the dialog
    // });
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title,
                style: TextStyle(
                  fontSize: fontSize,
                  color: color2,
                  fontWeight: FontWeight.bold,
                )),
            content: Text(description!,
                style: TextStyle(
                  fontSize: fontSize,
                  color: color2,
                  fontWeight: FontWeight.bold,
                )),
            contentTextStyle: TextStyle(
              color: color1,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            titleTextStyle: TextStyle(
                color: Color.fromARGB(255, 19, 125, 103),
                fontSize: fontSize,
                fontWeight: FontWeight.bold),
            actions: <Widget>[
              // TextButton(
              //   onPressed: () => Navigator.pop(context, 'Cancel'),
              //   child: const Text('Cancel'),
              // ),
              TextButton(
                onPressed: (() {
                  Navigator.pop(context, true);
                }),
                child: Text(
                  'OK',
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 19, 125, 103)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(
                  'Cancel Request',
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 19, 125, 103)),
                ),
              )
            ],
          );
        }).then((exit) {
      if (exit == null || exit == false) {
        return false;
      } else {
        return true;
      }
    });
  }

  String getFormattedDate(DateTime dte) {
    DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(dte);
    return formatted;
  }

  String _convertFromTimestamp(Timestamp? t) {
    if (t == null) {
      DateTime d = new DateTime(1970, 1, 1);
      int itt = d.millisecondsSinceEpoch;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(itt);
      String ss = getFormattedDate(dateTime);
      return ss;
    }
    DateTime date = t.toDate();
    String s = getFormattedDate(date);
    return s;
  }

  void onButtonPressed(Map<String, dynamic> item,
      bool flagPublishedButtonDisabled, BuildContext ctx) async {
    debugPrint(
        'line 41 in onButtonPressed: ${item['shiftDate']} ${item['shiftCode']}');
    //cancel  clentworkorder first
    debugPrint('line 201:${item['shiftCancellationNote']}');

    if (item['shiftCancellationNote'] == null) {
      _showDialog(
          ctx, "Cancellation Reason", "You must select a cancellation reason!");
      return;
    }
    int cancelReasonCodeId = 0;
    for (int i = 0; i < listOfRegistrantCancelReasons.length; i++) {
      Map<String, dynamic> mp = listOfRegistrantCancelReasons[i];
      debugPrint('line 204: $mp ${item['shiftCancellationNote']}');
      if (mp['reason'] == item['shiftCancellationNote']) {
        cancelReason = mp['reason'];
        cancelReasonCodeId = mp['codeId'];
        break;
      }
    }
    if (cancelReasonCodeId == 0) {
      _showDialog(ctx, "Error", 'There is no valid cancellation reason code');
      flagPublishedButtonDisabled = false;
      return;
    }
    try {
      item['shiftCanceledById'] = item['hcpId'];
      item['shiftCancellationCodeId'] = cancelReasonCodeId;
      item['shiftCanceledByName'] = item['hcpName'];
      item['shiftStatus'] = 'Canceled';
      item['cancelReasonCodeId'] = cancelReasonCodeId;
      item['cancelReason'] = cancelReason;
      item['shiftCanceledActionDate'] = Timestamp.fromDate(DateTime.now());
      item['shiftStatusDate'] = Timestamp.fromDate(DateTime.now());
      item['shiftCancellationType'] = 'E';
      item['shiftCanceledNote'] = "E";

      bool? bl1 = await clw.cancelHCPWorkOrderShift(item, item['hcpId'], ctx);
      if (bl1! == false) {
        flagPublishedButtonDisabled = false;
        _showDialog(
            ctx, "Cancel Error", "An error occurred canceling the shift");
        Navigator.of(ctx).pop();
      }
      await hcpTimeCardService.cancelScheduledShift(item, ctx);
      // List<String> tos = ['dickj41r@icloud.com'];
      // String from = 'noreply@consolidatedstaffing.com';
      // String fromUserName = 'Support';
      // String subject = 'Employee Shift Cancellation';
      //
      // String text = "Shift Cancellation";
      // text += "\r\nClient: ${item['clientName']}";
      // text += "\r\nShift: ${item['shiftCode']}";
      // text += "\r\nShiftDate:${_convertFromTimestamp(item['shiftDate'])}";
      // text += "\r\nEmployee: ${item['hcpName']}";
      // text += '\r\nReason: ${item['shiftCancellationNote']}';
      // //uncomment next to lines after DEBUG
      // await utilitiesServices.sendEmailFromGMail(
      //     tos, from, fromUserName, subject, text);
      debugPrint('line 257 just before alert');
      await _showDialog(ctx, "Cancellation",
          "You have successfully canceled the shift.  Don't forget to notify the client and your CMS representative.");
      Navigator.of(ctx).pop();
    } catch (e) {
      debugPrint('line 263 error: ${e.toString()}');
      await _showDialog(ctx, "Cancellation",
          "THere was an error:   Don't forget to notify the client and your CMS representative.");
      Navigator.of(ctx).pop();
    }
  }

  List<dynamic> listOfReasons = [];
  List<Map<String, dynamic>> listOfRegistrantCancelReasons = [];
  void getRegistrantCancelReasons() async {
    List<Map<String, dynamic>> lstw =
        await dropDownCodes.getCoordinatorHCPCancelReasons();
    List<String> lst = [];
    for (int i = 0; i < lstw.length; i++) {
      Map<String, dynamic> mp = lstw[i];
      String st = mp['reason'];
      lst.add(st);
    }

      listOfReasons = lst;
      listOfRegistrantCancelReasons = lstw;
      debugPrint('line 282: $lst');

  }

  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  bool flagPublishedButtonDisabled = false;
  double h = 1.0;
  double fontSize = 18;

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.sizeOf(context);
    double screenWidth = windowSize.width;
    double screenHeight = windowSize.height;
    double containerHeight = 32;
    double? h = windowSize.aspectRatio;
    int gridAxisCount = 1;
    if (h! < 1.0) {
      h = 1.0;
    }
    if (screenWidth! < 1400) {
      screenWidth = 1400;
    }
    debugPrint('line 201: $h $screenWidth $screenHeight');
    if (screenWidth! <= 650 || screenHeight! <= 650) {
      //portrait mode
      if (screenWidth! < screenHeight!) {
        fontSize = 14;
        containerHeight = 42;

      } else {
        fontSize = 14;
        containerHeight = 42;

        gridAxisCount = 2;
      }
    } else if (screenWidth! > 650 && screenWidth! <= 1200) {
      //tablet
      if (screenWidth! < screenHeight!) {
        fontSize = 18;
        containerHeight = 50;
        gridAxisCount = 2;
      } else  {
        fontSize = 16;
        containerHeight = 40;
        gridAxisCount = 3;
      }
    } else if (screenWidth! > 1200) {
      //desktop
      fontSize = 20;
      containerHeight = 60;
      gridAxisCount = 4;
    }
    double listTileScreenWidth = 350;
    debugPrint('line 336:  $gridAxisCount $fontSize $listTileScreenWidth ' );

    double smallFontSize = 14;
    smallFontSize /= h;
    debugPrint('line 40 in show cancel shifts');
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: Text("Cancel Shifts",
            style: TextStyle(
              fontSize:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! / h,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            )),
        leading: GestureDetector(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 24,
              color: Colors.black,
            ),
            onPressed: () {
              final navigator = Navigator.of(context)
                  .pushNamed(hcpMenu, arguments: arguments!);
            },
          ),
        ),
      ),
      body: FutureBuilder<dynamic>(
          future: Future.wait([_getAllConfirmedShifts()]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              debugPrint('line 364: ${snapshot.connectionState}');
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Container(
                  height: 100,
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ),
              );
            } else if (snapshot.data == [[]] &&
                snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Container(
                  height: 100,
                  child: Text('There are no confirmed shifts to cancel.',
                      style: TextStyle(
                          fontSize: fontSize,
                          color: color2,
                          fontWeight: FontWeight.bold)),
                ),
              );
            } else {
              List<dynamic> data = snapshot.data![0];
              debugPrint('line 328 $data ${data.length}');
              if (data.length == 0) {
                return Center(
                  child: Container(
                    height: 100,
                    child: Text('There are no confirmed shifts to cancel.',
                        style: TextStyle(
                            fontSize: fontSize,
                            color: color2,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              } else {
                List<dynamic> listH = snapshot.data[0];
                debugPrint('line 411: $listH');
                return SizedBox(
                  height: 900,
                  width: listTileScreenWidth,
                  child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            ),

            restorationId: 'ClientCampaignListView',
            itemCount: listH.length,
            itemBuilder: (BuildContext context, int index) {
              final item = listH[index];
              debugPrint('line 430: $item');
              return ClientCampaignTile(
                  itemm: item,
                  onButtonPressed: onButtonPressed,
                  showDialog: _showDialog,
                  ctx: context,
                  reasons: listOfReasons,
                  title: 'Cancellation Dialog',
                  description: 'Notify both the client and your CMS representative!',
                  fontSize: fontSize!,
                  gridAxisCount: gridAxisCount);
            }
            ),
                );
                //   ListView.builder(
                //   restorationId: 'ClientCampaignListView',
                //   itemCount: listH.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     final item = listH[index];
                //     return ClientCampaignTile(
                //         itemm: item,
                //         onButtonPressed: onButtonPressed,
                //         showDialog: _showDialog,
                //         flagPublishedButtonDisabled:
                //             flagPublishedButtonDisabled,
                //         ctx: context,
                //         reasons: listOfReasons,
                //         title: 'Cancellation Dialog',
                //         description:
                //             'Notify both the client and your CMS representative!');
                //   },
                // );
              }
            }
          }),
    );
  }
}

class ClientCampaignTile extends StatefulWidget {
  final Map<String, dynamic> itemm;
  final BuildContext ctx;
  final List<dynamic> reasons;
  final String title;
  final String description;
  final double fontSize;
  final int gridAxisCount;

  final void Function(Map<String, dynamic>, bool, BuildContext) onButtonPressed;
  final Future<bool> Function(BuildContext, String, String?) showDialog;

  const ClientCampaignTile(
      {required this.itemm,
      required this.onButtonPressed,
      required this.showDialog,
      required this.ctx,
      required this.reasons,
      required this.title,
      required this.description,
      required this.fontSize,
      required this.gridAxisCount});

  @override
  State<ClientCampaignTile> createState() => _ClientCampaignTileState();
}

class _ClientCampaignTileState extends State<ClientCampaignTile> {
  _ClientCampaignTileState();
  final _formKey = GlobalKey<FormState>();
  static final __formKey = new GlobalKey<FormState>();
  late Map<String, dynamic> item;
  UtilitiesServices utilitiesServices = UtilitiesServices();
  DropDownCodes dropDownCodes = DropDownCodes();
  List<dynamic> listOfReasons = [];

  Future<dynamic> getListOfReasons() async {
    try {
      listOfReasons = widget.reasons;

      debugPrint('line 398 get list of reasons: ${listOfReasons[0]}');
      return listOfReasons;
    } catch (e) {
      debugPrint('line 400: $e');
      return [];
    }
  }
  late int gridAxisCount;
  late String description;
  late String title;
  late double fontSize;
  @override
  initState() {
    super.initState();
    item = widget.itemm;
    gridAxisCount = widget.gridAxisCount;
    fontSize = widget.fontSize;
    title = widget.title;

    debugPrint('line 409: ${widget.reasons[0]}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  String convertFromTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    int tms = date.millisecondsSinceEpoch;

    DateTime dt = DateTime.fromMillisecondsSinceEpoch(tms + 18000);
    String sdt = formatter.format(dt);
    debugPrint('line 186: $sdt');
    return sdt;
  }

  DateFormat formatter = DateFormat('MM-dd-yyyy');
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  Color disabledTextColor = Colors.white;
  Color disabledColor = Colors.orange;
  bool flagPublishedButtonDisabled = false;
  void localButtonPressed(Map<String, dynamic> item, BuildContext ctx) {
    setState(() {
      flagPublishedButtonDisabled = true;
    });
    widget.onButtonPressed(item, flagPublishedButtonDisabled, ctx);
  }

  String getCityState(dynamic city, dynamic state) {
    String cty = city + ',' + state;
    return cty;
  }

  dynamic selectedCancelReasonValue = null;
  int selectedCancelReasonIndex = -1;

  Future<int> getReasonIndex(dynamic value) async {
    debugPrint('line 458 in getReasonindex');
    for (int i = 0; i < listOfReasons.length; i++) {
      if (value == listOfReasons[i]) {
        selectedCancelReasonIndex = i;
        selectedCancelReasonValue = value;
        break;
      }
    }
    debugPrint('line 465: $selectedCancelReasonIndex');
    return selectedCancelReasonIndex;
  }

  bool flagShowRed = false;
  double h = 1.0;
  String _getReason = 'HCP: Family Emergency';

  String getPayrateAsString(dynamic pr) {
    String prs = pr.toString();
    debugPrint('line 254: $pr $prs');
    double prd = double.parse(prs);
    prs = prd.toStringAsFixed(2);

    return prs;
  }
  final valueListenableCancelReason = ValueNotifier<String?>(null);
  @override
  Widget build(BuildContext context) {

    double smallFontSize = 16;
    smallFontSize /= h;
    double listTileScreenWidth = 350;

    debugPrint('line 98 in tile building $selectedCancelReasonValue');
    String hoursString =
        (item['decimalHours'] - (item['meals'] / 60)).toStringAsFixed(2);
    return Container(
      width: listTileScreenWidth,
      height: 500,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border.all(color: Color.fromARGB(255, 19, 125, 103), width: 4),
          borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Expanded(
            child: Container(
                height: 120,
                width: listTileScreenWidth,
                child: FutureBuilder<dynamic>(
                  future: Future.wait([
                    getListOfReasons(),
                  ]),
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {




                  }