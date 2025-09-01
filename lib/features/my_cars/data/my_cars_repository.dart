import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app/core/network/dio_client.dart'; // expose dioProvider
import 'package:mobile_app/core/widgets/rarity.dart';
import 'package:mobile_app/features/my_cars/model/body_type.dart';
import 'package:mobile_app/features/my_cars/model/user_car.dart';

abstract class IMyCarsRepository {
  Future<(List<UserCar>, String?)> listMyCars({
    String? brand,
    Rarity? rarity,
    BodyType? body,
    String? cursor,
  });

  Future<List<String>> fetchBrands();

  Future<List<String>> getShowcase();
  Future<void> saveShowcase(List<String> carIds);
}

class MyCarsRepository implements IMyCarsRepository {
  MyCarsRepository(this._ref);
  final Ref _ref;

  Dio get _dio => _ref.read(dioProvider);

  @override
  Future<(List<UserCar>, String?)> listMyCars({
    String? brand,
    Rarity? rarity,
    BodyType? body,
    String? cursor,
  }) async {
    final qp = <String, dynamic>{
      if (brand != null && brand.isNotEmpty) 'brand': brand,
      if (rarity != null) 'rarity': rarity.name,
      if (body != null) 'body': body.name,
      if (cursor != null) 'cursor': cursor,
    };

    final res = await _dio.get('/me/cars', queryParameters: qp);
    final data = res.data as Map<String, dynamic>;
    final items =
    (data['items'] as List).map((j) => UserCar.fromJson(j)).toList();
    final next = data['nextCursor'] as String?;
    return (items, next);
  }

  @override
  Future<List<String>> fetchBrands() async {
    final res = await _dio.get('/me/brands');
    return (res.data as List).map((e) => e.toString()).toList();
  }

  @override
  Future<List<String>> getShowcase() async {
    final res = await _dio.get('/me/showcase');
    return (res.data as List).map((e) => e.toString()).take(3).toList();
  }

  @override
  Future<void> saveShowcase(List<String> carIds) async {
    await _dio.put('/me/showcase', data: {'carIds': carIds.take(3).toList()});
  }
}
