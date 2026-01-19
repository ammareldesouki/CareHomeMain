
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/data/fakedata.dart' as AppFakeData;

import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/map_sample.dart';

class HomeHeader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  return          Container(
    height: MediaQuery.of(context).size.height * 0.2,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      ),
      color: TColors.primary,
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Row(
            spacing: 15,
            children: [
              InkWell(
                child: Text("Map"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(carehomeList: AppFakeData.CareHomeDatasFakeData,),
                    ),
                  );
                },
              ),

              Text("Sort"),
            ],
          ),

          SizedBox(height: 20),
        ],
      ),
    ),
  );

  }
}