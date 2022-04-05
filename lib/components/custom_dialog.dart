import 'package:flutter/material.dart';

class CustomDialog {
  final TickerProvider _tickerProvider;
  CustomDialog.init(this._tickerProvider);

  bool stateChanged = false;
  late AnimationController _controller;

  void dispose() => _controller.dispose();

  void initializeController() => _controller = AnimationController(
        vsync: _tickerProvider,
        duration: const Duration(milliseconds: 130),
      );

  Future<dynamic> show({
    required BuildContext context,
    Future<void> Function()? firstButtonTap,
    required Future<void> Function() secondButtonTap,
    required void Function(bool state) onComplete,
    required String title,
    required String content,
    String firstButtonText = 'Cancel',
    required String secondButtonText,
  }) async {
   /* try {
      _controller.value;
    } catch (e) {
      initializeController();
    }*/
    int count = 0;
    _controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          if (count > 2) {
            count = 0;
          } else {
            _controller.forward();
          }
          count++;
        }
      },
    );
    bool secondButtonLoading = false;
    bool firstButtonLoading = false;
    stateChanged = false;
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) =>
          Transform.scale(
        scale: animation.value,
        child: child,
      ),
      pageBuilder: (dialogContext, animation1, animation2) => WillPopScope(
        onWillPop: () async {
          _controller.forward();
          return false;
        },
        child: StatefulBuilder(
          builder: (stateContext, state) => ScaleTransition(
            scale: Tween<double>(begin: 1, end: 0.7).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
            ),
            child: AlertDialog(
              title: Text(title),
              content: Text(content),
              actionsPadding: const EdgeInsets.only(right: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              actions: [
                ElevatedButton(
                  onPressed: firstButtonLoading
                      ? null
                      : () async {
                          if (firstButtonTap != null) {
                            state(() => firstButtonLoading = true);
                            await firstButtonTap();
                            state(() => firstButtonLoading = false);
                          }
                          Navigator.pop(stateContext);
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.brown),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.brown),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: firstButtonLoading
                      ? const _DialogLoadingIndicator()
                      : Text(firstButtonText),
                ),
                ElevatedButton(
                  onPressed: secondButtonLoading
                      ? null
                      : () async {
                          state(() => secondButtonLoading = true);
                          await secondButtonTap();
                          state(() => secondButtonLoading = false);
                          stateChanged ? Navigator.pop(stateContext) : null;
                        },
                  child: !secondButtonLoading
                      ? Text(secondButtonText)
                      : const _DialogLoadingIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(
      () {
        onComplete(stateChanged);
      },
    );
  }
}

class _DialogLoadingIndicator extends StatelessWidget {
  const _DialogLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 57,
      child: Center(
        child: SizedBox(
          height: 15,
          width: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Colors.white54),
          ),
        ),
      ),
    );
  }
}
