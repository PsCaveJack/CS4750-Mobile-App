import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:untitled/Movie.dart';
import 'package:untitled/MovieByIdDTO.dart';
import 'package:untitled/MovieDTO.dart';

import 'Provider.dart';
import 'ProviderDTO.dart';

String path = "https://api.themoviedb.org/3/";
String key = "ba7bbdd19263d27d4496e3b158fdbfe0";

class FetchMovie {

  List<Movie> results = [];

  String fetchurl = "${path}search/movie?api_key=$key"
      "&page=1&include_adult=false&query=";

  Future<List<Movie>> getMovieList(String query) async {
    var url = Uri.parse(fetchurl + query);
    var response = await http.get(url);

    var data = [];

    if(response.statusCode == 200){
      data = json.decode(response.body)['results'];
      results = data.map((e) => Movie(MovieDTO.fromJson(e))).toList();
    }
    else {
      throw Exception("Failed to load movies");
    }

    return results;
  }

  Future<Movie> getMovieByID(int id) async {

    var url = Uri.parse("${path}movie/${id.toString()}?api_key=$key");
    var response = await http.get(url);

    Movie result;

    if(response.statusCode == 200){
      result = Movie.byId(MovieByIdDTO.fromJson(json.decode(response.body) as Map<String, dynamic>));
    }
    else {
      throw Exception("Failed to load movies");
    }

    result.providers = await getProvidersByMovieId(id);


    return result;

  }

  Future<List<Provider>> getProvidersByMovieId(int id) async {
    var url = Uri.parse("${path}movie/$id/watch/providers?api_key=$key");
    var response = await http.get(url);

    List<Provider> result = [];

    if(response.statusCode == 200){
      var resultData = json.decode(response.body)['results'];
      if(resultData.containsKey('US')) {
        var usData = resultData['US'];
        if (usData.containsKey('flatrate')) {
          // provider data is a list
          List providerData = usData['flatrate'];
          result = providerData
              .map((e) => ProviderDTO.fromJson(e))
              .where((providerDTO) => providerDTO.displayPriority! <= 20)
              .map((providerDTO) => Provider(providerDTO))
              .toList();
        }
      }
    }
    else {
      throw Exception("Failed to load movies");
    }
    return result;
  }

}