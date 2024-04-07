import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  
  const CustomErrorWidget({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFFFCBCB),
        borderRadius: BorderRadius.circular(5),
      ),
      child:
    Column(
      children: [
        for (var error in errors)
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red[900],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: errors.map((e) => Text(
                  e,
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                )).toList(),
              ),
            ],
          ),
      ],
          ),
    );
  }
}