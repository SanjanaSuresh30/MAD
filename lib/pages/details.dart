import 'package:flutter/material.dart';
import 'package:madfinal/service/cart_service.dart';
import 'package:madfinal/service/shared_pref.dart';
import '../widget/widget_support.dart';

class Details extends StatefulWidget {
  final String name;
  final String price;
  final String image;
  final String detail;

  const Details({
    Key? key,
    required this.name,
    required this.price,
    required this.image,
    required this.detail,
  }) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1;
  late int total;

  @override
  void initState() {
    super.initState();
    total = int.parse(widget.price.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  void updateTotal() {
    setState(() {
      total = quantity * int.parse(widget.price.replaceAll(RegExp(r'[^0-9]'), ''));
    });
  }

  Future<void> addToCart() async {
    // Get user ID from shared preferences
    String? userId = await SharedPreferenceHelper().getUserId();

    if (userId != null) {
      await CartService().addProductToCart(
        name: widget.name,
        price: widget.price,
        image: widget.image,
        quantity: quantity,
        userId: userId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.name} added to cart")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20.0),
            Image.network(
              widget.image,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name, style: AppWidget.boldTextFieldStyle()),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quantity > 1) {
                          --quantity;
                          updateTotal();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.all(5.0),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Text(quantity.toString(), style: AppWidget.semiBoldFieldStyle()),
                    const SizedBox(width: 20.0),
                    GestureDetector(
                      onTap: () {
                        ++quantity;
                        updateTotal();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.all(5.0),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              widget.detail,
              style: AppWidget.normalFieldStyle(),
            ),
            const SizedBox(height: 30.0),
            Row(
              children: [
                Text("Delivery Time", style: AppWidget.semiBoldFieldStyle()),
                const SizedBox(width: 25.0),
                const Icon(
                  Icons.alarm,
                  color: Colors.black54,
                ),
                const SizedBox(width: 5.0),
                Text(
                  "1 week",
                  style: AppWidget.semiBoldFieldStyle(),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price", style: AppWidget.semiBoldFieldStyle(),
                      ),
                      Text("Rs.$total", style: AppWidget.headlineTextFieldStyle(),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: addToCart,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Add to cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontFamily: 'Poppins'),
                          ),
                          const SizedBox(width: 20.0),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
