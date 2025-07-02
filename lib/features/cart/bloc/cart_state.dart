part of 'cart_bloc.dart';

abstract class CartState {}

abstract class CartActionState extends CartState {}

class CartInitialState extends CartState {
  CartInitialState();
}

class CartLoadingState extends CartState {
  CartLoadingState();
}

class CartSuccessLoadedState extends CartState {
  final List<Product> products;
  CartSuccessLoadedState({required this.products});
}

class CartRemoveState extends CartState {
  final String productId;
  CartRemoveState({required this.productId}) {
    GroceryData.cartProduct.remove(productId);
  }
}
