import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/utils/data/expenditure_details.dart';
import 'package:cms_web/features/shared/widgets/custom_card_widget.dart';

class ActivityDetailsCard extends StatelessWidget {
  const ActivityDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final expenditureDetails = ExpenditureDetails();
    return GridView.builder(
      itemCount: expenditureDetails.expenditureData.length,
      shrinkWrap: true, //only take up reauired space
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 15,
        mainAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) => CustomCard(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(expenditureDetails.expenditureData[index].icon,
              width: 30, height: 30),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 4),
            child: Text(expenditureDetails.expenditureData[index].value,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                )),
          ),
          Text(expenditureDetails.expenditureData[index].title,
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal)),
        ],
      )),
    );
  }
}
