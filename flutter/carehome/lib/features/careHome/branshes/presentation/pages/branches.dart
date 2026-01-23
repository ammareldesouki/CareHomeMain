import 'package:carehome/features/careHome/branshes/presentation/widgets/add_branch_form.dart';
import 'package:carehome/features/careHome/branshes/presentation/widgets/branch_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Branches extends StatelessWidget {
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
                    "Branches",
                    style: Theme.of(context).textTheme!.titleLarge,
                  ),

                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const AddBranchForm(),
                      );
                    },
                    child: Row(children: [Icon(Icons.add), Text("Add Branch")]),
                  ),
                ],
              ),

              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: 20,
                  shrinkWrap: true,

                  itemBuilder: (context, index) {
                    return BranchCard();
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
