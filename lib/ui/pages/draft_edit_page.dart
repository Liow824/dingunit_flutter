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
  final List<Map<String, String>> firstTimeBuyerOptions = [
    {'display': 'Yes', 'value': 'Y'},
    {'display': 'No', 'value': 'N'},
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

  String? _selectedIdentityType;
  String? _selectedTitle;
  String? _selectedState;
  String? _selectedFirstTimeBuyer;
  String? _selectedCountryCode;
  String? _selectedCountry;
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
    _emailController.text = widget.draftData['ClientEmail'] ?? '';
    _selectedCountryCode = widget.draftData['CountryCode'] ?? '';
    _mobileController.text = widget.draftData['Mobile'] ?? '';
    _addressController.text = widget.draftData['Address'] ?? '';
    _postCodeController.text = widget.draftData['PostCode']?.toString() ?? '';
    _cityController.text = widget.draftData['City'] ?? '';
    _selectedState = widget.draftData['State'];
    _selectedCountry = widget.draftData['Country'];
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
      'ClientEmail': _emailController.text,
      'CountryCode': _selectedCountryCode ?? '',
      'Mobile': _mobileController.text,
      'Address': _addressController.text,
      'Postcode': _postCodeController.text,
      'City': _cityController.text,
      'State': _selectedState ?? '',
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
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: "Country Code"),
                value: _selectedCountryCode,
                items: countryCode
                    .map((title) =>
                        DropdownMenuItem(value: title, child: Text(title)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCountryCode = value),
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
                decoration: const InputDecoration(labelText: "Country"),
                value: _selectedCountry,
                items: country
                    .map((title) =>
                        DropdownMenuItem(value: title, child: Text(title)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCountry = value),
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
