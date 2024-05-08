import 'package:flutter/material.dart';
import 'package:assignment/bloc/user_bloc.dart';

class UserProvider extends InheritedWidget {
  final UserBloc userBloc;

  UserProvider({
    required this.userBloc,
    required Widget child,
  }) : super(child: child);

  static UserProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProvider>();
  }

  @override
  bool updateShouldNotify(UserProvider oldWidget) {
    return userBloc != oldWidget.userBloc;
  }
}
