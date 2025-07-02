import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_demo/data/grocery_data.dart';
import 'package:bloc_demo/features/cart/ui/cart_page.dart';
import 'package:bloc_demo/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeDataLoadEvent>(homeDataLoadEvent);
    on<ProductAddedToCartEvent>(productAddedToCartEvent);
    on<ProductRemovedFromCartEvent>(productRemovedFromCartEvent);
    on<NavigateToCartPageEvent>(navigateToCartPageEvent);
  }

  // #region load data event
  FutureOr<void> homeDataLoadEvent(
    HomeDataLoadEvent event,
    Emitter<HomeState> emit,
  ) async {
    // start loading data
    emit(HomeLoadingState());

// Simulate a network call or data fetching
    await Future.delayed(const Duration(seconds: 2));

    // Here you would typically fetch data from a repository or service
    emit(
      HomeLoadedSuccessState(
        groceryProducts: GroceryData.groceryProducts
            .map((e) => Product.fromJson(e))
            .toList(),
        totalCartItems: GroceryData.cartProduct.length,
      ),
    );
  }
  // #endregion

  // #region add product to cart event
  FutureOr<void> productAddedToCartEvent(
    ProductAddedToCartEvent event,
    Emitter<HomeState> emit,
  ) {
    // Emit an action state when a product is added to the cart
    emit(ProductAddedToCartState(productId: event.productId));

    emit(HomeLoadedSuccessState(
      groceryProducts:
          GroceryData.groceryProducts.map((e) => Product.fromJson(e)).toList(),
      totalCartItems: GroceryData.cartProduct.length,
    ));
  }
  // #endregion

  // #region remove product from cart event
  FutureOr<void> productRemovedFromCartEvent(
      ProductRemovedFromCartEvent event, Emitter<HomeState> emit) {
    // Emit an action state when a product is removed from the cart
    emit(ProductRemovedFromCartState(productId: event.productId));

    // Update the state with the current list of products
    /**
     * this method is only change data if you want to recall loaddata event use other method
     */
    // emit(HomeLoadedSuccessState(
    //   groceryProducts:
    //       GroceryData.groceryProducts.map((e) => Product.fromJson(e)).toList(),
    //   totalCartItems: GroceryData.cartProduct.length,
    // ));

    // Alternatively, you can call the load data event to refresh the state
    add(HomeDataLoadEvent()); // Reload the home data
  }
  // #endregion

  // #region navigate to cart page event
  FutureOr<void> navigateToCartPageEvent(
      NavigateToCartPageEvent event, Emitter<HomeState> emit) {
    // Navigate to the cart page
    Navigator.of(event.context)
        .push(CupertinoPageRoute(builder: (context) => const CartPage()))
        .then((value) {
      // Optionally, you can add logic here to refresh the home page after returning from the cart
      add(HomeDataLoadEvent()); // Reload the home data
    });
  }
  // #endregion
}
