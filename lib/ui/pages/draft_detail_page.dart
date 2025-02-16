// import 'package:flutter/material.dart';
// import '../../class/draft.dart';
// import '../../data/dataset/client.dart';
// import '../../data/dataset/user.dart';
// import '../../nav/session_manager.dart';

// class DraftDetailPage extends StatefulWidget {
//   final int draftId; // The ID of the draft to display

//   const DraftDetailPage({super.key, required this.draftId});

//   @override
//   State<DraftDetailPage> createState() => _DraftDetailPageState();
// }

// class _DraftDetailPageState extends State<DraftDetailPage> {
//   bool isEditing = false; // Tracks whether the form is in edit mode
//   late ClientData draft;

//   // Controllers for the editable fields
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _postCodeController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _agencyCompanyController = TextEditingController();
//   final TextEditingController _agentNameController = TextEditingController();
//   final TextEditingController _agentPhoneController = TextEditingController();
//   final TextEditingController _remarksController = TextEditingController();

//   DateTime? _selectedPaymentDate;
//   bool _isFirstTimeBuyer = false;
//   List<String> _selectedTitles = [];

//   @override
//   void initState() {
//     super.initState();

//     // Find the draft data by ID
//     draft = clientDataset.firstWhere((client) => client.id == widget.draftId);

//     // Initialize controllers with draft data
//     _fullNameController.text = draft.fullName;
//     _emailController.text = draft.email;
//     _mobileController.text = draft.mobile;
//     _addressController.text = draft.address;
//     _postCodeController.text = draft.postCode.toString();
//     _cityController.text = draft.city;
//     _stateController.text = draft.state;
//     _agencyCompanyController.text = draft.agencyCompany;
//     _agentNameController.text = draft.agentName;
//     _agentPhoneController.text = draft.agentPhone;
//     _remarksController.text = draft.remarks;
//     _selectedPaymentDate = draft.paymentDate;
//     _isFirstTimeBuyer = draft.isFirstTimeBuyer;
//     _selectedTitles = draft.identity.split(',').map((e) => e.trim()).toList();
//   }

//   void saveChanges() {
//     setState(() {
//       draft.fullName = _fullNameController.text;
//       draft.email = _emailController.text;
//       draft.mobile = _mobileController.text;
//       draft.address = _addressController.text;
//       draft.postCode = int.tryParse(_postCodeController.text) ?? 0;
//       draft.city = _cityController.text;
//       draft.state = _stateController.text;
//       draft.agencyCompany = _agencyCompanyController.text;
//       draft.agentName = _agentNameController.text;
//       draft.agentPhone = _agentPhoneController.text;
//       draft.remarks = _remarksController.text;
//       draft.paymentDate = _selectedPaymentDate;
//       draft.isFirstTimeBuyer = _isFirstTimeBuyer;
//       draft.identity = _selectedTitles.join(', ');

//       isEditing = false; // Exit edit mode
//     });
//   }

//   void removeDraft() {
//     setState(() {
//       // Remove draft from local database
//       clientDataset.removeWhere((client) => client.id == draft.id);

//       // Remove draft ID from the current user's client IDs
//       int? currentUserId = SessionManager.currentUserId;
//       if (currentUserId != null) {
//         final currentUser = userDataset.firstWhere((user) => user.id == currentUserId);
//         currentUser.clientIds.remove(draft.id);
//       }
//     });

