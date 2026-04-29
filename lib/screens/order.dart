import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/cubits/cart/cart_cubit.dart';
import 'package:project/widgets/bottom_button.dart';

import 'home.dart';

class Order extends StatelessWidget {
  const Order({super.key, required this.username, required this.email});

  final String username;
  final String email;

  void goShop(BuildContext context) {
    context.read<CartCubit>().clearCart(email);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(username: username, email: email,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(252, 255, 255, 255),
      appBar: AppBar(backgroundColor: Color.fromARGB(0, 255, 255, 255)),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/order.png'),
                Text(
                  'Order Confirmed!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Your order has been confirmed, we will send you confirmation email shortly.',
                    style: TextStyle(
                      color: Colors.grey[500]
                    ),
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          BottomButton(label: 'Continue Shopping', action: goShop),
        ],
      ),
    );
  }
}
