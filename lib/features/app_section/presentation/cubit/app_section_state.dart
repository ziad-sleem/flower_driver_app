part of 'app_section_cubit.dart';

abstract class AppSectionState extends Equatable {
  const AppSectionState();
}

class AppSectionsInitial extends AppSectionState {
  @override
  List<Object?> get props => [];
}

class AppSectionsChanged extends AppSectionState {
  final int currentIndex;

  const AppSectionsChanged({this.currentIndex = 0});

  @override
  List<Object?> get props => [currentIndex];
}
