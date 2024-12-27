import 'package:flutter/material.dart';

class ColorSelectionWidget extends StatefulWidget {
  final List<String> availableColors;
  final Function(String) onColorSelected;

  const ColorSelectionWidget({
    Key? key,
    required this.availableColors,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  _ColorSelectionWidgetState createState() => _ColorSelectionWidgetState();
}

class _ColorSelectionWidgetState extends State<ColorSelectionWidget> {
  String selectedColor = '';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.only(right: 5, left: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(
              color: Colors.orange,
              width: 1
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: widget.availableColors.map((colorName) {
              return ColorItemWidget(
                colorName: colorName,
                isSelected: selectedColor == colorName,
                onColorSelected: () {
                  setState(() {
                    selectedColor = colorName;
                  });
                  widget.onColorSelected(colorName);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ColorItemWidget extends StatelessWidget {
  final String colorName;
  final bool isSelected;
  final VoidCallback onColorSelected;

  const ColorItemWidget({
    Key? key,
    required this.colorName,
    required this.isSelected,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? color = _getColorFromName(colorName);
    bool isWhite = color == Colors.white;

    return GestureDetector(
      onTap: onColorSelected,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Container(
          width: 15,
          height: 15,
          margin: EdgeInsets.only(right: 4, left: 4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isWhite ? Border.all(color: Colors.grey, width: 1.0) : null,
          ),
          child: isSelected
              ? Icon(
            Icons.done,
            color: colorName == 'White' ? Colors.black : Colors.white,
            size: 12,
          )
              : null,
        ),
      ),
    );
  }
}

Color? _getColorFromName(String colorName) {
  Map<String, Color> colorMap = {
    'Red': Colors.red,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'White': Colors.white,
    'Black': Colors.black,
    'Yellow': Colors.yellow,
    'Orange': Colors.orange,
  };
  return colorMap[colorName];
}
