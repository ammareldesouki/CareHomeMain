// lib/core/data/fakedata.dart

import 'package:carehome/core/models/care_home.dart';

import '../../features/careHome/application/data/models/application_model.dart';
import '../../features/careHome/offers/data/models/offer_model.dart';
import '../../features/psw/account/data/models/model.dart';

// ─── Care Home Account ───────────────────────────────────────────────────────
class CareHomeAccount {
  String name;
  String email;
  String phone;
  String address;
  String registrationNumber;
  String managerName;
  String logoUrl;

  CareHomeAccount({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.registrationNumber,
    required this.managerName,
    this.logoUrl = '',
  });
}

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



// ─── Applications ─────────────────────────────────────────────────────────────
final List<ApplicationModel> applications = [
  ApplicationModel(
    name: 'Sarah Johnson',
    email: 'sarah.j@email.com',
    position: 'Evening Care Assistant – Sunrise Care Home',
    appliedDate: '2026-01-20',
    phoneNumber: '+44 7911 123456',
    status: 'pending',
  ),
  ApplicationModel(
    name: 'Michael Brown',
    email: 'michael.b@email.com',
    position: 'Morning Care Assistant – Harmony Living',
    appliedDate: '2026-01-18',
    phoneNumber: '+44 7922 234567',
    status: 'accepted',
  ),
  ApplicationModel(
    name: 'Emily Davis',
    email: 'emily.d@email.com',
    position: 'Night Care Assistant – Golden Age',
    appliedDate: '2026-01-10',
    phoneNumber: '+44 7933 345678',
    status: 'expired',
  ),
  ApplicationModel(
    name: 'John Smith',
    email: 'john.s@email.com',
    position: 'Care Assistant – Sunrise Care Home',
    appliedDate: '2026-01-22',
    phoneNumber: '+44 7944 456789',
    status: 'pending',
  ),
  ApplicationModel(
    name: 'Aisha Patel',
    email: 'aisha.p@email.com',
    position: 'Evening Care Assistant – Sunrise Care Home',
    appliedDate: '2026-01-23',
    phoneNumber: '+44 7955 567890',
    status: 'pending',
  ),
];
PswProfile pswProfile = PswProfile(
  name: 'Sarah Johnson',
  email: 'sarah.j@email.com',
  phone: '+44 7911 123456',
  address: '14 Maple Street, London, UK',
  experience: '5 years in elderly care',
  qualifications: 'NVQ Level 3 in Health and Social Care',
  bio:
  'Passionate and dedicated care worker with over 5 years of experience supporting elderly and vulnerable individuals. Committed to providing compassionate, person-centred care.',
  rating: 4.9,
  completedShifts: 84,
);

// ─── Available Offers (from care homes) ──────────────────────────────────────

// ─── Applied Jobs ─────────────────────────────────────────────────────────────
List<AppliedJob> appliedJobs = [
  AppliedJob(
    id: 'aj1',
    offerTitle: 'Evening Care Assistant',
    careHomeName: 'Sunrise Care Home',
    branch: 'Main Branch',
    date: 'Saturday, 2026-02-15',
    timeFrom: '18:00',
    timeTo: '22:00',
    hourlyRate: 15.50,
    appliedDate: '2026-02-10',
    status: 'accepted',
  ),
  AppliedJob(
    id: 'aj2',
    offerTitle: 'Night Shift Nurse',
    careHomeName: 'Golden Age Residence',
    branch: 'West Wing',
    date: 'Monday, 2026-02-17',
    timeFrom: '22:00',
    timeTo: '06:00',
    hourlyRate: 18.00,
    appliedDate: '2026-02-12',
    status: 'pending',
  ),
  AppliedJob(
    id: 'aj3',
    offerTitle: 'Weekend Support Worker',
    careHomeName: 'Peaceful Life Care',
    branch: 'East Wing',
    date: 'Saturday, 2026-02-08',
    timeFrom: '09:00',
    timeTo: '17:00',
    hourlyRate: 14.00,
    appliedDate: '2026-02-03',
    status: 'rejected',
  ),
  AppliedJob(
    id: 'aj4',
    offerTitle: 'Morning Support Worker',
    careHomeName: 'Silver Years Center',
    branch: 'Garden Unit',
    date: 'Wednesday, 2026-02-19',
    timeFrom: '07:00',
    timeTo: '13:00',
    hourlyRate: 13.50,
    appliedDate: '2026-02-14',
    status: 'pending',
  ),
  AppliedJob(
    id: 'aj5',
    offerTitle: 'Dementia Care Specialist',
    careHomeName: 'Harmony Living',
    branch: 'Memory Unit',
    date: 'Tuesday, 2026-01-28',
    timeFrom: '14:00',
    timeTo: '20:00',
    hourlyRate: 16.50,
    appliedDate: '2026-01-20',
    status: 'accepted',
  ),
];