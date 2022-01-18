import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:piyush_flutter_bloc/lib.dart';

part 'user_state.dart';

part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required this.userRepository}) : super(UserInitialState());

  UserRepository userRepository;

  @override
  UserState get initialState => UserInitialState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserInitialState) {
    } else if (event is FetchUserEvent || event is HomeStarted) {
      yield UserLoadingState();
      try {
        List<UserModel> users = await userRepository.fetchUsers();
        print("CALLL============");
        yield UserLoadedState(users: users);
      } catch (e) {
        yield UserErrorState(message: e.toString());
      }
    }
  }
}
