import 'package:expensetracker/presentation/bloc/auth/signin/signin_bloc.dart';
import 'package:expensetracker/presentation/bloc/auth/signup/signup_bloc.dart';
import 'package:expensetracker/presentation/pages/auth/signin_page.dart';
import 'package:expensetracker/presentation/pages/auth/signup_page.dart';
import 'package:expensetracker/presentation/pages/expense/expense_page.dart';
import 'package:expensetracker/presentation/pages/home/home_page.dart';
import 'package:expensetracker/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/utils.dart';
import 'injection.dart' as di;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  di.initializeDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String?> getTokenFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Widget> getInitialPage() async {
    String? token = await getTokenFromSharedPrefs();

    if (token == null) {
      return SigninPage();
    }
    return MainPage();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //auth
        BlocProvider<SigninBloc>(create: (context) => di.locator<SigninBloc>()),
        BlocProvider<SignupBloc>(create: (context) => di.locator<SignupBloc>()),
      ],
      child: FutureBuilder(
        future: getInitialPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')),
              ),
            );
          } else {
            return MaterialApp(
              title: 'Expense Tracker',
              home: snapshot.data,
              navigatorObservers: [routeObserver],
              navigatorKey: navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  // pageauth
                  case '/':
                    return MaterialPageRoute(
                      builder: (context) => SigninPage(),
                    );
                  case '/signup':
                    return MaterialPageRoute(
                      builder: (context) => SignupPage(),
                    );

                  // main page
                  case '/main_page':
                    return MaterialPageRoute(builder: (context) => MainPage());
                  case '/home_page':
                    return MaterialPageRoute(builder: (context) => HomePage());
                  case '/expense_page':
                    return MaterialPageRoute(
                      builder: (context) => ExpensePage(),
                    );

                  default:
                    return MaterialPageRoute(
                      builder: (context) => Scaffold(
                        body: Center(
                          child: Text('No route defined for ${settings.name}'),
                        ),
                      ),
                    );
                }
              },
            );
          }
        },
      ),
    );
  }
}
