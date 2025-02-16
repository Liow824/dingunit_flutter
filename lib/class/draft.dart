class Draft {
  final int id; // Draft ID
  String title; // Title
  String name; // Name
  String email; // Email
  String mobile; // Mobile
  bool firstTime; // FirstTime
  String address; // Address
  int postCode; // PostCode
  String city; // City
  String state; // State
  DateTime paymentDate; // PaymentDate
  String agencyCmp; // AgencyCmp
  String agentName; // AgentName
  String agentPhone; // AgentPhone
  String remarks; // Remarks
  String guid; // GUID

  Draft({
    required this.id,
    required this.title,
    required this.name,
    required this.email,
    required this.mobile,
    required this.firstTime,
    required this.address,
    required this.postCode,
    required this.city,
    required this.state,
    required this.paymentDate,
    required this.agencyCmp,
    required this.agentName,
    required this.agentPhone,
    required this.remarks,
    required this.guid,
  });

  factory Draft.fromJson(Map<String, dynamic> json) {
    return Draft(
      id: json['ID'],
      title: json['Title'],
      name: json['Name'],
      email: json['Email'],
      mobile: json['Mobile'],
      firstTime: json['FirstTime'] == 1,
      address: json['Address'],
      postCode: json['PostCode'],
      city: json['City'],
      state: json['State'],
      paymentDate: DateTime.parse(json['PaymentDate']),
      agencyCmp: json['AgencyCmp'],
      agentName: json['AgentName'],
      agentPhone: json['AgentPhone'],
      remarks: json['Remarks'],
      guid: json['GUID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Title': title,
      'Name': name,
      'Email': email,
      'Mobile': mobile,
      'FirstTime': firstTime ? 1 : 0,
      'Address': address,
      'PostCode': postCode,
      'City': city,
      'State': state,
      'PaymentDate': paymentDate.toIso8601String(),
      'AgencyCmp': agencyCmp,
      'AgentName': agentName,
      'AgentPhone': agentPhone,
      'Remarks': remarks,
      'GUID': guid,
    };
  }
}
