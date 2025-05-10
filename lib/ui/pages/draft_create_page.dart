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
  final _formKey = GlobalKey<FormState>();

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
    'Kedah',
    'Kelantan',
    'Wilayah Persekutuan Kuala Lumpur',
    'Wilayah Persekutuan Labuan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Pulau Pinang',
    'Perak',
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
  final List<String> countryCode = [
    'Algeria (213)',
    'American Samoa (1684)',
    'Andorra (376)',
    'Angola (244)',
    'Anguilla (1264)',
    'Antarctica/Norfolk Island (672)',
    'Antigua And Barbuda (1268)',
    'Argentina (54)',
    'Armenia (355)',
    'Aruba (297)',
    'Australia/Cocos/Christmas Islands (61)',
    'Austria (43)',
    'Azerbaijan (994)',
    'Bahrain (973)',
    'Bangladesh (880)',
    'Barbados (1246)',
    'Belarus (375)',
    'Belgium (32)',
    'Belize (501)',
    'Benin (229)',
    'Bermuda (1441)',
    'Bhutan (975)',
    'Bolivia (591)',
    'Bosnia And Herzegowina (387)',
    'Botswana (267)',
    'Brazil (55)',
    'Brunei Darussalam (673)',
    'Bulgaria (359)',
    'Burkina Faso (226)',
    'Burundi (257)',
    'Cambodia (855)',
    'Cameroon (237)',
    'Cayman Islands (1345)',
    'Central African Republic (236)',
    'Chad (235)',
    'Chile (56)',
    'China (86)',
    'Colombia (57)',
    'Comoros (269)',
    'Congo, Democratic Republic Of (243)',
    'Congo, Peoples Republic Of (242)',
    'Cook Islands (682)',
    'Costa Rica (506)',
    'Cote DIvoire (225)',
    'Croatia (385)',
    'Cuba (53)',
    'Cyprus (357)',
    'Czech Republic (420)',
    'Denmark (45)',
    'Djibouti (253)',
    'Dominica (1767)',
    'Dominican Republic (1809)',
    'East Timor/Timor-Leste (670)',
    'Ecuador (593)',
    'Egypt (20)',
    'El Salvador (503)',
    'Equatorial Guinea (240)',
    'Estonia (372)',
    'Ethiopia (251)',
    'Falkland Islands (Malvinas) (500)',
    'Faroe Islands (298)',
    'Fiji (679)',
    'Finland (358)',
    'France (33)',
    'French Guiana (594)',
    'French Polynesia (689)',
    'Gabon (241)',
    'Gambia (220)',
    'Georgia (995)',
    'Germany (49)',
    'Ghana (233)',
    'Gibraltar (350)',
    'Greece (30)',
    'Greenland (299)',
    'Grenada (1473)',
    'Guadeloupe/Saint Barthelemy (590)',
    'Guam (1671)',
    'Guatemala (502)',
    'Guinea (224)',
    'Guinea-Bissau (245)',
    'Guyana (592)',
    'Haiti (509)',
    'Honduras (504)',
    'Hong Kong (852)',
    'Hungary (36)',
    'Iceland (354)',
    'India (91)',
    'Indonesia (62)',
    'Iran (98)',
    'Iraq (964)',
    'Ireland (353)',
    'Israel (972)',
    'Italy (39)',
    'Jamaica (1876)',
    'Japan (81)',
    'Jordan (962)',
    'Kenya (254)',
    'Kiribati (686)',
    'Korea, North (850)',
    'South Korea (82)',
    'Kuwait (965)',
    'Kyrgyzstan (996)',
    'Laos (856)',
    'Latvia (371)',
    'Lebanon (961)',
    'Lesotho (266)',
    'Liberia (231)',
    'Libyan Arab Jamahiriya (218)',
    'Liechtenstein (423)',
    'Lithuania (370)',
    'Luxembourg (352)',
    'Macao (853)',
    'Macedonia (389)',
    'Madagascar (261)',
    'Malawi (265)',
    'Malaysia (60)',
    'Maldives (960)',
    'Mali (223)',
    'Malta (356)',
    'Marshall Islands (692)',
    'Martinique (596)',
    'Mauritania (222)',
    'Mauritius (230)',
    'Mayotte Islands (262)',
    'Mexico (52)',
    'Micronesia (691)',
    'Moldova (373)',
    'Monaco (377)',
    'Mongolia (976)',
    'Montenegro (382)',
    'Montserrat (664)',
    'Morocco (212)',
    'Mozambique (258)',
    'Myanmar (95)',
    'Namibia (264)',
    'Nauru (674)',
    'Nepal (977)',
    'Netherlands (31)',
    'New Caledonia (687)',
    'New Zealand (64)',
    'Nicaragua (505)',
    'Niger (227)',
    'Nigeria (234)',
    'Niue (683)',
    'Norway (47)',
    'Oman (968)',
    'Pakistan (92)',
    'Palau (680)',
    'Panama (507)',
    'Papua New Guinea (675)',
    'Paraguay (595)',
    'Peru (51)',
    'Philippines (63)',
    'Poland (48)',
    'Portugal (351)',
    'Qatar (974)',
    'Romania (40)',
    'Russia/Kazakhstan (7)',
    'Rwanda (250)',
    'Saint Kitts And Nevis (1869)',
    'Saint Lucia (1758)',
    'Saint Martin (1599)',
    'Saint Vincent And The Grenadines (1784)',
    'Samoa (685)',
    'San Marino (378)',
    'Sao Tome And Principe (239)',
    'Saudi Arabia (966)',
    'Senegal (221)',
    'Serbia/Yugoslavia (381)',
    'Sierra Leone (232)',
    'Singapore (65)',
    'Slovakia (Slovak Republic) (421)',
    'Slovenia (386)',
    'Solomon Islands (677)',
    'Somalia (252)',
    'South Africa (27)',
    'Spain (34)',
    'Sri Lanka (94)',
    'St. Helena (290)',
    'St. Pierre And Miquelon (508)',
    'Sudan (249)',
    'Suriname (597)',
    'Swaziland (268)',
    'Sweden (46)',
    'Switzerland (41)',
    'Syrian Arab Republic (963)',
    'Taiwan (886)',
    'Tajikistan (992)',
    'Tanzania, United Republic Of (255)',
    'Thailand (66)',
    'Togo (228)',
    'Tonga (676)',
    'Trinidad And Tobago (1868)',
    'Tunisia (216)',
    'Turkey (90)',
    'Turkmenistan (993)',
    'Turks And Caicos Islands (1649)',
    'Tuvalu (688)',
    'Uganda (256)',
    'Ukraine (380)',
    'United Arab Emirates (971)',
    'United Kingdom (44)',
    'United States/Canada (1)',
    'Uruguay (598)',
    'Uzbekistan (998)',
    'Vanuatu (678)',
    'Venezuela (58)',
    'Vietnam (84)',
    'Virgin Islands (British) (1284)',
    'Virgin Islands (U.S) (1340)',
    'Wallis And Futuna Islands (681)',
    'Yemen (967)',
    'Zambia (260)',
    'Zimbabwe (263)',
    'Other'
  ];
  final List<String> country = [
    'Afghanistan',
    'Aland Islands',
    'Albania',
    'Algeria',
    'American Samoa',
    'Andorra',
    'Angola',
    'Anguilla',
    'Antigua',
    'Argentina',
    'Armenia',
    'Aruba',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bermuda',
    'Bhutan',
    'Bolivia',
    'Bosnia',
    'Botswana',
    'Bouvet Island',
    'Brazil',
    'British Virgin Islands',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burma',
    'Burundi',
    'Caicos Islands',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Cape Verde',
    'Cayman Islands',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Christmas Island',
    'Cocos Islands',
    'Colombia',
    'Comoros',
    'Congo',
    'Congo Brazzaville',
    'Cook Islands',
    'Costa Rica',
    'Cote Divoire',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czech Republic',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Ethiopia',
    'Europeanunion',
    'Falkland Islands',
    'Faroe Islands',
    'Fiji',
    'Finland',
    'France',
    'French Guiana',
    'French Polynesia',
    'French Territories',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Gibraltar',
    'Greece',
    'Greenland',
    'Grenada',
    'Guadeloupe',
    'Guam',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Heard Island',
    'Honduras',
    'Hong Kong',
    'Hungary',
    'Iceland',
    'India',
    'Indian Ocean Territory',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Jamaica',
    'Jan Mayen',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Macau',
    'Macedonia',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Martinique',
    'Mauritania',
    'Mauritius',
    'Mayotte',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Montserrat',
    'Morocco',
    'Mozambique',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'Netherlandsantilles',
    'New Caledonia',
    'New Guinea',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'Niue',
    'Norfolk Island',
    'North Korea',
    'Northern Mariana Islands',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Palestine',
    'Panama',
    'Paraguay',
    'Peru',
    'Philippines',
    'Pitcairn Islands',
    'Poland',
    'Portugal',
    'Puerto Rico',
    'Qatar',
    'Reunion',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Helena',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Pierre',
    'Saint Vincent',
    'Samoa',
    'San Marino',
    'Sandwich Islands',
    'Sao Tome',
    'Saudi Arabia',
    'Scotland',
    'Senegal',
    'Serbia',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Korea',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Swaziland',
    'Sweden',
    'Switzerland',
    'Syria',
    'Taiwan',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Timorleste',
    'Togo',
    'Tokelau',
    'Tonga',
    'Trinidad',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Tuvalu',
    'United Arab Emirates',
    'Uganda',
    'Ukraine',
    'United Kingdom',
    'United States',
    'Uruguay',
    'US Minor Islands',
    'US Virgin Islands',
    'Uzbekistan',
    'Vanuatu',
    'Vatican City',
    'Venezuela',
    'Vietnam',
    'Wales',
    'Wallis and Futuna',
    'Western Sahara',
    'Yemen',
    'Zambia',
    'Zimbabwe'
  ];

  String? _selectedIdentity;
  String? _selectedTitle;
  String? _selectedState;
  String? _selectedFirstTimeBuyer;
  String? _selectedCountryCode;
  String? _selectedCountry;
  DateTime? _selectedPaymentDate;

  final _paymentDateController = TextEditingController();
  final _identityNumberController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _preferredNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _postCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _agencyCompanyController = TextEditingController();
  final _agentNameController = TextEditingController();
  final _agentPhoneController = TextEditingController();
  final _remarksController = TextEditingController();

  final _mhubEmailController = TextEditingController();
  final _mhubPasswordController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _blockNameController = TextEditingController();
  final _unitNameController = TextEditingController();

  @override
  void dispose() {
    _paymentDateController.dispose();
    _identityNumberController.dispose();
    _fullNameController.dispose();
    _preferredNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _postCodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _agencyCompanyController.dispose();
    _agentNameController.dispose();
    _agentPhoneController.dispose();
    _remarksController.dispose();

    _mhubEmailController.dispose();
    _mhubPasswordController.dispose();
    _projectNameController.dispose();
    _blockNameController.dispose();
    _unitNameController.dispose();

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
    final Map<String, dynamic> draftData = {
      'MhubEmail': _mhubEmailController.text,
      'MhubPassword': _mhubPasswordController.text,
      'ProjectName': _projectNameController.text,
      'BlockName': _blockNameController.text,
      'UnitName': _unitNameController.text,
      'AuthorGuid': SessionManager.currentUserGuid,
      'IdentityType': _selectedIdentity ?? '',
      'IdentityNumber': _identityNumberController.text,
      'Title': _selectedTitle ?? '',
      'FullName': _fullNameController.text,
      'PreferredName': _preferredNameController.text,
      'Email': _emailController.text,
      'CountryCode': _selectedCountryCode ?? '',
      'Mobile': _mobileController.text,
      'Address': _addressController.text,
      'Postcode': int.tryParse(_postCodeController.text) ?? 0,
      'City': _cityController.text,
      'State': _selectedCountry == 'Malaysia'
          ? (_selectedState ?? '')
          : _stateController.text,
      'Country': _selectedCountry ?? '',
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
              // MHub Email (Text Field)
              TextFormField(
                controller: _mhubEmailController,
                decoration: const InputDecoration(
                  labelText: 'MHub Email',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your MHub email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'MHub Email is required';
                  }
                  // Optional: Add email format validation
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // MHub Password (Text Field)
              TextFormField(
                controller: _mhubPasswordController,
                decoration: const InputDecoration(
                  labelText: 'MHub Password',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your MHub password',
                ),
                obscureText: true, // Hide password input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'MHub Password is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Project Name (Text Field)
              TextFormField(
                controller: _projectNameController,
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the project name (or partial name)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Project Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Block Name (Text Field)
              TextFormField(
                controller: _blockNameController,
                decoration: const InputDecoration(
                  labelText: 'Block Name',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the block name (e.g., C1, A2, B3)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Block Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Unit Name (Text Field)
              TextFormField(
                controller: _unitNameController,
                decoration: const InputDecoration(
                  labelText: 'Unit Name',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the unit name (e.g., 12A-3A, 18-5)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unit Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Identity Type (Dropdown) --
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _selectedIdentity,
                hint: const Text('Identity Type'),
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
                  labelText: 'Identity Number',
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
                  border: OutlineInputBorder(),
                ),
                value: _selectedTitle, // starts null => user must select
                hint: const Text('Title'),
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
                  labelText: 'Full Name',
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
                  labelText: 'Preferred Name',
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
                  labelText: 'Email',
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

              // -- Country Code (Dropdown) --
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _selectedCountryCode, // starts null => user must select
                hint: const Text('Phone Country Code'),
                items: countryCode.map((title) {
                  return DropdownMenuItem(value: title, child: Text(title));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCountryCode = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a country code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Mobile (Text Field) --
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
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
                  labelText: 'Address',
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
                  labelText: 'Postcode',
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
                  labelText: 'City',
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
                  border: OutlineInputBorder(),
                ),
                value: _selectedState,
                hint: const Text('State'),
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

              // -- Country Name (Dropdown) --
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _selectedCountry,
                hint: const Text('Country'),
                items: country.map((title) {
                  return DropdownMenuItem(value: title, child: Text(title));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCountry = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- First Time Buyer? (Dropdown) --
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _selectedFirstTimeBuyer,
                hint: const Text('First Time Buyer?'),
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
                  labelText: 'Payment Date (DD/MM/YYYY)',
                  border: OutlineInputBorder(),
                ),
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
                  labelText: 'Agency Company name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Agency Company name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Agent Name (Text Field) --
              TextFormField(
                controller: _agentNameController,
                decoration: const InputDecoration(
                  labelText: 'Agent Name',
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
                  labelText: 'Agent Phone Number (+60)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Agent Phone Number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // -- Remarks (Text Field) --
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks',
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
