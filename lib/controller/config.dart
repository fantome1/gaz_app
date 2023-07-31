import 'dart:convert';
import 'package:http/http.dart' as http;

Future fetchDataFromAPI(String api) async {
  String apiUrl = "http://192.168.1.69:8000/api$api";
  var dataList;
  print(apiUrl);
  try {
    var response = await http.get(Uri.parse(apiUrl));

    var statut = response.statusCode;
    if (statut == 200) {
      dataList = json.decode(response.body);
      return dataList['hydra:member'];
    } else {
      print('Erreur lors de la récupération des données de l\'API.');
      return null;
    }
  } catch (e) {
    print('Erreur lors de la connexion à l\'API : $e');
  }
  return dataList;
}
// 192.168.1.69

Future postData(data, String api) async {
  String apiUrl = "http://192.168.1.69:8000/api$api";
  final headers = {
    "Accept": "application/json",
    "content-type": "application/json"
  }; // En-têtes de la requête

  final jsonBody = jsonEncode(data); // Convertit les données en JSON
  print(apiUrl);
  try {
    print(jsonBody);
    final response =
        await http.post(Uri.parse(apiUrl), headers: headers, body: jsonBody);

    // if (response.statusCode == 201) {
    //   // La requête a réussi
    //   print('Données envoyées avec succès');
    // } else {
    //   // La requête a échoué
    //   print('Erreur lors de l\'envoi des données : ${response.statusCode}');
    // }
  } catch (e) {
    return e;
  }
}
