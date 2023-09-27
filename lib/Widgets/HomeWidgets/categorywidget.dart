import 'package:designerdigger/Utilities/Provider/categoryprovider.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.asset,
    required this.activecatvalue,
  });

  final String asset, activecatvalue;

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Consumer<CategoryProvider>(
      builder: (context, value, child) {
        return InkWell(
          onTap: () {
            value.setactivecat(activecatvalue.toString());
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                Container(
                  height: sc.height * 0.105,
                  width: sc.width / 5.1,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                        asset.toString(),
                      )),
                      color: value.activecat == activecatvalue.toString()
                          ? buttonclr
                          : Theme.of(context).brightness == Brightness.dark
                              ? darkbackgroundclr
                              : lgreyclr,
                      borderRadius: BorderRadius.circular(12)),
                ),
                SizedBox(
                  height: sc.height * 0.01,
                ),
                Text(
                  activecatvalue,
                  style: const TextStyle(
                    color: greyclr,
                    fontSize: 15.3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
