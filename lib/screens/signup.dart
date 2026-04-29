import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/cubits/auth/auth_cubit.dart';
import 'package:project/cubits/auth/auth_states.dart';
import 'package:project/screens/login.dart';
import 'package:project/widgets/bottom_button.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  var userNameC = TextEditingController();
  var passwordC = TextEditingController();
  var emailC = TextEditingController();

  bool isUser = false;
  bool isEmail = false;

  int pass = 0;

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  void userIcon(String val) {
    setState(() {
      isUser = val.isNotEmpty;
    });
  }

  void emailIcon(String val) {
    setState(() {
      isEmail = val.isNotEmpty && emailRegex.hasMatch(val);
    });
  }

  void passIcon(String val) {
    setState(() {
      if (val.length > 8) {
        pass = 5;
        if (val.contains(RegExp(r'[!@#\$^&*\)\(-=_+~%]'))) {
          pass++;
        }
      } else {
        pass = 0;
      }
    });
  }

  bool isClick = false;

  void clickMe() {
    setState(() {
      isClick = !isClick;
    });
  }

  void goSign(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
        emailC.text.trim(),
        passwordC.text.trim(),
        userNameC.text.trim(),
      );
    }
  }

  @override
  void dispose() {
    userNameC.dispose();
    emailC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          } else if (state is AuthFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      const SizedBox(height: 150),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              TextFormField(
                                onChanged: userIcon,
                                decoration: InputDecoration(
                                  label: const Text('Username'),
                                  suffixIcon: isUser
                                      ? const Icon(Icons.check,
                                      color: Colors.green)
                                      : const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                                controller: userNameC,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "You must choose a username";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                onChanged: passIcon,
                                obscureText: true,
                                decoration: InputDecoration(
                                  label: const Text('Password'),
                                  suffixText: pass > 5
                                      ? 'Strong'
                                      : pass > 2
                                      ? 'Medium'
                                      : 'Weak',
                                  suffixStyle: TextStyle(
                                    color: pass > 5
                                        ? Colors.green
                                        : pass > 2
                                        ? Colors.yellow
                                        : Colors.red,
                                  ),
                                ),
                                controller: passwordC,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "You must choose a password";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                onChanged: emailIcon,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  label: const Text('Email Address'),
                                  suffixIcon: isEmail
                                      ? const Icon(Icons.check,
                                      color: Colors.green)
                                      : const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                                controller: emailC,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "You must choose an email address";
                                  } else if (!emailRegex.hasMatch(value)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
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
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height / 4 - 90,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: state is AuthLoadingState
                    ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                )
                    : BottomButton(label: 'Sign Up', action: goSign),
              ),
            ],
          );
        },
      ),
    );
  }
}
