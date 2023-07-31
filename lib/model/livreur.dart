class Livreur {
  String id;
  String? nom;
  String? numero;
  String? adresse;
  double lat;
  double lng;
  bool etat;
  Livreur(
      {required this.id,
      required this.nom,
      required this.numero,
      required this.adresse,
      required this.lat,
      required this.lng,
      required this.etat});
  Livreur.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nom = json['nom'],
        numero = json['numero'],
        lat = json['lat'],
        lng = json['lng'],
        etat = json['etat'];
}
