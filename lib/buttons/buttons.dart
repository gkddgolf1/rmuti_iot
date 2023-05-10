import 'package:flutter/material.dart';

// ปุ่มกด Submit
Widget elevatedButton({
  required String text,
  VoidCallback? onPressed,
  required List<Color> colors,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(0.0),
      elevation: 0.0,
    ),
    onPressed: onPressed,
    child: Ink(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 100.0, minHeight: 40.0),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}

// ปุ่มโชว์หัวข้อ
Widget roundedButton({
  required String title,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 32,
    ),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
      //border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
