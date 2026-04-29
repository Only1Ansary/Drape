import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({super.key, required this.label, required this.action});

  final String label;
  final void Function(BuildContext) action;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: InkWell(
        onTap: () => action(context),
        child: Container(
          decoration: BoxDecoration(color: Color.fromARGB(150, 50, 20, 255)),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
