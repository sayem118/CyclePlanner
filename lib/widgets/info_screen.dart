
import 'package:flutter/material.dart';


class InfoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
        appBar: AppBar(
          title: const Text("Iconic places"),
          backgroundColor: Colors.redAccent,
        );
    return Card(
        elevation: 8,
        shadowColor: Colors.amber,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
               padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.black],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                ),
  ),
    );
  }


}