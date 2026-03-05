class ShiftModel {
  final String shiftId;
  final String date;
  final String startTime;
  final String endTime;
  final bool isAvailable;

  const ShiftModel({
    required this.shiftId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  factory ShiftModel.fromMap(Map<String, dynamic> map) => ShiftModel(
    shiftId: map['shiftId'] ?? '',
    date: map['date'] ?? '',
    startTime: map['startTime'] ?? '',
    endTime: map['endTime'] ?? '',
    isAvailable: map['isAvailable'] ?? false,
  );
}
