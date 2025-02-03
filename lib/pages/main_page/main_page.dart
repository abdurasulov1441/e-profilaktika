import 'package:flutter/material.dart';
import 'package:profilaktika/app/router.dart';
import 'package:profilaktika/common/helpers/request_helper.dart';
import 'package:profilaktika/common/style/app_style.dart';
import 'package:profilaktika/db/cache.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<Map<String, List<Map<String, dynamic>>>> getLectures() async {
    final response =
        await requestHelper.getWithAuth('/api/v1/lectures/', log: true);

    final List<dynamic> lectures = response['data'];

    return groupLecturesByMonth(lectures);
  }

  Map<String, List<Map<String, dynamic>>> groupLecturesByMonth(
      List<dynamic> lectures) {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (int i = 1; i <= 12; i++) {
      grouped[_getMonthName(i)] = [];
    }

    for (var lecture in lectures) {
      DateTime date = DateTime.parse(lecture['date']);
      String month = _getMonthName(date.month);

      grouped[month]?.add(lecture);
    }
    return grouped;
  }

  String _getMonthName(int month) {
    List<String> months = [
      "Yanvar",
      "Fevral",
      "Mart",
      "Aprel",
      "May",
      "Iyun",
      "Iyul",
      "Avgust",
      "Sentabr",
      "Oktabr",
      "Noyabr",
      "Dekabr"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final user = cache.getString('first_name');
    final lastname = cache.getString('last_name');
    final structure = cache.getString('structure_uz');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', width: 30, height: 30),
            SizedBox(width: 20),
            Text('E-Profilaktika'),
            Spacer(),
            Text(structure!),
            Spacer(),
            Text('Salom, $user $lastname'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              cache.clear();
              router.go(Routes.loginPage);
            },
          ),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              router.push(Routes.themeAddPage);
            },
            child: Text('Yaratish'),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: getLectures(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Xatolik: ${snapshot.error}'));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: AppStyle.fontStyle.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (entry.value.isEmpty)
                        Text(
                          "Ma'lumot yo'q",
                          style: AppStyle.fontStyle.copyWith(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        )
                      else
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: entry.value.map((lecture) {
                            return GestureDetector(
                              onTap: () {
                                // Navigate to QuizPage and pass the lecture ID
                                router.push(
                                  Routes.quizPage,
                                  extra: lecture['id'], // Pass the lecture ID
                                );
                              },
                              child: Container(
                                width: 250,
                                height: 150,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue.shade100,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lecture['lecturer'],
                                      style: AppStyle.fontStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "raqami: ${lecture['number']}",
                                      style: AppStyle.fontStyle.copyWith(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "topic: ${lecture['topic']}",
                                      style: AppStyle.fontStyle.copyWith(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "Text: ${lecture['text']}",
                                      style: AppStyle.fontStyle.copyWith(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        "📅 ${lecture['date'].substring(0, 10)}",
                                        style: AppStyle.fontStyle.copyWith(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
