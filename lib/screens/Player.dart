import 'package:flutter/material.dart';
import 'package:mliss/components/custom-slider-thumb-shape.dart';
import 'package:mliss/components/custom-slider-track-shape.dart';
import 'package:mliss/components/gradient-background.dart';
import 'package:mliss/constants.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  double _sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return MlissScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            // TODO: temp placeholder for record
            height: 400,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('California',
                    style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'Prompt',
                        fontStyle: FontStyle.italic)),
                Text('Michael Oakley',
                    style: TextStyle(
                      fontSize: 24,
                      color: kSecondaryTextColor,
                      fontWeight: FontWeight.bold,
                    )),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbColor: kSliderHandleColor,
                    trackHeight: 3,
                    overlayColor: kSliderHandleColor,
                    thumbShape: CustomSliderThumbShape(),
                    trackShape: CustomSliderTrackShape(),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                  ),
                  child: Slider(
                    value: _sliderValue,
                    min: 0,
                    max: 100,
                    onChanged: (double value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                ),
                Row(
                  children: <Widget>[],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
