import 'package:cms_web/features/shared/widgets/custom_card_widget.dart';
import 'package:flutter/material.dart';

class SummaryDetails extends StatelessWidget {
  const SummaryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: const Color(0xFF2F353E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildDetails('Schd', '9500'),
          buildDetails('Open', '450'),
          buildDetails('PCncl', '40'),
          buildDetails('HCncl', '10'),
        ],
      ),
    );
  }

  Widget buildDetails(String key, String value) {
    return Column(
      children: [
        Container(
          height: 28,
          child: Text(
            key,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          height: 28,
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
