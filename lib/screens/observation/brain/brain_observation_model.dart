class BrainObservationModel {
  String scanningTechnique;
  double minFocusDiameter;
  double maxFocusDiameter;
  String basalGangliaLocation;
  String basalGangliaSymmetry;
  String basalGangliaContour;
  String basalGangliaDimensions;
  String basalGangliaSignal;
  String lateralVentriclesSymmetry;
  double lateralVentriclesWidthRight;
  double lateralVentriclesWidthLeft;
  double thirdVentricleWidth;
  String sylvianAqueductCondition;
  String fourthVentricleCondition;
  String cerebralLongitudinalFissureLocation;
  String convexitalGroovesCondition;
  String corpusCallosumCondition;
  String brainStemCondition;
  String cerebellumCondition;
  String cerebellarCortexWidthCondition;
  String craniovertebralJunctionCondition;
  String pituitaryGlandCondition;
  double pituitaryGlandHeight;
  String orbitalConesShape;
  String eyeballsShapeSize;
  double opticNervesDiameter;
  String perineuralSubarachnoidSpaceCondition;
  String extraocularMusclesCondition;
  String retrobulbarFattyTissueCondition;
  bool sinusesCystsPresence;
  double sinusesCystsSize;
  String sinusesPneumatization;
  String additionalObservations;

  BrainObservationModel({
    this.scanningTechnique = '',
    this.basalGangliaLocation = '',
    this.basalGangliaSymmetry = '',
    this.basalGangliaContour = '',
    this.basalGangliaDimensions = '',
    this.basalGangliaSignal = '',
    this.lateralVentriclesWidthRight = 0.0,
    this.lateralVentriclesWidthLeft = 0.0,
    this.thirdVentricleWidth = 0.0,
    this.sylvianAqueductCondition = '',
    this.fourthVentricleCondition = '',
    this.corpusCallosumCondition = '',
    this.brainStemCondition = '',
    this.cerebellumCondition = '',
    this.craniovertebralJunctionCondition = '',
    this.pituitaryGlandCondition = '',
    this.orbitalConesShape = '',
    this.eyeballsShapeSize = '',
    this.opticNervesDiameter = 0.0,
    this.extraocularMusclesCondition = '',
    this.retrobulbarFattyTissueCondition = '',
    this.sinusesCystsPresence = false,
    this.sinusesCystsSize = 0.0,
    this.sinusesPneumatization = '',
    this.additionalObservations = '',

    this.minFocusDiameter = 0.0,
    this.maxFocusDiameter = 0.0,
    this.lateralVentriclesSymmetry = '',
    this.cerebralLongitudinalFissureLocation = '',
    this.convexitalGroovesCondition = '',
    this.cerebellarCortexWidthCondition = '',
    this.pituitaryGlandHeight = 0.0,
    this.perineuralSubarachnoidSpaceCondition = '',


  });


  factory BrainObservationModel.initial() {
    return BrainObservationModel(
      scanningTechnique: '',
      basalGangliaLocation: '',
      basalGangliaSymmetry: '',
      basalGangliaContour: '',
      basalGangliaDimensions: '',
      basalGangliaSignal: '',
      lateralVentriclesWidthRight: 0.0,
      lateralVentriclesWidthLeft: 0.0,
      thirdVentricleWidth: 0.0,
      sylvianAqueductCondition: '',
      fourthVentricleCondition: '',
      corpusCallosumCondition: '',
      brainStemCondition: '',
      cerebellumCondition: '',
      craniovertebralJunctionCondition: '',
      pituitaryGlandCondition: '',
      orbitalConesShape: '',
      eyeballsShapeSize: '',
      opticNervesDiameter: 0.0,
      extraocularMusclesCondition: '',
      retrobulbarFattyTissueCondition: '',
      sinusesCystsPresence: false,
      sinusesCystsSize: 0.0,
      sinusesPneumatization: '',
      additionalObservations: '',

      minFocusDiameter: 0.0,
      maxFocusDiameter: 0.0,
      lateralVentriclesSymmetry: '',
      cerebralLongitudinalFissureLocation: '',
      convexitalGroovesCondition: '',
      cerebellarCortexWidthCondition: '',
      pituitaryGlandHeight: 0.0,
      perineuralSubarachnoidSpaceCondition: '',
    );
  }

  factory BrainObservationModel.copyWith(BrainObservationModel observationForm) {
    return BrainObservationModel(
      scanningTechnique: observationForm.scanningTechnique,
      basalGangliaLocation: observationForm.basalGangliaLocation,
      basalGangliaSymmetry: observationForm.basalGangliaSymmetry,
      basalGangliaContour: observationForm.basalGangliaContour,
      basalGangliaDimensions: observationForm.basalGangliaDimensions,
      basalGangliaSignal: observationForm.basalGangliaSignal,
      lateralVentriclesWidthRight: observationForm.lateralVentriclesWidthRight,
      lateralVentriclesWidthLeft: observationForm.lateralVentriclesWidthLeft,
      thirdVentricleWidth: observationForm.thirdVentricleWidth,
      sylvianAqueductCondition: observationForm.sylvianAqueductCondition,
      fourthVentricleCondition: observationForm.fourthVentricleCondition,
      corpusCallosumCondition: observationForm.corpusCallosumCondition,
      brainStemCondition: observationForm.brainStemCondition,
      cerebellumCondition: observationForm.cerebellumCondition,
      craniovertebralJunctionCondition: observationForm.craniovertebralJunctionCondition,
      pituitaryGlandCondition: observationForm.pituitaryGlandCondition,
      orbitalConesShape: observationForm.orbitalConesShape,
      eyeballsShapeSize: observationForm.eyeballsShapeSize,
      opticNervesDiameter: observationForm.opticNervesDiameter,
      extraocularMusclesCondition: observationForm.extraocularMusclesCondition,
      retrobulbarFattyTissueCondition: observationForm.retrobulbarFattyTissueCondition,
      sinusesCystsPresence: observationForm.sinusesCystsPresence,
      sinusesCystsSize: observationForm.sinusesCystsSize,
      sinusesPneumatization: observationForm.sinusesPneumatization,
      additionalObservations: observationForm.additionalObservations,

      minFocusDiameter: observationForm.minFocusDiameter,
      maxFocusDiameter: observationForm.maxFocusDiameter,
      lateralVentriclesSymmetry: observationForm.lateralVentriclesSymmetry,
      cerebralLongitudinalFissureLocation: observationForm.cerebralLongitudinalFissureLocation,
      convexitalGroovesCondition: observationForm.convexitalGroovesCondition,
      cerebellarCortexWidthCondition: observationForm.cerebellarCortexWidthCondition,
      pituitaryGlandHeight: observationForm.pituitaryGlandHeight,
      perineuralSubarachnoidSpaceCondition: observationForm.perineuralSubarachnoidSpaceCondition,

    );
  }


  factory BrainObservationModel.fromJson(Map<String, dynamic> json) {
    return BrainObservationModel(
      scanningTechnique: json['scanningTechnique'],
      basalGangliaLocation: json['basalGangliaLocation'],
      basalGangliaSymmetry: json['basalGangliaSymmetry'],
      basalGangliaContour: json['basalGangliaContour'],
      basalGangliaDimensions: json['basalGangliaDimensions'],
      basalGangliaSignal: json['basalGangliaSignal'],
      lateralVentriclesWidthRight: json['lateralVentriclesWidthRight'],
      lateralVentriclesWidthLeft: json['lateralVentriclesWidthLeft'],
      thirdVentricleWidth: json['thirdVentricleWidth'],
      sylvianAqueductCondition: json['sylvianAqueductCondition'],
      fourthVentricleCondition: json['fourthVentricleCondition'],
      corpusCallosumCondition: json['corpusCallosumCondition'],
      brainStemCondition: json['brainStemCondition'],
      cerebellumCondition: json['cerebellumCondition'],
      craniovertebralJunctionCondition: json['craniovertebralJunctionCondition'],
      pituitaryGlandCondition: json['pituitaryGlandCondition'],
      orbitalConesShape: json['orbitalConesShape'],
      eyeballsShapeSize: json['eyeballsShapeSize'],
      opticNervesDiameter: json['opticNervesDiameter'],
      extraocularMusclesCondition: json['extraocularMusclesCondition'],
      retrobulbarFattyTissueCondition: json['retrobulbarFattyTissueCondition'],
      sinusesCystsPresence: json['sinusesCystsPresence'],
      sinusesCystsSize: json['sinusesCystsSize'],
      sinusesPneumatization: json['sinusesPneumatization'],
      additionalObservations: json['additionalObservations'],

      minFocusDiameter: json['minFocusDiameter'],
      maxFocusDiameter: json['maxFocusDiameter'],
      lateralVentriclesSymmetry: json['lateralVentriclesSymmetry'],
      cerebralLongitudinalFissureLocation: json['cerebralLongitudinalFissureLocation'],
      convexitalGroovesCondition: json['convexitalGroovesCondition'],
      cerebellarCortexWidthCondition: json['cerebellarCortexWidthCondition'],
      pituitaryGlandHeight: json['pituitaryGlandHeight'],
      perineuralSubarachnoidSpaceCondition: json['perineuralSubarachnoidSpaceCondition'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scanningTechnique': scanningTechnique,
      'basalGangliaLocation': basalGangliaLocation,
      'basalGangliaSymmetry': basalGangliaSymmetry,
      'basalGangliaContour': basalGangliaContour,
      'basalGangliaDimensions': basalGangliaDimensions,
      'basalGangliaSignal': basalGangliaSignal,
      'lateralVentriclesWidthRight': lateralVentriclesWidthRight,
      'lateralVentriclesWidthLeft': lateralVentriclesWidthLeft,
      'thirdVentricleWidth': thirdVentricleWidth,
      'sylvianAqueductCondition': sylvianAqueductCondition,
      'fourthVentricleCondition': fourthVentricleCondition,
      'corpusCallosumCondition': corpusCallosumCondition,
      'brainStemCondition': brainStemCondition,
      'cerebellumCondition': cerebellumCondition,
      'craniovertebralJunctionCondition': craniovertebralJunctionCondition,
      'pituitaryGlandCondition': pituitaryGlandCondition,
      'orbitalConesShape': orbitalConesShape,
      'eyeballsShapeSize': eyeballsShapeSize,
      'opticNervesDiameter': opticNervesDiameter,
      'extraocularMusclesCondition': extraocularMusclesCondition,
      'retrobulbarFattyTissueCondition': retrobulbarFattyTissueCondition,
      'sinusesCystsPresence': sinusesCystsPresence,
      'sinusesCystsSize': sinusesCystsSize,
      'sinusesPneumatization': sinusesPneumatization,
      'additionalObservations': additionalObservations,

      'minFocusDiameter': minFocusDiameter,
      'maxFocusDiameter': maxFocusDiameter,
      'lateralVentriclesSymmetry': lateralVentriclesSymmetry,
      'cerebralLongitudinalFissureLocation': cerebralLongitudinalFissureLocation,
      'convexitalGroovesCondition': convexitalGroovesCondition,
      'cerebellarCortexWidthCondition': cerebellarCortexWidthCondition,
      'pituitaryGlandHeight': pituitaryGlandHeight,
      'perineuralSubarachnoidSpaceCondition': perineuralSubarachnoidSpaceCondition,

    };
  }
}
