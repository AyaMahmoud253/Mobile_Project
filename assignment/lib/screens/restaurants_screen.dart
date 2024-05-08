import 'package:flutter/material.dart';
import 'package:assignment/bloc/restaurant_bloc.dart'; // Import your RestaurantBloc class
import 'package:assignment/models/restaurant.dart';
import 'package:assignment/widgets/custom_restaurant_card.dart';
import 'package:assignment/widgets/buttomNavigationBar.dart';

class AllRestaurantsPage extends StatefulWidget {
  const AllRestaurantsPage({Key? key}) : super(key: key);

  @override
  State<AllRestaurantsPage> createState() => _AllRestaurantsPageState();
}

class _AllRestaurantsPageState extends State<AllRestaurantsPage> {
  RestaurantBloc? _restaurantBloc; // Change type to nullable

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _restaurantBloc = RestaurantBloc.of(context);
    _restaurantBloc?.fetchRestaurants();
    print('gggggggggg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Restaurants/Cafes List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<Restaurant>>(
        stream: _restaurantBloc?.restaurantsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Restaurant> restaurants = snapshot.data!;
            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return RestaurantCard(restaurant: restaurant);
              },
            );
          } else {
            print(snapshot.data);
            print(snapshot.error);
            print(snapshot.connectionState);
            // If there are no errors but no data available
            return Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: MyNavigationBar(),
    );
  }

  @override
  void dispose() {
    _restaurantBloc?.dispose();
    super.dispose();
  }
}
