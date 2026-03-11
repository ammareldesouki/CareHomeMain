import 'package:flutter/material.dart';

class OnBoardingContainer extends StatelessWidget {
  final int boardingnum;
  final String title;
  final String description;

  const OnBoardingContainer({
    super.key,
    required this.boardingnum,
    required this.title,
    this.description = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/onboarding$boardingnum.png",
                    ),
                  ),
                ),
              ),
            ),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            Text(
              description,
              style: Theme.of(context).textTheme!.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
