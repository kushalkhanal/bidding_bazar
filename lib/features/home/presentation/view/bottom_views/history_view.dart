import 'package:bidding_bazar/app/service_locator/service_locator.dart';
import 'package:bidding_bazar/features/auction/presentation/view/bid_history_view.dart';
import 'package:bidding_bazar/features/auction/presentation/view_model/bid_history_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<BidHistoryViewModel>(),
      child: const BidHistoryView(),
    );
  }
}