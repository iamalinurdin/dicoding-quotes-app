import 'package:flutter/material.dart';
import 'package:quotes_app/models/quote.dart';

class QuotesListScreen extends StatelessWidget {
  final Function(String) onTapped;
  final List<Quote> quotes;

  const QuotesListScreen({
    Key? key,
    required this.quotes,
    required this.onTapped
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes App"),
      ),
      body: ListView(
        children: [
          for (var quote in quotes)
            ListTile(
              title: Text(quote.author),
              subtitle: Text(quote.quote),
              isThreeLine: true,
              onTap: () => onTapped(quote.id),
            )
        ],
      ),
    );
  }
}