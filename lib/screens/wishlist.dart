import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/cubits/wishlist/wishlist_cubit.dart';
import 'package:project/cubits/wishlist/wishlist_states.dart';
import 'package:project/screens/product.dart';


class Wishlist extends StatelessWidget {
  const Wishlist({super.key, required this.email, required this.username});

  final String email;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,),
      body: BlocBuilder<WishlistCubit, WishlistStates>(
        builder: (context, state) {
          if (state is WishlistUpdatedState && state.items.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                itemCount: state.items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.5,
                ),
                itemBuilder: (context, index) {
                  final product = state.items[index];
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
                                        id: product.id,
                                        image: product.image,
                                        title: product.title,
                                        category: product.category,
                                        price: product.price,
                                        description: product.description,
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
                                      product.image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: Icon(Icons.favorite, color: Colors.red,),
                                  iconSize: 24,
                                  color: Colors.black54,
                                  onPressed: () {
                                    context
                                        .read<WishlistCubit>()
                                        .removeFromWishlist(product, email);
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
                                product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                product.category,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                '\$${product.price.toString()}',
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
              ),
            );
          }

          return const Center(
            child: Text(
              "Wishlist is empty",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        },
      ),
    );
  }
}
