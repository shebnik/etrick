import 'package:etrick/constants.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var logoSize = width * 0.5;
    return Column(
      children: [
        Image.asset(
          Constants.logoAssetPath,
          width: logoSize,
          height: logoSize,
        ),
        const SizedBox(height: 16),
        Text(
          'eTRICK',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: logoSize * 0.2,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
