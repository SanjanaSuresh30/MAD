class UnboardingContent {
  String image;
  String title;
  String description;

  UnboardingContent({
    required this.description,
    required this.image,
    required this.title,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    description: "Pick your choice of artwork,\n  handicrafts and paintings",
    image: 'images/MAD-images/cropped1.png', // Replace with your actual image path or URL
    title: 'Select from our\nFinest Collection',
  ),
  UnboardingContent(
    description: "You can pay Cash on Delivery and\nCard payment is available",
    image: 'images/MAD-images/screen2.png', // Replace with your actual image path or URL
    title: 'Easy and Online Payments',
  ),
];
