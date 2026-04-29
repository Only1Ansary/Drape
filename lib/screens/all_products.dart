import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/screens/product.dart';

import '../cubits/wishlist/wishlist_cubit.dart';
import '../models/product.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key, required this.email, required this.username});

  final String email;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,title: Text('All Products'), centerTitle: true,),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No products found.'));
            }

            final products = snapshot.data!.docs;

            return GridView.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.5,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                final data = product.data() as Map<String, dynamic>;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                      id: data['id'],
                                      image: data['image'],
                                      title: data['title'],
                                      category: data['category'],
                                      price: data['price'],
                                      description: data['description'],
                                      email: email,
                                      username: username,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Image.network(
                                    data['image'],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(Icons.favorite_border),
                                iconSize: 24,
                                color: Colors.black54,
                                onPressed: () {
                                  Product product = Product(
                                    id: data['id'],
                                    title: data['title'],
                                    description: data['description'],
                                    price: data['price'],
                                    image: data['image'],
                                    category: data['category'],
                                  );
                                  if (!context
                                      .read<WishlistCubit>()
                                      .isInWishlist(product)) {
                                    context
                                        .read<WishlistCubit>()
                                        .addToUserWishlist(product, email);
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Item added to Wishlist',
                                        ),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Item already in Wishlist',
                                        ),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['title'] ?? 'Untitled',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              data['category'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              '\$${data['price'].toString()}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
