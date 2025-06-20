// lib/core/error/exceptions.dart

// Thrown when an error occurs during an API call.
class ServerException implements Exception {}

// Thrown when an error occurs with the local cache (Hive).
class CacheException implements Exception {}