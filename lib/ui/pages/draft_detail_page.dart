import 'package:flutter/material.dart';
import 'package:flutter_application/api_service.dart';
import 'package:flutter_application/ui/pages/draft_edit_page.dart';

class DraftDetailPage extends StatefulWidget {
  final String draftGuid;

  const DraftDetailPage({super.key, required this.draftGuid});

  @override
  DraftDetailPageState createState() => DraftDetailPageState();
}

class DraftDetailPageState extends State<DraftDetailPage> {
  Future<Map<String, dynamic>>? draftFuture;
  Map<String, dynamic>? draftData;

  @override
  void initState() {
    super.initState();
    loadDraftDetails();
  }

  Future<void> loadDraftDetails() async {
    draftFuture = ApiService.getDraftDetails(widget.draftGuid);
    draftData = await draftFuture;
    if (draftData != null && draftData!['draft'] != null) {
      setState(() {
        draftData = draftData!['draft'];
      });
    }
  }

  Future<void> confirmDeleteDraft() async {
    bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Deletion"),
              content: const Text("Are you sure you want to delete this draft?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmDelete) {
      final response = await ApiService.deleteDraft(widget.draftGuid);
      if (response['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Draft deleted successfully")),
        );
        Navigator.of(context).pop(); // Go back after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Delete failed: ${response['message']}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        loadDraftDetails(); // 🔥 Reload details when going back
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Draft Details")),
        body: FutureBuilder<Map<String, dynamic>>(
          future: draftFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!['draft'] == null) {
              return const Center(child: Text("No draft found."));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Side - Client Details
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("Client Details"),
                          _buildDetail("Title", draftData!["Title"]),
                          _buildDetail("Full Name", draftData!["FullName"]),
                          _buildDetail("Preferred Name", draftData!["PreferredName"]),
                          _buildDetail("Identity Type", draftData!["IdentityType"]),
                          _buildDetail("Identity Number", draftData!["IdentityNumber"]),
                          _buildDetail("Email", draftData!["Email"]),
                          _buildDetail("Mobile", draftData!["Mobile"]),
                          _buildDetail("Address", draftData!["Address"]),
                          _buildDetail("Postcode", draftData!["PostCode"]),
                          _buildDetail("City", draftData!["City"]),
                          _buildDetail("State", draftData!["State"]),
                          _buildDetail("First-Time Buyer", draftData!["FirstTime"]),
                        ],
                      ),
                    ),

                    const SizedBox(width: 30), // Add spacing between columns

                    // Right Side - Agent Details, Additional Info, and Buttons
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🟢 Buttons moved to the top-right corner
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the right
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DraftEditPage(draftData: draftData!),
                                    ),
                                  );

                                  if (result == true) {
                                    loadDraftDetails(); // Refresh when coming back
                                  }
                                },
                                child: const Text("Edit"),
                              ),
                              const SizedBox(width: 10), // Spacing between buttons
                              ElevatedButton(
                                onPressed: confirmDeleteDraft,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20), // Add space below buttons

                          _buildSectionTitle("Agent Details"),
                          _buildDetail("Agency Company", draftData!["AgencyCmp"]),
                          _buildDetail("Agent Name", draftData!["AgentName"]),
                          _buildDetail("Agent Phone", draftData!["AgentPhone"]),

                          const SizedBox(height: 20),

                          _buildSectionTitle("Additional Information"),
                          _buildDetail("Payment Date", draftData!["PaymentDate"]),
                          _buildDetail("Created Time", draftData!["CreatedTime"]),
                          _buildDetail("Remarks", draftData!["Remarks"]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );

          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _buildDetail(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
           Text(value != null ? "$value" : "N/A"),
        ],
      ),
    );
  }
}
