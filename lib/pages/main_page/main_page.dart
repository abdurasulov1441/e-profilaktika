import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:profilaktika/app/router.dart';
import 'package:profilaktika/app/theme.dart';
import 'package:profilaktika/common/helpers/request_helper.dart';
import 'package:profilaktika/common/style/app_style.dart';
import 'package:profilaktika/common/utils/constants.dart';
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

  void _showEditDialog(Map<String, dynamic> lecture) {
    String lecturer = lecture['lecturer'] ?? '';
    int number = lecture['number'] ?? 0;
    String topic = lecture['topic'] ?? '';
    String text = lecture['text'] ?? '';
    String date = lecture['date'] ?? '';

    TextEditingController lecturerController =
        TextEditingController(text: lecturer);
    TextEditingController numberController =
        TextEditingController(text: number.toString());
    TextEditingController topicController = TextEditingController(text: topic);
    TextEditingController textController = TextEditingController(text: text);
    TextEditingController dateController = TextEditingController(text: date);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ma'ruzani tahrirlash"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: lecturerController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: "Ma'ruzachi"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: numberController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: "Raqami"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: topicController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: "Mavzu"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: "Matn"),
                maxLines: 10,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: "Sana (YYYY-MM-DD)"),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Bekor qilish"),
          ),
          ElevatedButton(
            onPressed: () {
              requestHelper.putWithAuth(
                '/api/v1/lectures/${lecture['id'].toString()}',
                {
                  "lecturer": lecturerController.text,
                  "number": int.tryParse(numberController.text) ?? 0,
                  "topic": topicController.text,
                  "text": textController.text,
                  "date": dateController.text,
                },
              ).then((response) {
                if (response != null && response['id'] != null) {
                  setState(() {});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Ma'ruza muvaffaqiyatli tahrirlandi!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Xato: Javob noto‘g‘ri formatda keldi")),
                  );
                }
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Xatolik yuz berdi: $error")),
                );
              });
            },
            child: Text("Saqlash"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("O'chirishni tasdiqlash"),
        content: Text("Ushbu ma'ruzani o'chirishni istaysizmi?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Bekor qilish"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              requestHelper
                  .deleteWithAuth('/api/v1/lectures/$id')
                  .then((value) {
                setState(() {});
                Navigator.pop(context);
              });
            },
            child: Text("O'chirish"),
          ),
        ],
      ),
    );
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
            Text(structure?.toUpperCase() ?? ''),
            Spacer(),
            Text('Salom, $user $lastname'),
            SizedBox(
              width: 10,
            ),
            // CircleAvatar(
            //   radius: 20,
            //   backgroundColor: Colors.grey.shade200,
            //   child: ClipOval(
            //     child: Image.network(
            //       '${Constants.imageUrl}${cache.getString('photo')}',
            //       fit: BoxFit.cover,
            //       width: 40,
            //       height: 40,
            //     ),
            //   ),
            // ),
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
          SizedBox(width: 10),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await router.push(Routes.themeAddPage);
                      if (result == 'added') {
                        setState(() {
                          getLectures();
                        });
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      width: 155,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          Text('Mavzu qo‘shish', style: AppStyle.fontStyle),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (entry.value.isNotEmpty)
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
                              "",
                              style: AppStyle.fontStyle.copyWith(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            )
                          else
                            Row(
                              children: [
                                Wrap(
                                  spacing: 20,
                                  runSpacing: 20,
                                  children: entry.value.map((lecture) {
                                    return GestureDetector(
                                      onTap: () {
                                        router.push(
                                          Routes.quizPage,
                                          extra: lecture['id'],
                                        );
                                      },
                                      child: Container(
                                        width: 320,
                                        height: 100,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 6,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  lecture['number'].toString(),
                                                  style: AppStyle.fontStyle
                                                      .copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    lecture['topic'],
                                                    style: AppStyle.fontStyle
                                                        .copyWith(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    lecture['lecturer'],
                                                    style: AppStyle.fontStyle
                                                        .copyWith(
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  lecture['date']
                                                      .substring(0, 10),
                                                  style: AppStyle.fontStyle
                                                      .copyWith(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: SvgPicture.asset(
                                                          'assets/icons/edit.svg'),
                                                      onPressed: () =>
                                                          _showEditDialog(
                                                              lecture),
                                                    ),
                                                    IconButton(
                                                      icon: SvgPicture.asset(
                                                          'assets/icons/delete.svg'),
                                                      onPressed: () =>
                                                          _showDeleteConfirmationDialog(
                                                              lecture['id']
                                                                  .toString()),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
