import 'package:flutter/material.dart';

class LivraisonFormPopup extends StatefulWidget {
  @override
  _LivraisonFormPopupState createState() => _LivraisonFormPopupState();
}

class _LivraisonFormPopupState extends State<LivraisonFormPopup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _livreurIdController = TextEditingController();
  TextEditingController _montantController = TextEditingController();
  TextEditingController _userfangreIdController = TextEditingController();
  TextEditingController _etatController = TextEditingController();
  TextEditingController _villeController = TextEditingController();
  TextEditingController _quartierController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _detailPositionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Formulaire de livraison'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _livreurIdController,
              decoration: InputDecoration(labelText: 'ID du livreur'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir l\'ID du livreur';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _montantController,
              decoration: InputDecoration(labelText: 'Montant'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir le montant';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _userfangreIdController,
              decoration: InputDecoration(labelText: 'ID de l\'utilisateur'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir l\'ID de l\'utilisateur';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _etatController,
              decoration: InputDecoration(labelText: 'État'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir l\'état';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _villeController,
              decoration: InputDecoration(labelText: 'Ville'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir la ville';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _quartierController,
              decoration: InputDecoration(labelText: 'Quartier'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir le quartier';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir la description';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _detailPositionController,
              decoration: InputDecoration(labelText: 'Détail de position'),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Créez ici votre objet Livraison avec les données saisies
              // par l'utilisateur à partir des contrôleurs de texte
              Navigator.of(context).pop();
            }
          },
          child: Text('Enregistrer'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annuler'),
        ),
      ],
    );
  }
}

// Utilisation du popup dans un écran
class MonLivreur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon écran'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LivraisonFormPopup();
              },
            );
          },
          child: Text('Ouvrir le formulaire'),
        ),
      ),
    );
  }
}
