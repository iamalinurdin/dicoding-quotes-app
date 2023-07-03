import 'package:flutter/material.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/screens/form_screen.dart';
import 'package:quotes_app/screens/quote_detail_screen.dart';
import 'package:quotes_app/screens/quote_list_screen.dart';

class MyRouterDelegate extends RouterDelegate with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  String? selectedQuote;
  bool isForm = false;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('QuoteListPage'),
          child: QuotesListScreen(
            quotes: quotes,
            onTapped: (String quoteId) {                
              selectedQuote = quoteId;
              notifyListeners();
            },
            toFormScreen: () {
              isForm = true;
              notifyListeners();
            },
          ),
        ),
        if (selectedQuote != null) 
          MaterialPage(
            key: ValueKey("QuoteDetailPage-$selectedQuote"),
            child: QuoteDetailsScreen(
              quoteId: selectedQuote!
            )
          ),
        if (isForm)
          MaterialPage(
            key: const ValueKey('FormScreen'),
            child: FormScreen(
              onSend: () {
                isForm = false;
                notifyListeners();
              }
            )
          )
      ],
      onPopPage: (route, result) {
        final didPop = route.didPop(result);

        if (!didPop) {
          return false;
        }

        selectedQuote = null;
        isForm = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}