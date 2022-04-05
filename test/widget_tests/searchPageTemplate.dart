import 'package:flutter/material.dart';

class DelegatePage extends StatelessWidget {
  const DelegatePage({
    Key? key,
    this.results,
    required this.delegate,
    this.passInInitialQuery = false,
    this.initialQuery,
    this.themeData,
  }) : super(key: key);

  final List<String?>? results;
  final SearchDelegate<String> delegate;
  final bool passInInitialQuery;
  final ThemeData? themeData;
  final String? initialQuery;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('HomeTitle'),
            actions: <Widget>[
              IconButton(
                tooltip: 'Search',
                icon: const Icon(Icons.search),
                onPressed: () async {
                  String? selectedResult;
                  if (passInInitialQuery) {
                    selectedResult = await showSearch<String>(
                      context: context,
                      delegate: delegate,
                      query: initialQuery,
                    );
                  } else {
                    selectedResult = await showSearch<String>(
                      context: context,
                      delegate: delegate,
                    );
                  }
                  results?.add(selectedResult);
                },
              ),
            ],
          ),
          body: const Text('HomeBody'),
        );
      }),
    );
  }
}