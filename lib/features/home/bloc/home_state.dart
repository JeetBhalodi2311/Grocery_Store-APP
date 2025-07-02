part of 'home_bloc.dart';

abstract class HomeState {}

// Initial state for the home screen
// This state is used to indicate that the home screen has not yet been initialized
abstract class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedSuccessState extends HomeState {
  final List<Product> groceryProducts;
  final int totalCartItems;

  HomeLoadedSuccessState(
      {required this.groceryProducts, required this.totalCartItems});
}

class HomeLoadedFailureState extends HomeState {
  final String errorMessage;

  HomeLoadedFailureState({required this.errorMessage});
}

class ProductAddedToCartState extends HomeActionState {
  final String productId;
  ProductAddedToCartState({required this.productId}) {
    GroceryData.cartProduct.add(productId);
  }
}

class ProductRemovedFromCartState extends HomeActionState {
  final String productId;
  ProductRemovedFromCartState({required this.productId}) {
    GroceryData.cartProduct.remove(productId);
  }
}
