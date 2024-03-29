import 'package:brainmri/models/observation_model.dart';
import 'package:brainmri/models/patients_model.dart';
import 'package:brainmri/screens/observation/brain/brain_observation_model.dart';
import 'package:redux/redux.dart';
import 'package:firebase_auth/firebase_auth.dart';



class UserState {
  final bool isLoading;
  final bool isLoggedIn;
  final bool isSignedUp;
  final String? accessToken;
  final String? refreshToken;
  final String message;
  final List<String?> errors;
  final User? user;
  final bool isPatientsListLoading;
  final List<PatientModel> patientsList;
  final bool isApprovingConclusion;
  final bool isValidatingConclusion;
  final bool isSavingObservation;
  final bool isSavingNewPatient;
  final bool isFetchingPatientNames;
  final List<Map<String, String>> patientNames;
  final Map<String, String> selectedPatient;
  final Map<String, String> selectedOType;
  final BrainObservationModel? brainObservation;
  final String conclusion;
  final bool isGeneratingConclusion;
  final String observationString;
  final bool isGeneratingReport;
  final bool isDownloadingReport;
  final String reportPath;
  final List<ObservationModel> patientObservations;
  final ObservationModel? patientSingleObservation;

  UserState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.isSignedUp = false,
    this.accessToken = '',
    this.refreshToken = '',
    this.message = '',
    this.errors = const [],
    this.user,
    this.isPatientsListLoading = false,
    this.patientsList = const [],
    this.isApprovingConclusion = false,
    this.isValidatingConclusion = false,
    this.isSavingObservation = false,
    this.isSavingNewPatient = false,
    this.isFetchingPatientNames = false,
    this.patientNames = const [],
    this.selectedPatient = const {},
    this.selectedOType = const {},
    this.brainObservation,
    this.conclusion = '',
    this.isGeneratingConclusion = false,
    this.observationString = '',
    this.isGeneratingReport = false,
    this.isDownloadingReport = false,
    this.reportPath = '',
    this.patientObservations = const [],
    this.patientSingleObservation,
  });

  UserState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    bool? isSignedUp,
    String? accessToken,
    String? refreshToken,
    String? message,
    List<String?>? errors,
    User? user,
    bool? isPatientsListLoading,
    List<PatientModel>? patientsList,
    bool? isApprovingConclusion,
    bool? isValidatingConclusion,
    bool? isSavingObservation,
    bool? isSavingNewPatient,
    bool? isFetchingPatientNames,
    List<Map<String, String>>? patientNames,
    Map<String, String>? selectedPatient,
    Map<String, String>? selectedOType,
    BrainObservationModel? brainObservation,
    String? conclusion,
    bool? isGeneratingConclusion,
    String? observationString,
    bool? isGeneratingReport,
    bool? isDownloadingReport,
    String? reportPath,
    List<ObservationModel>? patientObservations,
    ObservationModel? patientSingleObservation,

  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isSignedUp: isSignedUp ?? this.isSignedUp,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      message: message ?? this.message,
      errors: errors ?? this.errors,
      user: user ?? this.user,
      isPatientsListLoading: isPatientsListLoading ?? this.isPatientsListLoading,
      patientsList: patientsList ?? this.patientsList,
      isApprovingConclusion: isApprovingConclusion ?? this.isApprovingConclusion,
      isValidatingConclusion: isValidatingConclusion ?? this.isValidatingConclusion,
      isSavingObservation: isSavingObservation ?? this.isSavingObservation,
      isSavingNewPatient: isSavingNewPatient ?? this.isSavingNewPatient,
      isFetchingPatientNames: isFetchingPatientNames ?? this.isFetchingPatientNames,
      patientNames: patientNames ?? this.patientNames,
      selectedPatient: selectedPatient ?? this.selectedPatient,
      selectedOType: selectedOType ?? this.selectedOType,
      brainObservation: brainObservation ?? this.brainObservation,
      conclusion: conclusion ?? this.conclusion,
      isGeneratingConclusion: isGeneratingConclusion ?? this.isGeneratingConclusion,
      observationString: observationString ?? this.observationString,
      isGeneratingReport: isGeneratingReport ?? this.isGeneratingReport,
      isDownloadingReport: isDownloadingReport ?? this.isDownloadingReport,
      reportPath: reportPath ?? this.reportPath,
      patientObservations: patientObservations ?? this.patientObservations,
      patientSingleObservation: patientSingleObservation ?? this.patientSingleObservation,
    );
  }
}


// ========== SignInWithGoogle reducers ========== //


class SignInWithGoogle {
  SignInWithGoogle();
}

