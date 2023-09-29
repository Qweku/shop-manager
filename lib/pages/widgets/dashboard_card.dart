import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class DashboardCard extends StatefulWidget {
  final double totalProfit;
  const DashboardCard({Key? key, required this.totalProfit}) : super(key: key);

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  List<String> period = ['1D', '1W', '1M', '1Y'];
  List<String> periodProfit = ["Today's", "This Week's", "This Month's", "This Year's"];
  int tap = 0;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              top: -height * 0.15,
              left: -width * 0.2,
              child: Transform.rotate(
                angle: pi / 4,
                child: Container(
                    height: height * 0.5,
                    width: width * 0.4,
                    color: actionColor.withOpacity(0.1)),
              ),
            ),
            Positioned(
              top: -height * 0.15,
              right: -width * 0.3,
              child: Transform.rotate(
                angle: -(pi / 4),
                child: Container(
                    height: height * 0.5,
                    width: width * 0.4,
                    color: actionColor.withOpacity(0.1)),
              ),
            ),
            Positioned(
              bottom: -height * 0.2,
              right: width * 0.05,
              child: Transform.rotate(
                angle: -(pi / 4),
                child: Container(
                    height: height * 0.3,
                    width: width * 0.4,
                    color: primaryColor.withOpacity(0.1)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                        period.length,
                        (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tap = index;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  // width: width * 0.15,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: tap == index
                                            ? primaryColor
                                            : Colors.grey),
                                    color: tap == index
                                        ? primaryColor
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    period[index],
                                    textAlign: TextAlign.center,
                                    style: bodyText2.copyWith(
                                        color: tap == index
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                ),
                              ),
                            )),
                  ),
                  SizedBox(height: height * 0.05),
                  Text(
                    "${periodProfit[tap]} Profit",
                    style: bodyText1.copyWith(fontSize: 17, color: Colors.grey),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    'GHS ${widget.totalProfit.toStringAsFixed(2)}',
                    style: headline1.copyWith(fontSize: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
