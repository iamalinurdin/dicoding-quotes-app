import 'package:flutter/material.dart';
import 'package:quotes_app/db/auth_repository.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/screens/form_screen.dart';
import 'package:quotes_app/screens/login_screen.dart';
import 'package:quotes_app/screens/quote_detail_screen.dart';
import 'package:quotes_app/screens/quote_list_screen.dart';
import 'package:quotes_app/screens/splash_screen.dart';
import 'package:quotes_app/screens/register_screen.dart';

class MyRouterDelegate extends RouterDelegate with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  String? selectedQuote;
  bool isForm = false;
  final AuthRepository authRepository;
  List<Page> historyBack = [];
  bool? isLoggedIn;
  bool isRegister = false;

  List<Page> get _splashStack => const [
    MaterialPage(
      key: ValueKey('SplashPage'),
      child: SplashScreen()
    )
  ];

  List<Page> get _loggedOutStack => [
    MaterialPage(
      key: const ValueKey('LoginPage'),
      child: LoginScreen(
        onLogin: () {
          isLoggedIn = true;
          notifyListeners();
        },
        onRegister: () {
          isRegister = true;
          notifyListeners();
        },
      )
    ),
    if (isRegister == true)
      MaterialPage(
        key: const ValueKey('RegisterPage'),
        child: RegisterScreen(
          onRegister: () {
            isRegister = false;
            notifyListeners();
          },
          onLogin: () {
            isRegister = false;
            notifyListeners();
          },
        )
      )
  ];

  List<Page> get _loggedInStack => [
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
        onLogout: () {
          isLoggedIn = false;
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
  ];

  MyRouterDelegate(this.authRepository) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyBack = _splashStack;
    } else if (isLoggedIn == true) {
      historyBack = _loggedInStack;
    } else {
      historyBack = _loggedOutStack;
    }

    return Navigator(
      key: navigatorKey,
      pages: historyBack,
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