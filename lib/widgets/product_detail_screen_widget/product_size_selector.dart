import 'package:flutter/material.dart';

class SizeSelector extends StatefulWidget {
  final List<String> availableSizes;
  final Function(String) onSizeSelected;

  const SizeSelector({Key? key, required this.availableSizes, required this.onSizeSelected}) : super(key: key);

  @override
  _SizeSelectorState createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  String? selectedSize = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Row(
            children: widget.availableSizes.map((size) {
              bool isSelected = selectedSize == size;
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    selectedSize = isSelected ? null : size;
                  });
                  widget.onSizeSelected(size);
                },
                child: Container(
                  padding: const EdgeInsets.all(12), // Adjust padding as needed
                  margin: const EdgeInsets.only(right: 15), // Add spacing between buttons
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.deepOrangeAccent : Colors.orange,
                    ),
                    color: isSelected ? Colors.orange : null,
                  ),
                  child: Text(
                    size,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.orange,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

        ],
      ),
    );
  }
}

