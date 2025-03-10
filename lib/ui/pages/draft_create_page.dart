import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application/api_service.dart';
import 'package:flutter_application/nav/session_manager.dart';


class DraftCreatePage extends StatefulWidget {
  const DraftCreatePage({super.key});

  @override
  State<DraftCreatePage> createState() => _DraftCreatePageState();
}

class _DraftCreatePageState extends State<DraftCreatePage> {
  // A global key for the Form widget
  final _formKey = GlobalKey<FormState>();

  // Dropdown data
  final List<String> identityTypes = [
    'MyKad (NRIC)',
    'Passport',
    'Military / Police',
    'Company / Registration Number',
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
  final List<String> firstTimeBuyerOptions = [
    'Yes',
    'No',
  ];

  // Selected values (start them as null so they're unselected)
  String? _selectedIdentity;
  String? _selectedTitle;
  String? _selectedState;
  String? _selectedFirstTimeBuyer;

  // For Payment Date, we store a DateTime. We'll let the user pick via a date picker.
  DateTime? _selectedPaymentDate;
  final _paymentDateController = TextEditingController();

  // Controllers for text fields
  final _identityNumberController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _preferredNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _postCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _agencyCompanyController = TextEditingController();
  final _agentNameController = TextEditingController();
  final _agentPhoneController = TextEditingController();
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    // Always dispose controllers when the widget is removed from the widget tree
    _paymentDateController.dispose();
    _identityNumberController.dispose();
    _fullNameController.dispose();
    _preferredNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _postCodeController.dispose();
    _cityController.dispose();
    _agencyCompanyController.dispose();
    _agentNameController.dispose();
    _agentPhoneController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _pickPaymentDate() async {
    // Show a date picker to the user
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
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

  void _submitDraft() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ✅ Prepare the draft data
    final Map<String, dynamic> draftData = {
      'AuthorGuid': SessionManager.currentUserGuid,  // ✅ Required author GUID
      'IdentityType': _selectedIdentity ?? '',
      'IdentityNumber': _identityNumberController.text,
      'Title': _selectedTitle ?? '',
      'FullName': _fullNameController.text,
      'PreferredName': _preferredNameController.text,
      'Email': _emailController.text,
      'Mobile': _mobileController.text,
      'Address': _addressController.text,
      'Postcode': int.tryParse(_postCodeController.text) ?? 0,
      'City': _cityController.text,
      'State': _selectedState ?? '',
      'FirstTime': _selectedFirstTimeBuyer == 'Yes' ? 'Y' : 'N',  // ✅ Convert 'Yes' → 'Y', 'No' → 'N'
      'PaymentDate': _selectedPaymentDate != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedPaymentDate!)  // ✅ Format as `DATETIME`
          : '',
      'AgencyCmp': _agencyCompanyController.text,
      'AgentName': _agentNameController.text,
      'AgentPhone': _agentPhoneController.text,
      'Remarks': _remarksController.text,
    };

    try {
      final response = await ApiService.createDraft(draftData);

      if (response['status_code'] == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Draft submitted successfully!')),
        );
        Navigator.pop(context, true); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed: ${response['message']}')),
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
      appBar: AppBar(
        title: const Text('Create Draft'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // Everything that needs validation must be inside this Form
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- Identity Type (Dropdown) --
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Identity Type *',
                  border: OutlineInputBorder(),
                ),
                value: _selectedIdentity, // starts null => user must select
                hint: const Text('Select Identity Type'),
                items: identityTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedIdentity = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an identity type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Identity Number (Text Field) --
              TextFormField(
                controller: _identityNumberController,
                decoration: const InputDecoration(
                  labelText: 'Identity Number *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Identity Number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Title (Dropdown) --
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                ),
                value: _selectedTitle, // starts null => user must select
                hint: const Text('Select Title'),
                items: titles.map((title) {
                  return DropdownMenuItem(value: title, child: Text(title));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTitle = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Full Name (Text Field) --
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Preferred Name (Text Field) --
              TextFormField(
                key: const Key('preferredName'),
                controller: _preferredNameController,
                decoration: const InputDecoration(
                  labelText: 'Preferred Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // Debug print to check if the validator is triggered
                  if (value == null || value.isEmpty) {
                    return 'Preferred Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Email (Text Field) --
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Mobile (Text Field) --
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number* (+60)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mobile Number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Address (Text Field) --
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Postcode (Text Field) --
              TextFormField(
                controller: _postCodeController,
                decoration: const InputDecoration(
                  labelText: 'Postcode *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Postcode is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- City (Text Field) --
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'City is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- State (Dropdown) --
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'State *',
                  border: OutlineInputBorder(),
                ),
                value: _selectedState,
                hint: const Text('Select State'),
                items: states.map((st) {
                  return DropdownMenuItem(value: st, child: Text(st));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedState = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a state';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- First Time Buyer? (Dropdown) --
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'First Time Buyer?*',
                  border: OutlineInputBorder(),
                ),
                value: _selectedFirstTimeBuyer,
                hint: const Text('Select Yes or No'),
                items: firstTimeBuyerOptions.map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFirstTimeBuyer = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select Yes or No';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Payment Date (DD/MM/YYYY) --
              TextFormField(
                controller: _paymentDateController,
                decoration: const InputDecoration(
                  labelText: 'Payment Date (DD/MM/YYYY)*',
                  border: OutlineInputBorder(),
                ),
                // We'll let the user pick from a date picker
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _pickPaymentDate();
                },
                readOnly: true, // user must tap to pick
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Payment Date is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Agency Company (Text Field) --
              TextFormField(
                controller: _agencyCompanyController,
                decoration: const InputDecoration(
                  labelText: 'Agency Company is required',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Agency Company is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Agent Name (Text Field) --
              TextFormField(
                controller: _agentNameController,
                decoration: const InputDecoration(
                  labelText: 'Agent Name is required',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Agent Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Agent Telephone (Text Field) --
              TextFormField(
                controller: _agentPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Agent Telephone* (+60)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Agent Telephone is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Remarks (Text Field) --
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks is required',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Remarks is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // -- Submit Button --
              ElevatedButton(
                onPressed: _submitDraft,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
