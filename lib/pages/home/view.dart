import 'package:flutter/material.dart';

class TimetableScreen extends StatelessWidget {
  final Map<String, Map<String, List<String>>> timetableData;

  const TimetableScreen({Key? key, required this.timetableData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use your predefined TIME_SLOTS and DAYS order.
    final List<String> timeSlots = [
      "9:15-10:15",
      "10:15-11:15",
      "11:15-11:30 (Break)",
      "11:30-12:30",
      "12:30-1:30",
      "1:30-2:15 (Break)",
      "2:15-3:15",
      "3:15-4:15",
      "4:15-5:15"
    ];
    final List<String> daysOrder = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Generated Timetable"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: timetableData.entries.map((sectionEntry) {
          int numSlots = sectionEntry.value[daysOrder.first]?.length ?? timeSlots.length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${sectionEntry.key} Timetable",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text("Time Slot")),
                    ...daysOrder.map((day) => DataColumn(label: Text(day))).toList(),
                  ],
                  rows: List<DataRow>.generate(numSlots, (slotIndex) {
                    return DataRow(
                      cells: [
                        DataCell(Text(timeSlots[slotIndex])),
                        ...daysOrder.map((day) {
                          String subject = sectionEntry.value[day]?[slotIndex] ?? "";
                          return DataCell(Text(subject));
                        }).toList(),
                      ],
                    );
                  }),
                ),
              ),
              const Divider(height: 32),
            ],
          );
        }).toList(),
      ),
    );
  }
}
