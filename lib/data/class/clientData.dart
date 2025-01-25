class ClientData {
   int id; // Client dataset ID
   String identity; // Identity (e.g., Mr/Ms/Dr)
   String fullName; // Client full name
   String email; // Client email
   String mobile; // Client mobile number
   bool isFirstTimeBuyer; // Indicates if the client is a first-time buyer
   String address; // Address of the client
   int postCode; // Postal code
   String city; // City
   String state; // State
   DateTime? paymentDate; // Payment date
   String agencyCompany; // Agency company name
   String agentName; // Agent managing the client
   String agentPhone; // Agent's phone number
   String remarks; // Remarks or notes about the client
  

  ClientData({
    required this.id,
    required this.identity,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.isFirstTimeBuyer,
    required this.address,
    required this.postCode,
    required this.city,
    required this.state,
    this.paymentDate,
    required this.agencyCompany,
    required this.agentName,
    required this.agentPhone,
    required this.remarks,
  });
}
