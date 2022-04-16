import 'package:device_scanner/components/scanner_line.dart';
import 'package:device_scanner/models/device_model.dart';
import 'package:device_scanner/network/database.dart';
import 'package:device_scanner/screens/scanned_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String? barcode;

  final MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: controller,
          fit: BoxFit.fitHeight,
          onDetect: handleQRCode,
        ),
        ColorFiltered(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOut),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.black, backgroundBlendMode: BlendMode.dstOut),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.2,
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: MediaQuery.of(context).size.width / 1.2,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const ScannerLine(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                color: Colors.white,
                iconSize: 25.0,
                onPressed: test,
                icon: const Icon(Icons.bug_report_outlined),
              ),
              IconButton(
                color: Colors.white,
                iconSize: 25.0,
                onPressed: () => controller.switchCamera(),
                icon: ValueListenableBuilder(
                  valueListenable: controller.cameraFacingState,
                  builder: (context, state, child) {
                    switch (state as CameraFacing) {
                      case CameraFacing.front:
                        return const Icon(Icons.camera_front);
                      case CameraFacing.back:
                        return const Icon(Icons.camera_rear);
                    }
                  },
                ),
              ),
              IconButton(
                color: Colors.white,
                iconSize: 25.0,
                onPressed: () => controller.toggleTorch(),
                icon: ValueListenableBuilder(
                  valueListenable: controller.torchState,
                  builder: (context, state, child) {
                    switch (state as TorchState) {
                      case TorchState.off:
                        return const Icon(Icons.flash_off, color: Colors.white);
                      case TorchState.on:
                        return const Icon(Icons.flash_on, color: Colors.white);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> test() async {
    const String deviceID = 'KAATRU:S1';
    try {
      final Map<String, String> details = {
        deviceID.split(':')[0]: deviceID.split(':')[1]
      };
      final Position position = await Geolocator.getCurrentPosition();
      final DeviceModel metaDetails = DeviceModel.init(
          userID: Database.user.id,
          username: Database.user.name,
          lat: position.latitude,
          lng: position.longitude,
          id: details['KAATRU']!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScannedScreen(device: metaDetails),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid QR code format',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  dynamic handleQRCode(
      Barcode barcode, MobileScannerArguments? arguments) async {
    if (barcode.rawValue != null) {
      HapticFeedback.vibrate();
      final String deviceID = barcode.rawValue ?? '';
      try {
        final Map<String, String> details = {
          deviceID.split(':')[0]: deviceID.split(':')[1]
        };
        final Position position = await Geolocator.getCurrentPosition();
        final DeviceModel metaDetails = DeviceModel.init(
            userID: Database.user.id,
            username: Database.user.name,
            lat: position.latitude,
            lng: position.longitude,
            id: details['KAATRU']!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScannedScreen(device: metaDetails),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Invalid QR code format',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
