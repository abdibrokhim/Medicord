import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


class CustomDropdownWithSearch extends StatefulWidget {
  final List<Map<String, String>> items;
  final String itemName;
  final int dState;

  const CustomDropdownWithSearch({
    Key? key,
    required this.items,
    required this.itemName,
    required this.dState,
  }) : super(key: key);

  @override
  _CustomDropdownWithSearchState createState() => _CustomDropdownWithSearchState();
}

class _CustomDropdownWithSearchState extends State<CustomDropdownWithSearch> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  
  Map<String, String> selected = {};

  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalState, UserState>(
      converter: (appState) => appState.state.appState.userState,
      builder: (context, userState) {
        return GestureDetector(
          onTap: () => _showItemsList(context),
          child: AbsorbPointer(
            child: Padding(padding: const EdgeInsets.all(0.0),
              child: 
              
              TextFormField(
  controller: TextEditingController(text: selected['name'] ?? ''),
  style: TextStyle(
    color: Colors.black, // Text color inside the field
  ),
  decoration: InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.never, // Keeps the floating label text above the field
    filled: true, // Enables the fillColor property
    fillColor: Color(0xFFC3C3C3), // Background color for the TextFormField
    labelText: widget.itemName,
    labelStyle: TextStyle(
      color: Colors.black, // Color for the label when it is above the TextFormField
    ),
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
    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black), // Change to the icon you want
  ),
),

            ),
          ),
        );
      },
    );
  }

  void _showItemsList(BuildContext context) {
    List<String> filteredItems = widget.items.map((e) => e['name']!).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: const Color.fromARGB(255, 31, 33, 38),
          backgroundColor: const Color.fromARGB(255, 31, 33, 38),
          child: SizedBox(
            width: 300,
            height: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                  TextField(
  cursorColor: Colors.white, // Keeps the cursor white
  controller: searchController,
  style: TextStyle(
    color: Colors.white, // Text color
  ),
  decoration: InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.never, // Keeps the floating label text above the field
    floatingLabelStyle: TextStyle(
      color: Colors.transparent, // Keeps the floating label text white
    ),
    labelText: 'Search',
    labelStyle: TextStyle(
      color: Colors.white, // Keeps the label text white even when focused
    ),
    prefixIcon: const Icon(
      Icons.search,
      color: Colors.white,
    ),
    enabledBorder: OutlineInputBorder(
      // Normal state border
      borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
      // Border when TextField is focused
      borderSide: BorderSide.none
    ),
    // Removes the underline
    border: InputBorder.none,

                  
                      suffixIcon: searchController.text.isNotEmpty 
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              filteredItems = widget.items.map((e) => e['name']!).toList();
                              (context as Element).markNeedsBuild();

                              setState(() {
                                selected = {};
                              });
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.white,
                            )
                          )
                        : null,
                    ),
                    onChanged: (String value) {
                      filteredItems = (widget.items.map((e) => e['name']!).toList() ?? []).where((item) {
                        final itemLower = item.toLowerCase();
                        final searchLower = value.toLowerCase();
                        return itemLower.contains(searchLower);
                      }).toList();
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ),
                Divider(color: Colors.white),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ListTile(
                        title: Text(
                          item,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            searchController.text = item;
                            selected = {'id': widget.items.firstWhere((element) => element['name'] == item)['id']!, 'name': item};
                            print('selected: $selected');
                            StoreProvider.of<GlobalState>(context).dispatch(SelectPatientAction({'id': widget.items.firstWhere((element) => element['name'] == item)['id']!, 'name': item}));
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}