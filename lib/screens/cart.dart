import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/screens/order.dart';
import 'package:project/widgets/bottom_button.dart';
import '../cubits/cart/cart_cubit.dart';
import '../cubits/cart/cart_states.dart';

class Cart extends StatelessWidget {
  const Cart({super.key, required this.email, required this.username});

  final String email;
  final String username;

  void checkOut(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Order(email: email, username: username,)));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Cart"),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, CartStates>(
        builder: (context, state) {
          if (state is CartUpdatedState && state.items.isNotEmpty) {
            final subtotal = state.items.fold<double>(
              0,
              (sum, item) => sum + item.price,
            );

            const shipping = 10.0;
            final totalPay = (subtotal + shipping).toStringAsFixed(2);
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 300,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final product = state.items[index];
                          return Stack(
                            children: [
                              Container(
                                height: 150,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          product.image,
                                          width: 120,
                                          height: 100,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              product.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              product.category,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              "\$${product.price.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          100,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.grey[400]!,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.expand_more_outlined,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                Text(
                                                  '1',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          100,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.grey[400]!,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.expand_less_outlined,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: IconButton(
                                  icon: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Colors.grey[400]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  onPressed: () {
                                    context.read<CartCubit>().removeFromCart(
                                      product,email
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Delivery Address',
                              style: TextStyle(fontSize: 18),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.keyboard_arrow_right_outlined,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/gps.png',
                                width: 50,
                                height: 50,
                                opacity: AlwaysStoppedAnimation(0.8),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Chhatak, Sunamgonj 12/8AB'),
                                Text(
                                  'Sylhet',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(Icons.done, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Payment Method',
                              style: TextStyle(fontSize: 18),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.keyboard_arrow_right_outlined,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  'assets/images/visa.jpg',
                                  width: 50,
                                  height: 50,
                                  opacity: AlwaysStoppedAnimation(0.8),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Visa Classic'),
                                Text(
                                  '**** 7690',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(Icons.done, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Order Info',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Subtotal',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                                Spacer(),
                                Text(
                                  '\$$subtotal',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Shipping cost',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                                Spacer(),
                                Text(
                                  '\$10',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                                Spacer(),
                                Text(
                                  '\$$totalPay',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  BottomButton(label: 'Checkout', action: checkOut),
                ],
              ),
            );
          }

          return const Center(
            child: Text(
              "Cart is empty",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        },
      ),
    );
  }
}
