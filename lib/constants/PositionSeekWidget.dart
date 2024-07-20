import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/constants/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionSeekWidget extends StatefulWidget {
  Duration? currentPosition;
  Duration? duration;
  Function(Duration)? seekTo;
  Color? bgColor;

  PositionSeekWidget({Key? key, this.currentPosition, this.duration, this.seekTo, this.bgColor}) : super(key: key);

  @override
  _PositionSeekWidgetState createState() => _PositionSeekWidgetState();
}

class _PositionSeekWidgetState extends State<PositionSeekWidget> {
  Duration? _visibleValue;
  bool? listenOnlyUserInterraction = false;

  double get percent => widget.duration!.inMilliseconds == 0 ? 0 : _visibleValue!.inMilliseconds / widget.duration!.inMilliseconds;
  int get showVal => widget.currentPosition!.inMilliseconds > widget.duration!.inMilliseconds ? widget.duration!.inMilliseconds : widget.currentPosition!.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _visibleValue = widget.currentPosition;
  }

  @override
  void didUpdateWidget(PositionSeekWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInterraction!) {
      _visibleValue = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0.r),
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Styles.regular(durationToString(widget.currentPosition!), c: whiteColor, ff: "Poppins-Regular", fs: 15.sp),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8)),
              child: Slider(
                min: 0,
                max: widget.duration!.inMilliseconds.toDouble(),
                value: showVal.toDouble()<00?00:showVal.toDouble(),
                activeColor: whiteColor,
                inactiveColor: whiteColor.withOpacity(0.6),
                onChangeEnd: (newValue) {
                  setState(() {
                    listenOnlyUserInterraction = false;
                    widget.seekTo!(_visibleValue!);
                  });
                },
                onChangeStart: (_) {
                  setState(() {
                    listenOnlyUserInterraction = true;
                  });
                },
                onChanged: (newValue) {
                  setState(() {
                    final to = Duration(milliseconds: newValue.floor());
                    _visibleValue = to;
                  });
                },
              ),
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              child: Styles.regular(durationToString(widget.duration!), c: whiteColor, ff: "Poppins-Regular", fs: 15.sp)),
        ],
      ),
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  final twoDigitHours = twoDigits(duration.inHours.remainder(Duration.hoursPerDay));
  final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return twoDigitHours == "00" ? '$twoDigitMinutes:$twoDigitSeconds' : '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
}
