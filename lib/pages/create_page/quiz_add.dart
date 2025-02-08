import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:profilaktika/app/theme.dart';
import 'package:profilaktika/common/helpers/request_helper.dart';
import 'package:profilaktika/common/style/app_style.dart';

class QuizzAddPage extends StatefulWidget {
  final lectureId;

  const QuizzAddPage({super.key, required this.lectureId});

  @override
  State<QuizzAddPage> createState() => _QuizzAddPageState();
}

class _QuizzAddPageState extends State<QuizzAddPage> {
  final List<Key> _questions = [UniqueKey()];
  final Map<Key, Map<String, dynamic>> _questionData = {};

  void _addQuestion() {
    setState(() {
      final newKey = UniqueKey();
      _questions.add(newKey);
      _questionData[newKey] = {
        "question_text": "",
        "description": "",
        "answers": [
          {"text": "", "is_correct": false},
          {"text": "", "is_correct": false},
          {"text": "", "is_correct": false},
          {"text": "", "is_correct": true},
        ]
      };
    });
  }

  void _removeQuestion(Key key) {
    setState(() {
      _questions.remove(key);
      _questionData.remove(key);
    });
  }

  void _updateQuestionData(Key key, Map<String, dynamic> data) {
    _questionData[key] = data;
  }

  Future<void> _submitQuiz() async {
    final int themeid = widget.lectureId;
    print(widget.lectureId);
    print(widget.lectureId.runtimeType);
    try {
      for (var key in _questionData.keys) {
        final question = _questionData[key]!;
        final body = {
          "lecture_id": themeid,
          "question_text": question["question_text"],
          "description": question["description"],
          "answers": question["answers"]
        };

        await requestHelper.postWithAuth('/api/v1/questions/', body, log: true);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Testlar muvaffaqiyatli yuborildi!")),
      );
      context.pop('added');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik yuz berdi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.cardLight,
        centerTitle: true,
        title: const Text('Testni tuzish'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mavzulashtirilgan testni tuzish',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      QuestionWidget(
                        key: _questions[index],
                        questionNumber: index + 1,
                        onRemove: () => _removeQuestion(_questions[index]),
                        onUpdate: (data) =>
                            _updateQuestionData(_questions[index], data),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
            Center(
              child: Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: _addQuestion,
                  child: Text(
                    'Yangi test qo’shish',
                    style: AppStyle.fontStyle.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: MyColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 400,
                child: ElevatedButton(
                  onPressed: _submitQuiz,
                  child: Text(
                    'Yakunlash',
                    style: AppStyle.fontStyle.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: MyColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final int questionNumber;
  final VoidCallback onRemove;
  final ValueChanged<Map<String, dynamic>> onUpdate;

  const QuestionWidget({
    super.key,
    required this.onRemove,
    required this.onUpdate,
    required this.questionNumber,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<TextEditingController> _answerControllers =
      List.generate(4, (_) => TextEditingController());
  final List<bool> _isCorrect = [false, false, false, false];

  @override
  void dispose() {
    _questionController.dispose();
    _descriptionController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _notifyParent() {
    widget.onUpdate({
      "question_text": _questionController.text,
      "description": _descriptionController.text,
      "answers": List.generate(4, (index) {
        return {
          "text": _answerControllers[index].text,
          "is_correct": _isCorrect[index],
        };
      }),
    });
  }

  void _updateIsCorrect(int index, bool value) {
    setState(() {
      _isCorrect[index] = value;
    });
    _notifyParent();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: MyColors.cardLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.questionNumber} - testni tuzish',
                style: AppStyle.fontStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: widget.onRemove,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/delete.svg',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 10),
                      Text('O\'chirish',
                          style: AppStyle.fontStyle.copyWith(
                              color: Colors.red[900]!,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            style: AppStyle.fontStyle,
            controller: _questionController,
            onChanged: (_) => _notifyParent(),
            decoration: InputDecoration(
              labelStyle: AppStyle.fontStyle,
              labelText: 'Savol',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            style: AppStyle.fontStyle,
            controller: _descriptionController,
            onChanged: (_) => _notifyParent(),
            decoration: InputDecoration(
              labelStyle: AppStyle.fontStyle,
              labelText: 'To\'gri javob izohi',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(4, (index) {
            final labels = ['A', 'B', 'C', 'D']; // Массив с буквами
            return Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                      style: AppStyle.fontStyle,
                      controller: _answerControllers[index],
                      onChanged: (_) => _notifyParent(),
                      decoration: InputDecoration(
                        labelStyle: AppStyle.fontStyle,
                        labelText:
                            'Variant ${labels[index]}', // Используем буквы вместо номеров
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Checkbox(
                  value: _isCorrect[index],
                  onChanged: (value) {
                    _updateIsCorrect(index, value ?? false);
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
