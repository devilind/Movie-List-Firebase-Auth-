// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zupay_assignment/auth_service.dart';
import 'package:zupay_assignment/model/model.dart';
import 'package:zupay_assignment/movie_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User?>();
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance)),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        key: UniqueKey(),
        home: firebaseuser == null ? LoginScreen() : MoviesScreen(),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 250.0, left: 25, right: 25),
                child: Column(
                  children: [
                    SizedBox(
                      child: TextField(
                        controller: email,
                        decoration: InputDecoration(label: Text("Email")),
                      ),
                    ),
                    SizedBox(
                      child: TextField(
                        controller: password,
                        decoration: InputDecoration(label: Text("Password")),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    IconButton(
                      onPressed: () async {
                        await context.read<AuthService>().signIn(
                            email: email.text.trim(),
                            password: password.text.trim());

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoviesScreen()),
                        );
                      },
                      icon: Icon(
                        Icons.login,
                        size: 40,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
