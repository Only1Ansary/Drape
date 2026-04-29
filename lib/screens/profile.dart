import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/cubits/cart/cart_cubit.dart';
import '../cubits/auth/auth_cubit.dart';
import 'first.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.username, required this.email});

  final String username;
  final String email;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var usernameC = TextEditingController();
  var emailC = TextEditingController();

  @override
  void initState() {
    usernameC.text = widget.username;
    emailC.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: SizedBox(
                      height: 60,
                      width: 400,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                        child: Text('Do you really wanna Logout?'),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthCubit>().logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => First()),
                            (route) => false,
                          );
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black12,
              ),
              child: Center(
                child: TextFormField(
                  controller: usernameC,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.person_2_outlined),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black12,
              ),
              child: Center(
                child: TextFormField(
                  controller: emailC,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
