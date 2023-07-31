import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaz_app/model/commande.dart';
import 'package:gaz_app/model/livraison.dart';
import 'package:gaz_app/pages/intrerpage/OrderDetailsPage.dart';

class MesCommande extends StatefulWidget {
  const MesCommande({super.key});

  @override
  State<MesCommande> createState() => _MesCommandeState();
}

class _MesCommandeState extends State<MesCommande> {
  List<Livraison> livraison = [];
  String? uidf;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future getLivreur() async {
    try {
      setState(() {
        uidf = auth.currentUser!.uid;
      });
      print(uidf);
      var collection = await FirebaseFirestore.instance
          .collection('livraison')
          .where('userfangre', isEqualTo: uidf)
          .get();
      collection.docs.forEach((element) {
        Timestamp time = element.data()['datecreation'] as Timestamp;
        DateTime date = time.toDate();
        Livraison cmd = Livraison(
          datecreation: new DateTime(
              date.year, date.month, date.day, date.hour, date.minute, 0, 0),
          etat: element.data()['etat'],
          id: element.id,
          detailPosition: element.data()['detailposition'],
          description: element.data()['description'],
          livreurId: element.data()['livreur'],
          userfangreId: element.data()['userfangre'],
          montant: element.data()['montant'],
          lat: element.data()['lat'],
          lng: element.data()['lng'],
          quartier: element.data()['quartier'],
          ville: element.data()['ville'],
        );
        setState(() {
          livraison.add(cmd);
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
      appBar: AppBar(
        title: Text('Livraisons'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: livraison.length,
        itemBuilder: (context, index) {
          Livraison comm = livraison[index];
          return ListTile(
            title: Text('Mes livraisons'),
            subtitle: Text(
                'Date: ${comm.datecreation} \nMontant: ${comm.montant.toString()} Fcfa'),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: comm.etat ? Colors.green : Colors.red,
              ),
              onPressed: () {
                // Naviguer vers la page de détails de la commande
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => OrderDetailsPage(commande: comm),
                //   ),
                // );
              },
              child: Text('ETAT'),
            ),
          );
        },
      ),
    );
  }
}
