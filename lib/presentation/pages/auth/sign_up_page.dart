import 'package:expensetracker/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../bloc/auth/sign_up/sign_up_bloc.dart';

class SignUpPage extends StatefulWidget {
  static const ROUTE_NAME = '/sign_up';

  const SignUpPage({ super.key });

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
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
        title: Text('Sign Up', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0
      ),
      body: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Success Register", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.lightGreen
              )
            );

            Navigator.pushReplacementNamed(context, MainPage.ROUTE_NAME);
          }

          if (state is SignupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.red
              ),
            );
          }
        },
        child: context.watch<SignUpBloc>().state is SignUpLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FormBuilderTextField(
                    name: 'username',
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      label: Text('Username'),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0)
                      )
                    ),
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required()])
                  ),
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    name: 'password',
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      label: Text('Password'),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0)
                      )
                    ),
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required()])
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
                            context.read<SignUpBloc>().add(
                              FetchSignUp(
                                username: usernameController.text,
                                password: passwordController.text
                              )
                            );
                          }
                        }
                      },
                    child: const Text('Register', style: TextStyle(color: Colors.white))
                  ),
                  TextButton(
                    onPressed: () { Navigator.pop(context); },
                    child: const Text('Already have an account? Sign in', style: TextStyle(color: Colors.blue))
                  )
                ]
              )
            )
          )
        ),
      ),
    );
  }
}
