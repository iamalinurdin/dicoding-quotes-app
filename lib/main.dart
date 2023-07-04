import 'package:provider/provider.dart';
import 'package:quotes_app/common/url_strategy.dart';
import 'package:quotes_app/db/auth_repository.dart';
import 'package:quotes_app/providers/auth_provider.dart';
import 'package:quotes_app/routes/route_information_parser.dart';
import 'package:quotes_app/routes/router_delegate.dart';
import 'package:flutter/material.dart';

void main() {
  usePathUrlStrategy();
  runApp(const QuotesApp());
}

class QuotesApp extends StatefulWidget {
  const QuotesApp({Key? key}) : super(key: key);

  @override
  State<QuotesApp> createState() => _QuotesAppState();
}

class _QuotesAppState extends State<QuotesApp> {
  late MyRouterDelegate myRouterDelegate;
  late AuthProvider authProvider;
  late MyRouteInformationParser myRouteInformationParser;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();
    
    myRouterDelegate = MyRouterDelegate(authRepository);
    authProvider = AuthProvider(authRepository);
    myRouteInformationParser = MyRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => authProvider,
      child: MaterialApp.router(
        title: 'Quotes App',
        routerDelegate: myRouterDelegate,
        routeInformationParser: myRouteInformationParser,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}