import 'package:cms_web/features/shared/utils/data/models/expenditure_model.dart';

class ExpenditureDetails {
  final expenditureData = const [
    ExpenditureModel(
        icon: 'assets/icons/dollar.jpeg',
        value: '100,000',
        title: 'Total Billed'),
    ExpenditureModel(
        icon: 'assets/icons/dollar.jpeg', value: '80,000', title: 'Paid'),
    ExpenditureModel(
        icon: 'assets/icons/dollar.jpeg',
        value: '30,000',
        title: 'Total Credit'),
    ExpenditureModel(
        icon: 'assets/icons/dollar.jpeg', value: '50,000', title: 'Credit Left')
  ];
}
