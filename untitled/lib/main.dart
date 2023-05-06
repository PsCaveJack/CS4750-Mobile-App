import 'package:flutter/material.dart';
import 'package:untitled/BestProviders.dart';
import 'package:untitled/MovieDetails.dart';
import 'package:untitled/TMDBData.dart';
import 'package:untitled/UserMovieList.dart';

import 'Movie.dart';
// Name: Jack Rogers

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyMovieApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'MyMovieApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MyMovieApp",
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: MyListPage(),
    );
  }
}

class MyListPage extends StatefulWidget {
  @override
  _MyListPageState createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {

  List<Movie> list = [];

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  Future<List<Movie>> getList() async {
    return await UserMovieList.getList();
  }

  Future<void> refreshList() async {
    list = await UserMovieList.getList();
    setState(() {});

  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
        future: getList(),
        builder: (context, snapshot) {
          var data = snapshot.data;
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (data != null) {
            list = data;
            double h = MediaQuery.of(context).size.height;
            return RefreshIndicator(
                onRefresh: refreshList,
                child: Column(
                  children: [
                    Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        alignment: Alignment.centerLeft,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Your Movie List",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0)),
                              ElevatedButton(
                                onPressed: () {
                                  openSubscriptions(context, list);
                                },
                                child: Text('Subscriptions'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.blue[800]!,
                                  ),
                                  elevation: MaterialStateProperty.all<double>(4.0),
                                ),
                              ),
                            ])),
                    Expanded(
                      child: MovieList(list),
                    ),
                  ],
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  void openSubscriptions (BuildContext context, List<Movie> data){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => BestProviders(data)
        )
    );
  }
}

class BestProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column();
  }
}

class CustomSearchDelegate extends SearchDelegate {
  FetchMovie movieList = FetchMovie();
  List<Movie> list = [];
  @override
  ThemeData appBarTheme(BuildContext context) {

    final ThemeData theme = Theme.of(context).copyWith(
      primaryColor: Colors.black,
      textTheme: const TextTheme(
        headline6: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
    return theme;
  }
  // first overwrite to clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  // third overwrite to show query result
  // get request and navigate to page with matching shows
  @override
  Widget buildResults(BuildContext context) {
    // // TODO: implement buildResults
    //
    return MovieList(list);

  }

  // last overwrite to show the querying process at the runtime
  // get requests to show matching popular results
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Movie>>(
        future: movieList.getMovieList(query),
        builder: (context, snapshot) {
          var data = snapshot.data;
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (data != null) {
            list = data;
            double h = MediaQuery.of(context).size.height;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    openMovie(context, list[index]);
                  },
                  child: Container(
                    height: h * 0.1,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        opacity: 0.5,
                        image: list[index].backdrop,
                      ),
                    ),
                    child: ListTile(
                      title: Text(list[index].title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0,1.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0)
                              ),
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 8.0,
                                color: Color.fromARGB(0, 0, 0, 255)
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  void openMovie (BuildContext context, Movie movie){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => MovieDetails(movie: movie)
        )
    );
  }
}


class MovieList extends StatelessWidget {

  late List<Movie> list;

  MovieList(List<Movie> data){
    list = data;
  }
  @override
  Widget build(BuildContext context){
    return GridView.builder(
      itemCount: list.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
        mainAxisSpacing: 3, crossAxisSpacing: 3,childAspectRatio: .66),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            openMovie(context, list[index]);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                fit: BoxFit.fill,
                opacity: 1.0,
                image: list[index].poster,
              ),
            ),
          ),
        );
      },
    );
  }

  void openMovie (BuildContext context, Movie movie){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => MovieDetails(movie: movie)
        )
    );
  }

}
