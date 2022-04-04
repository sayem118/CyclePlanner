import 'package:flutter/material.dart';
import 'package:cycle_planner/widgets/search_page.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super( // coverage:ignore-line
      key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(top: 3, bottom: 3, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset.zero,
          )
        ]
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.location_pin,
                      size: 30.0,
                      color: Colors.blue
                    ),
                    hintText: 'Search Location',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      wordSpacing: 2,
                      fontSize: 16,
                      height: 1,
                    ),
                    suffixIcon: Icon(Icons.search),
                  ),
                  readOnly: true,
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: SearchPage(),
                    );
                  },
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}