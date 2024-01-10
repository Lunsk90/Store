// ignore_for_file: override_on_non_overriding_member, file_names

import 'package:flutter_bloc/flutter_bloc.dart';

// Eventos para actualizar los datos
abstract class PersonalDataEvent {}

class UpdateNameEvent extends PersonalDataEvent {
  final String name;

  UpdateNameEvent(this.name);
}

class UpdateLastNameEvent extends PersonalDataEvent {
  final String lastName;

  UpdateLastNameEvent(this.lastName);
}

// Estado para los datos personales
class PersonalData {
  final String name;
  final String lastName;

  PersonalData({required this.name, required this.lastName});

  PersonalData copyWith({String? name, String? lastName}) {
    return PersonalData(
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
    );
  }
}

// Bloc para manejar los datos personales
class PersonalDataBloc extends Bloc<PersonalDataEvent, PersonalData> {
  PersonalDataBloc() : super(PersonalData(name: '', lastName: ''));

  @override
  Stream<PersonalData> mapEventToState(PersonalDataEvent event) async* {
    if (event is UpdateNameEvent) {
      yield state.copyWith(name: event.name);
    } else if (event is UpdateLastNameEvent) {
      yield state.copyWith(lastName: event.lastName);
    }
  }
}
