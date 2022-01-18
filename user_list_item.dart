import 'package:flutter/material.dart';
import 'package:piyush_flutter_bloc/lib.dart';

class UserListItem extends StatelessWidget {
  final UserModel user;
  final Function(UserModel) onItemClick;

  const UserListItem({
    required this.user,
    required this.onItemClick,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key(user.id.toString()),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.all(SizeConfig.listItemPadding),
          child: Row(
            children: [
              user.avatarUrl == null
                  ? Container()
                  : Avatar(
                      photo: user.avatarUrl.toString(),
                      imageSize: 50,
                    ),
              SizedBox(
                width: SizeConfig.verticalSizeBoxSpace,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.login.toString(),
                    style: MyStyles.fontRegularTextBold(),
                  ),
                  Text(
                    user.type.toString(),
                    style: MyStyles.fontSmallText(),
                  ),
                ],
              )),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 15,
              )
            ],
          ),
        ),
      ),
      onTap: () => onItemClick(user),
    );
  }
}
