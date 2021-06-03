import 'package:data_over_sound_example/utils/margin.dart';
import 'package:data_over_sound_example/utils/navigator.dart';
import 'package:data_over_sound_example/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:im_animations/im_animations.dart';

import '../providers.dart';
import 'receive.dart';

class HomePage extends StatefulHookWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read(homeVM).init(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = useProvider(homeVM);

    return Scaffold(
      backgroundColor: kPrimaryColor,
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
                            width: 80,
                            height: 80,
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
                              'Send money to Chiziaruhoma',
                              style: GoogleFonts.oxygen(
                                fontSize: 15,
                                color: white.withOpacity(0.7),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const YMargin(40),
                            if (!provider.loading)
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 50,
                                    width: 250,
                                    color: white.withOpacity(0.1),
                                    child: TextField(
                                        enabled: false,
                                        textAlign: TextAlign.center,
                                        controller: provider.textTEC,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 20,
                                            color: white,
                                            fontWeight: FontWeight.w500),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '\u20a6 ' '0.00')),
                                  ))
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff2547F4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const YMargin(5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        '+',
                                        style: GoogleFonts.oxygen(
                                          fontSize: 25,
                                          color: white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        '−',
                                        style: GoogleFonts.oxygen(
                                          fontSize: 25,
                                          color: white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        '×',
                                        style: GoogleFonts.oxygen(
                                          fontSize: 25,
                                          color: white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        '÷',
                                        style: GoogleFonts.oxygen(
                                          fontSize: 25,
                                          color: white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        '=',
                                        style: GoogleFonts.oxygen(
                                          fontSize: 25,
                                          color: white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      top: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: white,
                          ),
                          child: KeyPad(),
                        ),
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
                  context.navigate(Receive(), isDialog: true);
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

class KeyPad extends HookWidget {
  const KeyPad({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Spacer(
            flex: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KeyInput(1),
                    KeyInput(2),
                    KeyInput(3),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KeyInput(4),
                    KeyInput(5),
                    KeyInput(6),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KeyInput(7),
                    KeyInput(8),
                    KeyInput(9),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KeyInput('•'),
                    Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: KeyInput('0')),
                    KeyInput('⌫'),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            height: 60,
            width: context.screenWidth(),
            child: CupertinoButton(
              onPressed: () async {
                context.read(homeVM).sendMoney(context);
              },
              borderRadius: BorderRadius.circular(15),
              color: kPrimaryColor,
              child: Text(
                'Send',
                style: GoogleFonts.oxygen(
                  fontSize: 14,
                  color: white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Spacer()
        ],
      ),
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
