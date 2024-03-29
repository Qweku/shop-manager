// // ignore_for_file: file_names
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:shop_manager/firebase_options.dart';
// enum ApplicationLoginState {
//   loggedOut,
//   emailAddress,
//   register,
//   password,
//   loggedIn,
// }
// class ApplicationState extends ChangeNotifier {
//   ApplicationState() {
//     init();
//   }

//   Future<void> init() async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );

//     FirebaseAuth.instance.userChanges().listen((user) {
//       if (user != null) {
//         _loginState = ApplicationLoginState.loggedIn;
//       } else {
//         _loginState = ApplicationLoginState.loggedOut;
//       }
//       notifyListeners();
//     });
//   }

//   ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
//   ApplicationLoginState get loginState => _loginState;

//   String? _email;
//   String? get email => _email;

//   void startLoginFlow() {
//     _loginState = ApplicationLoginState.emailAddress;
//     notifyListeners();
//   }

//   Future<void> verifyEmail(
//     String email,
//     void Function(FirebaseAuthException e) errorCallback,
//   ) async {
//     try {
//       var methods =
//           await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
//       if (methods.contains('password')) {
//         _loginState = ApplicationLoginState.password;
//       } else {
//         _loginState = ApplicationLoginState.register;
//       }
//       _email = email;
//       notifyListeners();
//     } on FirebaseAuthException catch (e) {
//       errorCallback(e);
//     }
//   }

//   Future<void> signInWithEmailAndPassword(
//     String email,
//     String password,
//     void Function(FirebaseAuthException e) errorCallback,
//   ) async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//     } on FirebaseAuthException catch (e) {
//       errorCallback(e);
//     }
//   }

//   void cancelRegistration() {
//     _loginState = ApplicationLoginState.emailAddress;
//     notifyListeners();
//   }

//   Future<void> registerAccount(
//       String email,
//       String displayName,
//       String password,
//       void Function(FirebaseAuthException e) errorCallback) async {
//     try {
//       var credential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//       await credential.user!.updateDisplayName(displayName);
//     } on FirebaseAuthException catch (e) {
//       errorCallback(e);
//     }
//   }

//   void signOut() {
//     FirebaseAuth.instance.signOut();
//   }
// }
