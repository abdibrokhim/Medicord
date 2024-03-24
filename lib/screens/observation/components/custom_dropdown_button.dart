import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  const CustomDropdownButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: const Color(0xFFC3C3C3), // Hex color code for the background
        borderRadius: BorderRadius.circular(4.0), // Optional: if you want rounded corners
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // To make the container wrap the content
        children: const [
          Text(
            'Select',
            style: TextStyle(
              color: Colors.black, // Text color
              fontSize: 16.0, // You can adjust the font size
            ),
          ),
          SizedBox(width: 8.0), // Spacing between text and icon
          Icon(
            Icons.arrow_drop_down,
            color: Colors.black, // Icon color
          ),
        ],
      ),
    );
  }
}
