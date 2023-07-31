import 'package:flutter/material.dart';
import 'package:gaz_app/model/commande.dart';

class OrderDetailsPage extends StatefulWidget {
  final Commande commande;
  OrderDetailsPage({required this.commande});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la commande'),
        centerTitle: true,
        backgroundColor: widget.commande.etat ? Colors.green : Colors.red,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Commande ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                  'Date: ${widget.commande.creationDate.year}-${widget.commande.creationDate.month}-${widget.commande.creationDate.day} ${widget.commande.creationDate.hour}h${widget.commande.creationDate.minute}',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Montant total: ${widget.commande.prix} Fcfa',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text(widget.commande.etat == true ? 'Déja effectué' : "En cour",
                  style: TextStyle(fontSize: 18)),
              // Ajoutez d'autres détails de la commande ici
            ],
          ),
        ),
      ),
    );
  }
}
