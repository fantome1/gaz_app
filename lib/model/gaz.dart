class Gaz {
  String id;
  String image;
  String marque;
  String poid;
  int prix;

  Gaz(
      {required this.id,
      required this.image,
      required this.marque,
      required this.poid,
      required this.prix});
  Gaz.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['image'],
        marque = json['marque'],
        poid = json['poid'],
        prix = json['prix'];
}
