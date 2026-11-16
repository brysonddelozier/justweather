// Started with https://docs.flutter.dev/development/ui/widgets-intro
//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter/material.dart';
import 'package:justweather/objects/locations.dart';
import 'package:justweather/widgets/weather_record.dart';
import 'package:justweather/widgets/add_location_dialog.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<Location> locations = [
    Location(name: "Conway", latitude: 35.0887, longitude: -92.4421),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Weather'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showCitySearchDialog(context, (city) {
                setState(() {
                  locations.add(Location(name: city.name, latitude: city.latitude, longitude: city.longitude));
                });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: locations.map((location) {
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  locations.remove(location);
                });
              },
              background: Container(
                color: Colors.red,
                 alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white, size: 40.0)),
              child: WeatherRecord(location: location)
            );
          }).toList(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'To Do List',
    home: const ToDoList(),
    theme: ThemeData.dark(useMaterial3: true),
    debugShowCheckedModeBanner: false,
  ));
}
