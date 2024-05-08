import 'package:assignment/models/product.dart';
import 'package:assignment/widgets/buttomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:assignment/models/restaurant.dart';
import 'package:assignment/bloc/restaurant_products_bloc.dart';

class RestaurantProductsPage extends StatefulWidget {
  final Restaurant restaurant;

  RestaurantProductsPage({required this.restaurant});

  @override
  State<RestaurantProductsPage> createState() => _RestaurantProductsPageState();
}

class _RestaurantProductsPageState extends State<RestaurantProductsPage> {
  late RestaurantProductsBloc _productsBloc;

  @override
  void initState() {
    super.initState();
    _productsBloc = RestaurantProductsBloc(restaurantId: widget.restaurant.id, child: Container());
    _productsBloc.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: MyNavigationBar(),
      body: StreamBuilder<List<Product>>(
        stream: _productsBloc.productsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Product> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: Color.fromARGB(255, 205, 221, 235),
                  shadowColor: Colors.grey,
                  elevation: 3,
                  child: Center(child: Text(product.name,
                  style: TextStyle(fontSize: 22),),
                ),);
              },
            );
          } else {
            return Center(child: Text('No products available'));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _productsBloc.dispose();
    super.dispose();
  }
}
