class Dispose {
  String id;
  String commercant;
  String gaz;
  bool etat;

  Dispose(
      {required this.id,
      required this.commercant,
      required this.gaz,
      required this.etat});

  Dispose.formJson(Map<String, dynamic> json)
      : id = json['id'],
        commercant = json['commercant'],
        gaz = json['gaz'],
        etat = json['etat'];
}
