
import 'package:flutter/material.dart';







class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class WishlistItem {
  final Product product;

  WishlistItem({required this.product});
}

class WishlistItemWidget extends StatelessWidget {
  final WishlistItem wishlistItem;

  WishlistItemWidget({required this.wishlistItem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(wishlistItem.product.name),
      leading: CircleAvatar(
        backgroundImage: AssetImage(wishlistItem.product.imageUrl),
      ),
      onTap: () {
        // Implement product details or removal from wishlist
        // For simplicity, let's remove the item from the wishlist
        Wishlist.removeFromWishlist(wishlistItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${wishlistItem.product.name} removed from the wishlist'),
          ),
        );
      },
    );
  }
}

class ShoppingCart {
  static List<CartItem> _cartItems = [];

  static List<CartItem> get cartItems => _cartItems;

  static void addToCart(Product product) {
    var existingItem = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity == 0) {
      _cartItems.add(CartItem(product: product, quantity: 1));
    } else {
      _cartItems[_cartItems.indexOf(existingItem)] =
          CartItem(product: product, quantity: existingItem.quantity + 1);
    }
  }

  static void removeFromCart(CartItem cartItem) {
    _cartItems.remove(cartItem);
  }

  static double calculateTotal() {
    return _cartItems.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }
}

class Wishlist {
  static List<WishlistItem> _wishlistItems = [];

  static List<WishlistItem> get wishlistItems => _wishlistItems;

  static void addToWishlist(Product product) {
    var existingItem = _wishlistItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => WishlistItem(product: product),
    );

    if (!_wishlistItems.contains(existingItem)) {
      _wishlistItems.add(WishlistItem(product: product));
    }
  }

  static void removeFromWishlist(WishlistItem wishlistItem) {
    _wishlistItems.remove(wishlistItem);
  }
}

class ShoppingCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: ShoppingCart.cartItems.isEmpty
          ? Center(
              child: Text('Your shopping cart is empty.'),
            )
          : ListView.builder(
              itemCount: ShoppingCart.cartItems.length,
              itemBuilder: (context, index) {
                var cartItem = ShoppingCart.cartItems[index];
                return ProductCartItem(cartItem: cartItem);
              },
            ),
      bottomNavigationBar: ShoppingCart.cartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total: \$${ShoppingCart.calculateTotal().toStringAsFixed(2)}'),
                  ElevatedButton(
                    onPressed: () {
                      // Implement checkout functionality
                      // For simplicity, let's clear the cart for now
                      ShoppingCart.cartItems.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Checkout successful'),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart),
                        SizedBox(width: 8),
                        Text('Checkout'),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class ProductCartItem extends StatelessWidget {
  final CartItem cartItem;

  ProductCartItem({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cartItem.product.name),
      subtitle: Text('Quantity: ${cartItem.quantity}'),
      trailing: Text('\$${cartItem.product.price * cartItem.quantity}'),
      leading: CircleAvatar(
        backgroundImage: AssetImage(cartItem.product.imageUrl),
      ),
      onTap: () {
        // Implement product details or removal from cart
        // For simplicity, let's remove the item from the cart
        ShoppingCart.removeFromCart(cartItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${cartItem.product.name} removed from the cart'),
          ),
        );
      },
    );
  }
}

class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: Wishlist.wishlistItems.isEmpty
          ? Center(
              child: Text('Your wishlist is empty.'),
            )
          : ListView.builder(
              itemCount: Wishlist.wishlistItems.length,
              itemBuilder: (context, index) {
                var wishlistItem = Wishlist.wishlistItems[index];
                return WishlistItemWidget(wishlistItem: wishlistItem);
              },
            ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text('Description: ${product.description}'),
            Text('Price: \$${product.price}'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ShoppingCart.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to the cart'),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_cart),
                      SizedBox(width: 8),
                      Text('Add to Cart'),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Wishlist.addToWishlist(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to the wishlist'),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite),
                      SizedBox(width: 8),
                      Text('Add to Wishlist'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          final MaterialPageRoute<dynamic> materialPageRoute = MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(product: widget.product),
            );
          Navigator.push(
            context,
            materialPageRoute,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      widget.product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ShoppingCart.addToCart(widget.product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${widget.product.name} added to the cart'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Wishlist.addToWishlist(widget.product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${widget.product.name} added to the wishlist'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Add to Wishlist',
                      style: TextStyle(color: Colors.white),
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


class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Product 1',
      description: 'Description of Product 1',
      price: 29.99,
      imageUrl: 'assets/55.png', // Update with your actual image path
    ),
Product(
      id: '2',
      name: 'Product 2',
      description: 'Description of Product 2',
      price: 39.99,
      imageUrl: 'assets/66.png', // Update with your actual image path
    ),
Product(
      id: '3',
      name: 'Product 3',
      description: 'Description of Product 3',
      price: 70.99,
      imageUrl: 'assets/3.png', // Update with your actual image path
    ),
Product(
      id: '4',
      name: 'Product 4',
      description: 'Description of Product 4',
      price: 20.99,
      imageUrl: 'assets/4.png', // Update with your actual image path
    ),

Product(
      id: '5',
      name: 'Product 5',
      description: 'Description of Product 5',
      price: 20.99,
      imageUrl: 'assets/77.png', // Update with your actual image path
    ),


Product(
      id: '6',
      name: 'Product 6',
      description: 'Description of Product 6',
      price: 20.99,
      imageUrl: 'assets/99.png', // Update with your actual image path
    ),
    // Add more products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              final MaterialPageRoute<dynamic> materialPageRoute = MaterialPageRoute(
                  builder: (context) => ShoppingCartScreen(),
                );
              Navigator.push(
                context,
                materialPageRoute,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              final MaterialPageRoute<dynamic> materialPageRoute = MaterialPageRoute(
                  builder: (context) => WishlistScreen(),
                );
              Navigator.push(
                context,
                materialPageRoute,
              );
            },
          ),
        ],
      ),





  drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'E-commerce App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Wishlist'),
              onTap: () {
                final MaterialPageRoute<dynamic> materialPageRoute = MaterialPageRoute(
                    builder: (context) => WishlistScreen(),
                  );
                Navigator.push(
                  context,
                  materialPageRoute,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Shopping Cart'),
              onTap: () {
                final MaterialPageRoute<dynamic> materialPageRoute = MaterialPageRoute(
                    builder: (context) => ShoppingCartScreen(),
                  );
                Navigator.push(
                  context,
                  materialPageRoute,
                );
              },
            ),
          ],
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}