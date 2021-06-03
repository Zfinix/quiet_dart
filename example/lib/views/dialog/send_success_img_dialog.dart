import 'dart:typed_data';

import 'package:data_over_sound_example/utils/margin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SendSuccessImageDialog extends StatelessWidget {
  final Uint8List rawImage;
  final bool sent;
  const SendSuccessImageDialog([this.rawImage, this.sent = true]);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight(0.63),
      child: Material(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            YMargin(context.screenHeight(0.06)),
            if (sent)
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  "assets/img/sd.gif",
                  height: 130,
                  width: 130,
                  fit: BoxFit.cover,
                ),
              ),
            YMargin(context.screenHeight(0.1)),
            Container(
              child: Text(
                'You ${sent ? 'Sent' : 'Received'} an Image via sound',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  color: Color(0xffA3A3A3),
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const YMargin(20),
            if (!sent)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 230,
                  width: context.screenWidth(0.8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: rawImage != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(rawImage),
                          )
                        : null,
                  ),
                ),
              ),
            const XMargin(30)
          ],
        ),
      ),
    );
  }
}
