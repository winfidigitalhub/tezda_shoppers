import 'package:flutter/material.dart';
import '../../model/product_model.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/homescreen_widgets/product_card.dart';
import '../../widgets/more_options_icons.dart';
import 'cart_page.dart';
import 'favorites_page.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with TickerProviderStateMixin {
  late Future<List<Product>> futureProducts;
  late AnimationController _tabAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<Offset> _tabSlideAnimation;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;
  final _auth = AuthService();

  final List<String> categories = [
    'All',
    'Electronics',
    'Jewelery',
    'Men\'s clothing',
    'Women\'s clothing'
  ];

  @override
  void initState() {
    super.initState();

    futureProducts = fetchProducts();

    _tabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _tabSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _tabAnimationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _tabController = TabController(length: categories.length, vsync: this);

    _tabAnimationController.forward();
    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.orange.withOpacity(0.1),
        leading: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              'Tezda',
              style: TextStyle(fontSize: 25,
                  color: Colors.deepOrangeAccent.withOpacity(0.8), fontWeight: FontWeight.w800),
            ),
          ),
        ),
        actions: [

          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const FavoritesPage()),
                );
              },
              icon: const Icon(Icons.favorite_sharp, color: Colors.deepOrangeAccent,)
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
              icon: Image.asset(
                'assets/images/cart.png',
                color: Colors.deepOrangeAccent,
              ),
            ),
          ),

          // Show more options Icon
          MoreOptions(
            onSelected: (value) {
              setState(() {
                switch (value) {
                  case 'signOut':
                    setState(() {
                      _auth.signOut(context);
                    });
                    break;
                }
              });
            },
          ),
        ],
        leadingWidth: MediaQuery.of(context).size.width / 2,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: SlideTransition(
                position: _tabSlideAnimation,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.deepOrangeAccent,
                  unselectedLabelColor: Colors.black,
                  indicator: const BoxDecoration(),
                  tabs: categories.map((category) => Tab(
                    child: InkResponse(
                      onTap: () {
                        _tabController.animateTo(categories.indexOf(category));
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Text(category),
                    ),
                  )).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TabBarView(
              controller: _tabController,
              children: categories.map((category) {
                List<Product> filteredProducts = snapshot.data!.where((product) {
                  if (category == 'All') {
                    return true;
                  } else {
                    return product.category == category.toLowerCase();
                  }
                }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 50),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 50,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    Product product = filteredProducts[index];
                    return ProductCard(product: product);
                  },
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator(
            color: Colors.deepOrangeAccent,
          ));
        },
      ),
    );
  }
}

