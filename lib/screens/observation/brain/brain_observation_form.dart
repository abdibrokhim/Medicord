import 'package:brainmri/models/conclusion_model.dart';
import 'package:brainmri/models/observation_model.dart';
import 'package:brainmri/screens/observation/brain/brain_observation_model.dart';
import 'package:brainmri/screens/observation/components/custom_dropdown.dart';
import 'package:brainmri/screens/observation/components/custom_text_field.dart';
import 'package:brainmri/screens/observation/components/custom_textformfield.dart';
import 'package:brainmri/screens/observation/components/primary_custom_button.dart';
import 'package:brainmri/screens/observation/components/template.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_logs.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/refreshable.dart';
import 'package:brainmri/utils/shared.dart';
import 'package:brainmri/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class BrainObservationForm extends StatefulWidget {
  const BrainObservationForm({Key? key}) : super(key: key);

  @override
  _BrainObservationFormState createState() => _BrainObservationFormState();
}

class _BrainObservationFormState extends State<BrainObservationForm> {
  final BrainObservationModel observation = BrainObservationModel();
  final TextEditingController radiologistNameController = TextEditingController();
  final TextEditingController newPatientNameController = TextEditingController();
  final TextEditingController birthYearController = TextEditingController();

  List<String> errors = [];

  @override
  void initState() {
    super.initState();

    initErrors();
  }


  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void initErrors() {
    setState(() {
      errors = [];
    });
  }


int calculateLines(String text) {
    final TextSpan span = TextSpan(text: text);
    final TextPainter tp = TextPainter(
      text: span,
      maxLines: null,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width*0.7);
    print('maxlines: ${tp.computeLineMetrics().length}');
    return tp.computeLineMetrics().length;
  }

  void fillErrorList() {
  // Reinitialize errors
  initErrors();

  var state = StoreProvider.of<GlobalState>(context).state.appState.userState;

  // Add errors to list
  if(state.selectedOType.isEmpty) {
    addError(error: 'Selecting a scan type is required');
  }

  if(state.selectedPatient.isEmpty) {
    addError(error: 'Selecting a patient is required');
  }

  if (observation.scanningTechnique.isEmpty) {
    addError(error: 'Scanning technique is required');
  }

  if (observation.basalGangliaLocation.isEmpty) {
    addError(error: 'Basal ganglia location is required');
  }

  if (observation.basalGangliaSymmetry.isEmpty) {
    addError(error: 'Basal ganglia symmetry is required');
  }

  if (observation.basalGangliaContour.isEmpty) {
    addError(error: 'Basal ganglia contour is required');
  }

  if (observation.basalGangliaDimensions.isEmpty) {
    addError(error: 'Basal ganglia dimensions are required');
  }

  if (observation.basalGangliaSignal.isEmpty) {
    addError(error: 'Basal ganglia signal is required');
  }

  if (observation.cerebralLongitudinalFissureLocation.isEmpty) {
    addError(error: 'Cerebral longitudinal fissure location is required');
  }

  if (observation.convexitalGroovesCondition.isEmpty) {
    addError(error: 'Convexital grooves condition is required');
  }

  if (observation.lateralVentriclesSymmetry.isEmpty) {
    addError(error: 'Lateral ventricles symmetry is required');
  }

  if (observation.sylvianAqueductCondition.isEmpty) {
    addError(error: 'Sylvian aqueduct condition is required');
  }

  if (observation.fourthVentricleCondition.isEmpty) {
    addError(error: 'Fourth ventricle condition is required');
  }

  if (observation.corpusCallosumCondition.isEmpty) {
    addError(error: 'Corpus callosum condition is required');
  }

  if (observation.brainStemCondition.isEmpty) {
    addError(error: 'Brain stem condition is required');
  }

  if (observation.cerebellumCondition.isEmpty) {
    addError(error: 'Cerebellum condition is required');
  }

  if (observation.cerebellarCortexWidthCondition.isEmpty) {
    addError(error: 'Cerebellar cortex width condition is required');
  }

  if (observation.craniovertebralJunctionCondition.isEmpty) {
    addError(error: 'Craniovertebral junction condition is required');
  }

  if (observation.pituitaryGlandCondition.isEmpty) {
    addError(error: 'Pituitary gland condition is required');
  }

  if (observation.orbitalConesShape.isEmpty) {
    addError(error: 'Orbital cones shape is required');
  }

  if (observation.eyeballsShapeSize.isEmpty) {
    addError(error: 'Eyeballs shape and size are required');
  }

  if (observation.perineuralSubarachnoidSpaceCondition.isEmpty) {
    addError(error: 'Perineural subarachnoid space condition is required');
  }

  if (observation.extraocularMusclesCondition.isEmpty) {
    addError(error: 'Extraocular muscles condition is required');
  }

  if (observation.retrobulbarFattyTissueCondition.isEmpty) {
    addError(error: 'Retrobulbar fatty tissue condition is required');
  }

  if (observation.sinusesPneumatization.isEmpty) {
    addError(error: 'Sinuses pneumatization is required');
  }


}

