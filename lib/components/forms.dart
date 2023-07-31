import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Forms {
  static Widget textField(TextEditingController controller,
      [Widget? suffix, bool? obscur = false, readOnly = false]) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        /*validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Champs obligatoire';
          }
          return null;
        },*/
        controller: controller,
        obscureText: obscur!,
        readOnly: readOnly,
        style: GoogleFonts.openSans(fontSize: 16, color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF3E3E55),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF3E3E55)),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(15),
          suffix: suffix,
        ),
      ),
    );
  }

  static Widget phoneField(TextEditingController controller,
      [Widget? suffix, TextInputType input = TextInputType.phone]) {
    return SizedBox(
      child: IntlPhoneField(
        style: GoogleFonts.openSans(fontSize: 16, color: Colors.white),
        showCursor: true,
        cursorColor: Colors.white,
        invalidNumberMessage: 'Numbre de chiffre incorrect',
        keyboardType: input,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          filled: true,
          fillColor: const Color(0xFF3E3E55),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF3E3E55)),
            borderRadius: BorderRadius.circular(10),
          ),
          suffix: suffix ?? const SizedBox.shrink(),
        ),
        initialCountryCode: 'BF',
        textAlignVertical: TextAlignVertical.center,
        flagsButtonMargin: const EdgeInsets.only(bottom: 2),
        disableLengthCheck: false,
        dropdownTextStyle:
            GoogleFonts.openSans(fontSize: 16, color: Colors.white),
        dropdownIcon:
            const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF72ada9)),
        dropdownIconPosition: IconPosition.trailing,
        flagsButtonPadding: const EdgeInsets.only(left: 10),
        /*onChanged: (value) {
          controller.text = value.countryCode + " " + value.number;
        },*/
        controller: controller,
      ),
    );
  }

  static Widget dropDownField(
      TextEditingController controller, List<String> items) {
    return Forms.textField(
      controller,
      PopupMenuButton<dynamic>(
        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        onSelected: (dynamic value) {
          controller.text = value;
        },
        itemBuilder: (BuildContext context) {
          return items.map<PopupMenuItem<dynamic>>((dynamic value) {
            return PopupMenuItem(child: Text(value), value: value);
          }).toList();
        },
      ),
      false,
      true,
    );
  }
}
