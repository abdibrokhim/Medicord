import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String initialValue;
  final int minLines;
  final int maxLines;
  final void Function()? onTap;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.initialValue,
    this.minLines = 1,
    this.maxLines = 4,
    this.onTap,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            color: Color(0xFFDDDDDD), // Label text color
            fontSize: 16, // Adjust the font size as needed
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8), // Spacing between label text and TextFormField
        TextFormField(
          onTap: widget.onTap,
          canRequestFocus: false, // Add this line
          readOnly: true, // Add this line
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          controller: _controller,
          style: TextStyle(
            color: Colors.black, // Text color inside the field
          ),
          decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never, // Ensures the label doesn't float
            filled: true, // Enables the fillColor property
            fillColor: Color(0xFFC3C3C3), // Background color for the TextFormField
            labelStyle: TextStyle(color: Colors.black.withOpacity(0),), // Makes label text transparent
            border: OutlineInputBorder( // Outline border when TextFormField is enabled
              borderSide: BorderSide.none, // No border side
              borderRadius: BorderRadius.circular(5.0), // Rounded corners like the CustomDropdownButton
            ),
            enabledBorder: OutlineInputBorder( // Outline border when TextFormField is enabled and not focused
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder( // Outline border when TextFormField is focused
              borderSide: BorderSide(
                color: Colors.black, // Color for the focused border
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ],
    );
  }
}
