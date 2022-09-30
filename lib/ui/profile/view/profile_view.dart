import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/core/app/color_palette.dart';
import 'package:beben_pos_desktop/ui/profile/cubit/profile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.store, size: 170, color: ColorPalette.primary),
                      const SizedBox(width: 20,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Component.text("Nama Toko", fontSize: 11),
                          const SizedBox(height: 5,),
                          Component.text(
                            state.responseprofile.name ?? "",
                            fontSize: 25,
                            colors: ColorPalette.black
                          ),
                          const SizedBox(height: 10,),
                          Component.text("Email", fontSize: 11),
                          const SizedBox(height: 5,),
                          Component.text(
                            state.responseprofile.email ?? "",
                            fontSize: 25,
                            colors: ColorPalette.black
                          ),
                          const SizedBox(height: 10,),
                          Component.text("Phone Number", fontSize: 11),
                          const SizedBox(height: 5,),
                          Component.text(
                            state.responseprofile.phoneNumber ?? "",
                            fontSize: 25,
                            colors: ColorPalette.black
                          ),
                          const SizedBox(height: 10,),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        } else {
          return Center(child: CupertinoActivityIndicator());
        }
      },
    );
  }
}