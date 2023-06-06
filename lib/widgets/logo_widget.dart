import 'package:etrick/constants.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          Constants.logoAssetPath,
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 20),
        Text(
          'ETRICK',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 64,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
