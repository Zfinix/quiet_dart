import 'package:data_over_sound_example/utils/margin.dart';
import 'package:data_over_sound_example/utils/navigator.dart';
import 'package:data_over_sound_example/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:im_animations/im_animations.dart';
import 'package:transparent_image/transparent_image.dart';

import '../providers.dart';
import 'receive.dart';
import 'receive_img.dart';

class SendImg extends StatefulHookWidget {
  SendImg({Key key}) : super(key: key);

  @override
  _SendImgState createState() => _SendImgState();
}

class _SendImgState extends State<SendImg> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read(homeVM).init(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = useProvider(homeVM);

    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'chizi',
                        child: ColorSonar(
                          wavesDisabled: !provider.loading,
                          // waveMotion: WaveMotion.synced,
                          contentAreaRadius: 10,
                          contentAreaColor: white.withOpacity(0.1),
                          innerWaveColor: white.withOpacity(0.1),
                          outerWaveColor: white.withOpacity(0.1),
                          middleWaveColor: white.withOpacity(0.1),
                          waveFall: 50,
                          waveMotion: WaveMotion.synced,
                          // duration: Duration(seconds: 5),
                          child: Container(
                            width: 120,
                            height: 120,
                            child:
                                Image.asset('assets/img/chizi.png', height: 80),
                          ),
                        ),
                      ),
                      if (!provider.loading)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const YMargin(20),
                            Text(
                              'Send a photo to Chiziaruhoma',
                              style: GoogleFonts.oxygen(
                                fontSize: 15,
                                color: white.withOpacity(0.7),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const YMargin(40),
                          ],
                        )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Stack(
                  children: [
                    Positioned.fill(
                      top: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        child: ImageSection(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CupertinoButton(
                padding: EdgeInsets.only(top: 40, right: 40),
                onPressed: () async {
                  context.navigate(ReceiveImage(), isDialog: true);
                },
                child: Icon(
                  CupertinoIcons.waveform_path,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageSection extends HookWidget {
  const ImageSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var prov = useProvider(homeVM);
    return Container(
      decoration: BoxDecoration(
        color: white,
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 250,
                width: context.screenWidth(0.8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: prov.image != null
                      ? DecorationImage(fit: BoxFit.cover, image: FileImage(prov.image))
                      : null,
                ),
              ),
            ),
            Positioned(
              right: 10,
              top:10,
              child: GestureDetector(
                onTap: (){
                  prov.image = null;
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: black.withOpacity(0.2),
                    padding: EdgeInsets.all(4),
                    child: Icon(CupertinoIcons.xmark, size:16),
                  ),
                ),
              ),
            )
          ],
        ),
        const YMargin(40),
        Container(
          height: 60,
          width: context.screenWidth(0.8),
          child: CupertinoButton(
            onPressed: () async {
              if (prov.image != null)
                context.read(homeVM).sendImage(context);
              else
                context.read(homeVM).getImage();
            },
            borderRadius: BorderRadius.circular(15),
            color: Colors.green,
            child: Text(
              prov.image == null ? 'Pick Image' : 'Send Image',
              style: GoogleFonts.oxygen(
                fontSize: 18,
                color: white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class KeyInput extends HookWidget {
  final dynamic _;
  const KeyInput(this._);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        context.read(homeVM).onTapNum("$_");
      },
      child: Text(
        '$_',
        style: GoogleFonts.oxygen(
            fontSize: 20, color: black, fontWeight: FontWeight.w500),
      ),
    );
  }
}
