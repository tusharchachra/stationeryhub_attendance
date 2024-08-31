import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/albums/album_users.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/controllers/new_organization_screen_controller.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_text.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_onboarding.dart';
import 'package:stationeryhub_attendance/screens/admin_dashboard_screen.dart';

import '../albums/album_organizations.dart';
import '../controllers/firebase_error_controller.dart';
import '../form_fields/form_field_button.dart';
import '../helpers/constants.dart';

class NewOrganizationScreen extends StatelessWidget {
  const NewOrganizationScreen({super.key});

  static NewOrganizationScreenController newOrganizationScreenController =
      Get.find();
  static FirebaseFirestoreController firestoreController = Get.find();
  //static SharedPrefsController sharedPrefsController = Get.find();
  static FirebaseErrorController errorController = Get.find();

  @override
  Widget build(BuildContext context) {
    newOrganizationScreenController.resetAll();
    return ScaffoldOnboarding(
      bodyWidget: Center(
        child: Form(
          key: newOrganizationScreenController.formKeyNewOrganization,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 364.w,
                height: 353.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey, blurRadius: 62.0.r),
                  ],
                  borderRadius: BorderRadius.circular(5.0.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 75.w,
                      height: 75.h,
                      decoration: BoxDecoration(
                        color: colourIconBackground,
                        shape: BoxShape.circle,
                      ),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0).w,
                          child: const Icon(
                            Icons.business,
                            color: colourPrimary,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Organization details',
                      style: Get.textTheme.displayLarge,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: FormFieldText(
                        prefixIcon: const Icon(Icons.business),
                        hintText: 'Organization name',
                        validator: (value) {
                          return newOrganizationScreenController
                              .validateName(value);
                        },
                        onChangedAction: (value) {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: const FormFieldText(
                        hintText: 'Address',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        isMultiLine: true,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Obx(
                () => newOrganizationScreenController.isLoading.value
                    ? SizedBox(
                        width: 25.w,
                        height: 25.h,
                        child: const CircularProgressIndicator(),
                      )
                    : FormFieldButton(
                        width: 384.w,
                        height: 56.h,
                        buttonText: 'Continue',
                        onTapAction: () async {
                          newOrganizationScreenController.isLoading.value =
                              true;
                          if (newOrganizationScreenController
                              .formKeyNewOrganization.currentState!
                              .validate()) {
                            newOrganizationScreenController.isLoading.value =
                                true;

                            AlbumOrganization? newOrganization =
                                AlbumOrganization(
                              name: newOrganizationScreenController
                                  .nameController.value.text
                                  .trim(),
                              address: newOrganizationScreenController
                                  .addressController.value.text
                                  .trim(),
                              createdOn: DateTime.now(),
                            );

                            //Inserting organization into firestore
                            String? insertedOrganizationId =
                                await firestoreController.createOrganization(
                                    newOrganization: newOrganization);

                            //fetch user from shared prefs
                            /* AlbumUsers? currentUser =
                                await sharedPrefsController
                                    .getUserFromSharedPrefs();*/

                            //inserting the newOrganizationId to the user's profile on firestore
                            await firestoreController
                                .updateOrganizationIdInCreator(
                                    currentUserId: firestoreController
                                        .registeredUser!.value!.firebaseId!,
                                    organizationId: insertedOrganizationId!);

                            //fetch user from firestore
                            AlbumUsers? currentUser =
                                await firestoreController.getUser(
                                    phoneNum: firestoreController
                                        .registeredUser!.value!.phoneNum!);

                            //fetch organization from firestore
                            newOrganization = await firestoreController
                                .getOrganization(orgId: insertedOrganizationId);

                            //update user details in shared prefs
                            /*  await sharedPrefsController.storeUserToSharedPrefs(
                                user: currentUser);*/

                            //store org details to shred prefs
                            /* await sharedPrefsController
                                .storeOrganizationToSharedPrefs(
                                    organization: newOrganization!);*/

                            /* if (kDebugMode) {
                              print('From shared prefs:');
                              var temp = await sharedPrefsController
                                  .getOrganizationFromSharedPrefs();
                              print(temp.toString());
                              var temp1 = await sharedPrefsController
                                  .getUserFromSharedPrefs();
                              print(temp1.toString());
                            }*/
                          }
                          newOrganizationScreenController.isLoading.value =
                              false;
                          {
                            Get.showSnackbar(
                              GetSnackBar(
                                messageText: Text(
                                  errorController.errorMsg.isNotEmpty
                                      ? errorController.errorMsg.toString()
                                      : 'New Organization created',
                                  textAlign: TextAlign.center,
                                  style: Get.textTheme.bodyMedium
                                      ?.copyWith(color: colourTextDark),
                                ),
                                duration: const Duration(seconds: 2),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.white,
                                boxShadows: [
                                  BoxShadow(
                                      color: Colors.grey, blurRadius: 62.0.r),
                                ],
                                snackStyle: SnackStyle.FLOATING,
                                borderRadius: 50.r,
                                margin: EdgeInsets.all(10.w),
                              ),
                            );
                            Get.to(() => AdminDashboardScreen());
                          }
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
