

abstract class GeminiError {
  final String errorMessage;
GeminiError({required this.errorMessage});
}

final class GeminiGenerativeAiException extends GeminiError {

  GeminiGenerativeAiException({required super.errorMessage});
}


final class GeminiUnexpectedFailure extends GeminiError {

  GeminiUnexpectedFailure({required super.errorMessage});
}


final class GeminiServerException extends GeminiError {

  GeminiServerException({required super.errorMessage});
}

final class GeminiResponseFormatException extends GeminiError {
  GeminiResponseFormatException({required super.errorMessage});
}