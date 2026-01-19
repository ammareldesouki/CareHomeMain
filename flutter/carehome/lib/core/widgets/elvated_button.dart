
import 'package:flutter/material.dart';

class TElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const TElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(

        onPressed: onPressed,
        child: Text(text,style: Theme.of(context).textTheme!.bodyMedium,),
      ),
    );
  }
}