UserState signInWithGoogleReducer(UserState state, SignInWithGoogle action) {
  return state.copyWith(isLoading: true);
}

class SignInWithGoogleSuccessAction {
  final User user;

  SignInWithGoogleSuccessAction(
    this.user,
  );
}

UserState signInWithGoogleSuccessReducer(UserState state, SignInWithGoogleSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    isLoggedIn: true,
    user: action.user,
  );
}


// ========== SignUp reducers ========== //

class SignUpAction {
  final String name;
  final String email;
  final String password;

  SignUpAction(
    this.name,
    this.email,
    this.password,
  );
}

UserState signUpReducer(UserState state, SignUpAction action) {
  return state.copyWith(isLoading: true);
}

class SignUpResponseAction {
  final User? user;
  
  SignUpResponseAction(this.user);
}

UserState signUpSuccessReducer(
  UserState state,
  SignUpResponseAction action,
) {
  return state.copyWith(
    isLoading: false,
    isSignedUp: true,
    user: action.user,
  );
}


// ========== Login reducers ========== //

class LoginAction {
  String email;
  String password;

  LoginAction(
    this.email,
    this.password,
  );
}


UserState loginReducer(UserState state, LoginAction action) {
  return state.copyWith(isLoading: true);
}

class LoginSuccessAction {
  final User? user;

  LoginSuccessAction(
    this.user,
  );
}

UserState loginSuccessReducer(UserState state, LoginSuccessAction action) {
  return state.copyWith(
    isLoggedIn: true, 
    isLoading: false,
    user: action.user,
  );
}

// ========== Fetch Specific Patient observations by patient id reducers ========== //
class FetchPatientAllObservations {
  final String patientId;

  FetchPatientAllObservations(
    this.patientId,
  );
}

class FetchPatientAllObservationsResponse {
  final PatientModel observations;

  FetchPatientAllObservationsResponse(
    this.observations,
  );
}

UserState fetchPatientAllObservationsReducer(UserState state, FetchPatientAllObservations action) {
  return state.copyWith(isLoading: true);
}

UserState fetchPatientAllObservationsResponseReducer(UserState state, FetchPatientAllObservationsResponse action) {
  return state.copyWith(
    isLoading: false,
    patientsList: state.patientsList.map((patient) {
      if (patient.id == action.observations.id) {
        return action.observations;
      }
      return patient;
    }).toList(),
  );
}

// ========== Fetch Specific Patient observation by patient id and observation id reducers ========== //
class FetchPatientSingleObservation {
  final String patientId;
  final String observationId;

  FetchPatientSingleObservation(
    this.patientId,
    this.observationId,
  );
}

class FetchPatientSingleObservationResponse {
  final Map<String, dynamic> data;

  FetchPatientSingleObservationResponse(
    this.data,
  );
}

UserState fetchPatientSingleObservationReducer(UserState state, FetchPatientSingleObservation action) {
  return state.copyWith(isLoading: true);
}

UserState fetchPatientSingleObservationResponseReducer(UserState state, FetchPatientSingleObservationResponse action) {

  String pId = action.data['patientId'];
  ObservationModel o = ObservationModel.fromJson(action.data['observation']);
  print('observation: $o');

  return state.copyWith(
    isLoading: false,
    patientsList: state.patientsList.map((patient) {
      if (patient.id == pId) {
        List<ObservationModel> updatedObservations = patient.observations?.map((observation) {
          if (observation.id == o.id) {
            return o; // Use the updated observation object
          }
          return observation;
        }).toList() ?? []; // Handle the case where patient.observations might be null
        return patient.copyWith(observations: updatedObservations);
      }
      return patient;
    }).toList(),
  );
}



// ========== FetchAllPatients reducers ========== //

class FetchAllPatients {
  FetchAllPatients();
}

UserState fetchAllPatientsReducer(UserState state, FetchAllPatients action) {
  return state.copyWith(isPatientsListLoading: true);
}

class FetchAllPatientsResponse {
  final List<PatientModel> patientsList;

  FetchAllPatientsResponse(
    this.patientsList,
  );
}

UserState fetchAllPatientsResponseReducer(UserState state, FetchAllPatientsResponse action) {
  return state.copyWith(
    isPatientsListLoading: false,
    patientsList: action.patientsList,
  );
}


// ========== UpdatePatientConclusion reducers ========== //

class UpdatePatientConclusion {
  final String patientId;
  final String observationId;
  final String conclusion;

  UpdatePatientConclusion(
    this.patientId,
    this.observationId,
    this.conclusion,
  );
}

