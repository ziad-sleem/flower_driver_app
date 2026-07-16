import 'dart:io';

sealed class EditProfileEvent {
  const EditProfileEvent();
}

class LoadProfileEvent extends EditProfileEvent {
  const LoadProfileEvent();
}

class EditProfileFirstNameChanged extends EditProfileEvent {
  final String value;
  const EditProfileFirstNameChanged(this.value);
}

class EditProfileLastNameChanged extends EditProfileEvent {
  final String value;
  const EditProfileLastNameChanged(this.value);
}

class EditProfileEmailChanged extends EditProfileEvent {
  final String value;
  const EditProfileEmailChanged(this.value);
}

class EditProfilePhoneChanged extends EditProfileEvent {
  final String value;
  const EditProfilePhoneChanged(this.value);
}

class EditProfilePhotoChanged extends EditProfileEvent {
  final File file;
  const EditProfilePhotoChanged(this.file);
}

class EditProfileSubmitted extends EditProfileEvent {
  const EditProfileSubmitted();
}
