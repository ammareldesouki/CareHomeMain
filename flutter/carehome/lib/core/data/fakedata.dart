import '../../../core/models/care_home.dart';
import '../../features/careHome/application/data/models/application_model.dart';

final List<CareHomeData> CareHomeDatasFakeData = [
  CareHomeData(
    name: 'Sunrise Care Home',
    latitude: 24.1315,
    longitude: 47.2690,
    salaryPerHour: 55,
    appointments: [],
  ),
  CareHomeData(
    name: 'Golden Age Residence',
    latitude: 24.1280,
    longitude: 47.2650,
    salaryPerHour: 60,
    appointments: [
      AppointmentDay(day: 'Monday',
        date: '2026-01-20',
        timeSlots: [
          TimeSlot(from: '10:00 AM ', to: ' 12:00 PM', isAvailable: true),
          TimeSlot(from: '12:00 PM ', to: ' 4:00 PM', isAvailable: false),
          TimeSlot(from: '8:00 PM ', to: '10:00 PM', isAvailable: false),
        ],),
    ],
  ),
  CareHomeData(
    name: 'Peaceful Life Care',
      latitude: 24.1350,
      longitude: 47.2705,
    salaryPerHour: 50,
      appointments: [
        AppointmentDay(day: 'Monday',
            date: '2026-01-20',
            timeSlots: [
              TimeSlot(from: '10:00 AM ', to: '12:00 PM', isAvailable: true),
              TimeSlot(from: '12:00 PM ', to: ' 4:00 PM', isAvailable: false),
              TimeSlot(from: '8:00 PM ', to: '10:00 PM', isAvailable: false)
            ]),
        AppointmentDay(day: 'Monday',
          date: '2026-01-20',
          timeSlots: [
            TimeSlot(from: '10:00 AM ', to: ' 12:00 PM', isAvailable: true),
            TimeSlot(from: '12:00 PM ', to: ' 4:00 PM', isAvailable: false),
            TimeSlot(from: '8:00 PM ', to: ' 10:00 PM', isAvailable: false),
          ],
        ),
      ]),
  CareHomeData(
    name: 'Silver Years Center',
    latitude: 24.1290,
    longitude: 47.2630,
    salaryPerHour: 70,
    appointments: [],
  ),
];

final List<ApplicationModel> applications = [
  ApplicationModel(name: 'Sarah Johnson',
    email: 'sarah.j@email.com',
    position: 'Evening Care Assistant – Sunrise Care Home',
    appliedDate: '2026-01-20',
    status: 'pending',),
  ApplicationModel(name: 'Michael Brown',
    email: 'michael.b@email.com',
    position: 'Morning Care Assistant – Harmony Living',
    appliedDate: '2026-01-18',
    status: 'accepted',),
  ApplicationModel(name: 'Emily Davis',
    email: 'emily.d@email.com',
    position: 'Night Care Assistant – Golden Age',
    appliedDate: '2026-01-10',
    status: 'expired',),
  ApplicationModel(name: 'John Smith',
    email: 'john.s@email.com',
    position: 'Care Assistant – Sunrise Care Home',
    appliedDate: '2026-01-22',
    status: 'pending',),
];