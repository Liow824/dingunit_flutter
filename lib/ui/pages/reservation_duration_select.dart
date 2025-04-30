import 'package:flutter/material.dart';

class RetryDurationDialog extends StatefulWidget {
  const RetryDurationDialog({super.key});

  @override
  RetryDurationDialogState createState() => RetryDurationDialogState();
}

class RetryDurationDialogState extends State<RetryDurationDialog> {
  double selectedMinutes = 60; // Default to 1 hour

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Retry Duration",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "${selectedMinutes.round()} minutes",
              style: const TextStyle(fontSize: 16),
            ),
            Slider(
              value: selectedMinutes,
              min: 1,
              max: 180,
              divisions: 179,
              label: "${selectedMinutes.round()} min",
              onChanged: (value) {
                setState(() {
                  selectedMinutes = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context, selectedMinutes.round()),
                  child: const Text("Confirm"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
