import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_demo/data/grocery_data.dart';
import 'package:bloc_demo/models/product_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitialState()) {
    on<CartLoadEvent>(cartLoadEvent);
    on<CartRemoveEvent>(cartRemoveEvent);
  }

  //# region cart load event
  FutureOr<void> cartLoadEvent(
      CartLoadEvent event, Emitter<CartState> emit) async {
    // show loading
    emit(CartLoadingState());

    // Simulate a delay for loading data
    await Future.delayed(const Duration(seconds: 3));

    // Here you would typically fetch data from a repository or service
    emit(CartSuccessLoadedState(
        products: GroceryData.groceryProducts
            .where((product) => GroceryData.cartProduct.contains(product["id"]))
            .toList()
            .map((product) => Product.fromJson(product))
            .toList()));
  }
  //# endregion

  //# region cart remove event
  FutureOr<void> cartRemoveEvent(
    CartRemoveEvent event,
    Emitter<CartState> emit,
  ) {
    // Emit a state indicating the product has been removed
    emit(CartRemoveState(productId: event.productId));

    // refresh the cart after removing the product
    /*
      You can either emit a new CartLoadEvent to reload the cart,
      it means recalling the cartLoadEvent method
    **/
    // add(CartLoadEvent());

    /*
     Alternatively, you can directly emit the success state after removing
    not like this, as it will not show the loading state
    **/
    emit(CartSuccessLoadedState(
        products: GroceryData.groceryProducts
            .where((product) => GroceryData.cartProduct.contains(product["id"]))
            .toList()
            .map((product) => Product.fromJson(product))
            .toList()));
  }
  // # endregion
}