class UpdatePatientConclusionResponse {

  UpdatePatientConclusionResponse();
}

UserState updatePatientConclusionReducer(UserState state, UpdatePatientConclusion action) {
  return state.copyWith(isSavingObservation: true);
}

UserState updatePatientConclusionResponseReducer(UserState state, UpdatePatientConclusionResponse action) {
  return state.copyWith(isSavingObservation: false);
}


// ========== ApprovePatientConclusion reducers ========== //

class ApprovePatientConclusionAction {
  final String patientId;
  final String observationId;
  final String name;

  ApprovePatientConclusionAction(this.patientId, this.observationId, this.name);
}

class ApprovePatientConclusionResponse {
  final bool success;

  ApprovePatientConclusionResponse(this.success);
}

UserState approvePatientConclusionReducer(UserState state, ApprovePatientConclusionAction action) {
  return state.copyWith(isApprovingConclusion: true);
}

UserState approvePatientConclusionResponseReducer(UserState state, ApprovePatientConclusionResponse action) {
  return state.copyWith(isApprovingConclusion: false);
}


// ========== ValidatePatientConclusion reducers ========== //

class ValidatePatientConclusionAction {
  final String patientId;
  final String observationId;

  ValidatePatientConclusionAction(this.patientId, this.observationId);
}

class ValidatePatientConclusionResponse {
  final bool success;

  ValidatePatientConclusionResponse(this.success);
}

UserState validatePatientConclusionReducer(UserState state, ValidatePatientConclusionAction action) {
  return state.copyWith(isValidatingConclusion: true);
}

UserState validatePatientConclusionResponseReducer(UserState state, ValidatePatientConclusionResponse action) {
  return state.copyWith(isValidatingConclusion: false);
}


// ========== SavePatientObservation reducers ========== //

class SavePatientObservationAction {
  final String patientId;
  final ObservationModel observation;

  SavePatientObservationAction(this.patientId, this.observation);
}

class SavePatientObservationResponse {}

UserState savePatientObservationReducer(UserState state, SavePatientObservationAction action) {
  return state.copyWith(isSavingObservation: true);
}

UserState savePatientObservationResponseReducer(UserState state, SavePatientObservationResponse action) {
  return state.copyWith(isSavingObservation: false);
}


// ========== SaveNewPatient reducers ========== //

class SaveNewPatientAction {
  final String fullName;
  final String birthYear;

  SaveNewPatientAction(this.fullName, this.birthYear);
}

class SaveNewPatientResponse {}

UserState saveNewPatientReducer(UserState state, SaveNewPatientAction action) {
  return state.copyWith(isSavingNewPatient: true);
}

UserState saveNewPatientResponseReducer(UserState state, SaveNewPatientResponse action) {
  return state.copyWith(isSavingNewPatient: false);
}


// ========== FetchAllPatientNames reducers ========== //

class FetchAllPatientNamesAction {}

class FetchAllPatientNamesResponse {
  final List<Map<String, String>> patientNames;

  FetchAllPatientNamesResponse(this.patientNames);
}

UserState fetchAllPatientNamesReducer(UserState state, FetchAllPatientNamesAction action) {
  return state.copyWith(isFetchingPatientNames: true);
}

UserState fetchAllPatientNamesResponseReducer(UserState state, FetchAllPatientNamesResponse action) {
  return state.copyWith(
    isFetchingPatientNames: false,
    patientNames: action.patientNames,
  );
}

// ========== selected patient reducers ========== //

class SelectPatientAction {
  final Map<String, String> patient;

  SelectPatientAction(this.patient);
}

UserState selectPatientReducer(UserState state, SelectPatientAction action) {
  return state.copyWith(selectedPatient: action.patient);
}


// ========== selected Observation Type reducers ========== //

class SelectObservationTypeAction {
  final Map<String, String> type;

  SelectObservationTypeAction(this.type);
}

UserState selectObservationTypeAction(UserState state, SelectObservationTypeAction action) {
  return state.copyWith(selectedOType: action.type);
}


// ========== ReinitializeFormAction Actions ========== //

class ReinitializeFormAction {
  ReinitializeFormAction();
}

UserState reinitializeFormReducer(
    UserState state, ReinitializeFormAction action) {
  return state.copyWith(
    brainObservation: BrainObservationModel.initial(),
    errors: [],
    isLoading: false,
    isApprovingConclusion: false,
    isValidatingConclusion: false,
    isSavingObservation: false,
    isSavingNewPatient: false,
    isFetchingPatientNames: false,
  );
}



class GenerateConclusionAction {
  final String observation;

