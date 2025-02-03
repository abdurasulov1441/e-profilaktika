import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:profilaktika/common/helpers/request_helper.dart';

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

        await requestHelper.postWithAuth('/api/v1/questions/', body);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Testlar muvaffaqiyatli yuborildi!")),
      );
      context.pop();
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
              child: ElevatedButton.icon(
                onPressed: _addQuestion,
                icon: const Icon(Icons.add),
                label: const Text('Yangi test qo’shish'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[900],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _submitQuiz,
                child: const Text('Yakunlash'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
  final VoidCallback onRemove;
  final ValueChanged<Map<String, dynamic>> onUpdate;

  const QuestionWidget(
      {super.key, required this.onRemove, required this.onUpdate});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<TextEditingController> _answerControllers =
      List.generate(4, (_) => TextEditingController());

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
      "answers": [
        {"text": _answerControllers[0].text, "is_correct": false},
        {"text": _answerControllers[1].text, "is_correct": false},
        {"text": _answerControllers[2].text, "is_correct": false},
        {"text": _answerControllers[3].text, "is_correct": true},
      ]
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Savolni yozish',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
              IconButton(
                onPressed: widget.onRemove,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _questionController,
            onChanged: (_) => _notifyParent(),
            decoration: InputDecoration(
              labelText: 'Savol',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            onChanged: (_) => _notifyParent(),
            decoration: InputDecoration(
              labelText: 'Savol izohi',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: _answerControllers[index],
                onChanged: (_) => _notifyParent(),
                decoration: InputDecoration(
                  labelText: index == 3 ? 'To’g’ri javob' : 'Noto’g’ri javob',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
