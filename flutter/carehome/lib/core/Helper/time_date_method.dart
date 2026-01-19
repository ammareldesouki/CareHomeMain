

import 'package:intl/intl.dart';

class TimeMethod{


  static String convertTimeToString(String dateString) {
    // Convert String to DateTime
    DateTime date = DateTime.parse(dateString);

    // Format date
    String formattedDate = DateFormat('dd MMM').format(date);

    return formattedDate; // 18 January 2026
  }





}
