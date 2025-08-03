
import 'package:bidding_bazar/core/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClient {
  io.Socket? _socket;

  // Singleton setup
  SocketClient._privateConstructor();
  static final SocketClient _instance = SocketClient._privateConstructor();
  factory SocketClient() {
    return _instance;
  }
  
  final String _socketUrl = AppConstants.baseUrl.replaceAll("/api", "");

  void connect() {
    if (_socket != null && _socket!.connected) {
      print('Socket is already connected.');
      return;
    }

    _socket = io.io(_socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    
    _socket!.connect();

    _socket!.onConnect((_) => print('Socket connected: ${_socket?.id}'));
    _socket!.onDisconnect((_) => print('Socket disconnected'));
    _socket!.onConnectError((data) => print('Connection Error: $data'));
    _socket!.onError((data) => print('Socket Error: $data'));
  }

  // --- Product Room Methods ---
  void joinProductRoom(String productId) {
    if (_socket == null || !_socket!.connected) return;
    _socket!.emit('join_product_room', productId);
    print('Joined product room: $productId');
  }
  
  void listenForBidUpdates(Function(dynamic) handler) {
    _socket?.on('bid_update', handler);
  }

  void leaveProductRoom(String productId) {
    if (_socket == null || !_socket!.connected) return;
    _socket!.emit('leave_product_room', productId);
    print('Left product room: $productId');
  }


  /// Joins the user's private room to receive personal notifications.
  void joinUserRoom(String userId) {
    if (_socket == null || !_socket!.connected) return;
    _socket!.emit('join_user_room', userId);
    print('Joined user room: $userId');
  }

  /// Listens for the 'new_notification' event from the server.
  void listenForNewNotification(Function(dynamic) handler) {
    _socket?.on('new_notification', handler);
  }


  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}