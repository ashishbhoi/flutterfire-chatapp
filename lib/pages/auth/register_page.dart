import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/services/firebase_auth_service.dart';
import 'package:chatapp/shared/regular_expression.dart';
import 'package:chatapp/shared/shared_preferences_state.dart';
import 'package:chatapp/widgets/navigator_widget.dart';
import 'package:chatapp/widgets/show_snack_bar.dart';
import 'package:chatapp/widgets/text_input_decoration.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final formKey = GlobalKey<FormState>();
  String fullName = "";
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
                      const Text("Register now to connect to your friends"),
                      const SizedBox(height: 32),
                      Image.asset("assets/photos/register_page.png"),
                      const SizedBox(height: 24),
                      TextFormField(
                        decoration: textFormFieldDecoration.copyWith(
                            labelText: "FullName",
                            prefixIcon: const Icon(Icons.person)),
                        onChanged: (val) {
                          setState(() {
                            fullName = val;
                          });
                        },
                        validator: (value) {
                          return RegExp(RegularExpression().nameVerify)
                                  .hasMatch(value!)
                              ? null
                              : "Please enter a valid name";
                        },
                      ),
                      const SizedBox(height: 10),
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
                        obscureText: true,
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
                            register();
                          },
                          child: const Text("REGISTER"),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account."),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Login Here."))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await firebaseAuthService
          .registerWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          await SharedPreferencesState.setLoggedInStatus(true);
          await SharedPreferencesState.setUserEmailSF(email);
          await SharedPreferencesState.setUserNameSF(fullName);
          return true;
        } else {
          setState(() {
            showErrorSnackBar(context, value);
            _isLoading = false;
          });
          return false;
        }
      }).then((value) => value
              ? nextScreenPushAndRemove(context, const HomePage())
              : null);
    }
  }
}
