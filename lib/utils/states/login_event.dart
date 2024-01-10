import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

class EmailDomainVerification extends LoginEvent {
  final String email;

  EmailDomainVerification(this.email);

  @override
  List<Object?> get props => [email];
}

class LoginRequested extends LoginEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class EmailMigrationVerification extends LoginEvent {
  final String email;

  EmailMigrationVerification(this.email);

  @override
  List<Object?> get props => [email];
}

class SignUpUser extends LoginEvent {
  final String email;
  final String password;

  SignUpUser(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class SignInUser extends LoginEvent {
  final String email;
  final String password;

  SignInUser(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class MissingPasswordVerficationEmail extends LoginEvent {
  final String email;
  final String verificationCode;

  MissingPasswordVerficationEmail(this.email, this.verificationCode);

  @override
  List<Object?> get props => [email, verificationCode];
}

class LaunchBiometrics extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class SetBiometricTerms extends LoginEvent {
  final bool biometricsAccess;
  SetBiometricTerms(this.biometricsAccess);

  @override
  List<Object?> get props => [biometricsAccess];
}

class AuthenticateWithBiometrics extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class GetCredentialsFastLogin extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class SetCredentialsFastLogin extends LoginEvent {
  final String email;
  final String password;

  SetCredentialsFastLogin(this.email, this.password);

  @override
  List<Object?> get props => [];
}

class BiometricAuthenticationShowedUp extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class SendVerificationCode extends LoginEvent {
  final String email;
  final String code;

  SendVerificationCode(this.email, this.code);

  @override
  List<Object?> get props => [];
}

class CheckBiometrics extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class RememberUser extends LoginEvent {
  final bool remember;
  final String email;

  RememberUser(this.remember, this.email);

  @override
  List<Object?> get props => [];
}

class ReadRememberUser extends LoginEvent {
  @override
  List<Object?> get props => [];
}
