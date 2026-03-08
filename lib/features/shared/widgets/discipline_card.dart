import 'package:flutter/material.dart';
import 'package:cms_web/features/clientapp/models/disciplines.dart';
//import 'package:auto_size_text/auto_size_text.dart';

class DisciplineCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final Discipline item;
  const DisciplineCard(
      {super.key,
      required this.onTap,
      required this.isSelected,
      required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          height: 72,
          padding: EdgeInsets.zero,
          child: TextButton(
            style: TextButton.styleFrom(
              elevation: 5,
              backgroundColor: Colors.white,
            ),
            onPressed: onTap,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    //  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          minHeight: 36,
                          maxHeight: 36,
                          minWidth: 120,
                          maxWidth: 120,
                        ),
                        //  height: 36,
                        //                   width: 120,
                        padding: EdgeInsets.zero,
                        child: Text(
                          item.disciplineName,
                          style: const TextStyle(
                            fontSize: 20,
                            height: 1,
                          ),
                        ),
                      ),
                      Container(
                          //   height: 36,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minHeight: 36,
                            maxHeight: 36,
                            minWidth: 120,
                            maxWidth: 120,
                          ),
                          // width: 120,
                          child: const Text('\$20.00}',
                              style: TextStyle(
                                fontSize: 20,
                                height: 1,
                              )))
                    ],
                  ),
                ),
                if (isSelected) // Show tick mark only if item is selected
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Icon(Icons.check_circle, color: Colors.green),
                    ),
                  ),
              ],
            ),
          ),
        ))
      ],
    );
  }
}