  void fillAddNewPatientErrorList() {
  // Reinitialize errors
  initErrors();

  // Add errors to list
  if (newPatientNameController.text.isEmpty) {
    addError(error: 'Patient name is required');
  }

  if (birthYearController.text.isEmpty) {
    addError(error: 'Birth year is required');
  }

  }

  void _regenerateConclusion() {
    print('regenerate conclusion');

    //     StoreProvider.of<GlobalState>(context).dispatch(
    //   SimulateGenerateConclusionAction(),
    // );

        var state = StoreProvider.of<GlobalState>(context).state.appState.userState;

        // GPT model
    StoreProvider.of<GlobalState>(context).dispatch(
      GptGenerateConclusionAction(state.observationString),
    );
  }

  void _generateConclusion() {
    print('generate conclusion');
    
//     // Below template, for testing purposes only
//     // ------------ //
//     String observationString = """
// Scanning technique: T1 FSE-sagital, T2 FLAIR, T2 FSE-axial, T2 FSE-coronar, DWI.
// On a series of tomograms in the structure of the subcortical and periventricular white matter of the cerebral hemispheres on both sides, multiple round-shaped foci of pathological intensity are asymmetrically determined, with unclear contours, homogeneous hyperintense signal characteristics on T2 VI and T2 FLAIR, with a diameter of 3-10 mm.
// The basal ganglia are usually located, symmetrical, with clear, even contours, the dimensions are not changed. The MR signal of the nuclei was not changed.
// The longitudinal fissure of the cerebrum is located centrally. Convexital grooves are moderately widened in the frontotemporal regions on both sides due to atrophy of the adjacent parts of the brain
// The lateral ventricles are symmetrical, the width of the ventricles at the level of the foramen of Monro is 10 mm on the right, 14 mm on the left. The third ventricle is 4 mm wide. Sylvian aqueduct has not been changed. The fourth ventricle is tent-shaped and not dilated.
// The corpus callosum is of normal shape and size. The brain stem is without areas of pathological intensity. The cerebellum is of normal shape, the signal characteristics of the white matter are not changed. The width of the cerebellar cortex is reduced due to atrophy. The craniovertebral junction is unchanged.
// The pituitary gland is moderately flattened, the height in the sagittal projection is 3 mm. The pituitary stalk is located centrally. The chiasma of the optic nerves is located usually, the contours are clear and even. Parasellar cisterns without areas of pathological intensity. The siphons of the internal carotid artery are not changed. The cavernous sinuses of both carotid arteries are symmetrical, with clear, even contours.
// The shape of the orbital cones on both sides is unchanged. The eyeballs are spherical in shape and of normal size. The signal characteristics of the vitreous body are not changed. The diameter of the optic nerves is not changed. The perineural subarachnoid space of the orbits is moderately diffusely dilated. The extraocular muscles are of normal size, the structure is without pathological signals. Retrobulbar fatty tissue without pathological signals.
// Region of the cerebellopontine angle: the prevestocochlear nerve is clearly differentiated on both sides. Pneumatization of the mastoid processes of the temporal bones is preserved.
// A cyst with a diameter of 14 mm is identified in the left maxillary sinus. The remaining paranasal sinuses are usually pneumatized.
// """;
// ------------ //


fillErrorList();  // uncomment in production

if (errors.isNotEmpty) {  // remove '!' in production
  showErrorBottomSheet(context, errors);
} else {

    // StoreProvider.of<GlobalState>(context).dispatch(
    //   SimulateGenerateConclusionAction(),
    // );


    print('observation: ${observation.toJson()}');

    String observationString = fillObservationTemplate(observation);

        print('observationString: $observationString');

      print('saving observationString');
    StoreProvider.of<GlobalState>(context).dispatch(
      SaveObservationAction(observationString),
    );

    // delay 2 seconds to save observationString
    Future.delayed(const Duration(seconds: 2));
    
    print('generating conclusion');
    
    // GPT model
    StoreProvider.of<GlobalState>(context).dispatch(
      GptGenerateConclusionAction(observationString),
    );

    showSubmitBottomSheet(context);

}
  }


