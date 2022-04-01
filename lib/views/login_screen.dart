import 'package:cycle_planner/views/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget{

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen>{
  // form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  //firebase
final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context){
    //email field
    final emailField = TextFormField(
      key: const ValueKey('emailLogInField'),
      autofocus: false,
      controller: emailController,
      keyboardType:TextInputType.emailAddress,
      validator: (value)
        {
          if(value!.isEmpty)
            {
             return ("Please Enter Your Email");
            }
          // reg expression for email validation
          if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-z0-9.-]+.[a-z]").hasMatch(value))
          {
            return ("Please Enter a Valid Email");
          }
          return null;
        },
      onSaved: (value)
      {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );


    //password field
    final passwordField = TextFormField(
      key: const ValueKey('passwordLogInField'),
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value)
        {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty)
            {
              return ("Password is Required For Login");
            }
          if (!regex.hasMatch(value))
            {
              return ("Please Enter a Valid Password (Min of 6 Characters");
            }
        },
      onSaved: (value)
      {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );


    final loginButton = Material(
      key: const ValueKey('LogInButton'),
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueGrey,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: ()
          {
            signIn(emailController.text, passwordController.text);
          },
          child: const Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color:Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    SizedBox(
                        height: 200,
                        child: Image.asset("assets/cyclebaynew.png",
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 45),
                    emailField,
                    const SizedBox(height: 25),
                    passwordField,
                    const SizedBox(height: 35),
                    loginButton,
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Don't have an account? "),
                        GestureDetector(onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                        },
                          child: const Text(
                            "SignUp",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w900,
                                fontSize: 15),
                          ),
                        )],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     Text(" Sign in as "),
                    //     GestureDetector(onTap: (){
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    //     },
                    //       child: const Text(
                    //         "Guest",
                    //         style: TextStyle(
                    //             color: Colors.redAccent,
                    //             fontWeight: FontWeight.w900,
                    //             fontSize: 15),
                    //       ),
                    //
                    //     )],
                    //
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async
  {
    if (_formKey.currentState!.validate())
      {
        await _auth.signInWithEmailAndPassword(email: email, password: password)
            .then((uid) =>
        {
        Fluttertoast.showToast(msg: "Login Successful"),
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen())),

        }).catchError((e)
            {
              Fluttertoast.showToast(msg: e!.message);
            });
      }
  }
}