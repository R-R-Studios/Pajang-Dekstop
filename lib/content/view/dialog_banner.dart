import 'dart:io';

import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/content/model/banner_create.dart' as banner ;
import 'package:beben_pos_desktop/core/app/color_palette.dart';
import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/core/util/core_function.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DialogBanner extends StatefulWidget {

  const DialogBanner({ Key? key }) : super(key: key);

  @override
  State<DialogBanner> createState() => _DialogBannerState();
}

class _DialogBannerState extends State<DialogBanner> {

  File? fileImage;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constant.paddingScreen,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Component.text("Nama"),
            const SizedBox(height: 10,),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama Banner',
                border: OutlineInputBorder(),
              ),
              // controller: _productCodeController,
              enabled: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Masukan nama banner';
                }
                return null;
              },
            ),
            const SizedBox(height: 20,),
            Component.text("Deskripsi"),
            const SizedBox(height: 10,),
            TextFormField(
              minLines: 5,
              maxLines: 5,
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              // controller: _productCodeController,
              enabled: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Masukan deskripsi';
                }
                return null;
              },
            ),
            const SizedBox(height: 20,),
            Component.text("Foto Banner"),
            const SizedBox(height: 10,),
            fileImage == null ? InkWell(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    setState(() {
                      fileImage = File(result.files.single.path!);
                    });
                  } else {
                    
                  }
              },
              // onTap: () => BlocProvider.of<DocumentationCubit>(context).addPhotoAfter(),
              child: Container(
                height: SizeConfig.blockSizeHorizontal * 20,
                width: SizeConfig.blockSizeHorizontal * 60,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    width: 1,
                    color: ColorPalette.grey
                  )
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_a_photo),
                    const SizedBox(width: 10,),
                    Component.text("Foto Banner")
                  ],
                ),
              ),
            ) : Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  Image.file(
                    fileImage!,
                    height: SizeConfig.blockSizeHorizontal * 20,
                    width: SizeConfig.blockSizeHorizontal * 60,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: InkWell(
                      child: const Icon(
                        Icons.remove_circle,
                        size: 20,
                        color: Colors.red,
                      ),
                      onTap: () {
                        setState(() {
                          fileImage = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
             InkWell(
                onTap: () async{
                  Navigator.of(context).pop((banner.BannerCreate(banner: banner.Banner(
                    name: nameController.text,
                    description: descController.text,
                    filename: CoreFunction.convertImageToBase64(fileImage!)
                  ))));
                },
                child: Card(
                  color: Colors.green,
                  child: Container(
                    alignment: Alignment.center,
                    width: SizeConfig.blockSizeHorizontal * 60,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Component.text("Tambah", colors: Colors.white,),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}