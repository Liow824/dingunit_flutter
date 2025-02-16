// import 'package:flutter/material.dart';
// import '../../data/dataset/client.dart';
// import '../../nav/routes.dart';

// class DraftManager extends StatelessWidget {
//   const DraftManager({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Draft Manager"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, AppRoutes.draftCreate);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueAccent,
//                 padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 "Add Draft",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.blueAccent, width: 2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.all(12.0),
//                 child: clientDataset.isEmpty
//                     ? const Center(
//                         child: Text(
//                           "No data available",
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.black54,
//                           ),
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: clientDataset.length,
//                         itemBuilder: (context, index) {
//                           final client = clientDataset[index];
//                           return Container(
//                             margin: const EdgeInsets.only(bottom: 12),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey, width: 1.5),
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: ListTile(
//                               title: Text(
//                                 client.fullName,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 client.email,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                               trailing: const Icon(
//                                 Icons.arrow_forward_ios,
//                                 size: 18,
//                                 color: Colors.blueAccent,
//                               ),
//                               onTap: () {
//                                 Navigator.pushNamed(
//                                   context,
//                                   AppRoutes.draftDetail,
//                                   arguments: client.id, // Pass client ID to detail page
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
