import 'dart:convert';
import 'dart:io';

import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:curiosity_flutter/helper/date_parse.dart';

import '../services/notification_service.dart';

class EvaluationCompletedPage extends StatefulWidget {
  @override
  _EvaluationCompletedPageState createState() =>
      _EvaluationCompletedPageState();
}

class _EvaluationCompletedPageState extends State<EvaluationCompletedPage> {
  String reflection = "";
  String activityEnjoyment = "";
  var image;
  var base64encode;
  String _id;
  UserDbService UDS;
  NotificationService notificationService;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context).settings.arguments as List;
    String uuid = args[0];
    String arg = args[1];
    setState(() {
      _id = uuid;
      UDS = UserDbService(uuid);
      notificationService = NotificationService();
    });
    print(arg + " was recieved");
    setState(() {
      activityEnjoyment = arg;
    });

    super.didChangeDependencies();
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.pickImage(
          source: ImageSource.gallery, maxHeight: 850, maxWidth: 850);
      // If the user did not select an image exit the function
      if (image == null) {
        return;
      }

      final imagePermanent = await saveImagePermanently(image.path);
      setState(() => this.image = imagePermanent);

      final bytes = File(image.path).readAsBytesSync();
      String encodedSrc = base64Encode(bytes);

      setState(() => this.base64encode = encodedSrc);
    } on PlatformException catch (e) {
      print('failed to pick image $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = Path.basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    bool clicked = false;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: height / 20, bottom: 14),
                  child: Container(
                    child: Text(
                      'Great Job!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      'Do you have any reflections about what you think enabled you to be successful today? Please type them below.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: height / 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(14)),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      cursorColor: Colors.white,
                      onChanged: (val) {
                        reflection = val;
                      },
                      onTap: FocusScope.of(context).unfocus,
                      decoration: InputDecoration(
                          hintText: " Proof of work and/or reflections...",
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "If your task requires you to upload a photo, please do so:",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width / 5.5, right: width / 5.5, top: 20),
                  child: image != null
                      ? Image.file(image)
                      : Text(
                          "No photo selected",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width / 5.5, right: width / 5.5, top: 20),
                  child: CupertinoButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Select Photo",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.blue,
                      onPressed: () => pickImage()),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width / 5.5,
                      top: height / 20,
                      right: width / 5.5,
                      bottom: 20),
                  child: CupertinoButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Continue",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.blue,
                      onPressed: () async {
                        if (!clicked) {
                          clicked = true;
                          Map<String, dynamic> data = {
                            'id': datetimeToString(DateTime.now()),
                            'isSuccessful': true,
                            'imageProof': base64encode,
                            'reflection': reflection,
                            'activityEnjoyment': activityEnjoyment
                          };
                          await UDS.updateDailyEval(data);
                          await notificationService
                              .cancelActivityCompletionNotification();
                          Navigator.pushReplacementNamed(context, '/navigation',
                              arguments: [_id, 0]);
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
