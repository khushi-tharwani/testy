import 'package:testy/constants/colors.dart';
import 'package:testy/data/model/banner_model.dart';
import 'package:testy/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final _control = PageController();

class _HomeState extends State<Home> {
  String? selectedSize;
  String? selectedColor;
  final List<String> sizes = ['6', '7', '8', '9', '10', '11'];
  final List<String> colors = ['Black', 'White', 'Red', 'Blue'];
  final TextEditingController quantityController = TextEditingController();

  void _showAddToCartSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              banners()[index].name ?? 'Shoe',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Size Selector
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Size',
                border: OutlineInputBorder(),
              ),
              value: selectedSize,
              items: sizes
                  .map((size) => DropdownMenuItem(
                        value: size,
                        child: Text(size),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedSize = value),
            ),
            const SizedBox(height: 15),

            // Color Selector
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Color',
                border: OutlineInputBorder(),
              ),
              value: selectedColor,
              items: colors
                  .map((color) => DropdownMenuItem(
                        value: color,
                        child: Text(color),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedColor = value),
            ),
            const SizedBox(height: 15),

            // Quantity Input
            TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Add to Cart Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: mains,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                if (selectedSize != null &&
                    selectedColor != null &&
                    quantityController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item added to cart!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all details')),
                  );
                }
              },
              child: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            AppBarr(),
            SearchBox(),
            bannerr(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ProductDetailScreen(
                              index: index,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 110),
                              child: Image.asset(
                                'images/${index + 1}.webp',
                                height: 200,
                                width: 190,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 155,
                              left: 20,
                              child: Text(
                                banners()[index].name!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 210,
                              right: 0,
                              left: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$ ' + banners()[index].price!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: mains.withOpacity(0.7),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          _showAddToCartSheet(context, index),
                                      child: Container(
                                        child: const Icon(
                                          Icons.shopping_cart_outlined,
                                          color: Colors.white,
                                        ),
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: mains.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(11),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: 4,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 270,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter bannerr() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: PageView(
              controller: _control,
              scrollDirection: Axis.horizontal,
              children: List.generate(
                3,
                (count) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: banner_builder(count),
                  ),
                ),
              ),
            ),
          ),
          SmoothPageIndicator(
            controller: _control,
            count: 3,
            effect: const WormEffect(
              dotHeight: 11,
              dotWidth: 11,
              activeDotColor: Color(0xffFF033E),
            ),
          ),
        ],
      ),
    );
  }

  Row banner_builder(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              'New Release',
              style: TextStyle(
                color: mains,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              banners()[count].name!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Force 1',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              width: 90,
              height: 37,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: mains,
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        RotationTransition(
          turns: const AlwaysStoppedAnimation(-30 / 360),
          child: Image.asset(
            'images/${banners()[count].image!}',
            height: 210,
            width: 210,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter SearchBox() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 15),
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 15),
                    Text(
                      'Search your shoes',
                      style: TextStyle(
                        color: Color.fromARGB(255, 194, 187, 187),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: mains,
                ),
                child: const Icon(
                  Icons.filter_alt,
                  color: Colors.white,
                  size: 27,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter AppBarr() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  'images/nike2_i.png',
                ),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('images/p3.jpg'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}