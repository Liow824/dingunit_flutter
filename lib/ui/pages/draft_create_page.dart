import 'package:flutter/material.dart';
import 'dart:math';
import '../../data/class/clientData.dart';
import '../../data/dataset/client.dart';
import '../../data/dataset/user.dart';
import '../../nav/session_manager.dart';

class DraftCreatePage extends StatefulWidget {
  const DraftCreatePage({super.key});

  @override
  _DraftCreatePageState createState() => _DraftCreatePageState();
}

class _DraftCreatePageState extends State<DraftCreatePage> {
  final List<String> titles = [
    'Mr.',
    'Ms.',
    'Mrs.',
    'Dr.',
    'JP',
    'Pehin',
    'Datin',
    'Datuk',
    'Dato\'',
    'Dato',
    'Datuk Seri',
    'Datin Seri',
    'Dato\' Sri',
    'Tan Sri',
    'Puan Sri',
    'Tun',
    'Not Applicable',
  ];

  // Controllers and variables
  String? _selectedIdentity;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _agencyCompanyController = TextEditingController();
  final TextEditingController _agentNameController = TextEditingController();
  final TextEditingController _agentPhoneController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  DateTime? _selectedPaymentDate;
  bool _isFirstTimeBuyer = false;

  // Save Draft Functionality
  void saveDraft(Map<String, dynamic> clientDataMap) {
    int generateRandomId() {
      Random random = Random();
      return 100000 + random.nextInt(900000);
    }

    int newDraftId;
    do {
      newDraftId = generateRandomId();
    } while (clientDataset.any((client) => client.id == newDraftId));

    ClientData newDraft = ClientData(
      id: newDraftId,
      identity: clientDataMap['identity'],
      fullName: clientDataMap['fullName'],
      email: clientDataMap['email'],
      mobile: clientDataMap['mobile'],
      isFirstTimeBuyer: clientDataMap['isFirstTimeBuyer'],
      address: clientDataMap['address'],
      postCode: clientDataMap['postCode'],
      city: clientDataMap['city'],
      state: clientDataMap['state'],
      paymentDate: clientDataMap['paymentDate'],
      agencyCompany: clientDataMap['agencyCompany'],
      agentName: clientDataMap['agentName'],
      agentPhone: clientDataMap['agentPhone'],
      remarks: clientDataMap['remarks'],
    );

    clientDataset.add(newDraft);

    int? currentUserId = SessionManager.currentUserId;
    if (currentUserId != null) {
      final currentUser = userDataset.firstWhere((user) => user.id == currentUserId);
      currentUser.clientIds.add(newDraftId);
    }

    print("Draft saved with ID: $newDraftId");
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Client Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title and Full Name
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      decoration: inputDecoration.copyWith(labelText: 'Title*'),
                      items: titles
                          .map((title) => DropdownMenuItem(
                                value: title,
                                child: Text(title),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedIdentity = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _fullNameController,
                      decoration: inputDecoration.copyWith(labelText: 'Full Name*'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Email and Mobile Number
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(labelText: 'Email*'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(labelText: 'Mobile*'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Address and Postcode
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(labelText: 'Address*'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(labelText: 'Postcode*'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // City and State
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(labelText: 'City*'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(labelText: 'State*'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Agency and Agent Name
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(labelText: 'Agency Company*'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(labelText: 'Agent Name*'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Agent Phone and Remarks
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(labelText: 'Agent Phone*'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(labelText: 'Remarks*'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Is First-Time Buyer and Payment Date
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CheckboxListTile(
                      title: const Text('First-Time Buyer'),
                      value: _isFirstTimeBuyer,
                      onChanged: (value) {
                        setState(() {
                          _isFirstTimeBuyer = value ?? false; // Update state when toggled
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      readOnly: true,
                      decoration: inputDecoration.copyWith(labelText: 'Payment Date'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedPaymentDate = pickedDate;
                          });
                        }
                      },
                      controller: TextEditingController(
                        text: _selectedPaymentDate != null
                            ? "${_selectedPaymentDate!.day}/${_selectedPaymentDate!.month}/${_selectedPaymentDate!.year}"
                            : '',
                      ),
                    ),
                  ),
                ],
              ),

              // Payment Date Picker
              

              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> clientDataMap = {
                    'identity': _selectedIdentity,
                    'fullName': _fullNameController.text,
                    'email': _emailController.text,
                    'mobile': _mobileController.text,
                    'isFirstTimeBuyer': _isFirstTimeBuyer,
                    'address': _addressController.text,
                    'postCode': int.tryParse(_postCodeController.text) ?? 0,
                    'city': _cityController.text,
                    'state': _stateController.text,
                    'paymentDate': _selectedPaymentDate,
                    'agencyCompany': _agencyCompanyController.text,
                    'agentName': _agentNameController.text,
                    'agentPhone': _agentPhoneController.text,
                    'remarks': _remarksController.text,
                  };

                  saveDraft(clientDataMap);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Draft saved successfully!')),
                  );
                },
                child: const Text('Save Draft'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
