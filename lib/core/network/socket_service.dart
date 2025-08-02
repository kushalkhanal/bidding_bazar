import 'dart:async';
import 'dart:io';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  static SocketService get instance => _instance;

  SocketService._internal();

  Socket? _socket;
  final StreamController<Map<String, dynamic>> _bidUpdatesController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _notificationsController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get bidUpdates => _bidUpdatesController.stream;
  Stream<Map<String, dynamic>> get notifications =>
      _notificationsController.stream;

  Future<void> connect() async {
    try {
      // TODO: Replace with your actual WebSocket server URL
      _socket = await Socket.connect('localhost', 8080);

      _socket!.listen(
        (data) {
          final message = String.fromCharCodes(data);
          try {
            // Parse the message as JSON
            final jsonData = Map<String, dynamic>.from(
              // Simple parsing - in production use proper JSON parsing
              {'message': message},
            );
            _bidUpdatesController.add(jsonData);
            _notificationsController.add(jsonData);
          } catch (e) {
            print('Error parsing socket message: $e');
          }
        },
        onError: (error) {
          print('Socket error: $error');
        },
        onDone: () {
          print('Socket connection closed');
        },
      );
    } catch (e) {
      print('Failed to connect to socket: $e');
    }
  }

  void joinAuctionRoom(String auctionId) {
    if (_socket != null) {
      final message = {'type': 'join_auction', 'auctionId': auctionId};
      _socket!.write('${message.toString()}\n');
    }
  }

  void leaveAuctionRoom(String auctionId) {
    if (_socket != null) {
      final message = {'type': 'leave_auction', 'auctionId': auctionId};
      _socket!.write('${message.toString()}\n');
    }
  }

  void sendBid(String auctionId, double amount) {
    if (_socket != null) {
      final message = {
        'type': 'place_bid',
        'auctionId': auctionId,
        'amount': amount,
      };
      _socket!.write('${message.toString()}\n');
    }
  }

  void disconnect() {
    _socket?.destroy();
    _socket = null;
  }

  void dispose() {
    disconnect();
    _bidUpdatesController.close();
    _notificationsController.close();
  }
}