  void showSubmitBottomSheet(BuildContext context) {

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return 
      StoreConnector<GlobalState, UserState>(
      onInit: (store) {
      },
      converter: (appState) => appState.state.appState.userState,
      builder: (context, userState) {
        return
      Container(
        height: 800,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        color: const Color.fromARGB(255, 31, 33, 38),
        child: SingleChildScrollView(
          child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
            Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
                              'Save observation and conclusion',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
      Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255), // Add your background color here
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            store.dispatch(ReinitializeFormAction());
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: Colors.black, size: 18,),
        ),
      ),
    ],
),
          
const SizedBox(height: 32.0),



userState.isGeneratingConclusion ?
  const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
          'Conclusion',
          style: TextStyle(
            color: Color(0xFFDDDDDD), // Label text color
            fontSize: 16, // Adjust the font size as needed
            fontWeight: FontWeight.w500,
          ),
        ),
      const SizedBox(height: 8.0),
  CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
    backgroundColor: Color(0xFFC3C3C3), // Change the background color
  ),
      const SizedBox(height: 8.0),
          Text(
            'Generating conclusion. Please wait...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
    ],
  ) :
CustomTextField(
  labelText: 'Conclusion',
  initialValue: userState.conclusion,
  maxLines: calculateLines(userState.conclusion) == 0 ? 1 : calculateLines(userState.conclusion),
),

const SizedBox(height: 24.0),
CustomTextFormField(
  labelText: 'Radiologist Name',
  isInputEmpty: radiologistNameController.text.isEmpty,
  onChanged: (value) => setState(() => radiologistNameController.text = value),
  onClear: () => setState(() => radiologistNameController.text = ''),
  initialValue: radiologistNameController.text,
),
  const SizedBox(height: 32.0),

userState.conclusion.isNotEmpty ?
  PrimaryCustomButton(
    label: 'Regenerate',
    onPressed: (userState.isGeneratingConclusion) ? () {} : _regenerateConclusion,
    loading: userState.isGeneratingConclusion,
  ) : const SizedBox(height: 0.0),
  
  const SizedBox(height: 32.0),

    PrimaryCustomButton(
    label: 'Submit',
    onPressed: (userState.isGeneratingConclusion || userState.isSavingObservation) ? () {} : _submitForm,
    loading: userState.isSavingObservation,
  ),
  
  const SizedBox(height: 32.0),

          ],
        ),
        ),
      );
    },
    );
  }
  );
}

  void showAddNewPatientBottomSheet(BuildContext context) {

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return 
      StoreConnector<GlobalState, UserState>(
      onInit: (store) {
      },
      converter: (appState) => appState.state.appState.userState,
      builder: (context, userState) {
        return
      Container(
        height: 600,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        color: const Color.fromARGB(255, 31, 33, 38),
        child: SingleChildScrollView(
          child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
            Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
                              'Add new patient',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
      Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255), // Add your background color here
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: Colors.black, size: 18,),
        ),
      ),
    ],
),
          
const SizedBox(height: 32.0),

CustomTextFormField(
  labelText: 'Patient name (ex: John Doe)',
  isInputEmpty: newPatientNameController.text.isEmpty,
  onChanged: (value) => setState(() => newPatientNameController.text = value),
  onClear: () => setState(() => newPatientNameController.text = ''),
  initialValue: newPatientNameController.text,
),
  const SizedBox(height: 24.0),
