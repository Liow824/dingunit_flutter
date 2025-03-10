import 'package:flutter/material.dart';
import 'package:flutter_application/api_service.dart';
import 'package:flutter_application/nav/session_manager.dart';
import 'package:intl/intl.dart';

class ReservationSelectDialog extends StatefulWidget {
  const ReservationSelectDialog({super.key});

  @override
  ReservationSelectDialogState createState() => ReservationSelectDialogState();
}

class ReservationSelectDialogState extends State<ReservationSelectDialog> {
  List<dynamic> draftList = [];
  bool isLoading = true;
  String? selectedDraftGuid;
  String? authorGuid;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadDrafts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadDrafts() async {
    await SessionManager.loadSession();
    authorGuid = SessionManager.currentUserGuid;

    if (authorGuid != null) {
      fetchDrafts();
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No user session found.")),
      );
    }
  }

  Future<void> fetchDrafts() async {
    if (authorGuid == null) return;
    final response = await ApiService.getDraftList(authorGuid!);

    if (response['status']) {
      setState(() {
        draftList = List<Map<String, dynamic>>.from(response['drafts'] ?? []);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 500, // Reduce dialog width
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Light gray background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select a Draft",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Draft List with Scrolling
            SizedBox(
              height: 400, 
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : draftList.isEmpty
                      ? const Center(
                          child: Text(
                            "No drafts available",
                            style: TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        )
                      : Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: draftList.length,
                            itemBuilder: (context, index) {
                              return _buildDraftItem(draftList[index]);
                            },
                          ),
                        ),
            ),

            const SizedBox(height: 15),

            // Dialog Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: selectedDraftGuid != null
                    ? () async {
                        final selectedDraft = draftList.firstWhere((draft) => draft['GUID'] == selectedDraftGuid);

                        String email = "jianhao.wee@gmail.com";
                        String password =  "Qwert12345";
                        final response = await ApiService.runAutoReserve(email,password);

                        if (response['status']) {
                          print("✅ Login Successful: ${response['message']}");
                          print("🌍 Page Title: ${response['page_title']}");

                          Navigator.pop(context, selectedDraft);
                        } 
                      }
                      : null, // Disable button if no draft is selected
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedDraftGuid != null ? Colors.blue : Colors.grey,
                  ),
                  child: const Text("Start"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftItem(Map<String, dynamic> draft) {
    String draftGuid = draft['GUID'];
    bool isSelected = draftGuid == selectedDraftGuid;

    String createdDate = "N/A";
    if (draft['CreatedTime'] != null) {
      DateTime parsedDate = DateTime.parse(draft['CreatedTime']);
      createdDate = DateFormat('dd/MM/yy HH:mm:ss').format(parsedDate);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDraftGuid = draftGuid; 
        });
      },
      child: Container(
        width: 420, // Increase width of draft container
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: isSelected ? 3 : 1.5, 
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              draft["FullName"] ?? "Unknown",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text("Last modified time: $createdDate"),
            Text("Email: ${draft["Email"] ?? 'No Email'}"),
          ],
        ),
      ),
    );
  }
}
