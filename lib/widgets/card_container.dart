import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  // const CardContainer({super.key});
  final Widget child;

  const CardContainer({Key? key, required this.child}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
          width:double.infinity,
          // height: 300,
          padding: EdgeInsets.all(20),
          // color:Colors.red
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0,5)
              )
            ],
          ),
          child: this.child,
        ),
    );
  }
}