CustomTextFormField(
  labelText: 'Birth year (ex: 1990)',
  isInputEmpty: birthYearController.text.isEmpty,
  onChanged: (value) => setState(() => birthYearController.text = value),
  onClear: () => setState(() => birthYearController.text = ''),
  initialValue: birthYearController.text,
),
  const SizedBox(height: 32.0),

  SizedBox(
                  width: double.infinity,
                  child:

          ElevatedButton(
  onPressed: (userState.isSavingNewPatient) ? () {} : () {
    fillAddNewPatientErrorList();

if (errors.isNotEmpty) {
  showErrorBottomSheet(context, errors);
} else {
                StoreProvider.of<GlobalState>(context).dispatch(
                  SaveNewPatientAction(newPatientNameController.text, birthYearController.text),
                );
}
  },
  style: ElevatedButton.styleFrom(
    elevation: 5,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white, // Set the text color (applies to foreground)
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700, 
    ),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Set the padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)), // Set the border radius
            side: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
  ),
  child: 
    userState.isSavingNewPatient ? 
      CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
    backgroundColor: Color(0xFFC3C3C3), // Change the background color
  ) :
  Text(
    'Save'
  ),
),
),
          ],
        ),
        ),
      );
    },
    );
  }
  );
}

  void _submitForm() {


    print('submitting form');

    if (radiologistNameController.text.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showToast(message: 'Radiologist name required.', bgColor: Colors.red[900]);
          });
          return;
        } else {

    var state = StoreProvider.of<GlobalState>(context).state.appState.userState;

    // simulate submit form

    // StoreProvider.of<GlobalState>(context).dispatch(
    //   SimulateSavePatientObservationAction(),
    // );
        // }
        final ObservationModel newOb = ObservationModel(
      conclusion: ConclusionModel(
        text: state.conclusion,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isValidated: true,
        isApproved: false,
      ),
      text: state.observationString,
      radiologistName: radiologistNameController.text,
      observedAt: DateTime.now(),
    );

    StoreProvider.of<GlobalState>(context).dispatch(
      SavePatientObservationAction(state.selectedPatient['id']! , newOb),
    );
        }

    // Navigator.of(context).pop();
  }

      void reFetchData()  {
          print('refetching');
        store.dispatch(FetchAllPatientNamesAction());
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    reFetchData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return 
    StoreConnector<GlobalState, UserState>(
      onInit: (store) {
        store.dispatch(FetchAllPatientNamesAction());
      },
      converter: (appState) => appState.state.appState.userState,
      builder: (context, userState) {
        return
        Container(
              color: const Color.fromARGB(255, 31, 33, 38),
              child:

    SingleChildScrollView(
      padding: const EdgeInsets.only(top: 0.0, bottom: 32),
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
                        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                          Expanded(
                            flex: 3,
              child: 
            Text('Select or add patient'
            , style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            ),
            ),
            Expanded(
              flex: 2,
              child: 
      CustomDropdownWithSearch( 
        labelText: "Select or add patient",
          items: userState.patientNames,
          itemName: 'Select',
          dState: 0,
          isAddNewPatient: true,
          onAddNewPatient: () {
            showAddNewPatientBottomSheet(context);
          },
        ),
        ),
        ],
      ),

      const SizedBox(height: 24.0),

CustomTextFormField(
  labelText: 'Scanning Technique',
  isInputEmpty: observation.scanningTechnique.isEmpty,
  onChanged: (value) => setState(() => observation.scanningTechnique = value),
  onClear: () => setState(() => observation.scanningTechnique = ''),
  initialValue: observation.scanningTechnique,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Minimum Focus Diameter (mm)',
  isInputEmpty: observation.minFocusDiameter == 0.0,
  onChanged: (value) => setState(() => observation.minFocusDiameter = double.tryParse(value) ?? 0.0),
  onClear: () => setState(() => observation.minFocusDiameter = 0.0),
  initialValue: observation.minFocusDiameter.toString(),
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Maximum Focus Diameter (mm)',
  isInputEmpty: observation.maxFocusDiameter == 0.0,
  onChanged: (value) => setState(() => observation.maxFocusDiameter = double.tryParse(value) ?? 0.0),
  onClear: () => setState(() => observation.maxFocusDiameter = 0.0),
  initialValue: observation.maxFocusDiameter.toString(),
),

const SizedBox(height: 24.0),

//==== Basal Ganglia ====//

Column(crossAxisAlignment: CrossAxisAlignment.start,
  children: [
Text(
  'Basal Ganglia', 
  textAlign: TextAlign.left,
  style: TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w700,
),),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Location',
  isInputEmpty: observation.basalGangliaLocation.isEmpty,
  onChanged: (value) => setState(() => observation.basalGangliaLocation = value),
  onClear: () => setState(() => observation.basalGangliaLocation = ''),
  initialValue: observation.basalGangliaLocation,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Symmetry',
  isInputEmpty: observation.basalGangliaSymmetry.isEmpty,
  onChanged: (value) => setState(() => observation.basalGangliaSymmetry = value),
  onClear: () => setState(() => observation.basalGangliaSymmetry = ''),
  initialValue: observation.basalGangliaSymmetry,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Contour',
  isInputEmpty: observation.basalGangliaContour.isEmpty,
  onChanged: (value) => setState(() => observation.basalGangliaContour = value),
  onClear: () => setState(() => observation.basalGangliaContour = ''),
  initialValue: observation.basalGangliaContour,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Dimensions',
  isInputEmpty: observation.basalGangliaDimensions.isEmpty,
  onChanged: (value) => setState(() => observation.basalGangliaDimensions = value),
  onClear: () => setState(() => observation.basalGangliaDimensions = ''),
  initialValue: observation.basalGangliaDimensions,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Signal',
  isInputEmpty: observation.basalGangliaSignal.isEmpty,
  onChanged: (value) => setState(() => observation.basalGangliaSignal = value),
  onClear: () => setState(() => observation.basalGangliaSignal = ''),
  initialValue: observation.basalGangliaSignal,
),
],),

const SizedBox(height: 24.0),

//==== Brain Grooves and Ventricles ====//

Column(crossAxisAlignment: CrossAxisAlignment.start,
  children: [
Text(
  'Brain Grooves and Ventricles',
  textAlign: TextAlign.left,
  style: TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w700,
),),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Lateral Ventricles Symmetry',
  isInputEmpty: observation.lateralVentriclesSymmetry.isEmpty,
  onChanged: (value) => setState(() => observation.lateralVentriclesSymmetry = value),
  onClear: () => setState(() => observation.lateralVentriclesSymmetry = ''),
  initialValue: observation.lateralVentriclesSymmetry,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Lateral Ventricles Width Right (mm)',
  isInputEmpty: observation.lateralVentriclesWidthRight == 0.0,
  onChanged: (value) => setState(() => observation.lateralVentriclesWidthRight = double.tryParse(value) ?? 0.0),
  onClear: () => setState(() => observation.lateralVentriclesWidthRight = 0.0),
  initialValue: observation.lateralVentriclesWidthRight.toString(),
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Lateral Ventricles Width Left (mm)',
  isInputEmpty: observation.lateralVentriclesWidthLeft == 0.0,
  onChanged: (value) => setState(() => observation.lateralVentriclesWidthLeft = double.tryParse(value) ?? 0.0),
  onClear: () => setState(() => observation.lateralVentriclesWidthLeft = 0.0),
  initialValue: observation.lateralVentriclesWidthLeft.toString(),
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Third Ventricle Width (mm)',
  isInputEmpty: observation.thirdVentricleWidth == 0.0,
  onChanged: (value) => setState(() => observation.thirdVentricleWidth = double.tryParse(value) ?? 0.0),
  onClear: () => setState(() => observation.thirdVentricleWidth = 0.0),
  initialValue: observation.thirdVentricleWidth.toString(),
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Cerebral Longitudinal Fissure Location',
  isInputEmpty: observation.cerebralLongitudinalFissureLocation.isEmpty,
  onChanged: (value) => setState(() => observation.cerebralLongitudinalFissureLocation = value),
  onClear: () => setState(() => observation.cerebralLongitudinalFissureLocation = ''),
  initialValue: observation.cerebralLongitudinalFissureLocation,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Sylvian Aqueduct Condition',
  isInputEmpty: observation.sylvianAqueductCondition.isEmpty,
  onChanged: (value) => setState(() => observation.sylvianAqueductCondition = value),
  onClear: () => setState(() => observation.sylvianAqueductCondition = ''),
  initialValue: observation.sylvianAqueductCondition,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Fourth Ventricle Condition',
  isInputEmpty: observation.fourthVentricleCondition.isEmpty,
  onChanged: (value) => setState(() => observation.fourthVentricleCondition = value),
  onClear: () => setState(() => observation.fourthVentricleCondition = ''),
  initialValue: observation.fourthVentricleCondition,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Convexital Grooves Condition',
  isInputEmpty: observation.convexitalGroovesCondition.isEmpty,
  onChanged: (value) => setState(() => observation.convexitalGroovesCondition = value),
  onClear: () => setState(() => observation.convexitalGroovesCondition = ''),
  initialValue: observation.convexitalGroovesCondition,
),
],),


