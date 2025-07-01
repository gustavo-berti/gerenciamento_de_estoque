import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/location/country_list_screen.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/location/state_list_screen.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/location/city_list_screen.dart';

class WidgetLocation extends StatelessWidget {
  const WidgetLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const TabBar(
          tabs: [
            Tab(text: 'Países', icon: Icon(Icons.public)),
            Tab(text: 'Estados', icon: Icon(Icons.map)),
            Tab(text: 'Cidades', icon: Icon(Icons.location_city)),
          ],
        ),
        body: const TabBarView(
          children: [
            CountryListScreen(),
            StateListScreen(),
            CityListScreen(),
          ],
        ),
      ),
    );
  }
}
