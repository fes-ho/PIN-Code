import 'package:frontend/src/features/authentication/data/auth_repositories/auth_repository.dart';
import 'package:frontend/src/utils/command.dart';
import 'package:frontend/src/utils/result.dart';
import 'package:logging/logging.dart';

class LoginViewModel {
  LoginViewModel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository {
    login = Command1<void, (String email, String password)>(_login);
  }

  final AuthRepository _authRepository;
  final _log = Logger('LoginViewModel');

  late Command1 login;

  Future<Result<void>> _login((String, String) credentials) async {
    final (email, password) = credentials;
    final result = await _authRepository.login(
      email: email,
      password: password,
    );
    if (result is Error<void>) {
      _log.warning('Login failed! ${result.error}');
    }
    return result;
  }
}