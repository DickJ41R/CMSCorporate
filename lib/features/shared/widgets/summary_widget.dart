import 'package:cms_web/features/shared/utils/colorsconstants.dart';
import 'package:cms_web/features/shared/widgets/pie_chart_widget.dart';
import 'package:cms_web/features/shared/widgets/summary_details.dart';
import 'package:flutter/material.dart';

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      decoration: const BoxDecoration(
        color: cardBackgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Chart(),
            SizedBox(height: 15),
            Container(
              width: screenWidth - 10,
              height: 40,
              child: const Text(
                'Summary',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const Expanded(
              child: SummaryDetails(),
            ),
            const Expanded(child: Text('Schduled')),
          ],
        ),
      ),
    );
  }
}
