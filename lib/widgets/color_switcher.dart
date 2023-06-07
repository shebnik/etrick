import 'package:etrick/app_theme.dart';
import 'package:etrick/services/utils.dart';
import 'package:flutter/material.dart';

class ColorSwitcher extends StatefulWidget {
  final String color;
  final bool isSelected;
  final Function(String color) onColorSelected;

  const ColorSwitcher({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onColorSelected,
  });

  @override
  State<ColorSwitcher> createState() => _ColorSwitcherState();
}

class _ColorSwitcherState extends State<ColorSwitcher> {
  late bool isSelected;

  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  @override
  void didUpdateWidget(ColorSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      setState(() {
        isSelected = widget.isSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onColorSelected(widget.color),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Utils.getColorFromText(widget.color),
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Text(
                  Utils.capitalize(widget.color),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}