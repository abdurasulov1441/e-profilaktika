import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:profilaktika/common/helpers/request_helper.dart';

class ThemeAddPage extends StatefulWidget {
  const ThemeAddPage({super.key});

  @override
  State<ThemeAddPage> createState() => _ThemeAddPageState();
}

class _ThemeAddPageState extends State<ThemeAddPage> {
  final TextEditingController _lecturerController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  DateTime? _selectedDate;

  // Method for date selection
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_lecturerController.text.isEmpty ||
        _numberController.text.isEmpty ||
        _topicController.text.isEmpty ||
        _textController.text.isEmpty ||
        _selectedDate == null) {
      _showError("Please fill all fields");
      return;
    }

    final response = await requestHelper.postWithAuth('/api/v1/lectures/', {
      'lecturer': _lecturerController.text,
      'number': _numberController.text,
      'topic': _topicController.text,
      'text': _textController.text,
      'date': _selectedDate!.toIso8601String(),
    });
    print(response);
    if (response['statusCode'] == 201) {
      _showSuccess("Theme created successfully");
      _clearForm();
    } else {
      _showError("Failed to create theme");
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _clearForm() {
    _lecturerController.clear();
    _numberController.clear();
    _topicController.clear();
    _textController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          enabled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: 'Maruza qilish sanasi',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _selectedDate == null
                    ? 'Sanani tanlang'
                    : "${_selectedDate!.toLocal()}".split(' ')[0],
              ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                context.pop('added');
              },
              icon: Icon(Icons.arrow_back)),
          title: Text("Mavzu qo'shish")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mavzu haqida ma’lumot',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
                label: 'Maruza raqami', controller: _numberController),
            _buildTextField(
                label: 'Maruza mavzusi', controller: _topicController),
            _buildTextField(
                label: 'Maruzachi', controller: _lecturerController),
            _buildDateField(context), // Date picker field
            _buildTextField(
                label: 'Maruza matnini kiriting',
                controller: _textController,
                maxLines: 11),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Yakunlash'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
