import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/cubits/auth/auth_cubit.dart';
import 'package:project/cubits/cart/cart_cubit.dart';
import 'package:project/cubits/wishlist/wishlist_cubit.dart';
import 'package:project/screens/home.dart';
import 'package:project/screens/signup.dart';
import '../cubits/auth/auth_states.dart';
import '../widgets/bottom_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var emailC = TextEditingController();
  var passwordC = TextEditingController();

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool isUser = false;
  int pass = 0;
  bool isClick = false;

  void clickMe() {
    setState(() {
      isClick = !isClick;
    });
  }

  Future<void> goLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        emailC.text.trim(),
        passwordC.text.trim(),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) async {
        if (state is AuthSuccessState) {
          final user = state.user;
          // Fetch user data from Firestore using the UID
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          String username = 'User'; // fallback
          if (userDoc.exists && userDoc.data()!.containsKey('name')) {
            username = userDoc['name'];
          }

          context.read<CartCubit>().fetchCartItems(emailC.text);
          context.read<WishlistCubit>().fetchWishlist(emailC.text);


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                username: username,
                email: user.email ?? '',
              ),
            ),
          );
        } else if (state is AuthFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Incorrect email or password',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(iconTheme: const IconThemeData()),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const Text(
                      'Please enter your data to continue',
                      style: TextStyle(color: Colors.black38),
                    ),
                    const SizedBox(height: 120),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                              controller: emailC,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "You must choose an email";
                                } else if (!emailRegex.hasMatch(value)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                              controller: passwordC,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "You must choose a password";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: const Text(
                                    "Forgot password?",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              children: [
                                const Text('Remember me'),
                                const Spacer(),
                                Switch(
                                  value: isClick,
                                  onChanged: (value) => clickMe(),
                                  activeTrackColor: Colors.green,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    InkWell(
                      child: const Text(
                        'Don\'t have an account? Signup',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(150, 50, 20, 255),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Signup(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(fontSize: 15, color: Colors.black38),
                          children: [
                            TextSpan(
                              text:
                              "By connecting your account you confirm that you agree with our ",
                            ),
                            TextSpan(
                              text: "Terms and Conditions",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // 🔹 Fixed button at bottom
            SafeArea(
              child: BottomButton(label: 'Login', action: goLogin),
            ),
          ],
        ),
      ),
    );
  }
}
