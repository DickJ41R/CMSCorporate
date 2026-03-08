import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/widgets/header_widget.dart';
import 'package:cms_web/features/shared/widgets/activity_details_card.dart';
import 'package:cms_web/features/shared/widgets/line_chart_card.dart';
import 'package:cms_web/features/shared/widgets/bar_graph_widget.dart';
import 'package:cms_web/features/shared/widgets/summary_widget.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(children: [
          const SizedBox(height: 10),
          const HeaderWidget(),
          const SizedBox(height: 10),
          const ActivityDetailsCard(),
          const SizedBox(height: 10),
          const LineChartCard(),
          const SizedBox(height: 10),
          //      const BarGraphCard(),
          //    const SizedBox(height: 10),
        ]),
      ),
    );
  }
}
