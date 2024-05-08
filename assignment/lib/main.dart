
import 'package:assignment/bloc/restaurant_bloc.dart';
import 'package:assignment/providers/restaurant_provider.dart';
import 'package:assignment/providers/user_provider.dart';
import 'package:assignment/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:assignment/screens/edit_profile_screen.dart';
import 'package:assignment/screens/login_screen.dart';
import 'package:assignment/screens/profile_screen.dart';
import 'package:assignment/screens/sign_up_screen.dart';
import 'package:assignment/bloc/user_bloc.dart'; // Import your UserBloc class

void main() {
  final userBloc = UserBloc();
  final restaurantBloc = RestaurantBloc();

  runApp(
    UserProvider(
      userBloc: userBloc,
      child: RestaurantProvider(
        restaurantBloc: restaurantBloc,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpPage(),
      routes: {
        'LoginPage': (context) => LoginPage(),
        'ProfilePage': (context) => ProfilePage(),
        'EditProfilePage': (context) => EditProfilePage(),
      },
    );
  }
}

