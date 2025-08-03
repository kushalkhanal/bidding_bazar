import 'package:bidding_bazar/core/api/api_client.dart';
import 'package:bidding_bazar/features/create_listing/domain/usecases/create_bidding_room.dart';
import 'package:dio/dio.dart';

abstract class CreateListingRemoteDataSource {
  Future<void> createBiddingRoom(CreateBiddingRoomParams params);
}

class CreateListingRemoteDataSourceImpl implements CreateListingRemoteDataSource {
  final ApiClient apiClient;
  late final Dio _dio;

  CreateListingRemoteDataSourceImpl({required this.apiClient}) {
    _dio = apiClient.instance;
  }

  @override
  Future<void> createBiddingRoom(CreateBiddingRoomParams params) async {
    final formData = FormData.fromMap({
      'name': params.name,
      'description': params.description,
      'startingPrice': params.startingPrice,
      'endTime': params.endTime.toIso8601String(),
    });

    for (var file in params.images) {
      formData.files.add(MapEntry(
        'productImages', // This MUST match your backend multer field name
        await MultipartFile.fromFile(file.path, filename: file.name),
      ));
    }

    await _dio.post(
      '/bidding-rooms',
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );
  }
}