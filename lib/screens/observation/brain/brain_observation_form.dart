import 'package:brainmri/models/conclusion_model.dart';
import 'package:brainmri/models/observation_mode.dart';
import 'package:brainmri/screens/observation/brain/brain_observation_model.dart';
import 'package:brainmri/screens/observation/components/custom_dropdown.dart';
import 'package:brainmri/screens/observation/components/custom_textformfield.dart';
import 'package:brainmri/screens/observation/components/template.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_logs.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/refreshable.dart';
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

  String radiologistName = '';

  void showDialoga() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Radiologist Name'),
          content: TextField(
            onChanged: (value) => setState(() => radiologistName = value),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {

    print(observation.toJson());
    
    var state = StoreProvider.of<GlobalState>(context).state.appState.userState;

    final ObservationModel newOb = ObservationModel(
      conclusion: ConclusionModel(
        text: state.conclusion,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isValidated: true,
        isApproved: false,
      ),
      text: state.observationString,
      radiologistName: radiologistName,
      observedAt: DateTime.now(),
    );

    StoreProvider.of<GlobalState>(context).dispatch(
      SavePatientObservationAction(state.selectedPatient['id']! , newOb),
    );

    Navigator.of(context).pop();
  }

  void _generateConclusion() {
    print('generate conclusion');


    print('observation: ${observation.toJson()}');

    String observationString = fillObservationTemplate(observation);
    
    // Below template, for testing purposes only
    // ------------ //
//     String observationString = """
// - Scanning Technique: T1 FSE-sagittal, T2 FLAIR, T2 FSE-axial, T2 FSE-coronal
// - Basal Ganglia:
//   - Location: Usually located
//   - Symmetry: Symmetrical
//   - Contour: Clear, even contours
//   - Dimensions: Not changed
//   - MR Signal: Not changed
// - Brain Grooves and Ventricles:
//   - Lateral Ventricles Width: Right: 7 mm, Left: 9 mm
//   - Third Ventricle Width: 4 mm
//   - Sylvian Aqueduct: Not changed
//   - Fourth Ventricle: Tent-shaped and not dilated
// - Brain Structures:
//   - Corpus Callosum: Normal shape and size
//   - Brain Stem: Without features
//   - Cerebellum: Normal shape
//   - Craniovertebral Junction: Unchanged
//   - Pituitary Gland: Normal shape, height 4 mm in sagittal projection
// - Optic Nerves and Orbital Structures:
//   - Orbital Cones Shape: Unchanged
//   - Eyeballs Shape and Size: Spherical and normal size
//   - Optic Nerves Diameter: Preserved
//   - Extraocular Muscles: Normal size, without pathological signals
//   - Retrobulbar Fatty Tissue: Without pathological signals
// - Paranasal Sinuses:
//   - Cysts Presence: Not mentioned
//   - Cysts Size: Not mentioned
//   - Sinuses Pneumatization: Usually pneumatized
// - Additional Observations: None mentioned
// """;
// ------------ //

    print('observationString: $observationString');

    print('saving observation');

    StoreProvider.of<GlobalState>(context).dispatch(
      SaveObservationAction(observationString),
    );

    print('generating conclusion');
    
    StoreProvider.of<GlobalState>(context).dispatch(
      GenerateConclusionAction(observationString),
    );
  }

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

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void initErrors() {
    setState(() {
      errors = [];
    });
  }

  String? name;
  DateTime? bDate;

  bool other = false;

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

                                if (userState.isSavingNewPatient)
                        const Column(
                          children: [
                            LinearProgressIndicator(),
                            Padding(padding: EdgeInsets.only(left:16.0, right:16.0),
                              child: 
                                Text('Saving new patient. Please wait...'),
                            ),
                          ],
                        ),
                                if (userState.isSavingObservation)
                        const Column(
                          children: [
                            LinearProgressIndicator(),
                            Padding(padding: EdgeInsets.only(left:16.0, right:16.0),
                              child: 
                                Text('Saving new observation. Please wait...'),
                            ),
                          ],
                        ),
                                if (userState.isGeneratingConclusion)
                        const Column(
                          children: [
                            LinearProgressIndicator(),
                            Padding(padding: EdgeInsets.only(left:16.0, right:16.0),
                              child: 
                                Text('Generating conclusion. Please wait...'),
                            ),
                          ],
                        ),
                        
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
          items: userState.patientNames,
          itemName: 'Select',
          dState: 0
        ),
        ),
        ],
      ),
ListTile(
  title: const Text('Other'),
  leading: Checkbox(
    value: other,
    onChanged: (bool? value) {
      setState(() {
        bDate = null;
        other = value!;
      });
    },
  ),
),

        other ?
        Column(children: [
          Row(
            children: [
Expanded(child: 
    TextField(
      decoration: const InputDecoration(labelText: 'Patient name'),
      onChanged: (value) => setState(() => name = value),
    ),
),

const SizedBox(width: 16.0),
    // Date of birth
Expanded(child: 
    TextButton(
      onPressed: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != bDate)
          setState(() {
            bDate = picked;
          });
      },
      child: Text(bDate != null ? bDate!.toIso8601String().split('T')[0] : 'Select date of birth'),
    ),
    ),
          ],),

      const SizedBox(height: 16.0),

          ElevatedButton(
            onPressed: () {
              AppLog.log().i('name: $name, bDate: $bDate');

              if (name != null && bDate != null) {
                String bYear = bDate!.year.toString();
                StoreProvider.of<GlobalState>(context).dispatch(
                  SaveNewPatientAction(name!, bYear),
                );
              }
            },
            child: Text('Save patient'),
            )
        ],) : Container(),

CustomTextFormField(
  labelText: 'Scanning Technique',
  isInputEmpty: observation.scanningTechnique.isEmpty,
  onChanged: (value) => setState(() => observation.scanningTechnique = value),
  onClear: () => setState(() => observation.scanningTechnique = ''),
  initialValue: observation.scanningTechnique,
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
  labelText: 'Dimensions',
  isInputEmpty: observation.basalGangliaContour.isEmpty,
  onChanged: (value) => setState(() => observation.basalGangliaContour = value),
  onClear: () => setState(() => observation.basalGangliaContour = ''),
  initialValue: observation.basalGangliaContour,
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
),
],),

          const SizedBox(height: 24.0),
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
    userState.conclusion.isEmpty ? 'Generate' : 'Regenerate'
  ),
),


          if (userState.conclusion.isNotEmpty)
          Column(children: [
            Text(
              'Conclusion:\n${userState.conclusion}'
            ),

          const SizedBox(height: 16.0),
          ElevatedButton(
  onPressed: showDialoga,
  style: ElevatedButton.styleFrom(
    elevation: 5,
    backgroundColor: Color(0xFF232428), // Set the background color
    foregroundColor: Colors.white, // Set the text color (applies to foreground)
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700, 
    ),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Set the padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)), // Set the border radius
    ),
  ),
  child: Text(
    'Submit'
  ),
),
          ],)
        ],
      ),
      ),
    );
      },
    );
  }
}