const SizedBox(height: 24.0),

//==== Brain Structures ====//

Column(crossAxisAlignment: CrossAxisAlignment.start,
  children: [
Text(
  'Brain Structures',
  textAlign: TextAlign.left,
  style: TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w700,
),),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Corpus Callosum Condition',
  isInputEmpty: observation.corpusCallosumCondition.isEmpty,
  onChanged: (value) => setState(() => observation.corpusCallosumCondition = value),
  onClear: () => setState(() => observation.corpusCallosumCondition = ''),
  initialValue: observation.corpusCallosumCondition,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Brain Stem Condition',
  isInputEmpty: observation.brainStemCondition.isEmpty,
  onChanged: (value) => setState(() => observation.brainStemCondition = value),
  onClear: () => setState(() => observation.brainStemCondition = ''),
  initialValue: observation.brainStemCondition,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Cerebellum Condition',
  isInputEmpty: observation.cerebellumCondition.isEmpty,
  onChanged: (value) => setState(() => observation.cerebellumCondition = value),
  onClear: () => setState(() => observation.cerebellumCondition = ''),
  initialValue: observation.cerebellumCondition,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Cerebellar Cortex Width Condition',
  isInputEmpty: observation.cerebellarCortexWidthCondition.isEmpty,
  onChanged: (value) => setState(() => observation.cerebellarCortexWidthCondition = value),
  onClear: () => setState(() => observation.cerebellarCortexWidthCondition = ''),
  initialValue: observation.cerebellarCortexWidthCondition,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Craniovertebral Junction Condition',
  isInputEmpty: observation.craniovertebralJunctionCondition.isEmpty,
  onChanged: (value) => setState(() => observation.craniovertebralJunctionCondition = value),
  onClear: () => setState(() => observation.craniovertebralJunctionCondition = ''),
  initialValue: observation.craniovertebralJunctionCondition,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Pituitary Gland Condition',
  isInputEmpty: observation.pituitaryGlandCondition.isEmpty,
  onChanged: (value) => setState(() => observation.pituitaryGlandCondition = value),
  onClear: () => setState(() => observation.pituitaryGlandCondition = ''),
  initialValue: observation.pituitaryGlandCondition,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Pituitary Gland Height (mm)',
  isInputEmpty: observation.pituitaryGlandHeight == 0.0,
  onChanged: (value) => setState(() => observation.pituitaryGlandHeight = double.tryParse(value) ?? 0.0),
  onClear: () => setState(() => observation.pituitaryGlandHeight = 0.0),
  initialValue: observation.pituitaryGlandHeight.toString(),
),
],),