  GenerateConclusionAction(this.observation);
}

class GenerateConclusionResponse {
  final String conclusion;

  GenerateConclusionResponse(this.conclusion);
}

UserState generateConclusionReducer(UserState state, GenerateConclusionAction action) {
  return state.copyWith(isGeneratingConclusion: true);
}

UserState generateConclusionResponseReducer(UserState state, GenerateConclusionResponse action) {
  return state.copyWith(
    isGeneratingConclusion: false,
    conclusion: action.conclusion,
  );
}

class SaveObservationAction {
  final String observation;

  SaveObservationAction(this.observation);
}

UserState saveObservationReducer(UserState state, SaveObservationAction action) {
  return state.copyWith(observationString: action.observation);
}


class GenerateReportAction {
  final PatientModel patient;

  GenerateReportAction(this.patient);
}

class GenerateReportResponse {
  final String reportPath;
  
  GenerateReportResponse(this.reportPath);
}


UserState generateReportReducer(UserState state, GenerateReportAction action) {
  return state.copyWith(isGeneratingReport: true);
}

UserState generateReportResponseReducer(UserState state, GenerateReportResponse action) {
  return state.copyWith(
    isGeneratingReport: false,
    reportPath: action.reportPath,
  );
}


class DownloadReportAction {
  final String path;

  DownloadReportAction(this.path);
}

class DownloadReportResponse {
  
  DownloadReportResponse();
}

// ========== DownloadReport reducers ========== //

UserState downloadReportReducer(UserState state, DownloadReportAction action) {
  return state.copyWith(isDownloadingReport: true);
}

UserState downloadReportResponseReducer(UserState state, DownloadReportResponse action) {
  return state.copyWith(
    isDownloadingReport: false,
    reportPath: ''
  );
}




// ========== simulations ========== //

class SimulateGenerateConclusionAction {

  SimulateGenerateConclusionAction();
}

UserState simulateGenerateConclusionReducer(UserState state, SimulateGenerateConclusionAction action) {
  return state.copyWith(isGeneratingConclusion: true);
}

class SimulateGenerateConclusionResponseAction {
  final String conclusion;

  SimulateGenerateConclusionResponseAction(this.conclusion);
}

UserState simulateGenerateConclusionResponseReducer(UserState state, SimulateGenerateConclusionResponseAction action) {
  print('conclusion: ${action.conclusion}');
  
  return state.copyWith(
    isGeneratingConclusion: false,
    conclusion: action.conclusion,
  );
}


class SimulateSavePatientObservationAction {
  SimulateSavePatientObservationAction();
}

class SimulateSavePatientObservationResponseAction {
  SimulateSavePatientObservationResponseAction();
}

UserState simulateSavePatientObservationReducer(UserState state, SimulateSavePatientObservationAction action) {
  return state.copyWith(isSavingObservation: true);
}

UserState simulateSavePatientObservationResponseReducer(UserState state, SimulateSavePatientObservationResponseAction action) {
  return state.copyWith(
    isSavingObservation: false,
  );
}


class SimulateApprovePatientConclusionAction {
  SimulateApprovePatientConclusionAction();
}

class SimulateApprovePatientConclusionResponseAction {
  SimulateApprovePatientConclusionResponseAction();
}

UserState simulateApprovePatientConclusionReducer(UserState state, SimulateApprovePatientConclusionAction action) {
  return state.copyWith(isApprovingConclusion: true);
}

UserState simulateApprovePatientConclusionResponseReducer(UserState state, SimulateApprovePatientConclusionResponseAction action) {
  return state.copyWith(isApprovingConclusion: false);
}

class SimulateGenerateReport {
  SimulateGenerateReport();
}

class SimulateGenerateReportResponse {
  SimulateGenerateReportResponse();
}

UserState simulateGenerateReportReducer(UserState state, SimulateGenerateReport action) {
  return state.copyWith(isGeneratingReport: true);
}

UserState simulateGenerateReportResponseReducer(UserState state, SimulateGenerateReportResponse action) {
  return state.copyWith(isGeneratingReport: false);
}

class SimulateDownloadReport {
  SimulateDownloadReport();
}

class SimulateDownloadReportResponse {
  SimulateDownloadReportResponse();
}

UserState simulateDownloadReportReducer(UserState state, SimulateDownloadReport action) {
  return state.copyWith(isDownloadingReport: true);
}

UserState simulateDownloadReportResponseReducer(UserState state, SimulateDownloadReportResponse action) {
  return state.copyWith(isDownloadingReport: false);
}



// ========== Combine all reducers ========== //

