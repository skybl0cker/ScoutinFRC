import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:flutter/material.dart';

import 'main.dart' as m;

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required List<SignedOutAction> actions});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Colors.white,
                secondary: Colors.grey,
                onPrimary: Colors.black,
                onSurface: Colors.white,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white),
                bodySmall: TextStyle(color: Colors.white),
              ),
              scaffoldBackgroundColor: const Color.fromRGBO(65, 68, 73, 1),
            ),
            child: SignInScreen(
              providers: [
                EmailAuthProvider(),
                GoogleProvider(clientId: "246498824596-93ae95j4i3lr4rmeq0mfu455jcdsjs6v.apps.googleusercontent.com"),
                AppleProvider(),
              ],
              headerBuilder: (context, constraints, shrinkOffset) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset('assets/images/rohawktics.png'),
                  ),
                );
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: action == AuthAction.signIn
                      ? const Text(
                          'Welcome to the RoHAWKtics Scouting App, please sign in!',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'Welcome to the RoHAWKtics Scouting App, please sign up!',
                          style: TextStyle(color: Colors.white),
                      )
                        );
              },
              footerBuilder: (context, action) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'By signing in, you agree to our terms and conditions.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          );
        }

        return const m.HomePage(title: "");
      },
    );
  }
}
