import 'package:beatz_wave/screens/song/SongScreen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';


import '../services/Auth.dart';

import 'BrandScreen.dart';
import 'GenreScreen.dart';
import 'auth/LoginScreen.dart';
import 'auth/RegisterScreen.dart';


class HomeScreen extends StatefulWidget {

  final String title;

  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final storage = new FlutterSecureStorage();


  @override
  void initState() {
    super.initState();

    // readToken();
    Future.microtask(() => readToken());
  }

  void readToken() async {
    dynamic token = await this.storage.read(key: 'token');

    if (token != null) {
      // Explicitly cast the token to a String
      String tokenString = token as String;

      Provider.of<Auth>(context, listen: false).tryToken(token: tokenString);

      print("read token");
      print(tokenString);
    } else {
      print("Token is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: Text('Beatz Wave')),
      drawer: Drawer(
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            if (!auth.authenticated) {
              return ListView(
                  children: [
                    ListTile(
                      title: Text('Login'),
                      leading: Icon(Icons.login),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                              LoginScreen(title: 'Login Screen')),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Register'),
                      leading: Icon(Icons.app_registration),
                      onTap: () {
                        //Handle logout logic
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => RegisterScreen(title: 'Register')),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Genres'),
                      leading: Icon(Icons.my_library_music),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => GenreScreen(title: 'GenreScreen')),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Brand'),
                      leading: Icon(Icons.surround_sound_rounded),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => BrandScreen(title: 'BrandScreen')),
                        );
                      },
                    )
                  ]
              );
            }
            else {
              String avatar = auth.user?.avatar as String;
              String name = auth.user?.name as String;
              String email = auth.user?.email as String;

              return ListView(
                children: [
                  DrawerHeader(
                    child: Column(
                      children: [

                        CircleAvatar(
                          //backgroundColor:Colors.white,
                          backgroundImage: NetworkImage(avatar),
                          radius: 30,
                        ),
                        SizedBox(height: 10,),

                        Text(
                          email,
                          style: TextStyle(color: Colors.white),
                        ),

                        SizedBox(height: 10,),

                        Text(
                          name,
                          style: TextStyle(color: Colors.white),
                        ),

                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text('Songs'),
                    leading: Icon(Icons.queue_music_sharp),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=> SongScreen(title: 'Song')),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Logout'),
                    leading: Icon(Icons.logout),
                    onTap: () {
                      //Handle logout logic
                      Provider.of<Auth>(context, listen: false).logout();
                    },
                  ),

                ],
              );
            }
          },
        ),
      ),
    );
  }
}
