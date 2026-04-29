import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/cubits/auth/auth_cubit.dart';
import 'package:project/cubits/wishlist/wishlist_cubit.dart';
import 'package:project/models/product.dart';
import 'package:project/screens/all_products.dart';
import 'package:project/screens/cart.dart';
import 'package:project/screens/product.dart';
import 'package:project/screens/profile.dart';
import 'package:project/screens/wishlist.dart';
import 'package:project/widgets/brand_item.dart';
import 'first.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.username, required this.email});

  final String username;
  final String email;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  bool isDark = false;

  late final List<Widget> _pages = [
    HomePage(email: widget.email, username: widget.username),
    Wishlist(email: widget.email, username: widget.username),
    Cart(email: widget.email, username: widget.username),
    Profile(username: widget.username, email: widget.email),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                    MaterialPageRoute(
                      builder: (context) =>
                          Cart(email: widget.email, username: widget.username),
                    ),
                  );
                },
                icon: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.username,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      Row(
                        children: [
                          Text(
                            'Verified Profile',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.verified, color: Colors.green, size: 16),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  SizedBox(
                    height: 40,
                    width: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(15, 0, 0, 0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          ' Orders',
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.light_mode_outlined, size: 30),
              title: Row(
                children: [
                  Text('Dark Mode', style: TextStyle(fontSize: 14)),
                  Spacer(),
                  Switch(
                    value: isDark,
                    activeTrackColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        if (isDark) {
                          isDark = false;
                        } else {
                          isDark = true;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Profile(username: widget.username, email: widget.email),
                  ),
                );
              },
              leading: Icon(Icons.error_outline, size: 30),
              title: Text(
                'Account Information',
                style: TextStyle(fontSize: 14),
              ),
            ),
            ListTile(
              leading: Icon(Icons.lock_outline, size: 30),
              title: Text('Password', style: TextStyle(fontSize: 14)),
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag_outlined, size: 30),
              title: Text('Order', style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Cart(email: widget.email, username: widget.username),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet_outlined, size: 30),
              title: Text('My Cards', style: TextStyle(fontSize: 14)),
            ),
            ListTile(
              leading: Icon(Icons.favorite_border, size: 30),
              title: Text('Wishlist', style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Wishlist(
                      email: widget.email,
                      username: widget.username,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined, size: 30),
              title: Text('Settings', style: TextStyle(fontSize: 14)),
            ),
            SizedBox(height: 140),
            ListTile(
              leading: Icon(Icons.logout_outlined, size: 30, color: Colors.red),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
              onTap: () {
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
                        borderRadius: BorderRadiusGeometry.circular(35),
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
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.email, required this.username});

  final String email;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Welcome to Laza', style: TextStyle(color: Colors.black26)),
          SizedBox(height: 15),
          Row(
            children: [
              SizedBox(
                height: 60,
                width: 290,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black12,
                  ),
                  child: Center(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                height: 60,
                width: 50,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(150, 50, 20, 255),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.keyboard_voice_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            children: [
              Row(
                children: [
                  Text('Choose Brand', style: TextStyle(fontSize: 18)),
                  Spacer(),
                  Text('View All', style: TextStyle(color: Colors.black38)),
                ],
              ),
              SizedBox(height: 20),
              // --- Brand section (unchanged) ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  children: [
                    BrandItem('assets/images/nike.jpeg', 'Nike'),
                    BrandItem('assets/images/adidas.png', 'Adidas'),
                    BrandItem('assets/images/fila.jpg', 'Fila'),
                    BrandItem('assets/images/puma.png', 'Puma'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text('New Arrival', style: TextStyle(fontSize: 18)),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AllProducts(email: email, username: username),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(color: Colors.black38),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          Expanded(
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
        ],
      ),
    );
  }
}
