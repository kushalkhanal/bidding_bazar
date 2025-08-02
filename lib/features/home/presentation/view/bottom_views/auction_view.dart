import 'package:bidding_bazar/app/service_locator/service_locator.dart';
import 'package:bidding_bazar/features/auction/presentation/view/auction_list_view.dart';
import 'package:bidding_bazar/features/auction/presentation/view_model/auction_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuctionView extends StatelessWidget {
  const AuctionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AuctionListViewModel>(),
      child: const AuctionListView(),
    );
  }
}