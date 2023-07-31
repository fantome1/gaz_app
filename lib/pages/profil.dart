import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaz_app/login/login_page.dart';
import 'package:gaz_app/main.dart';
import 'package:gaz_app/model/profil.dart';

class ProfilePage extends StatefulWidget {
  final ProfilModel profil;

  ProfilePage({
    required this.profil,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.profil.id.toString();
    emailController.text = widget.profil.email!;
    addressController.text = widget.profil.address!;
    phoneNumberController.text = widget.profil.numero!;
  }

  void showPaymentPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Paiement'),
          content: Text('Recharger votre compte'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Payer'),
              onPressed: () {
                // Logique pour effectuer le paiement avec CinetPay
                // makePayment();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Mon profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = true;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 64,
                backgroundImage: AssetImage('assets/imgs/img1.png'),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Solde',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  "${widget.profil.solde} Fcfa",
                  style: TextStyle(fontSize: 18),
                ),
                Container(
                    margin: EdgeInsets.only(left: 100),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 4, backgroundColor: Colors.green),
                        onPressed: () {
                          setState(() {
                            widget.profil.solde = widget.profil.solde + 1000;
                            PROFIL.solde = widget.profil.solde;
                          });
                          showPaymentPopup(context);
                        },
                        child: Text('Recharger')))
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Nom:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            isEditing
                ? TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(
                    widget.profil.id.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
            SizedBox(height: 16),
            Text(
              'Email:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            isEditing
                ? TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(
                    widget.profil.email,
                    style: TextStyle(fontSize: 18),
                  ),
            SizedBox(height: 16),
            Text(
              'Adresse:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            isEditing
                ? TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(
                    widget.profil.address,
                    style: TextStyle(fontSize: 18),
                  ),
            SizedBox(height: 16),
            Text(
              'Numéro de téléphone:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            isEditing
                ? TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(
                    widget.profil.numero,
                    style: TextStyle(fontSize: 18),
                  ),
            SizedBox(height: 16),
            if (isEditing)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditing = false;
                    // Sauvegarder les modifications du profil ici
                  });
                },
                child: Text('Enregistrer'),
              ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _signOut();
                  // Sauvegarder les modifications du profil ici
                });
              },
              child: Text('Deconnexion'),
            ),
          ],
        ),
      ),
    );
  }
}
