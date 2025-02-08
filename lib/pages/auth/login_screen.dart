import 'package:easy_localization/easy_localization.dart';
import 'package:profilaktika/app/router.dart';
import 'package:profilaktika/app/theme.dart';
import 'package:profilaktika/common/helpers/request_helper.dart';
import 'package:profilaktika/db/cache.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController jetonController = TextEditingController();
  TextEditingController passportNumberController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void formatPassportInput(String value) {
    String formatted = value.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    if (formatted.length >= 2) {
      formatted = formatted.substring(0, 2).toUpperCase() +
          (formatted.length > 2 ? ' ' + formatted.substring(2) : '');
    }
    passportNumberController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(pickedDate); // To'g'ri format
      setState(() {
        birthDateController.text = formattedDate; // Tanlangan sanani saqlash
      });
    }
  }

  Future<void> login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      final response = await requestHelper.post(
        '/api/v1/auth/login',
        {
          // 'id_number': jetonController.text.trim(),
          // 'passport_number': passportNumberController.text.replaceAll(' ', ''),
          // 'birthdate': birthDateController.text.trim(),
          'id_number': '008937',
          'passport_number': 'AB1234567',
          'birthdate': '1989-09-22',
        },
        log: true,
      );
      if (response['accessToken'] != null && response['refreshToken'] != null) {
        cache.setString('access_token', response['accessToken']);
        cache.setString('refresh_token', response['refreshToken']);

        cache.setInt('user_id', response['user']['id']);
        cache.setString('first_name', response['user']['firstname']);
        cache.setString('last_name', response['user']['lastname']);
        cache.setString('surname', response['user']['surname'] ?? '');
        cache.setString('photo', response['user']['photo']);
        print(response['accessToken']);

        router.go(Routes.mainPage);
      } else {
        String status = response['message'];
        ElegantNotification.success(
          width: 360,
          isDismissable: false,
          animationCurve: Curves.easeInOut,
          position: Alignment.topCenter,
          animation: AnimationType.fromTop,
          title: Text('Xatolik'),
          description: Text(status),
          onDismiss: () {},
          onNotificationPressed: () {},
          shadow: BoxShadow(
            color: Colors.green,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ).show(context);
      }
    } catch (error) {
      ElegantNotification.success(
        width: 360,
        isDismissable: false,
        animationCurve: Curves.easeInOut,
        position: Alignment.topCenter,
        animation: AnimationType.fromTop,
        title: Text('Sizning Ip manzilingizga ruhsat yo\'q'),
        description: Text('Kiberxavsizlikka murojaat qiling'),
        onDismiss: () {},
        onNotificationPressed: () {},
        shadow: BoxShadow(
          color: Colors.green,
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 4),
        ),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: themeProvider.getColor('background'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Xush kelibsiz!',
                    // style: themeProvider
                    //     .getTextStyle()
                    //     .copyWith(fontSize: 28, fontWeight: FontWeight.bold)
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Tizimga kirishingiz mumkin',
                    // style: themeProvider.getTextStyle()
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 400,
                  height: 400,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: jetonController,
                        decoration: InputDecoration(
                          hintText: 'Jeton raqami',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Loginni kiriting' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passportNumberController,
                        onChanged: formatPassportInput,
                        decoration: InputDecoration(
                          hintText: 'Passport seriya va raqami',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Passportni kiriting' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: birthDateController,
                        readOnly: true,
                        onTap: pickDate,
                        decoration: InputDecoration(
                          hintText: 'Tug‘ilgan kun',
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Tug‘ilgan kunni kiriting' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primary,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Kirish',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
