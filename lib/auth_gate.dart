import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
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
         return SignInScreen(
           providers: [
              EmailAuthProvider()
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
                   ? const Text('Welcome to the HVA RoHAWKtics Scouting App, please sign in!',
                   style: TextStyle(color: Colors.white),)
                   : const Text('Welcome to HVA RoHAWKtics Scouting App, please sign up!',
                   style: TextStyle(color: Colors.white),),
             );
           },
         );
       }

       return const m.HomePage(title: '');
     },
   );
 }
}

typedef HeaderBuilder = Widget Function(
 BuildContext context,
 BoxConstraints constraints,
 double shrinkOffset,
);
