import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application/api_service.dart';

class DraftEditPage extends StatefulWidget {
  final Map<String, dynamic> draftData;

  const DraftEditPage({super.key, required this.draftData});

  @override
  DraftEditPageState createState() => DraftEditPageState();
}

class DraftEditPageState extends State<DraftEditPage> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown options
  final List<String> identityTypes = [
    'MyKad (NRIC)',
    'Passport',
    'Military / Police',
    'Company / Registration Number'
  ];

  final List<String> titles = [
    'Mr.',
    'Ms.',
    'Mrs.',
    'Dr.',
    'JP',
    'Pehin',
    'Datin',
    'Datuk',
    "Dato'",
    'Datuk Seri',
    'Datin Seri',
    "Dato' Sri",
    'Tan Sri',
    'Puan Sri',
    'Tun',
    'Non applicable'
  ];

  final List<String> states = [
    'Johor',
    'Perlis',
    'Wilayah Persekutuan Putrajaya',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu'
  ];

  final List<Map<String, String>> firstTimeBuyerOptions = [
    {'display': 'Yes', 'value': 'Y'},
    {'display': 'No', 'value': 'N'},
  ];

  // Selected dropdown values
  String? _selectedIdentityType;
  String? _selectedTitle;
  String? _selectedState;
  String? _selectedFirstTimeBuyer;
  DateTime? _selectedPaymentDate;

  // Controllers for text fields
  final TextEditingController _mhubEmailController = TextEditingController();
  final TextEditingController _mhubPasswordController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _blockNameController = TextEditingController();
  final TextEditingController _unitNameController = TextEditingController();
  final TextEditingController _identityNumberController =
      TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _preferredNameController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _agencyCompanyController =
      TextEditingController();
  final TextEditingController _agentNameController = TextEditingController();
  final TextEditingController _agentPhoneController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _paymentDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    _mhubEmailController.text = widget.draftData['MhubEmail'] ?? '';
    _mhubPasswordController.text = widget.draftData['MhubPassword'] ?? '';
    _projectNameController.text = widget.draftData['ProjectName'] ?? '';
    _blockNameController.text = widget.draftData['BlockName'] ?? '';
    _unitNameController.text = widget.draftData['UnitName'] ?? '';
    _selectedIdentityType = widget.draftData['IdentityType'];
    _identityNumberController.text = widget.draftData['IdentityNumber'] ?? '';
    _selectedTitle = widget.draftData['Title'];
    _fullNameController.text = widget.draftData['FullName'] ?? '';
    _preferredNameController.text = widget.draftData['PreferredName'] ?? '';
    _emailController.text =
        widget.draftData['ClientEmail'] ?? ''; // Note: Changed to ClientEmail
    _mobileController.text = widget.draftData['Mobile'] ?? '';
    _addressController.text = widget.draftData['Address'] ?? '';
    _postCodeController.text = widget.draftData['PostCode']?.toString() ?? '';
    _cityController.text = widget.draftData['City'] ?? '';
    _selectedState = widget.draftData['State'];
    _selectedFirstTimeBuyer =
        widget.draftData['FirstTime'] == 'Y' ? 'Yes' : 'No';
    _agencyCompanyController.text = widget.draftData['AgencyCmp'] ?? '';
    _agentNameController.text = widget.draftData['AgentName'] ?? '';
    _agentPhoneController.text = widget.draftData['AgentPhone'] ?? '';
    _remarksController.text = widget.draftData['Remarks'] ?? '';

    if (widget.draftData['PaymentDate'] != null &&
        widget.draftData['PaymentDate'].isNotEmpty) {
      _selectedPaymentDate = DateTime.tryParse(widget.draftData['PaymentDate']);
      if (_selectedPaymentDate != null) {
        _paymentDateController.text =
            DateFormat('dd/MM/yyyy').format(_selectedPaymentDate!);
      }
    }
  }

  Future<void> _pickPaymentDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedPaymentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedPaymentDate = picked;
        _paymentDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _updateDraft() async {
    if (!_formKey.currentState!.validate()) return;

    final String draftGuid = widget.draftData['GUID'];
    final String authorGuid = widget.draftData['AuthorGUID'];

    final Map<String, dynamic> updatedData = {
      'DraftGuid': draftGuid,
      'AuthorGuid': authorGuid,
      'MhubEmail': _mhubEmailController.text,
      'MhubPassword': _mhubPasswordController.text,
      'ProjectName': _projectNameController.text,
      'BlockName': _blockNameController.text,
      'UnitName': _unitNameController.text,
      'IdentityType': _selectedIdentityType ?? '',
      'IdentityNumber': _identityNumberController.text,
      'Title': _selectedTitle ?? '',
      'FullName': _fullNameController.text,
      'PreferredName': _preferredNameController.text,
      'ClientEmail': _emailController.text, // Note: Changed to ClientEmail
      'Mobile': _mobileController.text,
      'Address': _addressController.text,
      'Postcode': _postCodeController.text,
      'City': _cityController.text,
      'State': _selectedState ?? '',
      'FirstTime': _selectedFirstTimeBuyer == 'Yes' ? 'Y' : 'N',
      'PaymentDate': _selectedPaymentDate != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedPaymentDate!)
          : '',
      'AgencyCmp': _agencyCompanyController.text,
      'AgentName': _agentNameController.text,
      'AgentPhone': _agentPhoneController.text,
      'Remarks': _remarksController.text,
    };

    try {
      final response = await ApiService.updateDraft(updatedData);

      if (response['status_code'] == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Draft updated successfully!')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Draft")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _mhubEmailController,
                decoration: const InputDecoration(labelText: "Mhub Email"),
              ),
              TextFormField(
                controller: _mhubPasswordController,
                decoration: const InputDecoration(labelText: "Mhub Password"),
              ),
              TextFormField(
                controller: _projectNameController,
                decoration: const InputDecoration(labelText: "Project Name"),
              ),
              TextFormField(
                controller: _blockNameController,
                decoration: const InputDecoration(labelText: "Block Name"),
              ),
              TextFormField(
                controller: _unitNameController,
                decoration: const InputDecoration(labelText: "Unit Name"),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: "Identity Type"),
                value: _selectedIdentityType,
                items: identityTypes
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedIdentityType = value),
              ),
              TextFormField(
                controller: _identityNumberController,
                decoration: const InputDecoration(labelText: "Identity Number"),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: "Title"),
                value: _selectedTitle,
                items: titles
                    .map((title) =>
                        DropdownMenuItem(value: title, child: Text(title)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedTitle = value),
              ),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              TextFormField(
                controller: _preferredNameController,
                decoration: const InputDecoration(labelText: "Preferred Name"),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(labelText: "Mobile"),
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              TextFormField(
                controller: _postCodeController,
                decoration: const InputDecoration(labelText: "Postcode"),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: "City"),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: "State"),
                value: _selectedState,
                items: states
                    .map((state) =>
                        DropdownMenuItem(value: state, child: Text(state)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedState = value),
              ),
              DropdownButtonFormField(
                decoration:
                    const InputDecoration(labelText: "First Time Buyer"),
                value: _selectedFirstTimeBuyer,
                items: firstTimeBuyerOptions.map((option) {
                  return DropdownMenuItem(
                      value: option['display'],
                      child: Text(option['display']!));
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedFirstTimeBuyer = value),
              ),
              TextFormField(
                controller: _paymentDateController,
                decoration: const InputDecoration(labelText: "Payment Date"),
                readOnly: true,
                onTap: _pickPaymentDate,
              ),
              TextFormField(
                controller: _agencyCompanyController,
                decoration: const InputDecoration(labelText: "Agency Company"),
              ),
              TextFormField(
                controller: _agentNameController,
                decoration: const InputDecoration(labelText: "Agent Name"),
              ),
              TextFormField(
                controller: _agentPhoneController,
                decoration: const InputDecoration(labelText: "Agent Telephone"),
              ),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(labelText: "Remarks"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _updateDraft, child: const Text("Update Draft")),
            ],
          ),
        ),
      ),
    );
  }
}
