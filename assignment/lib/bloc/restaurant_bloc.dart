import 'package:assignment/providers/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:assignment/models/restaurant.dart';

class RestaurantBloc {
  final BehaviorSubject<List<Restaurant>> _restaurantsSubject =
      BehaviorSubject<List<Restaurant>>();
  final String apiUrl = 'http://10.0.2.2:5266/api/Restaurant';

  Future<void> fetchRestaurants() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          List<Restaurant> restaurants =
              data.map((json) => Restaurant.fromJson(json)).toList();
          _restaurantsSubject.add(restaurants);
        } else {
          throw Exception('No restaurants found');
        }
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      print('Failed to load restaurants: $e');
      _restaurantsSubject.addError(e);
    }
  }

  Future<List<Restaurant>> fetchRestaurantsByProduct(String product) async {
  final String apiUrl = 'http://10.0.2.2:5266/api/ProductSearch/$product';
  try {
    final response = await http.get(Uri.parse(apiUrl));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['\$values'];
      if (data.isNotEmpty) {
        List<Restaurant> restaurants = data.map((json) {
          return Restaurant(
            id: json['id'],
            name: json['name'],
            address: json['address'],
            latitude: json['latitude'],
            longitude: json['longitude'],
          );
        }).toList();
        _restaurantsSubject.add(restaurants);
        return restaurants;
      } else {
        throw Exception('No restaurants found for the product: $product');
      }
    } else {
      throw Exception('Failed to load restaurants for the product: $product');
    }
  } catch (e) {
    print('Failed to load restaurants for the product $product: $e');
    _restaurantsSubject.addError(e);
    rethrow;
  }
}



  Stream<List<Restaurant>> get restaurantsStream =>
      _restaurantsSubject.stream;

  static RestaurantBloc of(BuildContext context) {
    final restaurantBloc =
        context.dependOnInheritedWidgetOfExactType<RestaurantProvider>();
    if (restaurantBloc == null) {
      throw Exception('RestaurantBloc not found in context');
    }
    return restaurantBloc.restaurantBloc;
  }

  void dispose() {
    _restaurantsSubject.close();
  }
}
