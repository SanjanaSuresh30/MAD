import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:madfinal/service/database.dart';
import 'package:madfinal/service/shared_pref.dart';
import 'package:madfinal/widget/widget_support.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id, wallet;
  Stream? foodStream;

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  Future<void> getSharedPref() async {
    id = await SharedPreferenceHelper().getUserId();
    wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  Future<void> onTheLoad() async {
    await getSharedPref();
    foodStream = await DatabaseMethods().getCartItem(id!);
    setState(() {});
  }

  int calculateTotal(AsyncSnapshot snapshot) {
    int total = 0;
    for (var ds in snapshot.data.docs) {
      total += int.parse(ds["Total"]);
    }
    return total;
  }

  Widget foodCart() {
    return StreamBuilder(
        stream: foodStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];

                return Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            height: 90,
                            width: 40,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(child: Text(ds["Quantity"])),
                          ),
                          const SizedBox(width: 20.0),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.network(
                                ds["Image"],
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              )
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ds["Name"],
                                  style: AppWidget.semiBoldFieldStyle(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Rs." + ds["Total"],
                                  style: AppWidget.semiBoldFieldStyle(),
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Remove Item"),
                                    content: Text("Are you sure you want to remove this item from your cart?"),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Remove"),
                                        onPressed: () {
                                          DatabaseMethods().removeFromCart(id!, ds.id);
                                          Navigator.of(context).pop();
                                        },
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
                  ),
                );
              }
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
                elevation: 2.0,
                child: Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Center(
                        child: Text(
                          "Item Cart",
                          style: AppWidget.headlineTextFieldStyle(),
                        )
                    )
                )
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: foodCart(),
            ),
            const Divider(),
            StreamBuilder(
              stream: foodStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                int total = calculateTotal(snapshot);
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Price",
                        style: AppWidget.boldTextFieldStyle(),
                      ),
                      Text(
                        "Rs.$total",
                        style: AppWidget.boldTextFieldStyle(),
                      )
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
                int total = calculateTotal(await foodStream?.first);
                int amount = int.parse(wallet!) - total;
                await SharedPreferenceHelper().saveUserWallet(amount.toString());

                // Add more functionality here after checkout, like clearing the cart, etc.
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)
                ),
                margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: const Center(
                    child: Text(
                      "CheckOut",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}