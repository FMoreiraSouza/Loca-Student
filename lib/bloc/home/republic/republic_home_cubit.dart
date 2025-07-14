import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/republic/republic_home_state.dart';

class RepublicHomeCubit extends Cubit<RepublicState> {
  RepublicHomeCubit() : super(RepublicInitial());

  void filterRepublics(String query) {
    if (state is! RepublicLoaded) return;

    final currentState = state as RepublicLoaded;
    final filtered = currentState.republics.where((alojamento) {
      final name = alojamento['name']?.toString().toLowerCase() ?? '';
      final address = alojamento['address']?.toString().toLowerCase() ?? '';
      final city = alojamento['city']?.toString().toLowerCase() ?? '';
      final state = alojamento['state']?.toString().toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();
      return name.contains(searchQuery) ||
          address.contains(searchQuery) ||
          city.contains(searchQuery) ||
          state.contains(searchQuery);
    }).toList();

    emit(currentState.copyWith(Republics: filtered));
  }
}
