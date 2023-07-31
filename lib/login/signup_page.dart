import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gaz_app/controller/config.dart';
import 'package:gaz_app/model/profil.dart';
import 'package:gaz_app/pages/home_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/buttons.dart';
import '../components/forms.dart';
import '../components/textStyling.dart';
import '../constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController civilController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController forenameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool obscur = false, policyChecked = false;
  var data;
  var collection = FirebaseFirestore.instance.collection('userfangre');
  ProfilModel profil = new ProfilModel(
      id: 0,
      email: '',
      address: '',
      numero: '',
      password: '',
      lng: 0,
      lat: 0,
      solde: 0,
      uid: '');
  String mydata = "Burkina Faso, Ouagadougou";
  void createUser(ProfilModel user) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        setState(() {
          data = value;
          user.uid = FirebaseAuth.instance.currentUser!.uid;
          //createUserData(user.toJson());
          collection.add(user.toJson());
        });
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return HomePage(
          utilisateur: user,
        );
      }));
    } catch (e) {
      print("creattion de suer erreur $e");
    }
  }

  Future createUserData(data) async {
    try {
      await postData(data, '/userfangres').then((value) {
        print(value);
      });
    } catch (e) {
      print('base symfony erreur $e');
    }
  }

  Position? currentPosition;
  Future getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = position;
      });
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      setState(() {
        mydata = "${place.locality}, ${place.country} , ${place.street}";
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
    print(mydata);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
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
          resizeToAvoidBottomInset: false,
          backgroundColor: backgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("S'inscrire",
                    style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Text('Entrez vos informations pour vous inscrire',
                    style: GoogleFonts.openSans(
                        color: Colors.white, fontSize: 15)),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: const BoxDecoration(
                    color: containerSecondColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Form(
                    key: formKey,
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        const SizedBox(height: 10),
                        TextStyling.textFieldTitle("Numero de télephone"),
                        Forms.phoneField(forenameController),
                        TextStyling.textFieldTitle("Adresse mail"),
                        Forms.textField(emailController),
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
                        const SizedBox(height: 10),
                        TextStyling.textFieldTitle("Confirmer Mot de passe"),
                        SizedBox(
                          height: 50,
                          child: Forms.textField(
                            confirmController,
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
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                              value: policyChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  policyChecked = value!;
                                });
                              },
                            ),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                    style: GoogleFonts.openSans(
                                      color: const Color(0xFF858597),
                                      fontSize: 15,
                                    ),
                                    children: [
                                      const TextSpan(
                                          text:
                                              'En créant votre compte, vous acceptez nos '),
                                      TextSpan(
                                        text: 'conditions d\'utilisation ',
                                        style: GoogleFonts.openSans(
                                            color: buttonPrimaryColor),
                                      ),
                                      const TextSpan(
                                          text:
                                              'et êtes d\'accord avec notre '),
                                      TextSpan(
                                        text: 'politique de confidentialité',
                                        style: GoogleFonts.openSans(
                                            color: buttonPrimaryColor),
                                      )
                                    ]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Buttons.customButton(
                          "Créer un compte",
                          200,
                          () async {
                            if (policyChecked) {
                              setState(() {
                                profil.email = emailController.text;
                                profil.numero = forenameController.text;
                                profil.lat = currentPosition!.latitude;
                                profil.lng = currentPosition!.longitude;
                                profil.address = mydata;
                                profil.password = passwordController.text;
                                createUser(profil);
                                // createUserData(profil.toJson());
                                //  print(profil.toJson());
                              });
                            }
                          },
                          policyChecked ? true : false,
                        ),
                      ],
                    ),
                  )),
            ],
          )),
    );
  }
}
