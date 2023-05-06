import 'package:flutter/material.dart';
import 'package:untitled/UserMovieList.dart';

import 'Movie.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key, required this.movie});

  final Movie movie;

  @override
  State<MovieDetails> createState() => _MyMoviePageState();
}

class _MyMoviePageState extends State<MovieDetails> {

  bool inList = false;

  String buttonText = "";

  Color buttonColor = Colors.white;
  @override
  void initState() {
    super.initState();
    getMovie();
  }

  void getMovie() async {
    inList = await UserMovieList.movieInList(widget.movie.id);
    if(inList) {
      buttonText = "Remove";
      buttonColor = Colors.red[400]!;
    } else {
      buttonText = "Add";
      buttonColor = Colors.green[400]!;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.movie.title)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(
                  aspectRatio: 0.66,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: widget.movie.poster,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  widget.movie.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    // Call the method you want to run here

                    setState(() {
                      if (inList) {
                        removeMovieFromList();
                        inList = false;
                        buttonText = "Add";
                        buttonColor = Colors.green[400]!;
                      } else {
                        addMovieToList();
                        inList = true;
                        buttonText = "Remove";
                        buttonColor = Colors.red[400]!;
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(primary: buttonColor),
                  child: Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Text(
                    widget.movie.description,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
                if(widget.movie.providers.isNotEmpty)
                  Column(children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                      child: Text(
                        "Providers",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child:
                        SizedBox(
                        height: 50.0,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.movie.providers.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 16.0);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  widget.movie.providers[index].logoPath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ), ),)
                  ]),
              ]),
            ],
          ),
        )
    );
  }

  void addMovieToList() {
    UserMovieList.addMovieToList(widget.movie.id);

  }

  void removeMovieFromList() {
    UserMovieList.removeMovieFromList(widget.movie.id);
  }

}