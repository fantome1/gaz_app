class Livraison {
  String id;
  String livreurId;
  int montant;
  String userfangreId;
  bool etat;
  String ville;
  String quartier;
  String description;
  String detailPosition;
  DateTime datecreation;
  double lat;
  double lng;

  Livraison({
    required this.id,
    required this.livreurId,
    required this.montant,
    required this.userfangreId,
    required this.etat,
    required this.ville,
    required this.quartier,
    required this.description,
    required this.detailPosition,
    required this.lat,
    required this.lng,
    required this.datecreation,
  });

  factory Livraison.fromJson(Map<String, dynamic> json) {
    return Livraison(
      id: json['id'],
      livreurId: json['livreur_id'],
      montant: json['montant'],
      userfangreId: json['userfangre_id'],
      etat: json['etat'],
      ville: json['ville'],
      quartier: json['quartier'],
      description: json['description'],
      detailPosition: json['detailposition'],
      lat: json['lat'],
      lng: json['lng'],
      datecreation: json['datecreation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'livreur': livreurId,
      'montant': montant,
      'userfangre': userfangreId,
      'etat': etat,
      'ville': ville,
      'quartier': quartier,
      'description': description,
      'detailposition': detailPosition,
      'lat': lat,
      'lng': lng,
      'datecreation': datecreation,
    };
  }
}
