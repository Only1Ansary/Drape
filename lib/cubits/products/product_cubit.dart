import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/cubits/products/product_states.dart';
import '../../services/api_services.dart';
import '../../services/firestore_services.dart';
class ProductCubit extends Cubit<ProductStates> {
  ProductCubit(this.firestoreServices) : super(ProductInitialState());

  final FirebaseServices firestoreServices;

  Future<void> fetchProducts() async {
    emit(ProductLoadingState());

    // try {
    //   final products = await firestoreServices.fetchProducts();
    //   emit(ProductLoadedState(products: products));
    // } catch (e) {
    //   emit(ProductErrorState(message: e.toString()));
    // }
  }
}
