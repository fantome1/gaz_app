class Marque {
  String id;
  String marque;
  String image;

  Marque({required this.id, required this.marque, required this.image});

  Marque.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        marque = json['marque'],
        image = json['image'];
}
