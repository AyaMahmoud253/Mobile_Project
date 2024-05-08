import 'package:flutter/material.dart';
import 'package:assignment/bloc/restaurant_bloc.dart';

class RestaurantProvider extends InheritedWidget {
  final RestaurantBloc restaurantBloc;

  RestaurantProvider({
    required this.restaurantBloc,
    required Widget child,
  }) : super(child: child);

  static RestaurantProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RestaurantProvider>();
  }

  @override
  bool updateShouldNotify(RestaurantProvider oldWidget) {
    return restaurantBloc != oldWidget.restaurantBloc;
  }
}
