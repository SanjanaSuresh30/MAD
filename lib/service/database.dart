import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addUserDetail(Map<String,dynamic> userInfoMap,String id)async{
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);

  }
  Future addItem(Map<String,dynamic> userInfoMap,String id)async{
    return await FirebaseFirestore.instance
        .collection('users')
        .add(userInfoMap);


  }
  Future<Stream<QuerySnapshot>> getItem(String name) async{
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }
  Future addItemToCart(Map<String,dynamic> userInfoMap,String id)async{
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
    .collection("Cart")
        .add(userInfoMap);

  }
  Future<Stream<QuerySnapshot>> getCartItem(String userId) async {
    return FirebaseFirestore.instance.collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots();
  }
  Future<void> removeFromCart(String userId, String foodId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .doc(foodId)
        .delete();
  }
}