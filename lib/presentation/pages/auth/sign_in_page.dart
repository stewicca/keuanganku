import 'package:expensetracker/presentation/pages/auth/sign_up_page.dart';
import 'package:expensetracker/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../bloc/auth/sign_in/sign_in_bloc.dart';

class SignInPage extends StatefulWidget {
  static const ROUTE_NAME = '/';

  const SignInPage({ super.key });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(validateButton);
    passwordController.addListener(validateButton);
  }

  void validateButton() {
    if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        isButtonDisabled = false;
      });
    } else {
      setState(() {
        isButtonDisabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0
      ),
      body: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            SnackBar(
              content: Text("Success Login", style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.lightGreen
            );

            Navigator.pushReplacementNamed(context, MainPage.ROUTE_NAME);
          }

          if (state is SignInError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.red
              )
            );
          }
        },
        child: context.watch<SignInBloc>().state is SignInLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    name: 'username',
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      label: Text('Username'),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0
                        )
                      )
                    ),
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required()])
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      label: Text('Password'),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0
                        )
                      )
                    )
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      )
                    ),
                    onPressed: isButtonDisabled
                      ? null
                      : () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          if (true) {
                            context.read<SignInBloc>().add(
                              FetchSignIn(
                                username: usernameController.text,
                                password: passwordController.text
                              )
                            );
                          }
                        }
                      },
                    child: const Text('Login', style: TextStyle(color: Colors.white))
                  ),
                  TextButton(
                    onPressed: () { Navigator.pushNamed(context, SignUpPage.ROUTE_NAME); },
                    child: const Text('Don\'t have an account? Sign up', style: TextStyle(color: Colors.blue))
                  ),
                ]
              )
            )
          )
        ),
      ),
    );
  }
}
