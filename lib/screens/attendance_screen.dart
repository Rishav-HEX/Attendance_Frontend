import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState
    extends State<AttendanceScreen> {
  DateTime selectedDate =
    DateTime.now();
  final api = ApiService();

  List attendance = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadAttendance();
  }
  Future<void> pickDate() async {

  final picked =
      await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2024),
    lastDate: DateTime(2035),
  );

  if (picked == null) return;

  selectedDate = picked;

  await loadAttendance();
}

  Future<void> loadAttendance() async {

  loading = true;

  setState(() {});

  final dateString =
      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

  final data =
      await api.getAttendanceByDate(
    dateString,
  );

  setState(() {

    attendance = data;

    loading = false;
  });
}

@override
Widget build(BuildContext context) {

  return Scaffold(

    appBar: AppBar(
      title: const Text(
        "Attendance History",
      ),
    ),

    body: Column(

      children: [

        Container(

          padding:
              const EdgeInsets.all(12),

          child: Row(

            children: [

              Expanded(

                child: Text(

                  "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",

                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              ElevatedButton.icon(

                onPressed: pickDate,

                icon: const Icon(
                  Icons.calendar_month,
                ),

                label: const Text(
                  "Select Date",
                ),
              ),
            ],
          ),
        ),

        Expanded(

          child: loading

              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : attendance.isEmpty

                  ? const Center(
                      child: Text(
                        "No Attendance Found",
                      ),
                    )

                  : ListView.builder(

                      itemCount:
                          attendance.length,

                      itemBuilder:
                          (context, index) {

                        final record =
                            attendance[index];

                        return Card(

                          margin:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          child: ListTile(

                            leading:
                                const CircleAvatar(
                              child: Icon(
                                Icons.check,
                              ),
                            ),

                            title: Text(
                              record["name"]
                                  .toString(),
                            ),

                            subtitle: Text(
                              "Roll: ${record["roll_no"]}",
                            ),

                            trailing: Column(

                              mainAxisAlignment:
                                  MainAxisAlignment.center,

                              children: [

                                Text(
                                  record["time"]
                                      .toString(),
                                ),

                                const SizedBox(
                                  height: 4,
                                ),

                                const Text(
                                  "Present",
                                  style: TextStyle(
                                    color:
                                        Colors.green,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    ),
  );
}
}