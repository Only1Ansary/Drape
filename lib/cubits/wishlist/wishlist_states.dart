import '../../models/product.dart';

abstract class WishlistStates {}

class WishlistInitialState extends WishlistStates {}

class WishlistUpdatedState extends WishlistStates {
  final List<Product> items;

  WishlistUpdatedState({required this.items});
}

class WishlistErrorState extends WishlistStates {
  final String message;

  WishlistErrorState({required this.message});

}
