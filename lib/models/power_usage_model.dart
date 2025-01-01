class PowerUsageModel {
  final double current;
  final double energy;
  final double power;
  final double powerFactor;
  final double voltage;
  final String jam;
  final String tanggal;
  final DateTime timestamp;

  PowerUsageModel({
    required this.current,
    required this.energy,
    required this.power,
    required this.powerFactor,
    required this.voltage,
    required this.jam,
    required this.tanggal,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'current': current,
      'energy': energy,
      'power': power,
      'powerFactor': powerFactor,
      'voltage': voltage,
      'jam': jam,
      'tanggal': tanggal,
      'timestamp': timestamp,
    };
  }

  factory PowerUsageModel.fromRealtime(Map<dynamic, dynamic> data) {
    return PowerUsageModel(
      current: (data['current'] ?? 0).toDouble(),
      energy: (data['energy'] ?? 0).toDouble(),
      power: (data['power'] ?? 0).toDouble(),
      powerFactor: (data['powerFactor'] ?? 0).toDouble(),
      voltage: (data['voltage'] ?? 0).toDouble(),
      jam: (data['jam'] ?? ""),
      tanggal: (data['tanggal'] ?? ""),
      timestamp: DateTime.now(),
    );
  }
}
