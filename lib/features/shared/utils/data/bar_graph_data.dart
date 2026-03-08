import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/utils/data/models/graph_model.dart';
import 'package:cms_web/features/shared/utils/data/models/bar_graph_model.dart';

class BarGraphData {
  final data = [
    const BarGraphModel(label: 'Paid Amount', color: Color(0xFFFEB95A), graph: [
      GraphModel(x: 0, y: 8),
      GraphModel(x: 1, y: 10),
      GraphModel(x: 2, y: 9),
      GraphModel(x: 3, y: 6),
      GraphModel(x: 4, y: 8),
      GraphModel(x: 5, y: 7),
      GraphModel(x: 6, y: 5),
    ]),
    const BarGraphModel(label: "Balance Due", color: Color(0xFFF2C8ED), graph: [
      GraphModel(x: 0, y: 8),
      GraphModel(x: 1, y: 10),
      GraphModel(x: 2, y: 9),
      GraphModel(x: 3, y: 6),
      GraphModel(x: 4, y: 6),
      GraphModel(x: 5, y: 7),
      GraphModel(x: 6, y: 7),
    ]),
    const BarGraphModel(label: 'Credit', color: Color(0xFF20AEF3), graph: [
      GraphModel(x: 0, y: 3),
      GraphModel(x: 1, y: 1),
      GraphModel(x: 2, y: 2),
      GraphModel(x: 3, y: 2),
      GraphModel(x: 4, y: 4),
      GraphModel(x: 5, y: 3),
      GraphModel(x: 6, y: 2),
    ])
  ];
  final label = ['M', 'T', 'W', 'Th', 'F', 'Sa', 'Su'];
}
