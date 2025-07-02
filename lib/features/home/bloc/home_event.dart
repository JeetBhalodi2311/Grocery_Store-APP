part of 'home_bloc.dart';

abstract class HomeEvent {}

// Event to load data for the home screen
class HomeDataLoadEvent extends HomeEvent {}

class ProductAddedToCartEvent extends HomeEvent {
  final String productId;

  ProductAddedToCartEvent({required this.productId});
}

class ProductRemovedFromCartEvent extends HomeEvent {
  final String productId;
  ProductRemovedFromCartEvent({required this.productId});
}

class NavigateToCartPageEvent extends HomeEvent {
  final BuildContext context;
  NavigateToCartPageEvent({required this.context});
}
