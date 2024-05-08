import 'package:assignment/bloc/user_bloc.dart';
import 'package:assignment/providers/user_provider.dart';
import 'package:assignment/models/user.dart';
import 'package:assignment/screens/profile_screen.dart';
import 'package:assignment/widgets/custom_text_field.dart';
import 'package:assignment/widgets/custum_button.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = UserProvider.of(context)!.userBloc;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Login Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          SizedBox(height: 80),
          Image.asset('lib/assets/images/undraw_Mobile_login_re_9ntv.png'),
          CustomTextField(
            obsText: false,
            controllerText: emailController,
            hint: 'i.e, studentID@stud.fci-cu.edu.eg',
            label: 'Email',
            icon: Icon(Icons.email),
          ),
          SizedBox(height: 10),
          CustomTextField(
            obsText: true,
            controllerText: passwordController,
            hint: 'Password',
            label: 'Password',
            icon: Icon(Icons.password),
          ),
          SizedBox(height: 15),
          CustomButton(
            text: 'Login',
            onPressed: () async {
              User user = User(
                email: emailController.text,
                password: passwordController.text,
              );
              try {
                await userBloc.loginUser(user);
                Navigator.pushNamed(context, 'ProfilePage');
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Login failed. Please try again.'),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

/*Future<void> loginUser(User user, BuildContext context) async {
  final Dio dio = Dio();
  const url = 'http://10.0.2.2:5266/api/Auth/login';

  try {
    final response = await dio.post(
      url,
      data: user.toJson(),
    );

    if (response.statusCode == 200) {
      final String email = response.data['email'];
      // Store the token locally using shared_preferences or flutter_secure_storage
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);

      // Navigate to role selection page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
        (route) => false,
      );
    } else {
      // Handle unsuccessful login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please check your credentials.'),
        ),
      );
    }

    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
  } catch (error) {
    print('Error: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred. Please try again later.'),
      ),
    );
  }
}*/
