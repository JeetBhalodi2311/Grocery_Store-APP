part of 'cart_bloc.dart';

abstract class CartEvent {}

class CartLoadEvent extends CartEvent {
  CartLoadEvent();
}

class CartRemoveEvent extends CartEvent {
  final String productId;
  CartRemoveEvent({required this.productId});
}
