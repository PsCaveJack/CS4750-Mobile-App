import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Movie.dart';
import 'Provider.dart';

class BestProviders extends StatelessWidget {

  // key is provider's id
  // value is the count
  Map<int, ProviderCount> list = {};

  late int numberOfMovies;

  BestProviders(List<Movie> data){
    numberOfMovies = data.length;

    for (int i = 0; i < data.length; i++){
      List<Provider> providers = data[i].providers;
      for (int a = 0; a < providers.length; a++){
        if(list.containsKey(providers[a].id)){
          list[providers[a].id]?.count = list[providers[a].id]!.count + 1;
        }
        else {
          list[providers[a].id] = ProviderCount(providers[a]);
        }
      }
    }
    // final percentage = (item.count / items.map((e) => e.count).reduce((a, b) => a + b)) * 100;
  }

  @override
  Widget build(BuildContext context) {
    List<MapEntry<int, ProviderCount>> sortedEntries = list.entries.toList()
      ..sort((e1, e2) => e2.value.count.compareTo(e1.value.count));
    return Scaffold(
      appBar: AppBar(
        title: Text('Best Subscriptions'),
      ),
      body: ListView.builder(
        itemCount: sortedEntries.length,
        itemBuilder: (context, index) {
          Provider provider = sortedEntries[index].value.p;
          int count = sortedEntries[index].value.count;
          return ListTile(
            leading: Image.network(
              provider.logoPath,
              height: 50,
              width: 50,
            ),
            title: Text(
              provider.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${((count / numberOfMovies) * 100).round()}%'),
          );
        },
      ),
    );
  }
}

class ProviderCount {

  late Provider p;

  int count = 0;

  ProviderCount(Provider provider){
    p = provider;
    count = 1;
  }

}