import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loca_student/bloc/home/owner/owner_home_state.dart';

class OwnerHomeCubit extends Cubit<OwnerState> {
  OwnerHomeCubit() : super(OwnerInitial());

  void filterRepublics(String query) {
    if (state is! OwnerLoaded) return;

    final currentState = state as OwnerLoaded;
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
