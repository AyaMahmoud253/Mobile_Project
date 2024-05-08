import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:assignment/models/product.dart';

class RestaurantProductsBloc extends InheritedWidget {
  final int restaurantId;
  final BehaviorSubject<List<Product>> _productsSubject = BehaviorSubject<List<Product>>();
  final String apiUrl = 'http://10.0.2.2:5266/api/Restaurant';

  RestaurantProductsBloc({Key? key, required Widget child, required this.restaurantId})
      : super(key: key, child: child);

  static RestaurantProductsBloc? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RestaurantProductsBloc>();
  }

  @override
  bool updateShouldNotify(RestaurantProductsBloc oldWidget) {
    return _productsSubject != oldWidget._productsSubject;
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$restaurantId/Products'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Product> products = data.map((json) => Product.fromJson(json)).toList();
        _productsSubject.add(products);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Failed to load products: $e');
      _productsSubject.addError(e);
    }
  }

  Stream<List<Product>> get productsStream => _productsSubject.stream;

  void dispose() {
    _productsSubject.close();
  }
}
