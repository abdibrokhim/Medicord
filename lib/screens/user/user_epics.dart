import 'dart:async';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/screens/user/user_service.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';


Stream<dynamic> fetchAllPatientsEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is FetchAllPatients)
      .asyncMap((action) => UserService.fetchPatients())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            FetchAllPatientsResponse(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching patients'),
          ]));
}

Stream<dynamic> updatePatientConclusionEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is UpdatePatientConclusion)
      .asyncMap((action) => UserService.updatePatientConclusion(action.patientId, action.observationId, action.conclusion))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            UpdatePatientConclusionResponse(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while updating patient conclusion'),
          ]));
}

Stream<dynamic> approvePatientConclusionEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is ApprovePatientConclusionAction)
      .asyncMap((action) => UserService.approvePatientConclusion(action.patientId, action.observationId, action.name))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            ApprovePatientConclusionResponse(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while approving patient conclusion'),
          ]));
}

Stream<dynamic> validatePatientConclusionEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is ValidatePatientConclusionAction)
      .asyncMap((action) => UserService.validatePatientConclusion(action.patientId, action.observationId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            ValidatePatientConclusionResponse(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while validating patient conclusion'),
          ]));
}

Stream<dynamic> savePatientObservationEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SavePatientObservationAction)
      .asyncMap((action) => UserService.savePatientObservation(action.patientId, action.observation))
      .flatMap<dynamic>((_) => Stream.fromIterable([
            SavePatientObservationResponse(),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while saving patient observation'),
          ]));
}

Stream<dynamic> saveNewPatientEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SaveNewPatientAction)
      .asyncMap((action) => UserService.saveNewPatient(action.fullName, action.birthYear))
      .flatMap<dynamic>((_) => Stream.fromIterable([
            SaveNewPatientResponse(),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while saving new patient'),
          ]));
}

Stream<dynamic> fetchAllPatientNamesEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is FetchAllPatientNamesAction)
      .asyncMap((action) => UserService.fetchAllPatientNames())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            FetchAllPatientNamesResponse(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching patient names'),
          ]));
}


Stream<dynamic> gptEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GptGenerateConclusionAction)
      .asyncMap((action) => UserService.gpt(action.observation))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GptGenerateConclusionResponse(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching patient names'),
          ]));
}

Stream<dynamic> generateReportEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is GenerateReportAction)
      .asyncMap((action) => UserService.generatePatientReport(action.pId, action.pName, action.bYear, action.observation))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            GenerateReportResponse(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            GenerateReportResponse(''),
            HandleGenericErrorAction('Error while fetching patient names'),
          ]));
}

Stream<dynamic> downloadReportEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is DownloadReportAction)
      .asyncMap((action) => UserService.downloadFile(action.path))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            DownloadReportResponse(),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching patient names'),
          ]));
}

Stream<dynamic> fetchPatientAllObservationsEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is FetchPatientAllObservations)
      .asyncMap((action) => UserService.fetchPatientAllObservations(action.patientId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            FetchPatientAllObservationsResponse(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching patient names'),
          ]));
}

Stream<dynamic> fetchPatientSingleObservationEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is FetchPatientSingleObservation)
      .asyncMap((action) => UserService.fetchPatientSingleObservation(action.patientId, action.observationId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            FetchPatientSingleObservationResponse(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching patient names'),
          ]));
}

Stream<dynamic> fetchOrganizationEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is FetchOrganizationAction)
      .asyncMap((action) => UserService.fetchOrganizationDetails())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            FetchOrganizationResponse(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching organization details'),
          ]));
}

Stream<dynamic> saveOrganizationDetailsEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SaveOrganizationDetailsAction)
      .asyncMap((action) => UserService.saveOrganizationDetails(action.organization))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SaveOrganizationDetailsResponse(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching organization details'),
          ]));
}


// basic testing epics

Stream<dynamic> saveReportUrlFirebaseEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SaveReportUrlFirebaseAction)
      .asyncMap((action) => UserService.saveReportUrlFirebase(action.pId, action.oId, action.url))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SaveReportUrlFirebaseActionResponse(),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching patients'),
          ]));
}



//==== simulations for testing purposes only ====//

// simulate conclusion generation
Stream<dynamic> simulateGenerateConclusionResponseActionEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SimulateGenerateConclusionAction)
      .asyncMap((action) => UserService.simulateGen())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SimulateGenerateConclusionResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching patient names'),
          ]));
}

Stream<dynamic> simulateSavePatientObservationAction(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SimulateSavePatientObservationAction)
      .asyncMap((action) => UserService.simulateS())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SimulateSavePatientObservationResponseAction(),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching patient names'),
          ]));
}


Stream<dynamic> simulateApprovePatientConclusionAction(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SimulateApprovePatientConclusionAction)
      .asyncMap((action) => UserService.simulateA())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SimulateApprovePatientConclusionResponseAction(),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching patient names'),
          ]));
}

Stream<dynamic> simulateGenerateReport(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SimulateGenerateReport)
      .asyncMap((action) => UserService.simulateR())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SimulateGenerateReportResponse(),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching patient names'),
          ]));
}

Stream<dynamic> simulateDownloadReport(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SimulateDownloadReport)
      .asyncMap((action) => UserService.simulateD())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SimulateDownloadReportResponse(),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching patient names'),
          ]));
}





List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> userEffects = [
  fetchAllPatientsEpic,
  updatePatientConclusionEpic,
  approvePatientConclusionEpic,
  validatePatientConclusionEpic,
  savePatientObservationEpic,
  saveNewPatientEpic,
  fetchAllPatientNamesEpic,
  gptEpic,
  generateReportEpic,
  downloadReportEpic,
  fetchPatientAllObservationsEpic,
  fetchPatientSingleObservationEpic,
  fetchOrganizationEpic,
  saveOrganizationDetailsEpic,

  // basic testing epics
  saveReportUrlFirebaseEpic,

  //==== simulations for testing purposes only ====//
  simulateGenerateConclusionResponseActionEpic,
  simulateSavePatientObservationAction,
  simulateApprovePatientConclusionAction,
  simulateGenerateReport,
  simulateDownloadReport
];

