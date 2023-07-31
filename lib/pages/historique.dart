import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaz_app/model/commande.dart';
import 'package:gaz_app/pages/intrerpage/OrderDetailsPage.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Commande> commandes = [];
  String? uidf;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future getLivreur() async {
    try {
      setState(() {
        uidf = auth.currentUser!.uid;
      });
      print(uidf);
      var collection = await FirebaseFirestore.instance
          .collection('commande')
          .where('userfangre', isEqualTo: uidf)
          .get();
      collection.docs.forEach((element) {
        Timestamp time = element.data()['datecreation'] as Timestamp;
        DateTime date = time.toDate();
        Commande cmd = Commande(
            creationDate: new DateTime(
                date.year, date.month, date.day, date.hour, date.minute, 0, 0),
            etat: element.data()['etat'],
            id: element.id,
            idGaz: element.data()['gaz'],
            idcommercant: element.data()['commercant'],
            idlivreur: element.data()['livreur'],
            iduser: element.data()['userfangre'],
            prix: element.data()['prix']);
        setState(() {
          commandes.add(cmd);
        });
        print(element.id);
      });
    } catch (e) {
      print("get gaz cmd $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getLivreur();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: commandes.length,
        itemBuilder: (context, index) {
          Commande comm = commandes[index];
          return ListTile(
            title: Text('Commande'),
            subtitle: Text(
                'Date: ${comm.creationDate} - Montant: \$${comm.prix.toString()}'),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: comm.etat ? Colors.green : Colors.red,
              ),
              onPressed: () {
                // Naviguer vers la page de détails de la commande
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsPage(commande: comm),
                  ),
                );
              },
              child: Text('Détails'),
            ),
          );
        },
      ),
    );
  }
}
