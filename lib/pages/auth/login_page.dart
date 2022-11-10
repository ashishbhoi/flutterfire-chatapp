import 'package:chatapp/pages/auth/register_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/services/firebase_auth_service.dart';
import 'package:chatapp/services/firebase_firestore_service.dart';
import 'package:chatapp/shared/regular_expression.dart';
import 'package:chatapp/shared/shared_preferences_state.dart';
import 'package:chatapp/widgets/navigator_widget.dart';
import 'package:chatapp/widgets/show_snack_bar.dart';
import 'package:chatapp/widgets/text_input_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Login now to connect to your friends"),
                      const SizedBox(height: 32),
                      Image.asset("assets/photos/login_page.png"),
                      const SizedBox(height: 24),
                      TextFormField(
                        decoration: textFormFieldDecoration.copyWith(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email)),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validator: (value) {
                          return RegExp(RegularExpression().emailVerify)
                                  .hasMatch(value!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: textFormFieldDecoration.copyWith(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock)),
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        validator: (val) {
                          return val!.length < 8
                              ? "Password must be at least 8 character"
                              : null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          child: const Text("LOGIN"),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                              onPressed: () {
                                nextScreenPush(context, const RegisterPage());
                              },
                              child: const Text("Register Here."))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await firebaseAuthService
          .loginWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          String userEmail = await FirebaseFirestoreService(
                  uid: FirebaseAuth.instance.currentUser!.uid)
              .getUserName();
          await SharedPreferencesState.setLoggedInStatus(true);
          await SharedPreferencesState.setUserEmailSF(email);
          await SharedPreferencesState.setUserNameSF(userEmail);
          return true;
        } else {
          setState(() {
            showErrorSnackBar(context, value);
            _isLoading = false;
          });
          return false;
        }
      }).then((value) =>
              value ? nextScreenPushReplace(context, const HomePage()) : null);
    }
  }
}
