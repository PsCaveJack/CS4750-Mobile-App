import 'package:flutter/material.dart';
import 'package:untitled/MovieByIdDTO.dart';

import 'package:untitled/MovieDTO.dart';

import 'Provider.dart';

class Movie {
  String title = "";
  String description = "";
  int id = -1;

  // images set to default
  NetworkImage backdrop = const NetworkImage("");
  NetworkImage poster = const NetworkImage("");

  List<Provider> providers = [];

  Movie(MovieDTO data){
    // simple text data
    title = data.title ?? title;
    description = data.overview ?? description;

    id = data.id ?? id;

    // images
    backdrop = (data.backdropPath != null) ?
      NetworkImage("https://www.themoviedb.org/t/p/w1920_and_h800_multi_faces/${data.backdropPath}")
        : backdrop;
    poster = (data.posterPath != null) ?
      NetworkImage("https://www.themoviedb.org/t/p/w1280/${data.posterPath}")
        : backdrop;


  }

  Movie.byId(MovieByIdDTO data){
    title = data.title ?? title;
    description = data.overview ?? description;

    id = data.id ?? id;

    // images
    backdrop = (data.backdropPath != null) ?
    NetworkImage("https://www.themoviedb.org/t/p/w1920_and_h800_multi_faces/${data.backdropPath}")
        : backdrop;
    poster = (data.posterPath != null) ?
    NetworkImage("https://www.themoviedb.org/t/p/w1280/${data.posterPath}")
        : backdrop;

    // providers

  }
}