//     // Return to the previous page
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Draft: ${draft.fullName}')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title and Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       draft.fullName,
//                       style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             isEditing = !isEditing; // Toggle the edit mode
//                           });
//                         },
//                         child: Text(isEditing ? 'Cancel' : 'Edit'),
//                       ),
//                       const SizedBox(width: 10),
//                       ElevatedButton(
//                         onPressed: removeDraft,
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                         child: const Text('Remove'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Editable Fields
//               ...[
//                 // Multi-select Title
//                 isEditing
//                     ? MultiSelectChipField(
//                         title: "Select Titles",
//                         options: const [
//                           'Mr.',
//                           'Ms.',
//                           'Mrs.',
//                           'Dr.',
//                           'JP',
//                           'Pehin',
//                           'Datin',
//                           'Datuk',
//                           'Dato\'',
//                           'Dato',
//                           'Datuk Seri',
//                           'Datin Seri',
//                           'Dato\' Sri',
//                           'Tan Sri',
//                           'Puan Sri',
//                           'Tun',
//                           'Not Applicable',
//                         ],
//                         selectedOptions: _selectedTitles,
//                         onSelectionChanged: (List<String> selectedTitles) {
//                           setState(() {
//                             _selectedTitles = selectedTitles;
//                           });
//                         },
//                       )
//                     : _buildField('Title', draft.identity),

//                 _buildEditableField('Full Name', _fullNameController),
//                 _buildEditableField('Email', _emailController),
//                 _buildEditableField('Mobile', _mobileController),
//                 _buildEditableField('Address', _addressController),
//                 _buildEditableField('Postcode', _postCodeController),
//                 _buildEditableField('City', _cityController),
//                 _buildEditableField('State', _stateController),
//                 _buildEditableField('Agency Company', _agencyCompanyController),
//                 _buildEditableField('Agent Name', _agentNameController),
//                 _buildEditableField('Agent Phone', _agentPhoneController),
//                 _buildEditableField('Remarks', _remarksController),

//                 // First-Time Buyer Toggle
//                 isEditing
//                     ? DropdownButtonFormField<bool>(
//                         decoration: const InputDecoration(labelText: 'First-Time Buyer'),
//                         value: _isFirstTimeBuyer,
//                         items: const [
//                           DropdownMenuItem(
//                             value: true,
//                             child: Text('Yes'),
//                           ),
//                           DropdownMenuItem(
//                             value: false,
//                             child: Text('No'),
//                           ),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             _isFirstTimeBuyer = value ?? false;
//                           });
//                         },
//                       )
//                     : _buildField(
//                         'First-Time Buyer',
//                         draft.isFirstTimeBuyer ? 'Yes' : 'No',
//                       ),

//                 // Payment Date with Calendar Picker
//                 isEditing
//                     ? TextFormField(
//                         readOnly: true,
//                         decoration: const InputDecoration(labelText: 'Payment Date'),
//                         onTap: () async {
//                           DateTime? pickedDate = await showDatePicker(
//                             context: context,
//                             initialDate: _selectedPaymentDate ?? DateTime.now(),
//                             firstDate: DateTime(2000),
//                             lastDate: DateTime(2100),
//                           );
//                           if (pickedDate != null) {
//                             setState(() {
//                               _selectedPaymentDate = pickedDate;
//                             });
//                           }
//                         },
//                         controller: TextEditingController(
//                           text: _selectedPaymentDate != null
//                               ? "${_selectedPaymentDate!.day}/${_selectedPaymentDate!.month}/${_selectedPaymentDate!.year}"
//                               : '',
//                         ),
//                       )
//                     : _buildField(
//                         'Payment Date',
//                         draft.paymentDate != null
//                             ? "${draft.paymentDate!.day}/${draft.paymentDate!.month}/${draft.paymentDate!.year}"
//                             : 'N/A',
//                       ),
//               ].map((field) => Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: field,
//                   )),

//               const SizedBox(height: 20),

//               // Save Button
//               if (isEditing)
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: saveChanges,
//                     child: const Text('Save Changes'),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper to build editable fields
//   Widget _buildEditableField(String label, TextEditingController controller) {
//     return isEditing
//         ? TextFormField(
//             controller: controller,
//             decoration: InputDecoration(
//               labelText: label,
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//           )
//         : _buildField(label, controller.text);
//   }

//   // Helper to build non-editable fields
//   Widget _buildField(String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 1,
//           child: Text(
//             "$label:",
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         Expanded(
//           flex: 2,
//           child: Text(value),
//         ),
//       ],
//     );
//   }
// }

// // Multi-select chip field widget
// class MultiSelectChipField extends StatelessWidget {
//   final String title;
//   final List<String> options;
//   final List<String> selectedOptions;
//   final Function(List<String>) onSelectionChanged;

//   const MultiSelectChipField({
//     required this.title,
//     required this.options,
//     required this.selectedOptions,
//     required this.onSelectionChanged,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         Wrap(
//           spacing: 8.0,
//           children: options.map((option) {
//             final isSelected = selectedOptions.contains(option);
//             return ChoiceChip(
//               label: Text(option),
//               selected: isSelected,
//               onSelected: (selected) {
//                 final updatedSelection = [...selectedOptions];
//                 if (selected) {
//                   updatedSelection.add(option);
//                 } else {
//                   updatedSelection.remove(option);
//                 }
//                 onSelectionChanged(updatedSelection);
//               },
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
