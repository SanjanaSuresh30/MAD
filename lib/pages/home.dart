import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:madfinal/service/database.dart';
import '../widget/widget_support.dart';
import '../pages/details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool painting = true, embroidery = false, lantern = false, pottery = false;
  String selectedCategory = "Painting";
  Stream? itemStream;

  ontheload(String category) async {
    itemStream = await DatabaseMethods().getItem(category);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload(selectedCategory);
  }

  String getImagePath(String category) {
    switch (category.toLowerCase()) {
      case 'painting':
        return 'images/MAD-images/painting.png';
      case 'embroidery':
        return 'images/MAD-images/embroidery.png';
      case 'lantern':
        return 'images/MAD-images/lantern.jpeg';
      case 'pottery':
        return 'images/MAD-images/pottery.webp';
      default:
        return 'images/MAD-images/default.png';
    }
  }

  Widget verticalItems() {
    return StreamBuilder(
      stream: itemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final items = snapshot.data.docs;
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: items.length,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              DocumentSnapshot ds = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(
                        name: ds["Name"],
                        price: ds["Price"],
                        image: ds["Image"],
                        detail: ds["Detail"],

                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                ds["Image"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ds["Name"],
                                  style: AppWidget.semiBoldFieldStyle(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  "Rs " + ds["Price"],
                                  style: AppWidget.semiBoldFieldStyle(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hello Sanjana,",
                      style: AppWidget.boldTextFieldStyle(),
                    ),
                    const Icon(Icons.shopping_cart, color: Colors.black),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Welcome to Folklore Finds!",
                  style: AppWidget.headlineTextFieldStyle(),
                ),
                Text(
                  "Empower your Desi spirits",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(height: 30.0),
                showItem(),
                const SizedBox(height: 30.0),
                verticalItems(),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        categoryWidget("Painting", painting),
        categoryWidget("Embroidery", embroidery),
        categoryWidget("Lantern", lantern),
        categoryWidget("Pottery", pottery),
      ],
    );
  }

  Widget categoryWidget(String category, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
          painting = category == "Painting";
          embroidery = category == "Embroidery";
          lantern = category == "Lantern";
          pottery = category == "Pottery";
        });
        ontheload(category);
      },
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 40,
            width: 40,
            child: Image.asset(
              getImagePath(category),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}