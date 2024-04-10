import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('d MMMM, yyyy');
  return formatter.format(date);
}

void showErrorBottomSheet(BuildContext context, List<String> errors) {
    showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
        return
      Container(
        height: 800,
        color: const Color.fromARGB(255, 31, 33, 38),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 0.0),
          child:
        SingleChildScrollView(
          child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
            Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
                              'Issues found',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
      Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255), // Add your background color here
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: Colors.black, size: 18,),
        ),
      ),
    ],
),
          
const SizedBox(height: 16),
                      Text(
                              'Please correct the following issues before proceeding',
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 32),
Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFFFCBCB),
        borderRadius: BorderRadius.circular(5),
      ),
      child:
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: errors.map((e) =>
    Text(
      '- ${e}',
      style: TextStyle(
        color: Colors.red[900],
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  ).toList(),
),
),
const SizedBox(height: 60),
          ],
        ), 
        ),
        ),
      );
    },
    );
}

void showMixedBottomSheet(BuildContext context, List<String> content, int state, String label, String infoText, Color bgColor, Color txtColor) {
    showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
        return
      Container(
        height: 800,
        color: const Color.fromARGB(255, 31, 33, 38),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 0.0),
          child:
        SingleChildScrollView(
          child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
            Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
                              label,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
      Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255), // Add your background color here
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: Colors.black, size: 18,),
        ),
      ),
    ],
),
          
const SizedBox(height: 16),
                      Text(
                              infoText,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 32),
Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child:
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: content.map((e) =>
    Text(
      '- ${e}',
      style: TextStyle(
        color: txtColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  ).toList(),
),
),
const SizedBox(height: 60),
          ],
        ), 
        ),
        ),
      );
    },
    );
}