const SizedBox(height: 24.0),

//==== Optic Nerves and Orbital Structures ====//

Column(crossAxisAlignment: CrossAxisAlignment.start,
  children: [
Text(
  'Optic Nerves and Orbital Structures',
  textAlign: TextAlign.left,
  style: TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w700,
),),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Orbital Cones Shape',
  isInputEmpty: observation.orbitalConesShape.isEmpty,
  onChanged: (value) => setState(() => observation.orbitalConesShape = value),
  onClear: () => setState(() => observation.orbitalConesShape = ''),
  initialValue: observation.orbitalConesShape,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Eyeballs Shape and Size',
  isInputEmpty: observation.eyeballsShapeSize.isEmpty,
  onChanged: (value) => setState(() => observation.eyeballsShapeSize = value),
  onClear: () => setState(() => observation.eyeballsShapeSize = ''),
  initialValue: observation.eyeballsShapeSize,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Optic Nerves Diameter (mm)',
  isInputEmpty: observation.opticNervesDiameter == 0.0,
  onChanged: (value) => setState(() => observation.opticNervesDiameter = double.tryParse(value) ?? 0.0),
  onClear: () => setState(() => observation.opticNervesDiameter = 0.0),
  initialValue: observation.opticNervesDiameter.toString(),
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Perineural Subarachnoid Space Condition',
  isInputEmpty: observation.perineuralSubarachnoidSpaceCondition.isEmpty,
  onChanged: (value) => setState(() => observation.perineuralSubarachnoidSpaceCondition = value),
  onClear: () => setState(() => observation.perineuralSubarachnoidSpaceCondition = ''),
  initialValue: observation.perineuralSubarachnoidSpaceCondition,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Extraocular Muscles Condition',
  isInputEmpty: observation.extraocularMusclesCondition.isEmpty,
  onChanged: (value) => setState(() => observation.extraocularMusclesCondition = value),
  onClear: () => setState(() => observation.extraocularMusclesCondition = ''),
  initialValue: observation.extraocularMusclesCondition,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Retrobulbar Fatty Tissue Condition',
  isInputEmpty: observation.retrobulbarFattyTissueCondition.isEmpty,
  onChanged: (value) => setState(() => observation.retrobulbarFattyTissueCondition = value),
  onClear: () => setState(() => observation.retrobulbarFattyTissueCondition = ''),
  initialValue: observation.retrobulbarFattyTissueCondition,
),
],),

