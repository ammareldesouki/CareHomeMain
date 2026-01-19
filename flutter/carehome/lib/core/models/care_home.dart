class TimeSlot {
  final String time;
  bool? isAvailable;

  TimeSlot({required this.time, this.isAvailable =true });
}

class AppointmentDay {
  final String day;
  final String date;
  final List<TimeSlot> timeSlots;

  AppointmentDay({
    required this.day,
    required this.date,
    required this.timeSlots,
  });
}

class CareHomeData {
  final String name;
  final String branch;
  final double distanceFromMe;
  final double salaryPerHour;
  final List<AppointmentDay> appointments;

  CareHomeData({
    required this.name,
    required this.branch,
    required this.distanceFromMe,
    required this.salaryPerHour,
    required this.appointments,
  });
}
