import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cms_web/features/shared/widgets/hcp_show_payment_pdf.dart';

final dio = Dio();

class ShowHCPPaymentDetailsScreen extends StatefulWidget {
  const ShowHCPPaymentDetailsScreen(
      {super.key,
      required this.paymentItem,
      required this.orgId,
      required this.args,
      required this.ctx});

  final Map<String, dynamic> paymentItem;
  final String orgId;
  final Map<String, dynamic> args;
  final BuildContext ctx;

  @override
  State<ShowHCPPaymentDetailsScreen> createState() =>
      _ShowHCPPaymentDetailsScreenState();
}

class _ShowHCPPaymentDetailsScreenState
    extends State<ShowHCPPaymentDetailsScreen> {
  // final bool _showCircle = false;

  // Widget _getAShortDateTime(DateTime dt ,String st, BuildContext ctx) {
  //   //  DateTime d2 =  DateTime.fromMillisecondsSinceEpoch(dt.seconds*1000);
  //   String sdt = "${dt.toString().padLeft(2,'0')}-${dt.month.toString().padLeft(2,'0')}-${dt.year}";
  //   return Text('$st $sdt',
  //     style: Theme.of(ctx).textTheme.bodyMedium!.copyWith(
  //       color: Theme.of(ctx).colorScheme.onSurface,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   );
  // }
  String getShortDate(dte) {
    if (dte == null) {
      return 'No Date';
    }
    if (dte.length >= 10) {
      return dte.substring(0, 10);
    }
    return 'No Date';
  }

  String formatMoney(dynamic money) {
    if (money == null) {
      return '0.00';
    }
    String st = money.toString();
    int idx = st.indexOf('.');
    if (idx == st.length - 2) {
      st += '0';
    }
    return st;
  }

  @override
  void initState() {
    super.initState();
  }

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
      backgroundColor: color1,
      appBar: AppBar(
        title: Text('Payment Details Screen',
            style: TextStyle(
              fontSize:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! / h,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(widget.ctx);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 36,
                  width: screenWidth! - 10,
                  child:
                      Text('ChkRegId: ${widget.paymentItem['checkRegisterId']}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          )),
                ),
                SizedBox(height: 5),
                Container(
                  height: 36,
                  width: screenWidth! - 10,
                  child: Text(
                    'Chk#: ${widget.paymentItem['checkNumber']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 36,
                  width: screenWidth! - 10,
                  child: Text(
                    'check Date: ${getShortDate(widget.paymentItem['checkDate'].toString())}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 36,
                  width: screenWidth! - 10,
                  child: Text(
                    'Chk Amount: \$${formatMoney(widget.paymentItem['checkAmount'])}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 36,
                  width: screenWidth! - 10,
                  child: Text(
                    'Gross Wages: \$${formatMoney(widget.paymentItem['grossWages'])}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 36,
                  width: screenWidth! - 10,
                  child: Text(
                    'Pay Period: ${widget.paymentItem['payPeriodId']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 36,
                  width: screenWidth! - 10,
                  child: Text(
                    'Period End: ${getShortDate(widget.paymentItem['periodEnding'].toString())}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 36,
                  width: screenWidth! - 10,
                  child: Text(
                    'hcpId: ${widget.paymentItem['regId']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 36,
                  width: screenWidth! - 10,
                  child: Text(
                    'HCP Name: ${widget.paymentItem['RegName']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 36,
                  width: 370,
                  child: Text(
                    'Employee Id: ${widget.paymentItem['employeeId']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 36,
                  width: screenWidth! - 10,
                  child: Text(
                    'Branch Name: ${widget.paymentItem['branchName']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Visibility(
                    //    visible: _showCircle,
                    //   child: CircularProgressIndicator(),
                    // ),
                    // Button for getting request
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        height: 40,
                        width: screenWidth! - 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => HCPShowPaymentPDF(
                                        hcpId: widget.paymentItem['regId']
                                            .toString(),
                                        checkRegisterId: widget
                                            .paymentItem['checkRegisterId']
                                            .toString(),
                                        orgId: widget.orgId,
                                        args: widget.args),
                                  ),
                                );
                              },
                              child: Text('Press to Show Check PDF',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: smallFontSize,
                                    fontWeight: FontWeight.bold,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
