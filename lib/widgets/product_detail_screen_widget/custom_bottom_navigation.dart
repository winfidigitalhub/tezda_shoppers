import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final double price;
  final VoidCallback onAddToCartPressed;

  const CustomBottomNavigationBar({
    Key? key,
    required this.price,
    required this.onAddToCartPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.orange.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 200,
            child: ListTile(
              title: const Text(
                'Price',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              subtitle: Text(
                '\$$price',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          ElevatedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.only(right: 30, left: 30, top: 15, bottom: 15),
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepOrangeAccent,
            ),
            onPressed: onAddToCartPressed,
            child: const Text(
              'ADD TO CART',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
