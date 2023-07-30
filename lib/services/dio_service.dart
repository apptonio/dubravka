// // ignore_for_file: avoid_annotating_with_dynamic

// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart' hide FormData, Response;

// enum HttpMethod {
//   get,
//   post,
//   put,
//   patch,
//   delete,
// }

// class DioService extends GetxService {
//   late final Dio dio;

//   @override
//   void onInit() {
//     super.onInit();

//     dio = Dio(
//       BaseOptions(
//         connectTimeout: kDebugMode
//             ? const Duration(milliseconds: 30000)
//             : const Duration(milliseconds: 5000),
//       ),
//     );
//   }

//   Future<T?> request<T>({
//     required String endpoint,
//     required HttpMethod httpMethod,
//     required Future<T> Function(dynamic responseData) onSuccess,
//     Function(String error)? onError,
//     Map<String, dynamic>? parameters,
//   }) async {
//     /// Encode passed parameters to `json`
//     final jsonData = jsonEncode(parameters);

//     try {
//       /// Create `Options` with proper `headers` and other data
//       final options = Options(
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         method: httpMethod.name,
//       );

//       late Response response;

//       /// Trigger [Dio] with the proper `HttpMethod` and pass all relevant data
//       switch (httpMethod) {
//         /// `GET request`
//         case HttpMethod.get:
//           response = await dio.get(
//             endpoint,
//             options: options,
//             queryParameters: parameters,
//           );
//           break;

//         /// `POST request`
//         case HttpMethod.post:
//           response = await dio.post(
//             endpoint,
//             data: jsonData,
//             options: options,
//           );
//           break;

//         /// `PUT request`
//         case HttpMethod.put:
//           response = await dio.put(
//             endpoint,
//             data: jsonData,
//             options: options,
//           );
//           break;

//         /// `PATCH request`
//         case HttpMethod.patch:
//           response = await dio.patch(
//             endpoint,
//             data: jsonData,
//             options: options,
//           );
//           break;

//         /// `DELETE request`
//         case HttpMethod.delete:
//           response = await dio.delete(
//             endpoint,
//             data: jsonData,
//             options: options,
//           );
//           break;

//         default:
//       }

//       return onSuccess(response.data);
//     } on DioError catch (e) {
//       if (onError != null) {
//         onError('$e');
//       }
//     } catch (e) {
//       if (onError != null) {
//         onError('$e');
//       }
//     }

//     return null;
//   }
// }
