import 'package:bloc_demo/features/cart/bloc/cart_bloc.dart';
import 'package:bloc_demo/models/product_model.dart';
import 'package:bloc_demo/widget/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartBloc cartBloc = CartBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartBloc.add(CartLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      bloc: cartBloc,
      listenWhen: (previous, current) => current is CartActionState,
      buildWhen: (previous, current) => current is! CartActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case CartLoadingState:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case CartSuccessLoadedState:
            List<Product> product = (state as CartSuccessLoadedState).products;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Cart'),
                actions: [
                  Text(product.length.toString()),
                ],
              ),
              body: ListView.builder(
                itemCount: product.length,
                itemBuilder: (context, index) {
                  return ProductWidget<CartBloc>(
                      productDataModel: product[index], bloc: cartBloc);
                },
              ),
            );
          default:
            return SizedBox();
        }
      },
    );
  }
}
