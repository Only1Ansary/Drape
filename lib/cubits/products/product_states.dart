
import '../../models/product.dart';

abstract class ProductStates {}

class ProductInitialState extends ProductStates {}

class ProductLoadingState extends ProductStates {}

class ProductLoadedState extends ProductStates {
  final List<Product> products;

  ProductLoadedState({required this.products});
}

class ProductErrorState extends ProductStates {
  final String message;

  ProductErrorState({required this.message});

}