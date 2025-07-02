import 'package:bloc_demo/data/grocery_data.dart';
import 'package:bloc_demo/features/cart/bloc/cart_bloc.dart';
import 'package:bloc_demo/features/home/bloc/home_bloc.dart';
import 'package:bloc_demo/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductWidget<T> extends StatelessWidget {
  final Product productDataModel;
  final T bloc;
  const ProductWidget(
      {super.key, required this.productDataModel, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.maxFinite,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(productDataModel.imageUrl))),
          ),
          const SizedBox(height: 20),
          Text(productDataModel.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(productDataModel.description),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("\$" + productDataModel.price.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.favorite_border)),
                  IconButton(
                      onPressed: () {
                        // Add product to cart
                        if (GroceryData.cartProduct
                            .contains(productDataModel.id)) {
                          if (bloc is HomeBloc) {
                            (bloc as HomeBloc).add(ProductRemovedFromCartEvent(
                                productId: productDataModel.id));
                          } else if (bloc is CartBloc) {
                            (bloc as CartBloc).add(CartRemoveEvent(
                                productId: productDataModel.id));
                          }
                        } else {
                          if (bloc is HomeBloc) {
                            (bloc as HomeBloc).add(ProductAddedToCartEvent(
                                productId: productDataModel.id));
                          }
                        }
                      },
                      icon: Icon(
                          GroceryData.cartProduct.contains(productDataModel.id)
                              ? Icons.shopify_rounded
                              : Icons.shopping_bag_outlined)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
