import 'package:flutter_application/data/class/clientData.dart';

class BookingTrx {
  final int id; // Transaction ID
  final int authorId; // User ID who made the transaction
  final String status; // Status of the transaction: Failed/Success
  final DateTime createdDate; // Date of transaction creation

  // Embedded client data (copied from the ClientData class)
  final ClientData clientData;

  BookingTrx({
    required this.id,
    required this.authorId,
    required this.status,
    required this.createdDate,
    required this.clientData,
  });

  // Method to get categorized information
  Map<String, String> getCategorizedInformation() {
    // Combine customer information into a string
    final customerInfo = '''
    Name: ${clientData.fullName}
    Identity: ${clientData.identity}
    Email: ${clientData.email}
    Mobile: ${clientData.mobile}
    Address: ${clientData.address}, ${clientData.city}, ${clientData.state} (${clientData.postCode})
    First-Time Buyer: ${clientData.isFirstTimeBuyer ? 'Yes' : 'No'}
    Remarks: ${clientData.remarks}
    ''';

    // Combine agent information into a string
    final agentInfo = '''
    Agency: ${clientData.agencyCompany}
    Agent Name: ${clientData.agentName}
    Agent Phone: ${clientData.agentPhone}
    ''';

    // Combine transaction information into a string
    final transactionInfo = '''
    Reservation ID: $id
    Author ID: $authorId
    Status: $status
    Created Date: ${createdDate.toLocal().toString()}
    Payment Date: ${clientData.paymentDate?.toLocal().toString() ?? 'N/A'}
    ''';

    // Return categorized data as a map
    return {
      'Customer Information': customerInfo,
      'Agent Information': agentInfo,
      'Transaction Information': transactionInfo,
    };
  }
}
