import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/product.dart';
import 'wishlist_states.dart';

class WishlistCubit extends Cubit<WishlistStates> {
  WishlistCubit() : super(WishlistInitialState());

  final List<Product> _wishlistItems = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _wishlistSubscription;
  String? _currentEmail;

  Future<void> fetchWishlist(String email) async {
    try {
      // Prevent redundant listeners for same user
      if (_currentEmail == email && _wishlistSubscription != null) return;

      await _wishlistSubscription?.cancel();
      _currentEmail = email;

      final docRef = _firestore.collection('wishlists').doc(email);

      // Auto-create doc if missing
      final doc = await docRef.get();
      if (!doc.exists) {
        await docRef.set({'email': email, 'items': []});
      }

      _wishlistSubscription = docRef.snapshots().listen((snapshot) {
        final data = snapshot.data();

        if (snapshot.exists && data != null && data['items'] is List) {
          final items = (data['items'] as List)
              .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          _wishlistItems
            ..clear()
            ..addAll(items);

          emit(WishlistUpdatedState(items: List.from(_wishlistItems)));
        } else {
          _wishlistItems.clear();
          emit(WishlistUpdatedState(items: []));
        }
      }, onError: (error) {
        emit(WishlistErrorState(message: 'Stream error: $error'));
      });
    } catch (e) {
      emit(WishlistErrorState(message: e.toString()));
    }
  }


  Future<void> addToUserWishlist(Product product, String userEmail) async {
    try {
      final userWishlistRef = _firestore.collection('wishlists').doc(userEmail);

      await userWishlistRef.set({
        'email': userEmail,
        'items': FieldValue.arrayUnion([
          {
            'id': product.id,
            'title': product.title,
            'price': product.price,
            'image': product.image,
            'category': product.category,
            'description': product.description,
          }
        ])
      }, SetOptions(merge: true));
      // listener will pick changes up
    } catch (e) {
      emit(WishlistErrorState(message: e.toString()));
    }
  }

  Future<void> removeFromWishlist(Product product, String userEmail) async {
    try {
      final userWishlistRef = _firestore.collection('wishlists').doc(userEmail);

      await userWishlistRef.update({
        'items': FieldValue.arrayRemove([
          {
            'id': product.id,
            'title': product.title,
            'price': product.price,
            'image': product.image,
            'category': product.category,
            'description': product.description,
          }
        ])
      });
      // listener will update local
    } catch (e) {
      emit(WishlistErrorState(message: e.toString()));
    }
  }

  bool isInWishlist(Product product) {
    for (int i = 0; i < _wishlistItems.length; i++) {
      if (product.id == _wishlistItems[i].id) {
        return true;
      }
    }
    return false;
  }

}
