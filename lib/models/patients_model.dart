import 'package:brainmri/models/observation_model.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class PatientModel {

  PatientModel({
    this.id,
    this.fullName,
    this.birthYear,
    this.observations,
  });

factory PatientModel.fromJson(Map<dynamic, dynamic> json) {
  return PatientModel(
    id: json['id'],
    fullName: json['fullName'],
    birthYear: json['birthYear'],
    observations: json['observations'],
  );
}
  String? id;
  String? fullName;
  String? birthYear;
  List<ObservationModel>? observations;

  PatientModel copyWith({
    String? id,
    String? fullName,
    String? birthYear,
    List<ObservationModel>? observations,
  }) {
    return PatientModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      birthYear: birthYear ?? this.birthYear,
      observations: observations ?? this.observations,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'birthYear': birthYear,
      'observations': observations?.map((e) => e.toJson()).toList(),
    };
  }
}