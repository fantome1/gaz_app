import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gaz_app/functions.dart';
import 'package:gaz_app/model/gaz.dart';
import 'package:gaz_app/model/marque.model.dart';
import 'package:gaz_app/pages/intrerpage/vendeur.dart';

class GazListe extends StatefulWidget {
  Marque marque;
  GazListe({required this.marque});

  @override
  State<GazListe> createState() => _GazListeState();
}

class _GazListeState extends State<GazListe> {
  List<Gaz> gaz = [];
  Future getLivreur() async {
    try {
      var collection = await FirebaseFirestore.instance
          .collection('gaz')
          .where('marque', isEqualTo: widget.marque.id)
          .get();
      collection.docs.forEach((element) {
        Gaz gazzo = new Gaz(
            id: element.id,
            image: element.data()['image'],
            marque: element.data()['poid'],
            poid: element.data()['marque'],
            prix: element.data()['prix']);
        setState(() {
          gaz.add(gazzo);
        });
        print(element.id);
      });
    } catch (e) {
      print("get gaz erreur");
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
        title: Text(widget.marque.marque),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: gaz.length,
          itemBuilder: (context, Index) {
            Gaz butane = gaz[Index];
            return Container(
              margin: EdgeInsets.all(13),
              height: MediaQuery.of(context).size.height / 8,
              child: InkWell(
                onTap: () {
                  MyFunction.onChangePage(
                      context,
                      GasSellersPage(
                        mongaz: butane,
                      ));
                },
                child: Card(
                  child: Row(
                    children: [
                      Image.network(
                        butane.image,
                        width: 100,
                        height: 100,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 60,
                        child: ListTile(
                          title: Text(butane.marque),
                          subtitle: Text(widget.marque.marque),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: Text("${butane.prix} FCFA"),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
