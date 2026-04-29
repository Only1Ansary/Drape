import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/product.dart';
import 'package:dio/dio.dart';

class ApiServices {
  final Dio _dio = Dio();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> fetchProducts() async {
    final response = await _dio.get("https://fakestoreapi.com/products");
    return (response.data as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }

  Future<void> uploadProductsToFirestore() async {
    try {
      final products = await fetchProducts();
      final batch = _firestore.batch();

      for (var product in products) {
        final docRef = _firestore.collection('products').doc(product.id.toString());
        batch.set(docRef, {
          'id': product.id,
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'image': product.image,
          'category': product.category
        });
      }

      await batch.commit();
      print('✅ All products uploaded successfully!');
    } catch (e) {
      print('❌ Error uploading products: $e');
    }
  }
}
