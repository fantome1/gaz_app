import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gaz_app/model/livreur.dart';

class getFireBaseData {
  var fire = FirebaseFirestore.instance;
  late List<Map<String, dynamic>> listeData;

  Future<List<Livreur>> getLivreur() async {
    List<Livreur> livreurs = [];
    var collection = await fire.collection('livreur').get();
    collection.docs.forEach((element) {
      Livreur livreur = new Livreur(
          id: element.id,
          nom: element.data()['nom'],
          numero: element.data()['numero'],
          adresse: element.data()['adresse'],
          lat: element.data()['lat'],
          lng: element.data()['lng'],
          etat: element.data()['etat']);
      livreurs.add(livreur);
      print(element.id);
    });
    return livreurs;
  }
}
