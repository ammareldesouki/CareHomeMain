import 'package:carehome/core/data/fakedata.dart';
import 'package:carehome/features/home/presentation/widgets/home_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../../../core/data/fakedata.dart' as AppFakeData;
import '../widgets/care_home_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: 16,
        children: [
         HomeHeader(),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: AppFakeData.CareHomeDatasFakeData.length,

              itemBuilder: (context, index) {
                return CareHomeCard(careHomeData: AppFakeData.CareHomeDatasFakeData[index]);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 10),
            ),
          ),
        ],
      ),
    );
  }
}

