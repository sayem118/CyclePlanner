import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cycle_planner/processes/application_processes.dart';

class SearchPage extends SearchDelegate<String> {

  // Icon behind search text field
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query.isEmpty ? close(context, "") : query = "";
        },
      ),
    ];
  }

  // Icon in front of the search text field
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, query),
    );
  }

  // List widget to search suggestion results accomodate 
  // when on-keyboard search button is clicked
  @override
  Widget buildResults(BuildContext context) {
    return resultTemplate(context);
  }

  // List widget to accomodate search suggestion results
  @override
  Widget buildSuggestions(BuildContext context) {
    return resultTemplate(context);
  }

  // Build a list widget that holds search / suggestion results
  Widget resultTemplate(BuildContext context) {
    final applicationProcesses = Provider.of<ApplicationProcesses>(context);
    applicationProcesses.searchPlaces(query);

    return ListView.separated(
      itemCount: applicationProcesses.searchResults.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(applicationProcesses.searchResults[index].description),
          contentPadding: const EdgeInsets.fromLTRB(5, 6, 5, 6),
          onTap: () {
            query = applicationProcesses.searchResults[index].description;
            applicationProcesses.setSelectedLocation(
              applicationProcesses.searchResults[index].placeId
            );
            showResults(context);
            close(context, query);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(thickness: 1.0,),
    );
  }
}