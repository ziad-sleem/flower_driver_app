import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'app_section_state.dart';

@injectable
class AppSectionsCubit extends Cubit<AppSectionState> {
  AppSectionsCubit() : super(AppSectionsInitial());

  void changeSection(int index) {
    emit(AppSectionsChanged(currentIndex: index));
  }
}
