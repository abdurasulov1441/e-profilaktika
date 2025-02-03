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
  bool isHiddenPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      final response = await requestHelper.post(
        '/api/v1/auth/login',
        {
          'username': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      if (response['accessToken'] != null && response['refreshToken'] != null) {
        cache.setString('access_token', response['accessToken']);
        cache.setString('refresh_token', response['refreshToken']);

        cache.setInt('user_id', response['user']['id']);
        cache.setString('first_name', response['user']['firstname']);
        cache.setString('last_name', response['user']['lastname']);
        cache.setString('surname', response['user']['surname'] ?? '');
        cache.setString('photo', response['user']['photo']);

        cache.setInt('structure_id', response['user']['structure']['id']);
        cache.setString('structure_oz', response['user']['structure']['oz']);
        cache.setString('structure_ru', response['user']['structure']['ru']);
        cache.setString('structure_uz', response['user']['structure']['uz']);

        cache.setInt('role_id', response['user']['role']['id']);
        cache.setString('role_oz', response['user']['role']['oz']);
        cache.setString('role_ru', response['user']['role']['ru']);
        cache.setString('role_uz', response['user']['role']['uz']);
        cache.setString('role_name', response['user']['role_name']);

        cache.setString('rank_oz', response['user']['rank']['oz']);
        cache.setString('rank_ru', response['user']['rank']['ru']);
        cache.setString('rank_uz', response['user']['rank']['uz']);

        cache.setString('position_oz', response['user']['position']['oz']);
        cache.setString('position_ru', response['user']['position']['ru']);
        cache.setString('position_uz', response['user']['position']['uz']);

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
                        controller: emailController,
                        decoration: InputDecoration(
                          // hoverColor: themeProvider.getColor('hoverColor'),
                          filled: true,
                          // fillColor: themeProvider.getColor('foreground'),
                          hintText: 'Login',
                          // hintStyle: themeProvider.getTextStyle(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Loginni kiriting';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: isHiddenPassword,
                        decoration: InputDecoration(
                          // hoverColor: themeProvider.getColor('hoverColor'),
                          filled: true,
                          // fillColor: themeProvider.getColor('foreground'),
                          hintText: 'Parol',
                          // hintStyle: themeProvider.getTextStyle(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isHiddenPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              // color: themeProvider.getColor('icon'),
                            ),
                            onPressed: togglePasswordView,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Parolni kiriting';
                          }
                          return null;
                        },
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
