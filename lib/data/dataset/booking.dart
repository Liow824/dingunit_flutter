import '../class/bookingTrx.dart';
import '../class/clientData.dart';

List<BookingTrx> bookingDataset = [
  // Existing successful booking
  BookingTrx(
    id: 1,
    authorId: 1, // Link to user ID
    status: "Success", // Status updated to "Success"
    createdDate: DateTime(2025, 1, 10), // Actual creation date
    clientData: ClientData(
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
      paymentDate: DateTime(2025, 1, 31), // Payment date
      agencyCompany: "Agency XYZ",
      agentName: "Agent Smith",
      agentPhone: "9876543210",
      remarks: "Important client",

    ),
  ),

  // Existing successful booking
  BookingTrx(
    id: 2,
    authorId: 2, // Link to regular user ID
    status: "Success",
    createdDate: DateTime(2025, 2, 5), // Actual creation date
    clientData: ClientData(
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
      paymentDate: DateTime(2025, 2, 15), // Payment date
      agencyCompany: "Agency ABC",
      agentName: "Agent Lee",
      agentPhone: "1122334455",
      remarks: "Returning client",

    ),
  ),

  // Booking for terminated user
  BookingTrx(
    id: 3, // Unique reservation ID
    authorId: 4, // Link to the terminated user ID
    status: "Fail", // Status updated to "Fail"
    createdDate: DateTime(2025, 3, 1), // Specific creation date
    clientData: ClientData(
      id: 3, // New client data ID
      identity: "Dr",
      fullName: "Sarah Connor",
      email: "sarah.connor@example.com",
      mobile: "5678901234",
      isFirstTimeBuyer: false,
      address: "789 Pine Street",
      postCode: 54321,
      city: "Newtown",
      state: "NY",
      paymentDate: DateTime(2025, 3, 5), // Payment date
      agencyCompany: "Agency ZYX",
      agentName: "Agent Carter",
      agentPhone: "9871234560",
      remarks: "Failed transaction",

    ),
  ),
];
