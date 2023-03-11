import 'package:flutter/material.dart';

class TreEMbanner extends StatelessWidget {
  const TreEMbanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: Container(
        color: Colors.white60,
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'lib/assets/logo-tondo.png',
                width: 100,
                height: 100,
              ),
              Image.asset(
                'lib/assets/logo-3.png',
              ),
              Column(
                children: const [
                  Text(
                    "PENNATA PARKING",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Text(
                    "INFO@3EM.IT",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
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
