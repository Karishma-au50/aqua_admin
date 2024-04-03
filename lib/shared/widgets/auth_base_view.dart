// import 'dart:ffi';
import 'package:flutter/material.dart';

class AuthBaseView extends StatelessWidget {
  const AuthBaseView({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Positioned(
        //   // top: -100.sp,
        //   left: -150.sp,
        //   child: Transform.rotate(
        //     angle: -27.2,
        //     child: Container(
        //       height: 449.sp,
        //       width: 423.sp,
        //       transform: Matrix4.rotationZ(-30.51 * 0.0174533),
        //       decoration: const BoxDecoration(
        //         gradient: LinearGradient(
        //           begin: Alignment.topCenter,
        //           end: Alignment.bottomCenter,
        //           colors: [
        //             Color.fromRGBO(22, 99, 81, 0.8),
        //             Color.fromRGBO(235, 248, 244, 0.8),
        //           ],
        //         ),
        //         // gradient: LinearGradient(
        //         //   begin: Alignment.topCenter,
        //         //   end: Alignment.bottomCenter,
        //         //   // begin: Alignment.bottomRight,
        //         //   // end: Alignment.bottomLeft,
        //         //   colors: [
        //         //     // Color.fromRGBO(22, 99, 81, 0.6),
        //         //     // Color.fromRGBO(22, 99, 81, 0.4),
        //         //     Color.fromRGBO(22, 99, 81, 0.8),
        //         //     Color.fromRGBO(235, 248, 244, 0.8),
        //         //   ],
        //         // ),
        //         borderRadius: BorderRadius.all(Radius.circular(30)),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.black12,
        //             blurRadius: 10,
        //             spreadRadius: 5,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        Positioned(
          top: 30,
          left: -390,
          child: Container(
            width: 423,
            height: 449.65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(64),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.08),
                  offset: Offset(0, 8),
                  blurRadius: 21,
                ),
              ],
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(22, 99, 81, 0.8),
                  Color.fromRGBO(235, 248, 244, 0.8),
                ],
              ),
            ),
            transform: Matrix4.rotationZ(
                -30.51 * 0.0174533), // Convert degrees to radians
          ),
        ),

        child,
      ],
    );
  }
}
