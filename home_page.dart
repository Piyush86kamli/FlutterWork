import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piyush_flutter_bloc/lib.dart';

class HomePage extends StatefulWidget {
  final UserRepository userRepository;
  final Function()? onNext;

  const HomePage({Key? key, required this.userRepository, this.onNext}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(
      userRepository: widget.userRepository,
    )..add(HomeStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users',style: MyStyles.fontScreenTitleTextBold(),)),
      body: Padding(
          padding: const EdgeInsets.only(
              left: SizeConfig.screenPadding,
              right: SizeConfig.screenPadding,
              top: SizeConfig.screenPadding),
          child: BlocProvider<UserBloc>(
            create: (context) => _userBloc,
            child: HomeBody(onNext: widget.onNext,userBloc: _userBloc,),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }



}

//
// class HomePage extends StatelessWidget {
//   final UserRepository userRepository;
//   final Function()? onNext;
//
//   const HomePage({Key? key, required this.userRepository, this.onNext}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Users',style: MyStyles.fontScreenTitleTextBold(),)),
//       body: Padding(
//           padding: const EdgeInsets.only(
//               left: SizeConfig.screenPadding,
//               right: SizeConfig.screenPadding,
//               top: SizeConfig.screenPadding),
//           child: BlocProvider<UserBloc>(
//             create: (context) => UserBloc(
//               userRepository: userRepository,
//             )..add(HomeStarted()),
//             child: HomeBody(onNext: onNext,),
//           )),
//     );
//   }
// }
