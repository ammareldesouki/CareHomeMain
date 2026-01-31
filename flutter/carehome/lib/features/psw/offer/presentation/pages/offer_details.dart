import 'package:carehome/core/models/care_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfferDetails extends StatelessWidget {
  final CareHomeData careHomeData;

  const OfferDetails({super.key, required this.careHomeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          careHomeData.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text("Care Home "),
            Text(careHomeData.name),
            Text(careHomeData.branch),
          ],
        ),
      ),
    );
  }
}
