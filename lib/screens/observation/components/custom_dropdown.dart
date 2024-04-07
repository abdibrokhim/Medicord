import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/refreshable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';


class CustomDropdownWithSearch extends StatefulWidget {
  final List<Map<String, String>> items;
  final String itemName;
  final int dState;
  final String labelText;
  final bool isAddNewPatient;
  final void Function()? onAddNewPatient;

  const CustomDropdownWithSearch({
    Key? key,
    required this.items,
    required this.itemName,
    required this.dState,
    required this.labelText,
    this.isAddNewPatient = false,
    this.onAddNewPatient,
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

      void reFetchData()  {
          print('refetching');
          if (widget.dState == 0) {

      store.dispatch(FetchAllPatientNamesAction());
          }

  }

    RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    reFetchData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
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

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        height: 800,
        color: const Color.fromARGB(255, 31, 33, 38),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
             Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
                            Text(
                              widget.labelText,
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
const SizedBox(height: 24),
TextFormField(
          cursorColor: Colors.black,
          controller: searchController,
          style: const TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: const Color(0xFFC3C3C3),
            labelStyle: const TextStyle(
              color: Colors.transparent,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
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
                          color: Colors.black,
                        ),
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
          
            // TextField(
            //   cursorColor: Colors.white,
            //   controller: searchController,
            //   style: TextStyle(
            //     color: Colors.white,
            //   ),
            //   decoration: InputDecoration(
            //     floatingLabelBehavior: FloatingLabelBehavior.never,
            //     floatingLabelStyle: TextStyle(
            //       color: Colors.transparent,
            //     ),
            //     labelText: 'Search',
            //     labelStyle: TextStyle(
            //       color: Colors.white,
            //     ),
            //     prefixIcon: const Icon(
            //       Icons.search,
            //       color: Colors.white,
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderSide: BorderSide.none,
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: BorderSide.none,
            //     ),
            //     border: InputBorder.none,
            //     suffixIcon: searchController.text.isNotEmpty
            //         ? IconButton(
            //             onPressed: () {
            //               searchController.clear();
            //               filteredItems = widget.items.map((e) => e['name']!).toList();
            //               (context as Element).markNeedsBuild();
            //               setState(() {
            //                 selected = {};
            //               });
            //             },
            //             icon: Icon(
            //               Icons.clear,
            //               color: Colors.white,
            //             ),
            //           )
            //         : null,
            //   ),
            //   onChanged: (String value) {
            //     filteredItems = (widget.items.map((e) => e['name']!).toList() ?? []).where((item) {
            //       final itemLower = item.toLowerCase();
            //       final searchLower = value.toLowerCase();
            //       return itemLower.contains(searchLower);
            //     }).toList();
            //     (context as Element).markNeedsBuild();
            //   },
            // ),

            // Divider(color: Colors.white),
            const SizedBox(height: 8),
            Expanded(
              child:     
              Refreshable(
            refreshController: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: 
              ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return 
                  ListTile(
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
                        selected = {
                          'id': widget.items.firstWhere((element) => element['name'] == item)['id']!,
                          'name': item
                        };
                        if (widget.dState == 0) {
                          StoreProvider.of<GlobalState>(context).dispatch(SelectPatientAction(selected));
                        }
                        if (widget.dState == 1) {
                          StoreProvider.of<GlobalState>(context).dispatch(SelectObservationTypeAction(selected));
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ),
            // add patient button
            if (widget.isAddNewPatient)
                          Column(
                            children: [
                              SizedBox(
                  height: 24,
),
                            SizedBox(
                  width: double.infinity,
                  child:
          ElevatedButton(
  onPressed: widget.onAddNewPatient,
  style: ElevatedButton.styleFrom(
    // elevation: 5,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white, // Set the text color (applies to foreground)
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700, 
    ),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Set the padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)), // Set the border radius
      side: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
  ),
  child: Text(
    "Add New Patient",
  ),
),
),
SizedBox(
                  height: 48,
),
                            ],
                          ),
          ],
        ),
      );
    },
  );
}

}