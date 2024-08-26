import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProductToCart({
    required String name,
    required String price,
    required String image,
    required int quantity,
    required String userId,
  }) async {
    final cartCollection = _firestore.collection('users').doc(userId).collection('cart');

    // Parse the price, handling any potential errors
    final parsedPrice = int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), ''));
    if (parsedPrice == null) {
      throw Exception("Invalid price format: $price");
    }

    try {
      // Check if the product already exists in the cart
      final querySnapshot = await cartCollection.where('Name', isEqualTo: name).get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the item exists, update the quantity and total
        final existingItem = querySnapshot.docs.first;
        final existingQuantity = int.parse(existingItem['Quantity']);
        final newQuantity = existingQuantity + quantity;
        final newTotal = (parsedPrice * newQuantity).toString();

        await existingItem.reference.update({
          'Quantity': newQuantity.toString(),
          'Total': newTotal,
        });
      } else {
        // Add a new cart item
        final cartItem = {
          "Name": name,
          "Price": price,
          "Image": image,
          "Quantity": quantity.toString(),
          "Total": (parsedPrice * quantity).toString(),
        };

        await cartCollection.add(cartItem);
      }
    } catch (e) {
      // Handle the error, e.g., show a message to the user or log the error
      print("Failed to add/update item in cart: $e");
      throw Exception("Failed to add/update item in cart");
    }
  }
}
