import 'package:assignment/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:assignment/models/user.dart';
import 'package:assignment/widgets/custom_text_field.dart';
import 'package:assignment/widgets/custum_button.dart';
import 'package:assignment/providers/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? selectedGender;
  String? selectedLevel;

  @override
  Widget build(BuildContext context) {
    final userBloc = UserProvider.of(context)!.userBloc;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<User>(
        stream: userBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final user = snapshot.data!;

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              CustomTextField(
                obsText: false,
                controllerText: TextEditingController(text: user.name),
                hint: 'Type your name',
                icon: Icon(Icons.person),
                label: 'Name',
                onChanged: (value) => user.name = value,
              ),
              SizedBox(height: 10),
              // Gender selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gender',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Male',
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                            user.gender = value!;
                          });
                        },
                      ),
                      Text('Male'),
                      Radio<String>(
                        value: 'Female',
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                            user.gender = value!;
                          });
                        },
                      ),
                      Text('Female'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              CustomTextField(
                obsText: false,
                controllerText: TextEditingController(text: user.email),
                hint: 'i.e, *******@gmail.com',
                label: 'Email',
                icon: Icon(Icons.email),
                onChanged: (value) => user.email = value,
              ),
              SizedBox(height: 10),
              // Level selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: selectedLevel,
                    onChanged: (value) {
                      setState(() {
                        selectedLevel = value;
                        user.level = value!;
                      });
                    },
                    items: ['1', '2', '3', '4']
                        .map((level) => DropdownMenuItem<String>(
                              value: level,
                              child: Text(level),
                            ))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 10),
              CustomTextField(
                obsText: true,
                controllerText: TextEditingController(text: user.password),
                hint: 'Password',
                label: 'Password',
                icon: Icon(Icons.password),
                onChanged: (value) => user.password = value,
              ),
              SizedBox(height: 10),
              CustomTextField(
                obsText: true,
                controllerText:
                    TextEditingController(text: user.confirmPassword),
                hint: 'Confirm Password',
                label: 'Confirm Password',
                icon: Icon(Icons.password),
                onChanged: (value) => user.confirmPassword = value,
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member?                                   ',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'LoginPage');
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              CustomButton(
                text: 'Submit',
                onPressed: () {
                  _registerUser(user);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _registerUser(User user) async {
  try {
    final userProvider = UserProvider.of(context);
    if (userProvider != null) {
      final userBloc = userProvider.userBloc;
      await userBloc.registerUser();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Success'),
        ),
      );
      // Navigate to the profile page
      Navigator.pushReplacementNamed(context, 'ProfilePage');
    } else {
      print('UserProvider is null');
    }
  } catch (error) {
    print(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registration Failed: $error'),
      ),
    );
  }
}






}
