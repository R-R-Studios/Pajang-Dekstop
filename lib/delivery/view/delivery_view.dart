import 'package:beben_pos_desktop/ui/delivery/cubit/delivery_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryView extends StatelessWidget {
  const DeliveryView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DeliveryCubit, DeliveryState>(
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }
}