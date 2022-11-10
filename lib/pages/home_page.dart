import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/services/firebase_auth_service.dart';
import 'package:chatapp/shared/shared_preferences_state.dart';
import 'package:chatapp/widgets/navigator_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  String _userName = "";

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chat App"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          firebaseAuthService.signOutUser();
          nextScreenPushAndRemove(context, const LoginPage());
        },
        label: const Text("SignOut"),
      ),
      body: Center(
        child: Text(_userName),
      ),
    );
  }

  void getUserName() async {
    await SharedPreferencesState.getUserName().then((value) {
      if (value != null) {
        setState(() {
          _userName = value;
        });
      }
    });
  }
}
