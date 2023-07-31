import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaz_app/controller/config.dart';
import 'package:gaz_app/model/profil.dart';
import 'package:gaz_app/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/buttons.dart';
import '../components/forms.dart';
import '../components/textStyling.dart';
import '../constants.dart';
import '../functions.dart';
import 'authentification_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscur = false;
  ProfilModel? monUser;
  List<ProfilModel> user = [];
  Future AuthData(email, pass) async {
    try {
      await fetchDataFromAPI('/userfangres').then((value) {
        for (var element in value) {
          setState(() {
            user.add(ProfilModel.fromJson(element));
          });
        }
        for (var man in user) {
          if (email == man.email && pass == man.password) {
            setState(() {
              monUser = man;
              print(monUser!.password);
            });
          }
        }
        _saveData(monUser!);
      });
    } catch (e) {
      print('erreur sur la recuperation des de $e');
    }
  }

  _saveData(ProfilModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcome', true);
    await prefs.setInt('id', user.id!);
    await prefs.setString('email', user.address!);
    await prefs.setString('adresse', user.email!);
    await prefs.setString('numero', user.numero!);
    await prefs.setDouble('lng', user.lng!);
    await prefs.setDouble('lat', user.lat!);
    await prefs.setString('password', user.password!);
    await prefs.setInt('solde', user.solde!);
    await prefs.setString('uid', user.uid!);
    print('Données sauvegardées');
    print(user.uid);
  }

  void sigin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: passwordController.text)
          .then((value) {
        print(value);
      });
      await AuthData(email.text, passwordController.text).then((value) {
        MyFunction.onChangePage(context, HomePage(utilisateur: monUser!));
      });
    } catch (e) {
      print("$e erreur login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Connexion',
                  style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: containerSecondColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const SizedBox(height: 10),
                    TextStyling.textFieldTitle("Adresse mail"),
                    Forms.textField(email),
                    const SizedBox(height: 10),
                    TextStyling.textFieldTitle("Mot de passe"),
                    SizedBox(
                      height: 50,
                      child: Forms.textField(
                        passwordController,
                        IconButton(
                            onPressed: () {
                              setState(() {
                                obscur = !obscur;
                              });
                            },
                            icon: Icon(
                                obscur
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white)),
                        obscur,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text('Mot de passe oublié ?',
                            style: GoogleFonts.openSans(
                                color: const Color(0xFFB8B8D2), fontSize: 15)),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 30),
                    Buttons.customButton(
                      "Se connecter",
                      200,
                      () {
                        setState(() {
                          sigin();
                        });
                      },
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: Text('Vous n\'avez pas de compte ? ',
                          style: GoogleFonts.openSans(
                              fontSize: 14, color: const Color(0xFFB8B8D2))),
                    ),
                    TextButton(
                        child: Text("Créer un compte",
                            style: GoogleFonts.openSans(
                                color: buttonPrimaryColor, fontSize: 14)),
                        onPressed: () => MyFunction.onChangePage(
                            context, const SignUpPage())),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
