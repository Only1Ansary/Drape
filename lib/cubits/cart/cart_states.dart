import '../../models/product.dart';

abstract class CartStates {}

class CartInitialState extends CartStates {}

class CartUpdatedState extends CartStates {
  final List<Product> items;

  CartUpdatedState({required this.items});
}

class CartErrorState extends CartStates{
  final String message;

  CartErrorState({required this.message});
}
