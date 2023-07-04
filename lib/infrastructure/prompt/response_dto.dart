import 'package:vocalis_ai/domain/prompt/response.dart';

class ResponseDto {
  final String textResponse;
  final String imageUrl;

  ResponseDto({
    required this.textResponse,
    required this.imageUrl,
  });

  Response toDomain() => Response(
        textResponse: textResponse,
        imageUrl: imageUrl,
      );

  factory ResponseDto.fromTextResponse(Map<String, dynamic> json) {
    return ResponseDto(
      textResponse: json['choices'][0]['message']['content'],
      imageUrl: "",
    );
  }

  factory ResponseDto.fromImageResponse(Map<String, dynamic> json) {
    return ResponseDto(
      textResponse: "",
      imageUrl: json['data'][0]['url'],
    );
  }
}