const SizedBox(height: 24.0),

//==== Paranasal Sinuses ====//

Column(crossAxisAlignment: CrossAxisAlignment.start,

  children: [
Text(
  'Paranasal Sinuses',
  textAlign: TextAlign.left,
  style: TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w700,
),),
const SizedBox(height: 14.0),
    
    CustomTextFormField(
  labelText: 'Cysts Presence',
  isInputEmpty: !observation.sinusesCystsPresence,
  onChanged: (value) => setState(() => observation.sinusesCystsPresence = value == 'true'),
  onClear: () => setState(() => observation.sinusesCystsPresence = false),
  initialValue: observation.sinusesCystsPresence ? 'Yes' : 'No',
  isBoolean: true,
  isReadOnly: true,
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Cysts Size (mm)',
  isInputEmpty: observation.sinusesCystsSize == 0.0,
  onChanged: (value) => setState(() => observation.sinusesCystsSize = double.tryParse(value) ?? 0.0),
  onClear: () => setState(() => observation.sinusesCystsSize = 0.0),
  initialValue: observation.sinusesCystsSize.toString(),
),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Sinuses Pneumatization',
  isInputEmpty: observation.sinusesPneumatization.isEmpty,
  onChanged: (value) => setState(() => observation.sinusesPneumatization = value),
  onClear: () => setState(() => observation.sinusesPneumatization = ''),
  initialValue: observation.sinusesPneumatization,
),
],),


const SizedBox(height: 24.0),

//==== Additional Observations ====//

Column(crossAxisAlignment: CrossAxisAlignment.start,
  children: [
Text(
  'Additional Observations',
  textAlign: TextAlign.left,
  style: TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w700,
),),
const SizedBox(height: 14.0),
CustomTextFormField(
  labelText: 'Anything else?',
  isInputEmpty: observation.additionalObservations.isEmpty,
  onChanged: (value) => setState(() => observation.additionalObservations = value),
  onClear: () => setState(() => observation.additionalObservations = ''),
  initialValue: observation.additionalObservations,
  minLines: 4,
  maxLines: 4,
),
],),

          const SizedBox(height: 24.0),
                          SizedBox(
                  width: double.infinity,
                  child:
          ElevatedButton(
  onPressed: _generateConclusion,
  style: ElevatedButton.styleFrom(
    // elevation: 5,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white, // Set the text color (applies to foreground)
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700, 
    ),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Set the padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)), // Set the border radius
      side: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
  ),
  child: Text(
    'Generate'
  ),
),
),
        ],
      ),
      ),
    );
      },
    );
  }
}
