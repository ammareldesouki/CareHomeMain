import '../models/care_home.dart';

final List<CareHomeData> CareHomeDatasFakeData = [

  CareHomeData(
    name: 'Sunrise Care Home',
    branch: 'Riyadh - North',
    distanceFromMe: 2.3,
    salaryPerHour: 55,
    appointments: [
      AppointmentDay(
        day: 'Monday',
        date: '2026-01-20',
        timeSlots: [
          TimeSlot(time: '10:00 AM - 12:00 PM',isAvailable: true),
          TimeSlot(time: '12:00 PM - 4:00 PM',isAvailable: false),
          TimeSlot(time: '8:00 PM - 10:00 PM',isAvailable: false),
        ],
      ),
    ],
  ),

  CareHomeData(
    name: 'Golden Age Residence',
    branch: 'Riyadh - East',
    distanceFromMe: 5.6,
    salaryPerHour: 60,
    appointments: [
      AppointmentDay(
        day: 'Tuesday',
        date: '2026-01-21',
        timeSlots: [
          TimeSlot(time: '9:00 AM - 1:00 PM',isAvailable: false),
          TimeSlot(time: '2:00 PM - 6:00 PM', isAvailable: false),
        ],
      ),
    ],
  ),

  CareHomeData(
    name: 'Peaceful Life Care',
    branch: 'Riyadh - West',
    distanceFromMe: 1.8,
    salaryPerHour: 50,
    appointments: [
      AppointmentDay(
        day: 'Wednesday',
        date: '2026-01-22',
        timeSlots: [
          TimeSlot(time: '8:00 AM - 12:00 PM',isAvailable: true),
          TimeSlot(time: '1:00 PM - 5:00 PM',isAvailable: false),
        ],
      ),
    ],
  ),

  CareHomeData(
    name: 'Hope Senior Living',
    branch: 'Riyadh - South',
    distanceFromMe: 6.1,
    salaryPerHour: 58,
    appointments: [
      AppointmentDay(
        day: 'Thursday',
        date: '2026-01-23',
        timeSlots: [
          TimeSlot(time: '7:00 AM - 11:00 AM',isAvailable: false),
          TimeSlot(time: '12:00 PM - 4:00 PM',isAvailable: false),
        ],
      ),
    ],
  ),

  CareHomeData(
    name: 'Comfort Haven',
    branch: 'Riyadh - Central',
    distanceFromMe: 3.0,
    salaryPerHour: 62,
    appointments: [
      AppointmentDay(
        day: 'Friday',
        date: '2026-01-24',
        timeSlots: [
          TimeSlot(time: '9:00 AM - 1:00 PM',isAvailable: true),
          TimeSlot(time: '2:00 PM - 6:00 PM',isAvailable: false),
        ],
      ),
    ],
  ),

  CareHomeData(
    name: 'Evergreen Care',
    branch: 'Riyadh - North',
    distanceFromMe: 4.5,
    salaryPerHour: 57,
    appointments: [
      AppointmentDay(
        day: 'Saturday',
        date: '2026-01-25',
        timeSlots: [
          TimeSlot(time: '10:00 AM - 2:00 PM'),
          TimeSlot(time: '3:00 PM - 7:00 PM'),
        ],
      ),


      AppointmentDay(
        day: 'Thursday',
        date: '2026-01-30',
        timeSlots: [
          TimeSlot(time: '9:00 AM - 1:00 PM'),
          TimeSlot(time: '2:00 PM - 6:00 PM'),
        ],
      ),
    ],
  ),

  CareHomeData(
    name: 'Serenity House',
    branch: 'Riyadh - East',
    distanceFromMe: 7.2,
    salaryPerHour: 65,
    appointments: [
      AppointmentDay(
        day: 'Sunday',
        date: '2026-01-26',
        timeSlots: [
          TimeSlot(time: '8:00 AM - 12:00 PM'),
          TimeSlot(time: '1:00 PM - 5:00 PM', isAvailable: false),
        ],
      ),
    ],
  ),

  CareHomeData(
    name: 'Bright Future Home',
    branch: 'Riyadh - West',
    distanceFromMe: 2.9,
    salaryPerHour: 53,
    appointments: [
      AppointmentDay(
        day: 'Monday',
        date: '2026-01-27',
        timeSlots: [
          TimeSlot(time: '9:00 AM - 12:00 PM'),
          TimeSlot(time: '1:00 PM - 4:00 PM'),
        ],
      ),
    ],
  ),

  CareHomeData(
    name: 'Harmony Living',
    branch: 'Riyadh - South',
    distanceFromMe: 6.8,
    salaryPerHour: 59,
    appointments: [
      AppointmentDay(
        day: 'Tuesday',
        date: '2026-01-28',
        timeSlots: [
          TimeSlot(time: '10:00 AM - 1:00 PM'),
          TimeSlot(time: '2:00 PM - 6:00 PM'),
        ],
      ),
    ],
  ),

  CareHomeData(
    name: 'Silver Years Center',
    branch: 'Riyadh - Central',
    distanceFromMe: 1.5,
    salaryPerHour: 70,
    appointments: [
      AppointmentDay(
        day: 'Wednesday',
        date: '2026-01-29',
        timeSlots: [
          TimeSlot(time: '8:00 AM - 12:00 PM'),
          TimeSlot(time: '1:00 PM - 5:00 PM'),
        ],
      ),
    ],
  ),

  CareHomeData(
    name: 'Gentle Touch Care',
    branch: 'Riyadh - North',
    distanceFromMe: 3.7,
    salaryPerHour: 56,
    appointments: [
      AppointmentDay(
        day: 'Thursday',
        date: '2026-01-30',
        timeSlots: [
          TimeSlot(time: '9:00 AM - 1:00 PM'),
          TimeSlot(time: '2:00 PM - 6:00 PM'),
        ],
      ),

      AppointmentDay(
        day: 'Thursday',
        date: '2026-01-30',
        timeSlots: [
          TimeSlot(time: '9:00 AM - 1:00 PM'),
          TimeSlot(time: '2:00 PM - 6:00 PM'),
        ],
      ),
      AppointmentDay(
        day: 'Thursday',
        date: '2026-01-30',
        timeSlots: [
          TimeSlot(time: '9:00 AM - 1:00 PM'),
          TimeSlot(time: '2:00 PM - 6:00 PM'),
        ],
      ),
      AppointmentDay(
        day: 'Thursday',
        date: '2026-01-30',
        timeSlots: [
          TimeSlot(time: '9:00 AM - 1:00 PM'),
          TimeSlot(time: '2:00 PM - 6:00 PM'),
        ],
      ),


    ],
  ),

  CareHomeData(
    name: 'New Life Residence',
    branch: 'Riyadh - East',
    distanceFromMe: 5.1,
    salaryPerHour: 61,
    appointments: [
      AppointmentDay(
        day: 'Friday',
        date: '2026-01-31',
        timeSlots: [
          TimeSlot(time: '10:00 AM - 2:00 PM'),
          TimeSlot(time: '3:00 PM - 7:00 PM'),
        ],
      ),
    ],
  ),
];
