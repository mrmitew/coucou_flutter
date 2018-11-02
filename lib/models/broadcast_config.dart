class BroadcastConfig {
  final String type;
  final String name;
  final int port;
  final Map<String, String> txtRecords;

  BroadcastConfig({this.type, this.name, this.port, this.txtRecords});

  toMap() => {
        "type": type,
        "name": name,
        "port": port,
        "txtRecords": txtRecords,
      };
}
