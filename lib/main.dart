import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gaz_app/firebase_options.dart';
import 'package:gaz_app/login/login_page.dart';
import 'package:gaz_app/model/profil.dart';
import 'package:gaz_app/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ProfilModel? profil;
  bool wel = false;
  Future _verifData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      wel = prefs.getBool('welcome')!;
      int? id = prefs.getInt('id');
      String? email = prefs.getString('email');
      String? address = prefs.getString('adresse');
      String? numero = prefs.getString('numero');
      double? lng = prefs.getDouble('lng');
      double? lat = prefs.getDouble('lat');
      String? password = prefs.getString('password');
      int? solde = prefs.getInt('solde');
      String? uid = prefs.getString('uid');
      ProfilModel userReup = new ProfilModel(
          id: id!,
          email: email!,
          address: address!,
          numero: numero!,
          password: password!,
          lng: lng!,
          lat: lat!,
          solde: solde!,
          uid: uid!);
      setState(() {
        profil = userReup;
      });
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mon Gaz',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: backgroundColor),
          useMaterial3: true,
        ),
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return wel == true
                    ? HomePage(
                        utilisateur: profil!,
                      )
                    : LoginPage();
              } else {
                return LoginPage();
                //OnboardingPage();
              }
            }));
  }
}
