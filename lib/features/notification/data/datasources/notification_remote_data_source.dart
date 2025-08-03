import 'package:bidding_bazar/core/api/api_client.dart';
import 'package:bidding_bazar/features/notification/data/models/notification_model.dart';
import 'package:dio/dio.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getMyNotifications();
  Future<void> markNotificationsAsRead();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;
  late final Dio _dio;

  NotificationRemoteDataSourceImpl({required this.apiClient}) {
    _dio = apiClient.instance;
  }

  @override
  Future<List<NotificationModel>> getMyNotifications() async {
    final response = await _dio.get('/notifications');
    return (response.data as List).map((n) => NotificationModel.fromJson(n)).toList();
  }

  @override
  Future<void> markNotificationsAsRead() async {
    await _dio.put('/notifications/read');
  }
}