//Client  tiemcard approval Scheduling Page
import 'package:flutter/material.dart';

class ClientTimecardApprovalSchedulingPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientTimecardApprovalSchedulingPage({super.key, required this.args});

  @override
  State<ClientTimecardApprovalSchedulingPage> createState() =>
      _ClientTimecardApprovalSchedulingPageState();
}

class _ClientTimecardApprovalSchedulingPageState
    extends State<ClientTimecardApprovalSchedulingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text('Time Card Approval'),
    );
  }
}
