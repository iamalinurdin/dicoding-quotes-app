import 'package:flutter/material.dart';
import 'package:quotes_app/db/auth_repository.dart';
import 'package:quotes_app/models/page_configuration.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/screens/form_screen.dart';
import 'package:quotes_app/screens/login_screen.dart';
import 'package:quotes_app/screens/quote_detail_screen.dart';
import 'package:quotes_app/screens/quote_list_screen.dart';
import 'package:quotes_app/screens/splash_screen.dart';
import 'package:quotes_app/screens/register_screen.dart';

class MyRouterDelegate extends RouterDelegate<PageConfiguration> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  String? selectedQuote;
  bool isForm = false;
  final AuthRepository authRepository;
  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool? isUnknown;

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
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }

    return Navigator(
      key: navigatorKey,
      pages: historyStack,
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
  Future<void> setNewRoutePath(PageConfiguration configuration) async {
    if (configuration.isUnknownPage) {
      isUnknown = true;
      isRegister = false;
    } else if (configuration.isRegisterPage) {
      isRegister = true;
    } else if (configuration.isHomePage ||
        configuration.isLoginPage ||
        configuration.isSplashPage) {
      isUnknown = false;
      selectedQuote = null;
      isRegister = false;
    } else if (configuration.isDetailPage) {
      isUnknown = false;
      isRegister = false;
      selectedQuote = configuration.quoteId.toString();
    } else {
      print(' Could not set new route');
    }
    notifyListeners();
  }

  @override
  PageConfiguration? get currentConfiguration {
    if (isLoggedIn == null) {
      return PageConfiguration.splash();
    } else if (isRegister == true) {
      return PageConfiguration.register();
    } else if (isLoggedIn == false) {
      return PageConfiguration.login();
    } else if (isUnknown == true) {
      return PageConfiguration.unknown();
    } else if (selectedQuote == null) {
      return PageConfiguration.home();
    } else if (selectedQuote != null) {
      return PageConfiguration.detailQuote(selectedQuote!);
    } else {
      return null;
    }
  }
}