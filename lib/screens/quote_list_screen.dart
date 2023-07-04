import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/providers/auth_provider.dart';
import 'package:quotes_app/routes/page_manager.dart';

class QuotesListScreen extends StatelessWidget {
  final Function(String) onTapped;
  final Function toFormScreen;
  final List<Quote> quotes;
  final Function() onLogout;

  const QuotesListScreen({
    Key? key,
    required this.quotes,
    required this.onTapped,
    required this.toFormScreen,
    required this.onLogout
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes App"),
        actions: [
          IconButton(
            onPressed: () async {
              final scaffoldMessengerState = ScaffoldMessenger.of(context);
              toFormScreen();
              final dataString = await context.read<PageManager>().waitForResult();

              scaffoldMessengerState.showSnackBar(
                SnackBar(
                  content: Text('my name is $dataString')
                )
              );
            }, 
            icon: const Icon(Icons.quiz)
          )
        ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final authRead = context.read<AuthProvider>();
          final result = await authRead.logout();
          if (result) onLogout();
        },
        tooltip: "Logout",
        child: authWatch.isLoadingLogout
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.logout),
      ),
    );
  }
}