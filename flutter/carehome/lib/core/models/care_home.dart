


class CareHomeData {
  final String name;
  final double latitude;
  final double longitude;
  final int salaryPerHour;
  final List<AppointmentDay> appointments;

  CareHomeData({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.salaryPerHour,
    required this.appointments,
  });
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

class TimeSlot {
  final String time;
  final bool isAvailable;

  TimeSlot({required this.time, this.isAvailable = true});
}
