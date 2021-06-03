import 'package:data_over_sound_example/models/money_model.dart';
import 'package:data_over_sound_example/utils/margin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SendSuccessDialog extends StatelessWidget {
  final MoneyModel moneyModel;
  final bool sent;
  const SendSuccessDialog([this.moneyModel, this.sent= true]);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight(0.6),
      child: Material(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            YMargin(context.screenHeight(0.06)),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                "assets/img/${sent ?'sd':'rc'}.gif",
                height: 130,
                width: 130,
                fit: BoxFit.cover,
              ),
            ),
           
            YMargin(context.screenHeight(0.1)),
            Container(
              child: Text(
                'You ${sent? 'Sent':'Received'} via sound',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  color: Color(0xffA3A3A3),
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const YMargin(10),
            Text(
              cFmt.format(moneyModel?.amount ?? 100.00),
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.w500,
              ),
            ),
            const XMargin(30)
          ],
        ),
      ),
    );
  }
}
