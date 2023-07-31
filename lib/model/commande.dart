import 'package:gaz_app/model/gazseller.dart';
import 'package:gaz_app/model/livreur.dart';
import 'package:gaz_app/model/profil.dart';

class Commande {
  String id;
  String idcommercant;
  String iduser;
  String idlivreur;
  String idGaz;
  int prix;
  bool etat;
  DateTime creationDate;

  Commande({
    required this.id,
    required this.idcommercant,
    required this.iduser,
    required this.idlivreur,
    required this.idGaz,
    required this.prix,
    required this.etat,
    required this.creationDate,
  });

  Commande.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idcommercant = json['commercant'],
        idGaz = json['gaz'],
        iduser = json['userfangre'],
        idlivreur = json['livreur '],
        prix = json['prix'],
        creationDate = json['datecreation'],
        etat = json['etat'];
  Map<String, dynamic> toJson() {
    return {
      "commercant": idcommercant,
      "userfangre": iduser,
      "gaz": idGaz,
      "livreur": idlivreur,
      "prix": prix,
      "etat": etat,
      "datecreation": creationDate
    };
  }
}
