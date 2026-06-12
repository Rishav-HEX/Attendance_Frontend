import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class StudentProfileScreen extends StatefulWidget {

  const StudentProfileScreen({
    super.key,
  });

  @override
  State<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState
    extends State<StudentProfileScreen> {

      final api = ApiService();

    Map<String, dynamic>? student;

    bool loading = true;

  Future<void> loadProfile(
  String studentId,
)

async {

  try {

    final data =
        await api.getStudentProfile(
      studentId,
    );
print(
  "PROFILE DATA => $data",
);
    if (!mounted) return;

    setState(() {

      student = data;

      loading = false;
    });

  } catch (e) {

    print(
      "PROFILE ERROR => $e",
    );

    if (!mounted) return;

    setState(() {

      loading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {

    final studentId =
        ModalRoute.of(context)!
            .settings
            .arguments as String;

        if (loading &&
    student == null) {

  Future.microtask(() {

    loadProfile(
      studentId,
    );
  });
}

if (loading) {

  return const Scaffold(

    body: Center(

      child:
          CircularProgressIndicator(),
    ),
  );
}

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F7FB),

      appBar: AppBar(

        backgroundColor:
            const Color(0xFFF5F7FB),

        elevation: 0,

        title: const Text(
          "Student Profile",
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            Container(

              padding:
                  const EdgeInsets.all(
                20,
              ),

              decoration:
                  BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  24,
                ),

                boxShadow: [

                  BoxShadow(
                    color:
                        Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Column(

                children: [

                  CircleAvatar(
  radius: 55,

  backgroundImage: NetworkImage(
    "http://10.88.100.152:8000/students-images/$studentId.jpg",
  ),

  onBackgroundImageError: (_, __) {
    print("Photo Not Found");
  },
),

                  Text(
  student?["name"] ?? "Loading...",
  style: GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

                  const SizedBox(
                    height: 5,
                  ),

                 Text(
  "ID: ${student?["student_id"] ?? studentId}",
  style: GoogleFonts.poppins(),
),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            _infoCard(
              "Name",
              student?["name"]?.toString() ?? "N/A",
            ),

            _infoCard(
              "Roll Number",
              student?["roll_no"]?.toString() ?? "N/A",
            ),

            _infoCard(
              "Class",
              student?["class_name"]?.toString() ?? "N/A",
            ),

            _infoCard(
              "Section",
              student?["section"]?.toString() ?? "N/A",
            ),

            const SizedBox(
              height: 20,
            ),

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(
                20,
              ),

              decoration:
                  BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  24,
                ),

                boxShadow: [

                  BoxShadow(
                    color:
                        Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Column(

                children: [

                  Text(
                    "Attendance Statistics",
                    style:
                        GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Row(

                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceEvenly,

                    children: [

                      _statBox(
                        "Present",
                        student?["present_days"]?.toString() ?? "0",
                        Colors.green,
                      ),

                      _statBox(
                        "%",
                        student?["attendance_percentage"]?.toString() ?? "0",
                        Colors.blue,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Text(
                    "Last Attendance",
                    style:
                        GoogleFonts.poppins(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
  student?["last_attendance"] ??
      "N/A",

  style:
      GoogleFonts.poppins(),
),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    String title,
    String value,
  ) {

    return Container(

      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        boxShadow: [

          BoxShadow(
            color:
                Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),

      child: Row(

        children: [

          Text(
            "$title : ",
            style:
                GoogleFonts.poppins(
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          Expanded(
            child: Text(
              value,
              style:
                  GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(
    String title,
    String value,
    Color color,
  ) {

    return Container(

      width: 120,

      padding:
          const EdgeInsets.all(
        15,
      ),

      decoration:
          BoxDecoration(

        color:
            color.withValues(
          alpha: 0.1,
        ),

        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),

      child: Column(

        children: [

          Text(
            value,
            style:
                GoogleFonts.poppins(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
              color: color,
            ),
          ),

          Text(
            title,
            style:
                GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }
}