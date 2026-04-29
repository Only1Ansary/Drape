import 'package:flutter/material.dart';
import 'package:project/screens/login.dart';

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  Color buttonColor = Color.fromARGB(20, 0, 0, 0);

  void switchColor() {
    setState(() {
      if (buttonColor == Color.fromARGB(20, 0, 0, 0)) {
        buttonColor = Color.fromARGB(150, 50, 20, 255);
      } else {
        buttonColor = Color.fromARGB(20, 0, 0, 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 250,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Look Good, Feel Good",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "Create your individual & unique style and look amazing everyday.",
                          style: TextStyle(color: Colors.black38),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: switchColor,
                            child: SizedBox(
                              width: 150,
                              height: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    style: TextStyle(
                                      color:
                                          buttonColor ==
                                              Color.fromARGB(20, 0, 0, 0)
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    'Men',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          InkWell(
                            onTap: switchColor,
                            child: SizedBox(
                              width: 150,
                              height: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      buttonColor == Color.fromARGB(20, 0, 0, 0)
                                      ? Color.fromARGB(150, 50, 20, 255)
                                      : Color.fromARGB(20, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Women',
                                    style: TextStyle(
                                      color:
                                          buttonColor ==
                                              Color.fromARGB(20, 0, 0, 0)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
