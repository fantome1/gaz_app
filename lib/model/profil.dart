class ProfilModel {
  int id;
  String email;
  String address;
  String password;
  String numero;
  double lng;
  double lat;
  int solde;
  String uid;

  ProfilModel({
    required this.id,
    required this.email,
    required this.address,
    required this.numero,
    required this.password,
    required this.lng,
    required this.lat,
    required this.solde,
    required this.uid,
  });

  ProfilModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        address = json['password'],
        numero = json['numero'],
        lng = double.parse(json['lng']),
        lat = double.parse(json['lat']),
        password = json['password'],
        solde = int.parse(json['solde']),
        uid = json['uid'];

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'numero': numero,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'adresse': address,
      'solde': solde.toString(),
      'uid': uid.toString(),
    };
  }
}

ProfilModel PROFIL = ProfilModel(
  id: 1,
  address: '1200 logement',
  email: 'nass@gmail.com',
  numero: '55472856',
  solde: 0,
  lat: 000,
  lng: 00,
  password: '1234',
  uid: '1234',
);
