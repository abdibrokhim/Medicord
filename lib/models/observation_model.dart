import 'package:brainmri/models/conclusion_model.dart';

class ObservationModel {

  ObservationModel({
    this.id,
    this.text,
    this.observedAt,
    this.radiologistName,
    this.conclusion,
    this.reportPath,
  });

  factory ObservationModel.fromJson(Map<dynamic, dynamic> json) {
    return ObservationModel(
      id: json['id'],
      text: json['text'],
      observedAt: json['observedAt'] != null ? DateTime.parse(json['observedAt']) : null,
      radiologistName: json['radiologistName'],
      conclusion: json['conclusion'],
      reportPath: json['reportPath'],
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'observedAt': observedAt?.toIso8601String(),
    'radiologistName': radiologistName,
    'conclusion': conclusion?.toJson(),
    'reportPath': reportPath,
  };


  final String? id;
  final String? text;
  final DateTime? observedAt;
  final String? radiologistName;
  final ConclusionModel? conclusion;
  final String? reportPath;

  ObservationModel copyWith({
    String? id,
    String? text,
    DateTime? observedAt,
    String? radiologistName,
    ConclusionModel? conclusion,
    String? reportPath,
  }) {
    return ObservationModel(
      id: id ?? this.id,
      text: text ?? this.text,
      observedAt: observedAt ?? this.observedAt,
      radiologistName: radiologistName ?? this.radiologistName,
      conclusion: conclusion ?? this.conclusion,
      reportPath: reportPath ?? this.reportPath,
    );
  }
}