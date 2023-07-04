import 'package:freezed_annotation/freezed_annotation.dart';

part 'response.freezed.dart';

@freezed
class Response with _$Response {
  const factory Response({
    required String textResponse,
    required String imageUrl,
  }) = _Response;
}
