import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gaz_app/functions.dart';
import 'package:gaz_app/model/marque.model.dart';
import 'package:gaz_app/pages/intrerpage/gazliste.dart';

class MarqueListe extends StatefulWidget {
  const MarqueListe({super.key});

  @override
  State<MarqueListe> createState() => _MarqueListeState();
}

class _MarqueListeState extends State<MarqueListe> {
  List<Marque> marques = [];
  Future getMarqueListe() async {
    try {
      ///////////
      final collection =
          await FirebaseFirestore.instance.collection('marque').get();
      collection.docs.forEach((data) {
        Marque marque =
            Marque(id: data.id, marque: data['marque'], image: data['image']);
        setState(() {
          marques.add(marque);
        });
      });
    } catch (e) {
      print('pas de donnees sur les marques $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getMarqueListe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Liste des marques'),
          centerTitle: true,
        ),
        body: GridView.builder(
            primary: false,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20),
            itemCount: marques.length,
            itemBuilder: (context, index) {
              Marque mark = marques[index];
              return InkWell(
                onTap: () {
                  MyFunction.onChangePage(
                      context,
                      GazListe(
                        marque: mark,
                      ));
                },
                child: Card(
                  child: Column(
                    children: [
                      Image.network(
                        mark.image,
                        width: 100,
                        height: 100,
                      ),
                      Text(mark.marque),
                    ],
                  ),
                ),
              );
            }));
  }
}
