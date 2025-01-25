import '../class/clientData.dart';

List<ClientData> clientDataset = [
  ClientData(
    id: 1,
    identity: "Mr",
    fullName: "John Doe",
    email: "johndoe@example.com",
    mobile: "1234567890",
    isFirstTimeBuyer: true,
    address: "123 Main Street",
    postCode: 12345,
    city: "Springfield",
    state: "IL",
    paymentDate: DateTime(2025, 1, 31), // Specific date
    agencyCompany: "Agency XYZ",
    agentName: "Agent Smith",
    agentPhone: "9876543210",
    remarks: "Important client",
  ),

  ClientData(
    id: 2,
    identity: "Ms",
    fullName: "Emily Wong",
    email: "emily.wong@example.com",
    mobile: "0987654321",
    isFirstTimeBuyer: false,
    address: "456 Maple Avenue",
    postCode: 67890,
    city: "Oakwood",
    state: "CA",
    paymentDate: DateTime(2025, 2, 15), // Specific date
    agencyCompany: "Agency ABC",
    agentName: "Agent Lee",
    agentPhone: "1122334455",
    remarks: "Returning client",
  ),
];
