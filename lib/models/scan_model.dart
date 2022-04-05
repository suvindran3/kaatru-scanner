class ScanModel {
  final String deviceID;
  final String macAddress;

  ScanModel.fromScan(List<String> config)
      : deviceID = config.elementAt(0).split(':')[1].trim(),
        macAddress = config.elementAt(1).split(':')[1].trim();
}
