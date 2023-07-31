import 'package:flutter/material.dart';
import 'package:gaz_app/login/login_page.dart';
import 'package:gaz_app/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../components/buttons.dart';
import '../components/forms.dart';
import '../components/num_pad.dart';
import '../constants.dart';
import '../functions.dart';

class AuthentificationPage extends StatefulWidget {
  final String phoneNumber;
  const AuthentificationPage({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  State<AuthentificationPage> createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<AuthentificationPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  bool launchVerify = false;
  String? verificationCode, pinCode;

  @override
  void initState() {
    setState(() {
      phoneController.text = widget.phoneNumber;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: ListView(
          //mainAxisAlignment: MainAxisAlignment.end,
          children: [
            !launchVerify ? _numberContainer() : _optContainer(),
            Container(
              color: containerSecondColor,
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width,
              child: NumPad(
                delete: () {
                  setState(() {});
                  if (launchVerify && pinController.text.isNotEmpty) {
                    pinController.text = pinController.text
                        .toString()
                        .substring(0, pinController.text.toString().length - 1);
                  }
                  if (!launchVerify && phoneController.text.isNotEmpty) {
                    phoneController.text = phoneController.text
                        .toString()
                        .substring(
                            0, phoneController.text.toString().length - 1);
                  }
                },
                onSubmit: () {},
                controller: launchVerify ? pinController : phoneController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberContainer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 25),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                Text(
                  'Authentification',
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Image.asset('assets/imgs/phone_auth.png'),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: const BoxDecoration(
              color: containerSecondColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Vérifiez votre numéro de téléphone',
                  style: GoogleFonts.openSans(
                      color: const Color(0xFFB8B8D2), fontSize: 14),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 80,
                        child: Forms.phoneField(phoneController,
                            const SizedBox.shrink(), TextInputType.none),
                      ),
                      Positioned(
                          right: 0,
                          bottom: 20,
                          child: Buttons.customButton(
                            'Continuer',
                            130,
                            () async {
                              setState(() {
                                launchVerify = true;
                              });
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _optContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: containerSecondColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 25),
                    onPressed: () {
                      setState(() {
                        launchVerify = false;
                      });
                    }),
                Text(
                  'Vérification',
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Un code de vérification a été envoyé sur ce numéro : +226 ${phoneController.text}',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                color: const Color(0xFFB8B8D2),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 50),
          Pinput(
            controller: pinController,
            androidSmsAutofillMethod:
                AndroidSmsAutofillMethod.smsUserConsentApi,
            listenForMultipleSmsOnAndroid: true,
            /*validator: (value) {
              return value == '2222' ? null : 'Pin is incorrect';
            },*/

            length: 6,
            defaultPinTheme: PinTheme(
              width: 50,
              height: 50,
              textStyle: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: backgroundColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.none,
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            onCompleted: (pin) {
              setState(() {
                pinCode = pin;
              });
            },
            onChanged: (value) {},
          ),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Vous n\'avez pas reçu le code? ',
                style: GoogleFonts.openSans(color: const Color(0xFFB8BBD2))),
            Text('Réessayez',
                style: GoogleFonts.openSans(color: const Color(0xFF3D5CFF)))
          ]),
          const SizedBox(height: 50),
          Buttons.customButton(
            'Vérifier & Continuer',
            300,
            () {
              MyFunction.onChangePage(context, const Verification());
              /*try {
                FirebaseAuth.instance
                    .signInWithCredential(PhoneAuthProvider.credential(
                        verificationId: verificationCode!, smsCode: pinCode!))
                    .then((value) async {
                  if (value.user != null) {
                    
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('invalid OTP')));
                  }
                });
              } catch (e) {
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('invalid OTP')));
              }*/
            },
          ),
        ],
      ),
    );
  }
}

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: containerSecondColor,
            borderRadius: BorderRadius.circular(15),
          ),
          width: MediaQuery.of(context).size.width / 1.7,
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/imgs/valid.png'),
              const SizedBox(height: 20),
              Text('Vérification terminée',
                  style: GoogleFonts.openSans(color: Colors.white)),
              const SizedBox(height: 20),
              Buttons.customButton(
                "Continuer",
                220,
                () {
                  MyFunction.onChangePage(context, const LoginPage());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
