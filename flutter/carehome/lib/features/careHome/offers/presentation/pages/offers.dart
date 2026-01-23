import 'package:carehome/features/careHome/offers/presentation/widgets/add_offer_form.dart';
import 'package:carehome/features/careHome/offers/presentation/widgets/offer_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../branshes/presentation/widgets/branch_card.dart';

class OfferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Offers",
                    style: Theme.of(context).textTheme!.titleLarge,
                  ),

                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const AddOfferForm(),
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.add),
                        SizedBox(width: 4),
                        Text("Add Offer"),
                      ],
                    ),
                  ),
                ],
              ),

              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: 20,
                  shrinkWrap: true,

                  itemBuilder: (context, index) {
                    return OfferCard();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
