import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/content/cubit/banner_cubit.dart';
import 'package:beben_pos_desktop/content/view/dialog_banner.dart';
import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nav_router/nav_router.dart';

class BannerView extends StatelessWidget {

final VoidCallback callback;

  const BannerView({ required this.callback, Key? key }) : super(key: key);

  dialogCreate(currentContext){
    showDialog(
      context: navGK.currentContext!, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Container(
            width: 500,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Buat Banner"),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  tooltip: "Tutup",
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.close)
                )
              ],
            ),
          ),
          content: DialogBanner(),
        );
      }
    ).then((value) {
      if(value != null){
        // GlobalFunctions.log("className", value);
        BlocProvider.of<BannerCubit>(currentContext).create(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BannerCubit, BannerState>(
        builder: (context, state) {
          if(state is BannerLoading){
            return CupertinoActivityIndicator();
          } else if (state is BannerLoaded) {
            return Padding(
              padding: Constant.paddingScreen,
              child: ListView(
                children: [
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: callback,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        label: Text("Back"),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(color: Colors.white),
                          padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                          primary: Color(0xff3498db)
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Component.text("Banner Anda", fontSize: 17, colors: Colors.black),
                      const Spacer(),
                      InkWell(
                        onTap: (){
                          dialogCreate(context);
                        },
                        child: Card(
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.white),
                                const SizedBox(width: 5,),
                                Component.text("Tambah", colors: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  ListView.builder(
                    itemCount: state.list.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black26,
                              width: 1
                            )
                          )
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Component.text("${(index + 1)})", fontWeight: FontWeight.bold, fontSize: 16),
                            const SizedBox(width: 10,),
                            CachedNetworkImage(
                              imageUrl: state.list[index].imageUrl ?? "",
                              height: SizeConfig.blockSizeHorizontal * 15,
                              width: SizeConfig.blockSizeHorizontal * 25,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 20,),
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Component.text(
                                    state.list[index].name ?? "",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    colors: Colors.black
                                  ),
                                  const SizedBox(height: 10,),
                                  Component.text(
                                    state.list[index].description ?? "", 
                                    maxLines: 7
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is BannerEmpty) {
            return Center(child: Text("Belum ada data"));
          } else {
            return Container();
          }
        },
      )
    );
  }
}