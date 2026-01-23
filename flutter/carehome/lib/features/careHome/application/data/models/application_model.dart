class ApplicationModel {
  final String name;
  final String email;
  final String position;
  final String appliedDate;
  final String status; // pending | accepted | expired

  ApplicationModel({
    required this.name,
    required this.email,
    required this.position,
    required this.appliedDate,
    required this.status,
  });
}
