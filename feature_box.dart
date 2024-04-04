import 'package:flutter/material.dart';
import 'package:voice_assistance/pallete.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headertext;
  final String description;
  const FeatureBox(
      {super.key,
      required this.color,
      required this.headertext,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(left: 15),
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              headertext,
              style: const TextStyle(
                fontFamily: 'Cera Pro',
                color: Pallete.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Cera Pro',
              color: Pallete.blackColor,
            ),
          ),
        ]),
      ),
    );
  }
}
