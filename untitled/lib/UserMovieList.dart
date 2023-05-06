import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/TMDBData.dart';

import 'Movie.dart';

class UserMovieList {
  static List<int> userMovieIDs = [];

  static Future<void> loadIntList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<int> intList = prefs.getStringList('myMovieList')?.map((e) => int.parse(e)).toList() ?? [];

    userMovieIDs = intList;
  }

  static Future<void> addMovieToList(int id) async {

    if (!await movieInList(id)) {
      userMovieIDs.add(id);
      saveIntList(userMovieIDs);
    }

  }

  static Future<void> removeMovieFromList(int id) async {

    if(await movieInList(id)) {
      userMovieIDs.remove(id);
      saveIntList(userMovieIDs);
    }
  }

  static Future<bool> movieInList(int id) async {
    await loadIntList();

    return userMovieIDs.contains(id);
  }

  static Future<void> saveIntList(List<int> list) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('myMovieList', list.map((e) => e.toString()).toList());
  }

  static void resetList() {
    userMovieIDs = [];
    saveIntList([]);
  }

  static Future<List<Movie>> getList() async {

    await loadIntList();

    List<Movie> result = [];
    
    FetchMovie database = FetchMovie();

    for (int i = 0; i < userMovieIDs.length; i++){
      result.add(await database.getMovieByID(userMovieIDs[i]));
    }

    return result;
  }


}