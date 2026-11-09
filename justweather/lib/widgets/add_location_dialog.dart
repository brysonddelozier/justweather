import 'package:flutter/material.dart';
import 'package:justweather/api/location_api.dart';


class CitySearchDialog extends StatefulWidget {
  final Function(City) onCityAdded;

  const CitySearchDialog({super.key, required this.onCityAdded});

  @override
  State<CitySearchDialog> createState() => _CitySearchDialogState();
}

class _CitySearchDialogState extends State<CitySearchDialog> {
  String currentSearchText = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Location'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Type city name...'),
              onChanged: (newText) {
                setState(() {
                  currentSearchText = newText;
                });
              },
            ),
            const SizedBox(height: 16),
            
            Flexible(
              child: FutureBuilder<List<City>>(
                future: searchCities(currentSearchText),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Loading...'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('No cities found.'),
                    );
                  }

                  List<City> cities = snapshot.data!.where((city) => city.country == "United States").toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(cities[index].name),
                        trailing: Text(cities[index].state ?? 'State Unknown'),
                        onTap: () {
                          widget.onCityAdded(cities[index]);
                          Navigator.pop(context);
                        },
                      );                     
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


void showCitySearchDialog(BuildContext context, Function(City) onCityAdded) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CitySearchDialog(onCityAdded: onCityAdded);
    },
  );
}
