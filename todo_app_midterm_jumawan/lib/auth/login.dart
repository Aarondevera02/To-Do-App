import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:todo_app_midterm_jumawan/screens/ongoing.dart';
import 'package:todo_app_midterm_jumawan/auth/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var obscurePassword = true;

  //Login
  void loginUsers() async {
    if (_formkey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Please Wait..');
    await FirebaseAuth.instance
      .signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text)
        .then((UserCredential) async {
        if (mounted) {
          Navigator.pop(context);
          String collectionPath = 'users';
          String uid = UserCredential.user!.uid;
          final docSnapshot = await FirebaseFirestore.instance
              .collection(collectionPath)
              .doc(UserCredential.user!.uid)
              .get();
          dynamic data = docSnapshot.data();
          Navigator.push(
          context,
          CupertinoPageRoute(
            builder: ((context) {
            return  OnGoingScreen();
          }),
        ),
      );
        Navigator.pop(context);
      }
    }).catchError((err) {
      if (mounted) {
        Navigator.pop(context);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Invalid email and/or password');
      }
    });
  }
}

@override
Widget build(BuildContext context) {
  const inputTextSize = TextStyle(fontSize: 16,);
  return Scaffold(
    //Body
    body: SafeArea(
      child: Container(
      color: Colors.grey,
      padding: const EdgeInsets.all(12.0),
      child: Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
              children: const [
                SizedBox(
                  height: 20,
                ),
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  height: 300,
                  width: 300,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'To Do Application',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
            const Text('Sign in',style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),),
              const SizedBox(
                height: 12.0,
              ),
              //Email
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Required. Please enter an email address.';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Please enter a valid email address';
                  }
                },
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: inputTextSize,
              ),
              const SizedBox(
                height: 12.0,
              ),
              //Password
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Required. Please enter your password.';
                  }
                  if (value.length <= 6) {
                    return 'Password must be more than 6 characters';
                  }
                },
                obscureText: obscurePassword,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
                style: inputTextSize,
              ),
              const SizedBox(
                height: 12.0,
              ),
              ElevatedButton(
                onPressed: loginUsers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                    
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18))),
                child: const Text('Login',style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),),

              ),
              const SizedBox(
                height: 12.0,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) {
                      return const RegistrationScreen();
                    }),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18))),
                child: const Text('Register Account',style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}