import 'package:flutter/material.dart';
import 'package:gaz_app/constants.dart';
import 'package:gaz_app/model/profil.dart';
import 'package:gaz_app/pages/accueil.dart';
import 'package:gaz_app/pages/historique.dart';
import 'package:gaz_app/pages/livreur.dart';
import 'package:gaz_app/pages/profil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  ProfilModel utilisateur;
  HomePage({super.key, required this.utilisateur});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Position? _currentPosition;

  void _onMenuIndexTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var usi = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      PROFIL = widget.utilisateur;
    });
    try {
      _getCurrentLocation();
    } catch (e) {
      print('erruer de lancemnt');
    }
  }

  final List<Widget> _widgetOptions = <Widget>[
    Accueil(
      profilModel: PROFIL,
    ),
    DeliveryRequestPage(),
    Container(
      child: OrderHistoryPage(),
    ),
    Container(
      child: ProfilePage(
        profil: PROFIL,
      ),
    ),
  ];
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifiez si les services de localisation sont activés
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Service de localisation désactivé'),
            content: const Text(
                'Veuillez activer le service de localisation pour continuer.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Vérifiez si l'application a l'autorisation de la localisation
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Autorisation de localisation refusée'),
              content: const Text(
                  'Veuillez autoriser l\'accès à la localisation pour continuer.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
    }

    // Obtenir la position actuelle
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      PROFIL.lat = position.latitude;
      PROFIL.lng = position.longitude;
    });

    print('Latitude: ${position.latitude}');
    print('Longitude: ${position.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("MENU PRINCIPAL"),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                height: 120,
                color: Colors.blue, // Couleur d'arrière-plan du haut du drawer
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.utilisateur.email.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Fermer le drawer
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Accueil'),
                onTap: () {
                  // Action à effectuer lorsque l'élément du drawer est cliqué
                  // Par exemple, naviguer vers une autre page
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Paramètres'),
                onTap: () {
                  // Action à effectuer lorsque l'élément du drawer est cliqué
                  // Par exemple, naviguer vers une autre page
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Déconnexion'),
                onTap: () {
                  // Action à effectuer lorsque l'élément du drawer est cliqué
                  // Par exemple, déconnecter l'utilisateur
                },
              ),
            ],
          ),
        ),
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedItemColor: buttonPrimaryColor,
          unselectedLabelStyle: GoogleFonts.openSans(
            color: Colors.grey,
            fontSize: 12,
          ),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.openSans(),
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Gaz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_gas_station_outlined),
              label: 'Livreur',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.history_outlined), label: 'Historiques'),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onMenuIndexTapped,
        ));
  }
}


/**
 * Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[400]!,
              hoverColor: Colors.grey[200]!,
              gap: 5,
              activeColor: buttonPrimaryColor,
              iconSize: 18,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black54,
              textStyle: GoogleFonts.openSans(color: buttonPrimaryColor),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  iconSize: 22,
                  text: 'Accueil',
                ),
                GButton(
                  icon: Icons.local_gas_station_outlined,
                  iconSize: 22,
                  text: 'Gaz',
                ),
                GButton(
                  icon: Icons.history_rounded,
                  iconSize: 22,
                  text: 'Historiques',
                ),
                GButton(
                  icon: Icons.discount_outlined,
                  iconSize: 22,
                  text: 'Promo',
                ),
                GButton(
                  icon: Icons.person_4_rounded,
                  iconSize: 22,
                  text: 'Profil',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
 */