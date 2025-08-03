import 'package:bidding_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';
import 'package:equatable/equatable.dart';

class BidHistoryEntity extends Equatable {
  final List<BiddingRoomEntity> winning;
  final List<BiddingRoomEntity> activeOrOutbid;

  const BidHistoryEntity({required this.winning, required this.activeOrOutbid});
  
  @override
  List<Object?> get props => [winning, activeOrOutbid];
}

class ProfileDataEntity extends Equatable {
  final UserEntity profile;
  final List<BiddingRoomEntity> listedItems;
  final BidHistoryEntity bidHistory;

  const ProfileDataEntity({
    required this.profile,
    required this.listedItems,
    required this.bidHistory,
  });

  @override
  List<Object?> get props => [profile, listedItems, bidHistory];
}