// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zupay_assignment/auth_service.dart';
import 'package:zupay_assignment/main.dart';
import 'package:zupay_assignment/model/model.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  var confirmSave;
  TextEditingController movieName = TextEditingController();
  TextEditingController directorName = TextEditingController();

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Movie"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                SizedBox(
                  child: TextField(
                    controller: movieName,
                    decoration: InputDecoration(label: Text("Name")),
                  ),
                ),
                SizedBox(
                  child: TextField(
                    controller: directorName,
                    decoration: InputDecoration(label: Text("Director")),
                  ),
                )
              ],
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  confirmSave = 'no';
                });
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 10.0, right: 8, bottom: 10),
                child: Text(
                  'No',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  Movies.add(Movie(
                      name: movieName.text,
                      director: directorName.text,
                      img:
                          "https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_UY67_CR0,0,45,67_AL_.jpg"));
                });
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 10, bottom: 10),
                child: Text(
                  'Yes',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User?>();

    Size size = MediaQuery.of(context).size;
    return firebaseuser != null
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                'Movies',
                style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.3),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.logout_outlined),
                  onPressed: () {
                    context.read<AuthService>().signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false);
                  },
                )
              ],
            ),
            body: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: Movies.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  onDismissed: (direction) => {
                    showSnackBar(context, Movies[index], index),
                    removeMovie(index),
                  },
                  background: Container(
                    height: 50,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(
                      right: 20,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 30,
                      color: Colors.white,
                    ),
                    color: Colors.red,
                  ),
                  key: UniqueKey(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8, top: 8, bottom: 8),
                    child: Material(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(5),
                      elevation: 2,
                      child: SizedBox(
                        height: 70,
                        width: size.width * 0.95,
                        child: ListTile(
                          leading: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.network(
                                Movies[index].img,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          title: Text(
                            Movies[index].name,
                            style: GoogleFonts.montserrat(fontSize: 18),
                          ),
                          subtitle: Text(Movies[index].director,
                              style: GoogleFonts.montserrat(fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              enableFeedback: true,
              onPressed: () => {
                showOptionsDialog(context),
              },
              child: Icon(Icons.add),
            ),
          )
        : Scaffold(
            body: Center(child: Text("wrong credentials login failed")),
          );
  }

  removeMovie(int index) {
    setState(() {
      Movies.removeAt(index);
    });
  }

  showSnackBar(context, Movie movie, int index) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      content: Text(movie.name),
      action: SnackBarAction(
        label: "Undo",
        onPressed: () {
          undoDelete(index, movie);
        },
      ),
    ));
  }

  void undoDelete(int index, Movie movie) {
    setState(() {
      Movies.insert(index, movie);
    });
  }
}
