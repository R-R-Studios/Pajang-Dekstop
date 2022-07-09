import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final bool isLoading;

  LoadingScreen({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 24),
            child: Card(
                color: Colors.grey[200],
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.all(18),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            new CircularProgressIndicator(),
                            Container(
                              margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                              child: Text(
                                'Mohon menunggu',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'poppins_bold'),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          )),
    );
  }
}
