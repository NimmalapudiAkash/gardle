import 'package:flutter/material.dart';
import 'package:myapp/AIPage.dart';
import 'package:myapp/product.dart';

class EnhancedHomePage extends StatelessWidget {
  const EnhancedHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          backgroundColor: Colors.deepPurple,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              // Add other menu options here
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final productName = ['kurkure', 'cakes', 'Burger', 'veg'][index];
              final productImage = [
                'images/kurkure.jpg',
                'images/cake.jpg',
                'images/burger.jpg',
                'images/veg.png'
              ][index];
              final productDescription = [
                'Sleek and stylish smartwatch with advanced features',
                'Lightweight and durable fitness tracker to monitor your activity',
                'Truly wireless earbuds with exceptional sound quality',
                'Voice-controlled smart speaker with integrated AI assistant'
              ][index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnhancedProductDetailsPage(
                        productName: productName,
                        productImage: productImage,
                        productDescription: productDescription,
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          productImage,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.black.withOpacity(0.6),
                            child: Text(
                              productName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AIPage()),
            );
          },
          backgroundColor: Colors.deepPurple,
          label: const Text(
            'AI',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: const Icon(Icons.assistant_rounded),
        ));
  }
}
