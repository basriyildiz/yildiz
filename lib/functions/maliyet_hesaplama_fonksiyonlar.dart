import 'package:flutter/material.dart';

void listeDegistirme(
    int i, TextEditingController controller, List<double> liste) {
  if (double.parse(controller.text) > 0) {
    var _index = liste.lastIndexOf(liste[i]);
    liste.replaceRange(_index, _index + 1, [double.parse(controller.text)]);
  }
}

   nullCheck(element) {
    if (element.text > 0) {
      return double.parse(element.text);
    } else {
      return 0;
    }
  }

  bosMalzemeAdiKontrolcusu(e) {
    if (e.text.toString().length > 0) {
      return e.text;
    } else {
      return "";
    }
  }