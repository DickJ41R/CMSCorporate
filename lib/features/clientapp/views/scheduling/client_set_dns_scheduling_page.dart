//Client set dns Scheduling Page
import 'package:flutter/material.dart';

class ClientSetDNSSchedulingPage extends StatefulWidget {
  final Map<String, String> args;
  const ClientSetDNSSchedulingPage({super.key, required this.args});

  @override
  State<ClientSetDNSSchedulingPage> createState() =>
      _ClientSetDNSSchedulingPageState();
}

class _ClientSetDNSSchedulingPageState
    extends State<ClientSetDNSSchedulingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text('Set DNS'),
    );
  }
}
