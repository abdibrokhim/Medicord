import 'package:brainmri/screens/observation/brain/brain_observation_model.dart';

String fillObservationTemplate(BrainObservationModel observation) {
  return """
  Observation Report:
  Scanning Technique: ${observation.scanningTechnique}

  In the structure of the subcortical and periventricular white matter of the cerebral hemispheres on both sides, multiple round-shaped foci of pathological intensity are asymmetrically determined. These have unclear contours and homogeneous hyperintense signal characteristics on T2 VI and T2 FLAIR, with diameters ranging from ${observation.minFocusDiameter} to ${observation.maxFocusDiameter} mm.

  The basal ganglia are ${observation.basalGangliaLocation} and ${observation.basalGangliaSymmetry}, with ${observation.basalGangliaContour} contours, and their dimensions are ${observation.basalGangliaDimensions}. The MR signal of the nuclei is ${observation.basalGangliaSignal}.

  The longitudinal fissure of the cerebrum is ${observation.cerebralLongitudinalFissureLocation}. Convexital grooves are ${observation.convexitalGroovesCondition} in the frontotemporal regions on both sides due to atrophy of the adjacent parts of the brain.

  The lateral ventricles are ${observation.lateralVentriclesSymmetry}, with widths of ${observation.lateralVentriclesWidthRight} mm on the right and ${observation.lateralVentriclesWidthLeft} mm on the left at the level of the foramen of Monro. The third ventricle is ${observation.thirdVentricleWidth} mm wide. The Sylvian aqueduct ${observation.sylvianAqueductCondition} and the fourth ventricle, which is ${observation.fourthVentricleCondition}, have not been changed.

  The corpus callosum is of ${observation.corpusCallosumCondition} shape and size. The brain stem is ${observation.brainStemCondition}. The cerebellum is of ${observation.cerebellumCondition} shape, and the signal characteristics of the white matter are not changed. The width of the cerebellar cortex is ${observation.cerebellarCortexWidthCondition} due to atrophy. The craniovertebral junction is ${observation.craniovertebralJunctionCondition}.

  The pituitary gland is ${observation.pituitaryGlandCondition}, with a height of ${observation.pituitaryGlandHeight} mm in the sagittal projection. The pituitary stalk is located centrally. The chiasma of the optic nerves is located usually, with clear and even contours. Parasellar cisterns without areas of pathological intensity. The siphons of the internal carotid artery are not changed. The cavernous sinuses of both carotid arteries are symmetrical, with clear, even contours.

  The shape of the orbital cones on both sides is ${observation.orbitalConesShape}. The eyeballs are ${observation.eyeballsShapeSize}. The signal characteristics of the vitreous body are not changed. The diameter of the optic nerves is ${observation.opticNervesDiameter}. The perineural subarachnoid space of the orbits is ${observation.perineuralSubarachnoidSpaceCondition}. The extraocular muscles are of ${observation.extraocularMusclesCondition}. Retrobulbar fatty tissue ${observation.retrobulbarFattyTissueCondition}.

  Region of the cerebellopontine angle: the prevestocochlear nerve is clearly differentiated on both sides. Pneumatization of the mastoid processes of the temporal bones is ${observation.sinusesCystsPresence ? 'not preserved' : 'preserved'}.

  A cyst with a diameter of ${observation.sinusesCystsSize} mm is identified in the left maxillary sinus. The remaining paranasal sinuses are ${observation.sinusesPneumatization}.

  Additional Observations: ${observation.additionalObservations}
  """;
}
