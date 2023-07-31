import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaz_app/controller/config.dart';
import 'package:gaz_app/controller/fontion.dart';
import 'package:gaz_app/model/commande.dart';
import 'package:gaz_app/model/gaz.dart';
import 'package:gaz_app/model/gazseller.dart';
import 'package:gaz_app/model/livreur.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class GasSellersPage extends StatefulWidget {
  Gaz mongaz;
  GasSellersPage({required this.mongaz});
  @override
  _GasSellersPageState createState() => _GasSellersPageState();
}

class _GasSellersPageState extends State<GasSellersPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<GazVender> commercant = [];
  List idList = [];
  List<String> listedipos = [];
  final _commercant =
      FirebaseFirestore.instance.collection('commercants').snapshots();
  final _livreur = FirebaseFirestore.instance
      .collection('livreur')
      .where('disponibilite', isEqualTo: true)
      .snapshots();
  final _dipose = FirebaseFirestore.instance.collection('dispose');

  Commande cmd = Commande(
      id: '',
      idcommercant: '',
      iduser: '',
      idlivreur: '',
      idGaz: '',
      prix: 0,
      etat: false,
      creationDate: DateTime.now());

  void openGoogleMaps(double latitude, double longitude) async {
    final url2 =
        'https://www.openstreetmap.org/?mlat=$latitude&mlon=$longitude#map=15/$latitude/$longitude';
    final url = 'https://maps.google.com/?q=$latitude,$longitude';
    await launch(url2);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not open Google Maps.');
    }
  }

  _getMyCommer() async {
    var _commer = await FirebaseFirestore.instance
        .collection('dispose')
        .where('etat', isEqualTo: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element['gaz'] == widget.mongaz.id) {
          setState(() {
            listedipos.add(element['commercant']);
          });
        }
      });
    });
    return listedipos;
  }

  String adresse = "";
  Position? currentPosition;
  Future postCommande(Commande cmd) async {
    try {
      var collection = await FirebaseFirestore.instance.collection('commande');
      collection.add(cmd.toJson());
      return true;
    } catch (e) {
      print('pas de creation de commande $e');
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _getMyCommer();
    cmd.iduser = auth.currentUser!.uid;
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future getMyData(double lati, longi) async {
    String mydata = "";
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lati, longi);
      Placemark place = placemarks[0];
      setState(() {
        mydata = "${place.locality}, ${place.country} , ${place.street}";
      });
    } catch (e) {
      print("$e erreur de recup de la vie");
    }
    return mydata;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendeurs de Gaz'),
      ),
      body: StreamBuilder(
          stream: _commercant,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docu = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docu.length,
                itemBuilder: (context, index) {
                  GazVender gasSeller = new GazVender(
                      id: docu[index].id.toString(),
                      nomprenom: docu[index]['nomprenom'],
                      numero: docu[index]['numero'],
                      adresse: docu[index]['adresse'],
                      lat: docu[index]['lat'],
                      lng: docu[index]['lng'],
                      etat: docu[index]['etat'],
                      codepromo: docu[index]['codepromo']);
                  double distance = 0.0;
                  if (currentPosition != null) {
                    getMyData(gasSeller.lat, gasSeller.lng).then((value) {
                      setState(() {
                        gasSeller.adresse = value;
                      });
                    }).onError((error, stackTrace) {
                      gasSeller.adresse = "";
                    });
                    distance = calculateDistance(
                      currentPosition!.latitude,
                      currentPosition!.longitude,
                      gasSeller.lat,
                      gasSeller.lng,
                    );
                  }

                  return listedipos.contains(gasSeller.id)
                      ? InkWell(
                          onTap: () {
                            if (gasSeller.etat == true) {
                              setState(() {
                                cmd.idcommercant = gasSeller.id!;
                                cmd.idGaz = widget.mongaz.id;
                                cmd.prix = widget.mongaz.prix + 1000;
                              });
                              _showMyDialogpopup(
                                  context, gasSeller.lat, gasSeller.lng);
                            } else {
                              _showMyDialog(context);
                            }
                          },
                          child: ListTile(
                            title: Text(gasSeller.nomprenom!),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(gasSeller.adresse == null
                                    ? " "
                                    : gasSeller.adresse!),
                                Text(
                                    'Distance: ${distance.toStringAsFixed(2)} km'),
                              ],
                            ),
                            trailing: gasSeller.etat
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : Icon(Icons.cancel, color: Colors.red),
                          ),
                        )
                      : null;
                },
              );
            } else {
              return Container();
            }
          }),
    );
  }

  Future<void> _showMyDialogpopup(context, lat, long) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "OPTION",
            textAlign: TextAlign.center,
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Vous faire livre?',
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Se rendre sur place',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Quitter'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('SE FAIRE LIVRER'),
              onPressed: () {
                Navigator.pop(context);
                _listeLiveur(context);
              },
            ),
            TextButton(
              child: const Text("S'Y RENDRE"),
              onPressed: () {
                openGoogleMaps(lat, long);
                //MyFunction.onChangePage(context, GasSellersPage());
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ALERTE',
            textAlign: TextAlign.center,
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'CETTE BOUTIQUE EST FERME',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _listeLiveur(context) async {
    return showDialog<void>(
      context: context,
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Liste des livreurs',
            textAlign: TextAlign.center,
          ),
          content: Container(
            width: 300,
            height: 200,
            child: StreamBuilder(
                stream: _livreur,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var docu = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: docu.length,
                      itemBuilder: (context, index) {
                        Livreur monlivreur = new Livreur(
                            id: docu[index].id,
                            nom: docu[index]['nom'],
                            numero: docu[index]['numero'],
                            adresse: docu[index]['adresse'],
                            lat: docu[index]['lat'],
                            lng: docu[index]['lng'],
                            etat: docu[index]['etat']);
                        double distance = 0.0;
                        if (currentPosition != null) {
                          getMyData(monlivreur.lat, monlivreur.lng)
                              .then((value) {
                            setState(() {
                              monlivreur.adresse = value;
                            });
                          }).onError((error, stackTrace) {
                            monlivreur.adresse = "";
                          });
                          distance = calculateDistance(
                            currentPosition!.latitude,
                            currentPosition!.longitude,
                            monlivreur.lat,
                            monlivreur.lng,
                          );
                        }

                        return InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              cmd.idlivreur = monlivreur.id!;
                              cmd.creationDate = DateTime.now();
                              postCommande(cmd).then((value) {
                                if (value == true) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text('Commande effectué avec succes'),
                                    backgroundColor: Colors.green,
                                    action: SnackBarAction(
                                      label: 'ok',
                                      onPressed: () {
                                        print('oki');
                                      },
                                    ),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('erreur'),
                                    backgroundColor: Colors.red,
                                    action: SnackBarAction(
                                      label: 'ok',
                                      onPressed: () {
                                        print('erruer   ==');
                                      },
                                    ),
                                  ));
                                }
                              });
                            });
                          },
                          child: ListTile(
                            title: Text(monlivreur.nom!),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(monlivreur.adresse == null
                                    ? " "
                                    : monlivreur.adresse!),
                                Text(
                                    'Distance: ${distance.toStringAsFixed(2)} km'),
                              ],
                            ),
                            trailing: monlivreur.etat
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : Icon(Icons.cancel, color: Colors.red),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Quitter'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
