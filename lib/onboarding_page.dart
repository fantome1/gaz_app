import 'package:flutter/material.dart';
import 'package:gaz_app/login/signup_page.dart';
import 'package:gaz_app/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'constants.dart';
import 'login/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context, Widget page) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: ((context, animation, secondaryAnimation) {
            return LoginPage();
          }),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/imgs/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    final pageDecoration = PageDecoration(
        titleTextStyle: GoogleFonts.openSans(
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFEAEAFF)),
        bodyTextStyle:
            GoogleFonts.openSans(fontSize: 15.0, color: Colors.white70),
        bodyPadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        pageColor: backgroundColor,
        imagePadding: const EdgeInsets.only(top: 50),
        imageAlignment: Alignment.center,
        bodyFlex: 3,
        imageFlex: 4,
        safeArea: 100);

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: backgroundColor,
      allowImplicitScrolling: true,
      autoScrollDuration: 5000,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(top: 16, right: 16),
          child: TextButton(
              child:
                  const Text('Passer', style: TextStyle(color: Colors.white)),
              onPressed: () {
                introKey.currentState?.animateScroll(2);
              }),
        )),
      ),
      pages: [
        PageViewModel(
          title: "Bienvenue dans notre application",
          body: "Découvrez les fonctionnalités incroyables que nous offrons",
          image: _buildImage('img2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Facile à utiliser",
          body:
              "Notre application est conçue pour être conviviale et intuitive",
          image: _buildImage('img1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
            title: "Commandez en ligne",
            body:
                "Commandez facilement des bouteiles de gaz depuis votre smartphone",
            image: _buildImage('img3.png'),
            decoration: pageDecoration,
            footer: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _onIntroEnd(context, const SignUpPage()),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      fixedSize: const Size(180, 60),
                      backgroundColor: buttonPrimaryColor,
                      elevation: 2,
                    ),
                    child: Text("S'inscrire",
                        style: GoogleFonts.openSans(
                            fontSize: 14, color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () => _onIntroEnd(context, const LoginPage()),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      fixedSize: const Size(180, 60),
                      backgroundColor: buttonSecondColor,
                      elevation: 2,
                    ),
                    child: Text("Se connecter",
                        style: GoogleFonts.openSans(
                            fontSize: 14, color: Colors.white)),
                  ),
                ],
              ),
            )),
      ],
      onDone: () => _onIntroEnd(context, Scaffold()),
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      back: const Icon(Icons.arrow_back),
      skip: const Text('Passer', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Continuer',
          style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
