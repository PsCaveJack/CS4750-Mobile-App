import 'package:flutter/material.dart';
import 'package:untitled/ProviderDTO.dart';

class Provider {

  String logoPath = "";
  int id = -1;
  String name = "";

  Provider(ProviderDTO data) {
    name = data.providerName ?? name;
    id = data.providerId ?? id;

    logoPath = "https://image.tmdb.org/t/p/w200${data.logoPath}" ?? logoPath;
  }
}