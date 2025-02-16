class Reservation {
  final int id; // Reservation ID
  String authorGuid; // AuthorGUID
  String status; // Status
  DateTime createdTime; // CreatedTime
  int clientDataGuid; // ClientDataGUID

  Reservation({
    required this.id,
    required this.authorGuid,
    required this.status,
    required this.createdTime,
    required this.clientDataGuid,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['ID'],
      authorGuid: json['AuthorGUID'],
      status: json['Status'],
      createdTime: DateTime.parse(json['CreatedTime']),
      clientDataGuid: json['ClientDataGUID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'AuthorGUID': authorGuid,
      'Status': status,
      'CreatedTime': createdTime.toIso8601String(),
      'ClientDataGUID': clientDataGuid,
    };
  }
}
