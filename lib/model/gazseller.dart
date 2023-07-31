class GazVender {
  String? id;
  String? nomprenom;
  String? numero;
  String? adresse;

  double lat;
  double lng;
  String? codepromo;
  bool etat;

  GazVender(
      {required this.id,
      required this.nomprenom,
      required this.numero,
      required this.adresse,
      required this.lat,
      required this.lng,
      required this.codepromo,
      required this.etat});
  GazVender.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nomprenom = json['nomprenom'],
        numero = json['numero'],
        lat = json['lat'],
        lng = json['lng'],
        codepromo = json['codepromo'],
        etat = json['etat'];
}
