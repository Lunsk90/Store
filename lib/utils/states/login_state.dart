abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class EmailMigrated extends LoginState {}

class EmailNotMigrated extends LoginState {}

class EmailMigrationNotFound extends LoginState {}

class EmailDomainBelongs extends LoginState {}

class EmailDomainIsExternal extends LoginState {}

class UserNameIsNotAnEmail extends LoginState {}

class UserContainsIlegalCharacters extends LoginState {}

class UserMigrationSuccessful extends LoginState {}

class UserMigrationFailed extends LoginState {}

class UserLoginFailed extends LoginState {}

class UserLoginSuccessful extends LoginState {}

class UserLoginWrongCredentials extends LoginState {}

class LoginSuccess extends LoginState {
  final String email;

  LoginSuccess(this.email);
}

//States for biometrics
class BiometricsInDevice extends LoginState {}

class UserAuthenticatedWithBiometrics extends LoginState {}

class BiometricsAccess extends LoginState {}

class BiometricsNoAccess extends LoginState {}

class BiometricsTermsSet extends LoginState {}

class ReturnCredentialsBiometricLogin extends LoginState {}

class FastLoginCredentialsSet extends LoginState {}

class BiometricsPresented extends LoginState {}

//Verify User by Code
class UserVerificationInProgress extends LoginState {}

class UserWasVerified extends LoginState {}

class UserCouldNotBeVerified extends LoginState {}

//Remember Me
class RememberMeState extends LoginState {
  final bool remember;
  final String email;

  RememberMeState(this.remember, this.email);
}
