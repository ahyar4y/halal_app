import 'package:flutter/services.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';

class VisionAPI {
  Future get getCredentials async {
    final data = await rootBundle.loadString('assets/My First Project-023557525da4.json');
    
    return ServiceAccountCredentials.fromJson(json.decode(data));
  }

  Future get getClient async {
    final client = await clientViaServiceAccount(await getCredentials, [VisionApi.CloudVisionScope]);

    return client;
  }

  Future ocr(String image) async {
    var client = getClient;
    var vision = VisionApi(await client);
    var api = vision.images;
    var response = await api.annotate(BatchAnnotateImagesRequest.fromJson({
      "requests": [
        {
          "image": {
            "source": {
              "imageUri": image
            }
          },
          "features": [
            {"type": "TEXT_DETECTION"}
          ] 
        }
      ]
    }));

    response.responses.forEach((element) {
      var data = element.textAnnotations;
      print(data);
    });

  }
}