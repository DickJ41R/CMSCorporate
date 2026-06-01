class CalendarServices {
  final List<DateTime>? listOfDates;
  const CalendarServices({this.listOfDates});

  CalendarServices copyWith({List<DateTime>? listOfDates}) {
    return CalendarServices(listOfDates: listOfDates ?? this.listOfDates);
  }
}

// class CalendarServicesNotifier extends StateNotifier<CalendarServices> {
//
//   CalendarServicesNotifier(listOfDates) :
//         super((CalendarServices(listOfDates: listOfDates)));
//
//   void updateListOfDates(List<DateTime> listOfDates) {
//     state = state.copyWith(listOfDates:listOfDates);
//   }
//   List<DateTime>? get fromListOfDates {
//     return state.listOfDates;
//   }
//}
