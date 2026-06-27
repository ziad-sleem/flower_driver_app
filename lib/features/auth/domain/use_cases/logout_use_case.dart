import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';

@injectable
class LogoutUseCase {
  LogoutUseCase();

  Future<void> call() {
    return SecureStorageService.deleteToken();
  }
}
