import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:profilaktika/app/router.dart';
import 'package:profilaktika/common/helpers/request_helper.dart';

class QuizPage extends StatefulWidget {
  final lectureId;

  const QuizPage({super.key, required this.lectureId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<List<Map<String, dynamic>>> _questionsFuture;
  List<Map<String, dynamic>> _questions = [];

  @override
  void initState() {
    super.initState();
    _questionsFuture = fetchQuestionsByLectureId(widget.lectureId);
  }

  Future<List<Map<String, dynamic>>> fetchQuestionsByLectureId(
      int lectureId) async {
    final response = await requestHelper.getWithAuth('/api/v1/questions/');
    final List<dynamic> data = response['data'];

    final filteredQuestions = data
        .where((question) => question['lecture_id'] == lectureId)
        .map((question) => question as Map<String, dynamic>)
        .toList();

    setState(() {
      _questions = filteredQuestions;
    });

    return filteredQuestions;
  }

  Future<void> deleteQuestion(int questionId) async {
    await requestHelper.deleteWithAuth('/api/v1/questions/$questionId');
    setState(() {
      _questions.removeWhere((question) => question['id'] == questionId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Savol muvaffaqiyatli o‘chirildi'),
      ),
    );
  }

  Future<void> updateQuestion(
      BuildContext context, Map<String, dynamic> question) async {
    final TextEditingController questionTextController =
        TextEditingController(text: question['question_text']);
    final TextEditingController descriptionController =
        TextEditingController(text: question['description']);
    final List<TextEditingController> answerControllers =
        (question['answers'] as List<dynamic>)
            .map((answer) => TextEditingController(text: answer['text']))
            .toList();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Savolni yangilash'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: questionTextController,
                  decoration: const InputDecoration(labelText: 'Savol matni'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Savol izohi'),
                ),
                const SizedBox(height: 8),
                ...answerControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  return TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: index == 0
                          ? 'To‘g‘ri javob'
                          : 'Noto‘g‘ri javob ${index}',
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Bekor qilish'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedQuestion = {
                  "lecture_id": question['lecture_id'],
                  "question_text": questionTextController.text,
                  "description": descriptionController.text,
                  "answers": answerControllers
                      .asMap()
                      .entries
                      .map((entry) => {
                            "id": question['answers'][entry.key]['id'],
                            "text": entry.value.text,
                            "is_correct":
                                entry.key == 0, // Первый ответ правильный
                          })
                      .toList(),
                };

                final response = await requestHelper.putWithAuth(
                  '/api/v1/questions/${question['id']}',
                  updatedQuestion,
                );

                setState(() {
                  final index =
                      _questions.indexWhere((q) => q['id'] == question['id']);
                  if (index != -1) {
                    _questions[index] =
                        response['question']; // Обновляем локальный список
                  }
                });

                Navigator.pop(context); // Закрываем диалог
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Savol muvaffaqiyatli yangilandi')),
                );
              },
              child: const Text('Yangilash'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Savollar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await context.push<String>(Routes.quizAddPage,
                  extra: widget.lectureId);

              if (result == 'added') {
                setState(() {
                  _questionsFuture =
                      fetchQuestionsByLectureId(widget.lectureId);
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Xatolik yuz berdi: ${snapshot.error}'),
            );
          }

          if (_questions.isEmpty) {
            return const Center(
                child: Text('Bu mavzu uchun savollar mavjud emas.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              final question = _questions[index];
              final answers = question['answers'] as List<dynamic>;

              return Card(
                margin: const EdgeInsets.only(
                    bottom: 16.0, left: 308.0, right: 308.0),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Savol: ${question['question_text']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Javoblar:',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Izoh: ${question['description']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      ...answers.map((answer) {
                        final isCorrect = answer['is_correct'] as bool;
                        return Row(
                          children: [
                            Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                answer['text'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      isCorrect ? Colors.green : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            onPressed: () async {
                              await deleteQuestion(question['id']);
                            },
                            child: const Text('O‘chirish'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            onPressed: () => updateQuestion(context, question),
                            child: const Text('Tahrirlash'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
