import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/widgets/bottom_button.dart';

import '../cubits/cart/cart_cubit.dart';
import '../models/product.dart';
import '../widgets/expandable_text.dart';
import 'cart.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({
    super.key,
    required this.image,
    required this.title,
    required this.category,
    required this.price,
    required this.description, required this.id, required this.email, required this.username,
  });

  final int id;
  final String image;
  final String title;
  final String category;
  final double price;
  final String description;
  final String email;
  final String username;

  void goCart(BuildContext context) {
    Product product = Product(
      id: id,
      title: title,
      description: description,
      price: price,
      image: image,
      category: category,
    );
    context.read<CartCubit>().addToCart(product, email);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to Cart successfully'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cart(email: email, username: username,)),
                  );
                },
                icon: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                    image,
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Price',
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              category,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '\$${price.toString()}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ExpandableText(description),
                        SizedBox(height: 40),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Total Price',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'with VAT,SD',
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Text(
                              '\$${price.toString()}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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

          SafeArea(
            child: BottomButton(label: 'Add to Cart', action: goCart),
          ),
        ],
      ),
    );
  }
}
