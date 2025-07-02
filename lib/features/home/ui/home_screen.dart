import 'package:bloc_demo/features/home/bloc/home_bloc.dart';
import 'package:bloc_demo/models/product_model.dart';
import 'package:bloc_demo/widget/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    homeBloc.add(HomeDataLoadEvent());
  }

  final HomeBloc homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    print("rendering home screen");
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      bloc: homeBloc,
      listener: (context, state) {
        if (state is ProductAddedToCartState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product added to cart: ${state.productId}'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (state is ProductRemovedFromCartState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product removed from cart: ${state.productId}'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case HomeLoadedSuccessState:
            final successState = state as HomeLoadedSuccessState;
            return Scaffold(
              appBar: AppBar(
                title: Text('Grocery App'),
                actions: [
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.favorite_border)),
                  IconButton(
                      onPressed: () {
                        homeBloc.add(NavigateToCartPageEvent(context: context));
                      },
                      icon: Stack(
                        children: [
                          Icon(Icons.shopping_bag_outlined,
                              applyTextScaling: false),
                          Positioned(
                            right: 0,
                            top: -5,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                successState.totalCartItems.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
              body: ListView.builder(
                itemCount: successState.groceryProducts.length,
                itemBuilder: (context, index) {
                  Product product = successState.groceryProducts[index];
                  return ProductWidget<HomeBloc>(
                      productDataModel: product, bloc: homeBloc);
                },
              ),
            );
          case HomeLoadedFailureState:
            final failureState = state as HomeLoadedFailureState;
            return Center(
              child: Text(failureState.errorMessage),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
