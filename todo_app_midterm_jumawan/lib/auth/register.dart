import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import '../authentication.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();
  var obscurePassword = true;
  final _formkey = GlobalKey<FormState>();
  final collectionPath = 'users'; //Collection Path
  
  //Register User
  void registerUsers() async {
    try {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (userCredential.user == null) {
        throw FirebaseAuthException(code: 'null-usercredential');
      }
      String uid = userCredential.user!.uid;
      FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(uid)
          .set({'task': [], 'finished': []});
      Navigator.push(
        context,
        CupertinoPageRoute (
          builder: (context) {
            return  AuthenticationScreen();
          },
        ),
      );
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title:
                'Your password is weak. Please enter more than 6 characters.');
        return;
      }
      if (ex.code == 'email-already-in-use') {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title:
                'Your email is already registered. Please enter a new email address.');
        return;
      }
      if (ex.code == 'null-usercredential') {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'An error occured while creating your account. Try again.');
      }
    }
  }

  //Validation
  void validateUsers() {
    if (_formkey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: null,
        confirmBtnText: 'Yes',
        cancelBtnText: 'Cancel',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          registerUsers();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Registration',
          style: TextStyle(fontSize: 20),
        ),
      ),

      //Body
      body: Container(
        color: Colors.grey,
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: const[
                    //Logo
                    Image(image: AssetImage('assets/images/logo.png'),
                      height: 300,
                      width: 300,),
                       SizedBox(
                        height: 10,
                      ),
                       Text(
                        'To Do Application',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        
                      ),
                       SizedBox(height: 10,),
                  ],
                ),
                       
                const  Text('Registration' ,style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),),
                const  SizedBox(
                  height: 12,
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
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
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
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),

                //Confirm Password
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your password.';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords don\'t match';
                    }
                  },
                  obscureText: obscurePassword,
                  controller: confirmpassController,
                 decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style:const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                ElevatedButton(
                  onPressed: validateUsers,
                  style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18))),
                  child: const Text('Register',style: TextStyle(
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