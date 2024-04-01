import 'package:appointment_booking_app/shared/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appointment_booking_app/core/app/app_colors.dart';
import 'package:appointment_booking_app/core/user_type.dart';
import 'package:appointment_booking_app/extensions/screen.dart';
import 'package:appointment_booking_app/features/dashboard/presentation/views/homescreen.dart';
import 'package:appointment_booking_app/features/merchants/presentation/views/merchant_dashboard.dart';
import 'package:appointment_booking_app/providers/auth_providers.dart';
import 'package:appointment_booking_app/shared/custom_appbar.dart';
import 'package:appointment_booking_app/shared/custom_appbar_title.dart';
import 'package:appointment_booking_app/shared/custom_leading.dart';
import 'package:appointment_booking_app/shared/show_toast.dart';

class UserTypeScreen extends ConsumerStatefulWidget {
  const UserTypeScreen({super.key});

  @override
  UserTypeScreenState createState() => UserTypeScreenState();
}

class UserTypeScreenState extends ConsumerState<UserTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        leading: CustomLeading(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.screenWidth(0.07)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const CustomAppBarTitle(
                  title: 'Just a sec 😃 ',
                  description: 'Select your account type',
                ),
                SizedBox(
                  height: context.screenHeight(0.05),
                ),
                UserTypeCard(
                  description:
                      'Easily find and book appointments with top professionals',
                  asset: 'assets/pngs/customer.png',
                  onpressed: () => selectUserType(UserType.customer),
                  userType: UserType.customer,
                  deccolor: AppColors.bg.withOpacity(0.1),
                ),
                UserTypeCard(
                  description:
                      'Grow your business by connecting with more customers',
                  asset: 'assets/pngs/merchant.png',
                  onpressed: () => selectUserType(UserType.merchant),
                  userType: UserType.merchant,
                  deccolor: const Color(0xFFF78F50).withOpacity(0.13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectUserType(UserType selectedType) async {
    final success = await ref
        .read(authStateProvider.notifier)
        .selectRole(selectedType, context);
    if (success) {
      // After successfully updating the role, fetch the latest user model.
      final updatedUserModel = ref.read(authStateProvider.notifier).userModel;
      // Ensure the updated model reflects the selected role.
      if (updatedUserModel != null &&
          updatedUserModel.userType == selectedType) {
        navigateBasedOnUserType(updatedUserModel.userType);
      } else {
        showErrorToast("Failed to update user role, please try again.");
      }
    } else {
      showErrorToast("User model is null, please log in again.");
    }
  }

  void navigateBasedOnUserType(UserType userTypes) {
    final userType = userTypes;
    UserType.unKnown;
    switch (userType) {
      case UserType.merchant:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const MerchantDashboardScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case UserType.customer:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        );
        break;
      case UserType.unKnown:
      default:
        Navigator.pushReplacementNamed(context, '/userTypeSelection');
        break;
    }
  }
}

class UserTypeCard extends StatelessWidget {
  const UserTypeCard({
    super.key,
    required this.userType,
    required this.deccolor,
    this.onpressed,
    required this.asset,
    required this.description,
  });
  final UserType userType;
  final Color deccolor;
  final String asset;
  final String description;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        margin: EdgeInsets.only(bottom: context.screenHeight(0.03)),
        height: context.screenHeight(0.22),
        width: context.screenWidth(0.93),
        decoration: BoxDecoration(
          color: deccolor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.screenWidth(0.05),
            vertical: context.screenHeight(0.04),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userType.title,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: AppColors.textdark,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Image.asset(
                    asset,
                    height: 50,
                  )
                ],
              ),
              const Height10(),
              Text(description)
            ],
          ),
        ),
      ),
    );
  }
}
