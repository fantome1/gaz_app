import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaz_app/controller/fontion.dart';
import 'package:gaz_app/functions.dart';
import 'package:gaz_app/model/commande.dart';
import 'package:gaz_app/model/profil.dart';
import 'package:gaz_app/pages/historique.dart';
import 'package:gaz_app/pages/intrerpage/gazliste.dart';
import 'package:gaz_app/pages/intrerpage/vendeur.dart';
import 'package:gaz_app/pages/livreur.dart';
import 'package:gaz_app/pages/marque.dart';
import 'package:gaz_app/pages/mescmd.dart';

class Accueil extends StatefulWidget {
  ProfilModel profilModel;
  Accueil({required this.profilModel});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: [
          MenuItem(
            image: 'assets/imgs/gaz.png',
            title: 'Gaz',
            onPressed: () {
              MyFunction.onChangePage(context, MarqueListe());
              //_showMyDialog(context);
              // Action pour l'option "Nouvelle commande"
            },
          ),
          MenuItem(
            image: 'assets/imgs/livreur.png',
            title: 'Livreurs',
            onPressed: () {
              MyFunction.onChangePage(context, DeliveryRequestPage());

              //  Action pour l'option "Historique des commandes"
            },
          ),
          MenuItem(
            image: 'assets/imgs/encour.jpg',
            title: 'Mes commandes',
            onPressed: () {
              // Action pour l'option "Profil"MesCommande
              MyFunction.onChangePage(context, MesCommande());
            },
          ),
          MenuItem(
            image: 'assets/imgs/historique.png',
            title: 'Historique',
            onPressed: () {
              //_showMyDialog(context);
              MyFunction.onChangePage(context, OrderHistoryPage());
              // Action pour l'option "Déconnexion"
            },
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onPressed;

  const MenuItem({
    required this.image,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 50,
              height: 50,
            ),
            SizedBox(height: 8.0),
            Text(title, style: TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}
