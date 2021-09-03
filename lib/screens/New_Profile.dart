import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potbelly/grovey_startScreens/ProviderService.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/settings_screen.dart';
import 'package:potbelly/services/ServiceProvider.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:provider/provider.dart';

import 'WebView.dart';

class NewProfileScreen extends StatefulWidget {
  const NewProfileScreen({Key key}) : super(key: key);

  @override
  _NewProfileScreenState createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  profileoptionlist(sub) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black12),
          // BoxShadow(blurRadius: 10, color: Colors.black12),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Material(
                  elevation: 10,
                  shadowColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/andy.png'),
                    backgroundColor: Colors.transparent,
                    minRadius: Sizes.RADIUS_18,
                    maxRadius: Sizes.RADIUS_18,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Text('My Profile',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.black,
                        letterSpacing: .3,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'roboto')),
              ],
            ),
            Row(
              children: [
                sub == false
                    ? Container()
                    : Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            // shape :BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 1.2,
                            )),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified,
                              size: 15,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Subscribed'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blueAccent,
                                    letterSpacing: .3,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'roboto')),
                          ],
                        ),
                      ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 15,
                  color: AppColors.secondaryElement,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  optionlist(noti, name, icon, shadow) {
    return Material(
      elevation: !shadow ? 4 : 0,
      shadowColor: Colors.black54,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: shadow
              ? [
                  BoxShadow(blurRadius: 10, color: Colors.black12)
                  // BoxShadow(blurRadius: 10, color: Colors.black12),
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Material(
                  //   elevation: 5,
                  //   shadowColor: Colors.grey[400],
                  //   // color: Colors.transparent,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(100),
                  //   ),
                  // child:
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      icon,
                      size: 20,
                      color: AppColors.grey,
                    ),
                    // )
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(name,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          letterSpacing: .3,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'roboto')),
                ],
              ),
              Row(
                children: [
                  noti == null
                      ? Container()
                      : Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(100),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.secondaryElement,
                                  width: 1.4)),
                          child: Text(noti,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryElement,
                                  letterSpacing: .3,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'roboto')),
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                    color: AppColors.secondaryElement,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  logout(name, icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        //  boxShadow:  shadow? [
        //   BoxShadow(blurRadius: 10, color: Colors.black12)
        //   // BoxShadow(blurRadius: 10, color: Colors.black12),
        // ]:[],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Material(
                //   elevation: 5,
                //   shadowColor: Colors.grey[400],
                //   // color: Colors.transparent,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(100),
                //   ),
                // child:
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: RotatedBox(
                      quarterTurns: 0,
                      child: Icon(
                        icon,
                        size: 22,
                        color: Colors.red,
                      )),
                  // )
                ),
                SizedBox(
                  width: 10,
                ),
                Text(name,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        letterSpacing: .3,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'roboto')),
              ],
            ),
            // Icon(Icons.arrow_forward_ios_outlined,size: 15, color: AppColors.secondaryElement,)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(builder: (context, service, child) {
    return Consumer<CartProvider>(builder: (context, cartservice, child) {
      return Scaffold(
        backgroundColor: Color(0xFFF9FBFA),
        appBar: AppBar(
          elevation: 1.5,
          // centerTitle: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account',
                style: Styles.customTitleTextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: Sizes.TEXT_SIZE_18,
                ),
              ),
              Text(
                service.prefs.getString('email') ?? '',
                style: Styles.customTitleTextStyle(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.My_social);
                },
                child: profileoptionlist(service.usermealsub),),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.editProfileScreen);
                },
                child: optionlist(null, 'Edit Profile', Icons.edit, true),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.changePasswordScreen);
                },
                child: optionlist(
                    null, 'Change Password', Icons.lock_outline, false),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.cart_Screen,
                  );
                },
                child: optionlist(cartservice.cartitemlength.toString(), 'Cart',
                    OMIcons.shoppingCart, true),
              ),
              InkWell(
                onTap: () {
                  // Navigator.pushNamed(context, AppRouter.changePasswordScreen);
                },
                child:
                    optionlist(null, 'Wallet', OMIcons.monetizationOn, false),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.notificationsScreen);
                },
                child: optionlist(
                    null, 'Notifications', OMIcons.notifications, false),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.bookmarksScreen);
                },
                child: optionlist(null, 'Bookmarks', OMIcons.bookmarks, true),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.order_list);
                },
                child: optionlist(null, 'My Order', OMIcons.history, false),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.userAddresses);
                },
                child:
                    optionlist(null, 'My Address', OMIcons.myLocation, false),
              ),
              InkWell(
                onTap: () {
                  // Navigator.pushNamed(context, AppRouter.changePasswordScreen);
                },
                child:
                    optionlist(null, 'My Transactions', OMIcons.payment, false),
              ),
              InkWell(
                onTap: () {
                 Navigator.pushNamed(
                          context, AppRouter.userSubscriptionList)
                      .then((value) {
                    
                    Provider.of<ServiceProvider>(context, listen: false)
                        .getsubdata(context);});
                },
                child: optionlist(null, 'My Subscription',
                    Icons.auto_awesome_motion_outlined, false),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewPage(
                                url: 'https://loveats.app/privacy-policy-ap')));
                },
                child: optionlist(
                    null, 'Privacy Policy', Icons.security_outlined, false),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewPage(
                                url: 'https://loveats.app/privacy-policy-ap')));
                },
                child: optionlist(null, 'Terms & Conditions',
                    Icons.description_outlined, false),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                 _logoutDialog(context);
                },
                child: logout('Logout', Icons.logout_outlined),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    });
    });
  }


  
  Future<void> _logoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return _buildAlertDialog(context);
      },
    );
  }

  _logoutFunction(BuildContext context) async {
    Provider.of<ProviderService>(context, listen: false).allfalse();
    Provider.of<ProviderService>(context, listen: false).reset();
    await Service().logout(context);
  }

  Widget _buildAlertDialog(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(Sizes.RADIUS_32),
        ),
      ),
      child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(
          Sizes.PADDING_0,
          Sizes.PADDING_36,
          Sizes.PADDING_0,
          Sizes.PADDING_0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.RADIUS_20),
        ),
        elevation: Sizes.ELEVATION_4,
        content: Container(
          height: Sizes.HEIGHT_150,
          width: Sizes.WIDTH_300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SingleChildScrollView(
                child: Center(
                  child: Text(
                    'Are you sure you want to Logout ?',
                    style: textTheme.title.copyWith(
                      fontSize: Sizes.TEXT_SIZE_20,
                      color: Colors.black54
                    ),
                  ),
                ),
              ),
              Spacer(flex: 1),
              Row(
                children: <Widget>[
                  AlertDialogButton(
                    buttonText: "No",
                    width: Sizes.WIDTH_150,
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: AppColors.greyShade1,
                      ),
                      right: BorderSide(
                        width: 1,
                        color: AppColors.greyShade1,
                      ),
                    ),
                    textStyle:
                        textTheme.button.copyWith(color: Colors.black54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  AlertDialogButton(
                    buttonText: "Yes",
                    width: Sizes.WIDTH_150,
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: AppColors.greyShade1,
                      ),
                    ),
                    textStyle: textTheme.button
                        .copyWith(color: AppColors.secondaryElement),
                    onPressed: () => _logoutFunction(context),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
