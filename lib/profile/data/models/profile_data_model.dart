import 'package:bidding_bazar/features/auth/data/models/user_model.dart';
import 'package:bidding_bazar/features/product/data/models/bidding_room_model.dart';
import 'package:bidding_bazar/profile/domain/entities/profile_data_entity.dart';

class BidHistoryModel extends BidHistoryEntity {
  const BidHistoryModel({required super.winning, required super.activeOrOutbid});

  factory BidHistoryModel.fromJson(Map<String, dynamic> json) {
    return BidHistoryModel(
      winning: (json['winning'] as List)
          .map((item) => BiddingRoomModel.fromJson(item))
          .toList(),
      activeOrOutbid: (json['activeOrOutbid'] as List)
          .map((item) => BiddingRoomModel.fromJson(item))
          .toList(),
    );
  }
}

class ProfileDataModel extends ProfileDataEntity {
  const ProfileDataModel({
    required super.profile,
    required super.listedItems,
    required super.bidHistory,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileDataModel(
      profile: UserModel.fromJson(json['profile']),
      listedItems: (json['listedItems'] as List)
          .map((item) => BiddingRoomModel.fromJson(item))
          .toList(),
      bidHistory: BidHistoryModel.fromJson(json['bidHistory']),
    );
  }
}