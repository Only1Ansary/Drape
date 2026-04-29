import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product.dart';
import 'cart_states.dart';

class CartCubit extends Cubit<CartStates> {
  CartCubit() : super(CartInitialState());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Product> _cartItems = [];
  StreamSubscription<DocumentSnapshot>? _cartSubscription;
  String? _currentEmail;

  /// Start listening to user's cart in Firestore
  Future<void> fetchCartItems(String email) async {
    try {
      // Prevent redundant listeners for same user
      if (_currentEmail == email && _cartSubscription != null) return;

      await _cartSubscription?.cancel();
      _currentEmail = email;

      final docRef = _firestore.collection('cart').doc(email);

      // Auto-create doc if missing
      final doc = await docRef.get();
      if (!doc.exists) {
        await docRef.set({'email': email, 'cartItems': []});
      }

      _cartSubscription = docRef.snapshots().listen((snapshot) {
        final data = snapshot.data();

        if (snapshot.exists && data != null && data['cartItems'] is List) {
          final items = (data['cartItems'] as List)
              .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          _cartItems
            ..clear()
            ..addAll(items);

          emit(CartUpdatedState(items: List.from(_cartItems)));
        } else {
          _cartItems.clear();
          emit(CartUpdatedState(items: []));
        }
      }, onError: (error) {
        emit(CartErrorState(message: 'Stream error: $error'));
      });
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  Future<void> addToCart(Product product, String userEmail) async {
    try {
      final userCartRef = _firestore.collection('cart').doc(userEmail);

      await userCartRef.set({
        'email': userEmail,
        'cartItems': FieldValue.arrayUnion([
          {
            'id': product.id,
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'image': product.image,
            'category': product.category,
          },
        ]),
      }, SetOptions(merge: true));

      // Local update
      if (!_cartItems.any((p) => p.id == product.id)) {
        _cartItems.add(product);
        emit(CartUpdatedState(items: List.from(_cartItems)));
      }
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  Future<void> removeFromCart(Product product, String userEmail) async {
    try {
      final userCartRef = _firestore.collection('cart').doc(userEmail);

      await userCartRef.update({
        'cartItems': FieldValue.arrayRemove([
          {
            'id': product.id,
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'image': product.image,
            'category': product.category,
          },
        ])
      });

      _cartItems.removeWhere((p) => p.id == product.id);
      emit(CartUpdatedState(items: List.from(_cartItems)));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  Future<void> stopListening() async {
    await _cartSubscription?.cancel();
    _cartSubscription = null;
    _currentEmail = null;
  }

  Future<void> clearCart(String userEmail) async {
    try {
      final userCartRef = _firestore.collection('cart').doc(userEmail);

      // Set cartItems to an empty list in Firestore
      await userCartRef.update({
        'cartItems': [],
      });

      // Clear local list
      _cartItems.clear();

      // Emit updated state
      emit(CartUpdatedState(items: []));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }


  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
