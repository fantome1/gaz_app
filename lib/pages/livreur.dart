import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaz_app/controller/fontion.dart';
import 'package:gaz_app/model/livraison.dart';
import 'package:gaz_app/model/livreur.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: use_key_in_widget_constructors
class DeliveryRequestPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _DeliveryRequestPageState createState() => _DeliveryRequestPageState();
}

class _DeliveryRequestPageState extends State<DeliveryRequestPage> {
  final _livreur = FirebaseFirestore.instance
      .collection('livreur')
      .where('disponibilite', isEqualTo: true)
      .snapshots();
  late FirebaseAuth auth;
  List<Livreur> livreurs = [];
  List<double> idList = [];
  Future creatCommande() async {}
  final _formKey = GlobalKey<FormState>();
  TextEditingController _livreurIdController = TextEditingController();
  TextEditingController _montantController = TextEditingController();
  TextEditingController _userfangreIdController = TextEditingController();
  TextEditingController _etatController = TextEditingController();
  TextEditingController _villeController = TextEditingController();
  TextEditingController _quartierController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _detailPositionController = TextEditingController();
  void openGoogleMaps(double latitude, double longitude) async {
    final url2 =
        'https://www.openstreetmap.org/?mlat=$latitude&mlon=$longitude#map=15/$latitude/$longitude';
    final url = 'https://maps.google.com/?q=$latitude,$longitude';

    await launch(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not open Google Maps.');
    }
  }

  String adresse = "";
  Position currentPosition = Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  @override
  void initState() {
    super.initState();
    _getDistannceProche();
    auth = FirebaseAuth.instance;
  }

  Future getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = position;
      });
      return position;
    } catch (e) {
      print('Error getting current location: $e');
    }
    return null;
  }

  _getDistannceProche() async {
    try {
      var com = await FirebaseFirestore.instance
          .collection('livreur')
          .where('disponibilite', isEqualTo: true)
          .get();

      getCurrentLocation().then((e) {
        for (var element in com.docs) {
          idList.add(calculateDistance(element['lat'], element['lng'],
              currentPosition!.latitude, currentPosition!.longitude));
          print(element.id);
        }
        idList.sort();
        print(idList);
      });
    } catch (e) {
      print('no data');
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

  Future MaStreet(double lati, longi) async {
    String mydata = "";
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lati, longi);
      Placemark place = placemarks[0];
      setState(() {
        mydata = "${place.street}";
      });
    } catch (e) {
      print("$e erreur de recup de la vie");
    }
    return mydata;
  }

  Future _postLivraison(Livraison livraison) async {
    try {
      var collection = FirebaseFirestore.instance
          .collection('livraison')
          .add(livraison.toJson())
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('livraison effectuée avec succes'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'ok',
            onPressed: () {
              print('oki');
            },
          ),
        ));
        print('donne envoye avec success');
      });
    } catch (e) {
      print("no data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livreurs'),
      ),
      body: StreamBuilder(
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
                    getMyData(monlivreur.lat, monlivreur.lng).then((value) {
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
                      if (monlivreur.etat == true) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _popLivraison(
                                monlivreur,
                                currentPosition!.latitude,
                                currentPosition!.longitude);
                          },
                        );
                      } else {
                        _showMyDialog(context);
                      }
                    },
                    child: ListTile(
                      title: Text(monlivreur.nom!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(monlivreur.adresse == null
                              ? " "
                              : monlivreur.adresse!),
                          Text('Distance: ${distance.toStringAsFixed(2)} km'),
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

  _popLivraison(Livreur livreurId, double lat, lng) {
    Livraison livraison = Livraison(
        livreurId: livreurId.id,
        montant: 1000,
        userfangreId: auth.currentUser!.uid,
        etat: false,
        ville: "Ouagadougou",
        quartier: '',
        description: '',
        detailPosition: '',
        lat: lat,
        lng: lng,
        datecreation: DateTime.now(),
        id: '');
    return AlertDialog(
      title: Text('Formulaire de livraison'),
      content: Flexible(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _villeController,
                decoration: InputDecoration(labelText: 'Ville'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez saisir la ville';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quartierController,
                decoration: InputDecoration(labelText: 'Quartier'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez saisir le quartier';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez saisir la description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _detailPositionController,
                decoration: InputDecoration(labelText: 'Détail de position'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                livraison.quartier = _quartierController.text;
                livraison.ville = _villeController.text;
                livraison.description = _descriptionController.text;
                livraison.detailPosition = _detailPositionController.text;
              });
              Navigator.of(context).pop();
              _postLivraison(livraison);
            }
          },
          child: Text('Enregistrer'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annuler'),
        ),
      ],
    );
  }
}
