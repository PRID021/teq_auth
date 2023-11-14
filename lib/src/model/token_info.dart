import 'package:equatable/equatable.dart';

class TokenInfo with EquatableMixin {
  final String accessToken;
  final String refreshToken;

  TokenInfo({required this.accessToken, required this.refreshToken});

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
