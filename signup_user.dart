import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pixell_app/fragments/users_tab_layout.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/signup_pojo.dart';
import 'package:pixell_app/presenter/signup_presenter.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart' as mypreference;

import '../dialog/signup_terms_condition.dart';

class MySignUp extends StatefulWidget {
  MySignUp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return new _MySignUpStateful();
  }
}

class _MySignUpStateful extends State<MySignUp> implements SignupContract {
  SignupPresenter _signupPresenter;

  final textNameController = TextEditingController();
  final textEmailController = TextEditingController();
  final textBirthdayController = TextEditingController();
  final textPasswordController = TextEditingController();
  final textConfirmPasswordController = TextEditingController();

  String passDateOfBirth = "";
  bool allFieldValidate = false;
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _birthdayFocus = FocusNode();
  DateTime selectedDateTime;

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool checkedTermsValue = false;

  Future<void> _selectDate(BuildContext context) async {
    if (selectedDateTime == null) {
      selectedDateTime = DateTime(DateTime.now().year - 21, 1);
    }

    final DateTime d = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(1800, 1),
      lastDate: DateTime.now(),
    );
    if (d != null)
      setState(() {
        selectedDateTime = d;
        textBirthdayController.text = new DateFormat.yMMMMd("en_US").format(d);
        passDateOfBirth = new DateFormat('yyyy-MM-dd hh:mm:ss').format(d);
      });
  }

  @override
  void initState() {
    _signupPresenter = new SignupPresenter(this);
    isPasswordVisible = false;
    isConfirmPasswordVisible = false;

    allFocusListener();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget topbar = new Container(
      child: Center(
          child: Row(
        children: <Widget>[
          new IconButton(
              icon: new Image.asset(
                'graphics/arrow-left.png',
                height: MyConstants.toolbar_icon_height_width,
                width: MyConstants.toolbar_icon_height_width,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              }),
          Text(
            AppLocalizations.of(context).translate("label_signup"),
            style: TextStyle(
                fontSize: MyConstants.toolbar_text_size, color: Colors.white),
          ),
        ],
      )),
      height: MyConstants.topbar_height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage('graphics/surface_top_signup.png'),
          fit: BoxFit.fill,
        ),
      ),
    );

    Widget middleSection = new Expanded(
      child: new Container(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
                left: MyConstants.layout_margin,
                right: MyConstants.layout_margin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0,
                      MyConstants.vertical_control_space,
                      0.0,
                      MyConstants.vertical_control_space),
                ),
                TextFormField(
                  controller: textNameController,
                  textInputAction: TextInputAction.next,
                  focusNode: _nameFocus,
                  autofocus: false,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(context, _nameFocus, _emailFocus);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: MyUtils().validateFieldOnly(
                      context,
                      textNameController.text,
                      AppLocalizations.of(context)
                          .translate('msg_enter_first_name'),
                    ),
                    labelText:
                        AppLocalizations.of(context).translate('hint_name'),
                    labelStyle: TextStyle(
                        color: _nameFocus.hasFocus
                            ? MyUtils().getColorFromHex(MyConstants.color_theme)
                            : Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyUtils()
                              .getColorFromHex(MyConstants.color_theme),
                          width: 2.0),
                      borderRadius:
                          BorderRadius.circular(MyConstants.input_box_radius),
                    ),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                ),
                TextFormField(
                  autofocus: false,
                  controller: textEmailController,
                  textInputAction: TextInputAction.next,
                  focusNode: _emailFocus,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(context, _emailFocus, _passwordFocus);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: MyUtils()
                        .validateEmail(context, textEmailController.text),
                    labelText:
                        AppLocalizations.of(context).translate('hint_email'),
                    labelStyle: TextStyle(
                        color: _emailFocus.hasFocus
                            ? MyUtils().getColorFromHex(MyConstants.color_theme)
                            : Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyUtils()
                              .getColorFromHex(MyConstants.color_theme),
                          width: 2.0),
                      borderRadius:
                          BorderRadius.circular(MyConstants.input_box_radius),
                    ),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                ),
                TextFormField(
                  autofocus: false,
                  controller: textBirthdayController,
                  focusNode: _birthdayFocus,
                  onTap: () {
                    _birthdayFocus.unfocus();
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    errorText: MyUtils().validateFieldOnly(
                        context,
                        textBirthdayController.text,
                        AppLocalizations.of(context)
                            .translate('msg_select_birthdate')),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: AppLocalizations.of(context)
                        .translate('label_birthday'),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                ),
                TextFormField(
                  scrollPadding: EdgeInsets.only(
                      bottom: MyConstants.textformfield_scrollpadding),
                  obscureText: !isPasswordVisible,
                  controller: textPasswordController,
                  textInputAction: TextInputAction.next,
                  focusNode: _passwordFocus,
                  autofocus: false,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(
                        context, _passwordFocus, _confirmPasswordFocus);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: MyUtils().validatePassword(
                        context,
                        textPasswordController.text,
                        AppLocalizations.of(context)
                            .translate('msg_enter_password')),
                    labelText:
                        AppLocalizations.of(context).translate('hint_password'),
                    labelStyle: TextStyle(
                        color: _passwordFocus.hasFocus
                            ? MyUtils().getColorFromHex(MyConstants.color_theme)
                            : Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyUtils()
                              .getColorFromHex(MyConstants.color_theme),
                          width: 2.0),
                      borderRadius:
                          BorderRadius.circular(MyConstants.input_box_radius),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                ),
                TextFormField(
                  scrollPadding: EdgeInsets.only(
                      bottom: MyConstants.textformfield_scrollpadding),
                  obscureText: !isConfirmPasswordVisible,
                  autofocus: false,
                  controller: textConfirmPasswordController,
                  textInputAction: TextInputAction.done,
                  focusNode: _confirmPasswordFocus,
                  onFieldSubmitted: (term) {
                    _signupClickValidation();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: MyUtils().validatePassword(
                        context,
                        textConfirmPasswordController.text,
                        AppLocalizations.of(context)
                            .translate('msg_reenter_password')),
                    labelText: AppLocalizations.of(context)
                        .translate('hint_confirm_password'),
                    labelStyle: TextStyle(
                        color: _confirmPasswordFocus.hasFocus
                            ? MyUtils().getColorFromHex(MyConstants.color_theme)
                            : Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyUtils()
                              .getColorFromHex(MyConstants.color_theme),
                          width: 2.0),
                      borderRadius:
                          BorderRadius.circular(MyConstants.input_box_radius),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0, MyConstants.space_30, 0.0, 0.0),
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: checkedTermsValue,
                      onChanged: (newValue) {
                        checkedTermsValue = newValue;
                        checkAllFieldValidate();
                      }, //  <-- leading Checkbox
                    ),
                    Flexible(
                      child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    .translate('label_read_terms'),
                                style:  TextStyle(
                                    color: MyUtils().getColorFromHex(
                                        MyConstants.color_edti_title_text),
                                    fontSize: MyConstants.textsize_terms_conditions),
                              ),
                              TextSpan(
                                text: " ",
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    .translate('label_click_terms'),
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: MyUtils().getColorFromHex(
                                        MyConstants.color_edti_title_text),
                                    fontSize:
                                    MyConstants.textsize_terms_conditions),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    MyUtils().check().then((intenet) {
                                      if (intenet != null && intenet) {
                                        showDialog(
                                          context: context,
                                          builder: (_) => TermsCondition(
                                            title: AppLocalizations.of(context)
                                                .translate('label_click_terms'),
                                            loadUrl: MyConstants.URL_TERMS_CONDITIONS,
                                          ),
                                        );
                                      } else {
                                        MyUtils().toastdisplay(
                                            AppLocalizations.of(context)
                                                .translate('msg_no_internet'));
                                      }
                                    });
                                  },
                              ),
                              TextSpan(
                                text: " ",
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    .translate('label_and_the'),
                                style:  TextStyle(
                                    color: MyUtils().getColorFromHex(
                                        MyConstants.color_edti_title_text),
                                    fontSize: MyConstants.textsize_terms_conditions),
                              ),
                              TextSpan(
                                text: " ",
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    .translate('label_data_usage_policy'),
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: MyUtils().getColorFromHex(
                                        MyConstants.color_edti_title_text),
                                    fontSize:
                                    MyConstants.textsize_terms_conditions),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    MyUtils().check().then((intenet) {
                                      if (intenet != null && intenet) {
                                        showDialog(
                                          context: context,
                                          builder: (_) => TermsCondition(
                                            title: AppLocalizations.of(context)
                                                .translate('label_data_usage_policy'),
                                            loadUrl: MyConstants.URL_DATA_POLICY,
                                          ),
                                        );
                                      } else {
                                        MyUtils().toastdisplay(
                                            AppLocalizations.of(context)
                                                .translate('msg_no_internet'));
                                      }
                                    });
                                  },
                              ),
                            ],
                          ),),
                    ),
                  ],
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0, MyConstants.space_50, 0.0, 0.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    /*Bottom banner display*/
    Widget bottomBanner = new GestureDetector(
        onTap: () {
          _signupClickValidation();
        },
        child: new Container(
          child: Center(
            child: Text(
              AppLocalizations.of(context).translate('label_next'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MyConstants.btn_text_size,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          height: MyConstants.bottombar_height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: new DecorationImage(
              image: allFieldValidate
                  ? new AssetImage('graphics/surface_bottom_selected.png')
                  : new AssetImage('graphics/surface_bottom_signup.png'),
              fit: BoxFit.fill,
            ),
          ),
        ));

    Widget body = new Column(
      // This makes each child fill the full width of the screen
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        topbar,
        middleSection,
        bottomBanner,
      ],
    );

    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyUtils().getColorFromHex(MyConstants.color_screeb_bg),
      body: new Padding(
        padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: body,
      ),
    );
  }

  /*Api call for signup with validation check*/
  void _signupClickValidation() {
    if (textBirthdayController.text.isEmpty) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate('msg_select_birthdate'));
      return;
    }

    //Password & Confirm password same
    if (textPasswordController.text != textConfirmPasswordController.text) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate('msg_same_password_confirm'));
      return;
    }

    if (allFieldValidate) {
      MyUtils().check().then((intenet) {
        if (intenet != null && intenet) {
          _signupPresenter.doSignup(
              context,
              textNameController.text,
              textEmailController.text,
              passDateOfBirth,
              textPasswordController.text);
        } else {
          MyUtils().toastdisplay(
              AppLocalizations.of(context).translate('msg_no_internet'));
        }
      });
    }
  }

  /*Listener for TextFormField*/
  void allFocusListener() {
    textNameController.addListener(() {
      checkAllFieldValidate();
    });

    textEmailController.addListener(() {
      checkAllFieldValidate();
    });

    textBirthdayController.addListener(() {
      checkAllFieldValidate();
    });

    textPasswordController.addListener(() {
      checkAllFieldValidate();
    });

    textConfirmPasswordController.addListener(() {
      checkAllFieldValidate();
    });
  }

  void checkAllFieldValidate() {
    setState(() {
      if (MyUtils().validateFieldOnly(context, textNameController.text, "") ==
              null &&
          MyUtils().validateEmail(context, textEmailController.text) == null &&
          MyUtils().validateFieldOnly(
                  context, textBirthdayController.text, "") ==
              null &&
          MyUtils()
                  .validatePassword(context, textPasswordController.text, "") ==
              null &&
          MyUtils().validatePassword(
                  context, textConfirmPasswordController.text, "") ==
              null &&
          checkedTermsValue) {
        allFieldValidate = true;
      } else {
        allFieldValidate = false;
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    textNameController.dispose();
    textEmailController.dispose();
    textBirthdayController.dispose();
    textPasswordController.dispose();
    textConfirmPasswordController.dispose();
    super.dispose();
  }

  /*Keyboard action focus listener*/
  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void onSignupError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onSignupSuccess(SignupPojo user) {
    if (user.token == null) {
      MyUtils().toastdisplay(
        AppLocalizations.of(context).translate("msg_error_login"),
      );
    } else {
      mypreference.MySharePreference()
          .saveBoolInPref(MyConstants.PREF_AS_GUEST, true);

      if (user.id != null) {
        mypreference.MySharePreference()
            .saveIntegerInPref(MyConstants.PREF_KEY_USERID, user.id);
      }

      mypreference.MySharePreference().saveStringInPref(
          MyConstants.PREF_KEY_LOGIN_TOKEN, user.token.toString());

      MyConstants.currentSelectedBottomTab = 0;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => UsersTabLayout(
                  fromScreen: MyConstants.FROM_SIGNUP,
                )),
        (Route<dynamic> route) => false,
      );
    }
  }

  /*Display Terms & Condition dialog*/
  Future<void> terms_condionAlertDialogBox(BuildContext mContext) {
    return showDialog(
        barrierDismissible: false,
        context: mContext,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.all(0.0),
            content: new SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(MyConstants.layout_margin),
                width: double.infinity,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(5.0),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)
                          .translate('label_terms_conditions'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    new Container(
                      margin: new EdgeInsets.fromLTRB(
                          0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate('content_terms_conditions'),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    new Container(
                      margin: new EdgeInsets.fromLTRB(
                          0.0, MyConstants.space_40, 0.0, 0.0),
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate('label_data_usage_policy'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    new Container(
                      margin: new EdgeInsets.fromLTRB(
                          0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate('content_terms_conditions1'),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    AppLocalizations.of(context).translate("label_close"),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MyConstants.btn_dialog_size,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
