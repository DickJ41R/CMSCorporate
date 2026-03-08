import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/utils/data/pie_chart_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cms_web/features/shared/utils/colorsconstants.dart';

class Chart extends StatelessWidget {
  const Chart({super.key});
  @override
  Widget build(BuildContext context) {
    final pieChartData = ChartData();

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: pieChartData.pieChartSelectionDatas,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding),
                Text(
                  "95%",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                const SizedBox(height: 8),
                const Text("of 100%")
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     final pieChartData = ChartData();
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Shift Scheduling Data',
//               style: TextStyle(
//                   height: 32,
//                   fontSize: 12,
//                   color: Colors.black
//
//               )),
//
//         ),
//         body: Stack(
//             children: [
//               Container (
//                 height: 250,
//               child: PieChart(
//                   PieChartData(
//                     sectionsSpace: 0,
//                     centerSpaceRadius: 70,
//                     startDegreeOffset: -90,
//                     sections: pieChartData.pieChartSelectionDatas,
//                   )
//               ),
//               ),
//               Positioned.fill(
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: defaultPadding),
//                         Text(
//                           "95",
//                           style: Theme
//                               .of(context)
//                               .textTheme
//                               .headlineMedium!
//                               .copyWith(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                               height: 0.5
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         const Text('0f 100%')
//                       ]
//                   )
//               )
//             ]
//         )
//     );
//   }
// }
