import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final dio = Dio();

class ShowHCPCredentialDetailsScreen extends StatefulWidget {
  const ShowHCPCredentialDetailsScreen(
      {super.key, required this.hcpCredential, required this.ctx});

  final Map<String, dynamic> hcpCredential;
  final BuildContext ctx;

  @override
  State<ShowHCPCredentialDetailsScreen> createState() =>
      _ShowHCPCredentialDetailsScreenState();
}

class _ShowHCPCredentialDetailsScreenState
    extends State<ShowHCPCredentialDetailsScreen> {
  //final bool _showCircle = false;

  String getBoolValues(bool? bl) {
    String bls = 'No';
    if (bl == null) {
      return bls;
    }
    if (bl == true) {
      bls = "Yes";
    }
    return bls;
  }

  String getFormattedDate(Timestamp dts) {
    debugPrint('line 32 detauks: $dts');
    DateTime dte = dts.toDate();
    String formattedDate =   DateFormat('MM/dd/yyyy').format(dte);

    return formattedDate;
    // DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final String formatted = formatter.format(dte);
    // return formatted;
  }

  String getStringData(String? st) {
    if (st == null) {
      return "No Data";
    }
    if (st.length > 30) {
      st = st.substring(0, 30);
    }
    return st;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    debugPrint('line 61 $width');
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Credential: ${getStringData(widget.hcpCredential['codeId'])}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(widget.ctx).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SafeArea(
          child: Center(
            child: Container(
              height: screenHeight - 120,
              width: 900,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('CredId: ${widget.hcpCredential['credentialId']}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                )),
                        SizedBox(width: 5),
                        Text(
                            'CredCode: ${getStringData(widget.hcpCredential['codeId'])}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                )),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 40,
                    width: 500,
                    child: Text(
                      'CredDesc: ${getStringData(widget.hcpCredential['credentialDescription'])}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 40,
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            width: 240,
                            child: Text(
                              'Type: ${widget.hcpCredential['credentialType']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 40,
                          width: 240,
                          child: Text(
                            'AqdDate: ${getFormattedDate(widget.hcpCredential['credAcquiredDate'])}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 40,
                    width: 500,
                    child: Text(
                      'Verifier: ${getStringData(widget.hcpCredential['credVerifiedBy'])}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 40,
                    width: 500,
                    child: Text(
                      'ExpDate: ${getFormattedDate(widget.hcpCredential['credExpirationDate'])}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 40,
                    width: 500,
                    child: Text(
                      'Verified: ${getFormattedDate(widget.hcpCredential['employeeVerifiedDate'])}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 40,
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            width: 240,
                            child: Text(
                              'Pass: ${getBoolValues(widget.hcpCredential['credPass'])}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 40,
                          width: 240,
                          child: Text(
                            'Warn: ${getBoolValues(widget.hcpCredential['credWarn'])}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 40,
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            width: 240,
                            child: Text(
                              'WillFail: ${getBoolValues(widget.hcpCredential['credWillFail'])}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 40,
                          width: 240,
                          child: Text(
                            'WillWarn: ${getBoolValues(widget.hcpCredential['credWillWarn'])}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 40,
                    width: 500,
                    child: Text(
                      'WarnDate: ${getFormattedDate(widget.hcpCredential['credWillWarnDate'])}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 40,
                    width: 500,
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 240,
                          child: Text(
                            'Agency Reqrd: ${getBoolValues(widget.hcpCredential['agencyRequired'])}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 40,
                          width: 240,
                          child: Text(
                            'Yes?No : ${getBoolValues(widget.hcpCredential['yesNoLabel'])}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
