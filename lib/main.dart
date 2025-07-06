import 'package:expensetracker/presentation/bloc/auth/sign_in/sign_in_bloc.dart';
import 'package:expensetracker/presentation/bloc/auth/sign_up/sign_up_bloc.dart';
import 'package:expensetracker/presentation/pages/auth/sign_in_page.dart';
import 'package:expensetracker/presentation/pages/auth/sign_up_page.dart';
import 'package:expensetracker/presentation/pages/expense/expense_page.dart';
import 'package:expensetracker/presentation/pages/home/home_page.dart';
import 'package:expensetracker/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/utils.dart';
import 'common/navigation.dart';
import 'injection.dart' as di;

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
      return SignInPage();
    }
    return MainPage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInBloc>(create: (context) => di.locator<SignInBloc>()),
        BlocProvider<SignUpBloc>(create: (context) => di.locator<SignUpBloc>())
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
                  case '/':
                    return MaterialPageRoute(builder: (context) => SignInPage());
                  case '/sign_up':
                    return MaterialPageRoute(builder: (context) => SignUpPage());
                  case '/main_page':
                    return MaterialPageRoute(builder: (context) => MainPage());
                  case '/home_page':
                    return MaterialPageRoute(builder: (context) => HomePage());
                  case '/expense_page':
                    return MaterialPageRoute(builder: (context) => ExpensePage());
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