Reducer<UserState> userReducer = combineReducers<UserState>([
  TypedReducer<UserState, SignInWithGoogle>(signInWithGoogleReducer),
  TypedReducer<UserState, SignInWithGoogleSuccessAction>(signInWithGoogleSuccessReducer),
  TypedReducer<UserState, FetchAllPatients>(fetchAllPatientsReducer),
  TypedReducer<UserState, FetchAllPatientsResponse>(fetchAllPatientsResponseReducer),
  TypedReducer<UserState, ApprovePatientConclusionAction>(approvePatientConclusionReducer),
  TypedReducer<UserState, ApprovePatientConclusionResponse>(approvePatientConclusionResponseReducer),
  TypedReducer<UserState, ValidatePatientConclusionAction>(validatePatientConclusionReducer),
  TypedReducer<UserState, ValidatePatientConclusionResponse>(validatePatientConclusionResponseReducer),
  TypedReducer<UserState, SavePatientObservationAction>(savePatientObservationReducer),
  TypedReducer<UserState, SavePatientObservationResponse>(savePatientObservationResponseReducer),
  TypedReducer<UserState, SaveNewPatientAction>(saveNewPatientReducer),
  TypedReducer<UserState, SaveNewPatientResponse>(saveNewPatientResponseReducer),
  TypedReducer<UserState, FetchAllPatientNamesAction>(fetchAllPatientNamesReducer),
  TypedReducer<UserState, FetchAllPatientNamesResponse>(fetchAllPatientNamesResponseReducer),
  TypedReducer<UserState, SignUpAction>(signUpReducer),
  TypedReducer<UserState, SignUpResponseAction>(signUpSuccessReducer),
  TypedReducer<UserState, LoginAction>(loginReducer),
  TypedReducer<UserState, LoginSuccessAction>(loginSuccessReducer),
  TypedReducer<UserState, UpdatePatientConclusion>(updatePatientConclusionReducer),
  TypedReducer<UserState, UpdatePatientConclusionResponse>(updatePatientConclusionResponseReducer),
  TypedReducer<UserState, SelectPatientAction>(selectPatientReducer),
  TypedReducer<UserState, ReinitializeFormAction>(reinitializeFormReducer),
  TypedReducer<UserState, GenerateConclusionAction>(generateConclusionReducer),
  TypedReducer<UserState, GenerateConclusionResponse>(generateConclusionResponseReducer),
  TypedReducer<UserState, SaveObservationAction>(saveObservationReducer),
  TypedReducer<UserState, GenerateReportAction>(generateReportReducer),
  TypedReducer<UserState, GenerateReportResponse>(generateReportResponseReducer),
  TypedReducer<UserState, DownloadReportAction>(downloadReportReducer),
  TypedReducer<UserState, DownloadReportResponse>(downloadReportResponseReducer),
  TypedReducer<UserState, SelectObservationTypeAction>(selectObservationTypeAction),
  TypedReducer<UserState, FetchPatientAllObservations>(fetchPatientAllObservationsReducer),
  TypedReducer<UserState, FetchPatientAllObservationsResponse>(fetchPatientAllObservationsResponseReducer),
  TypedReducer<UserState, FetchPatientSingleObservation>(fetchPatientSingleObservationReducer),
  TypedReducer<UserState, FetchPatientSingleObservationResponse>(fetchPatientSingleObservationResponseReducer),

  
  //==== simulations for testing purposes only ====//
  TypedReducer<UserState, SimulateGenerateConclusionAction>(simulateGenerateConclusionReducer),
  TypedReducer<UserState, SimulateGenerateConclusionResponseAction>(simulateGenerateConclusionResponseReducer),
  TypedReducer<UserState, SimulateSavePatientObservationAction>(simulateSavePatientObservationReducer),
  TypedReducer<UserState, SimulateSavePatientObservationResponseAction>(simulateSavePatientObservationResponseReducer),
  TypedReducer<UserState, SimulateApprovePatientConclusionAction>(simulateApprovePatientConclusionReducer),
  TypedReducer<UserState, SimulateApprovePatientConclusionResponseAction>(simulateApprovePatientConclusionResponseReducer),
  TypedReducer<UserState, SimulateGenerateReport>(simulateGenerateReportReducer),
  TypedReducer<UserState, SimulateGenerateReportResponse>(simulateGenerateReportResponseReducer),
  TypedReducer<UserState, SimulateDownloadReport>(simulateDownloadReportReducer),
  TypedReducer<UserState, SimulateDownloadReportResponse>(simulateDownloadReportResponseReducer),
]);