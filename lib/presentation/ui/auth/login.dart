// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'package:mazad/presentation/state/auth_store.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:states_rebuilder/states_rebuilder.dart';

// class GetImages {
  
// static Future <Map<String,dynamic>> getImageListFromAssets(List<Asset> _images)async{
//   List<Future<ByteData>> futures = [];
//     _images.forEach((img) {
//       futures.add(img.getByteData());
//     });
//     final list = await Future.wait(futures);
//     final imgList = List.generate(list.length, (i) {
//     print(list[i].buffer.asUint8List().cast<int>());
//       return list[i].buffer.asUint8List().cast<int>();
//     });
//     final imageNames = List.generate(_images.length, (i)=>_images[i].name);
//     return {
//       'imageList' : imgList,
//       'imageNames': imageNames
//     };
// }
// static postWithFile(
//     String urlString,
//     Map<String, String> body, {
//     String filePath,
//     String fileName,
//     List additionalData,
//     String additionalDataField,
//     List additionalFiles,
//     List additionalFilesNames,
//     String additionalFilesField,
//   }) async {
//     final reactiveModel = Injector.getAsReactive<AuthStore>();
//     String _token = reactiveModel.state.credentialsModel?.data?.apiToken;
//     _token =
//         'c8GoLrSvefAfqfb2BJ5VXUOUJrSybNAcAd2LeQsNFPGHN60ejuDEV64sSQNblAx75eDpEvz8zFJwe2p6DUkrYjk3LNsimclr6b2v';

//     Uri url = Uri.parse(urlString);
//     // String image = savedOccasion['image'];
//     // Map<String, String> body = (savedOccasion); //.toJson();
//     Map<String, String> header = {'Authorization': 'Bearer $_token'};
//     http.MultipartRequest request = http.MultipartRequest('post', url);
//     request.fields.addAll(body);
//     if (filePath != null)
//       request.files.add(await http.MultipartFile.fromPath('image', filePath));
//     if (additionalFiles != null && additionalFiles.isNotEmpty)
//       for (int i = 0; i < additionalFiles.length; i++) {
//         print('additionalFiles[i]');
//         request.files
//             .add(http.MultipartFile.fromBytes('$additionalFilesField[$i]', additionalFiles[i], filename: '${additionalFilesNames[i]}'));
//       }
//     if (additionalData != null && additionalData.isNotEmpty)
//       for (int i = 0; i < additionalFiles.length; i++) {
//         request.fields['$additionalDataField[$i]'] =
//             additionalData[i].toString();
//       }
//     request.headers.addAll(header);
//     print(body);
//     try {
//       final response = await request.send();
//       final responseData =
//           json.decode(utf8.decode(await response.stream.first));

//       print('Response from post with image $responseData}');
//       if (response.statusCode >= 200 && response.statusCode <= 300) {
//         // final responseData = (json.decode(utf8.decode(onData)));

//         print(responseData);
//         if (responseData['msg'].toString().toLowerCase() == 'success') {
//           print(responseData);
//           return (responseData);
//         } else {
//           if (responseData['msg'].toString().contains('unauth'))
//             throw 'من فضلك تأكد من تسجيل الدخول';
//           else
//             throw responseData['data'];
//         }
//       } else
//         throw 'تعذر الإتصال';

//       // return SaveOccasionModel.fromJson(
//       //     APIs.checkResponse(json.decode(utf8.decode(onData))));

//     } on SocketException catch (e) {
//       print(e);
//       throw 'تحقق من اتصالك بالانترنت';
//     } on HttpException catch (e) {
//       print(e);
//       throw 'تعذر الاتصال بالخادم';
//     } on FormatException catch (e) {
//       print(e);
//       throw 'Bad response';
//     } catch (e) {
//       print(e);
//       throw '$e';
//     }
//   }

// }