import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/current_order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/create_notification_request_use_case.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/delete_driver_location_use_case.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/save_current_order_usecase.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/set_driver_location_use_case.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/watch_order_state_usecase.dart';
import 'package:tracking_app/features/oreder_details/presentation/order_details/cubit/order_details_intents.dart';
import 'package:tracking_app/features/oreder_details/presentation/order_details/cubit/order_step.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_data_response_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_driver_data_use_case.dart';

part 'order_details_state.dart';

@Injectable()
class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final SaveCurrentOrderUseCase _saveCurrentOrderUseCase;
  final WatchCurrentOrderUseCase _watchCurrentOrderUseCase;
  final CreateNotificationRequestUseCase _createNotificationRequestUseCase;
  final GetDriverDataUseCase _getDriverDataUseCase;
  final SetDriverLocationUseCase _setDriverLocationUseCase;
  final DeleteDriverLocationUseCase _deleteDriverLocationUseCase;

  OrderDetailsCubit(
    this._saveCurrentOrderUseCase,
    this._watchCurrentOrderUseCase,
    this._createNotificationRequestUseCase,
    this._getDriverDataUseCase,
    this._setDriverLocationUseCase,
    this._deleteDriverLocationUseCase,
  ) : super(const OrderDetailsState());
  String? _driverName;
  String? _driverPhone;
  String? _vehicleType;
  String? _vehicleNumber;
  String? _vehicleLicense;

  StreamSubscription<CurrentOrderEntity?>? _stateSubscription;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _locationWriteTimer;
  bool _isStreamingLocation = false;
  String? _streamingOrderId;
  final Logger _logger = Logger();

  void doIntent(OrderDetailsIntent intent) {
    switch (intent) {
      case StartOrderDetailsIntent():
        _start(intent.order, initialState: intent.initialState);

      case AdvanceOrderStepIntent():
        _advance();
    }
  }

  Future<void> _start(OrderEntity order, {String? initialState}) async {
    emit(state.copyWith(order: order));

    if (initialState != null) {
      final step = OrderStep.fromState(initialState);

      if (step != null) {
        emit(state.copyWith(order: order, step: step));
      }
    }

    _loadDriverProfile();

    await _stateSubscription?.cancel();

    _stateSubscription = _watchCurrentOrderUseCase(orderId: order.id!).listen(
      (currentOrder) {
        if (currentOrder == null) {
          if (state.step == OrderStep.arrived) {
            emit(
              state.copyWith(
                step: OrderStep.delivered,
                updateState: const BaseState(data: true),
              ),
            );
            SecureStorageService.deleteCurrentOrderId();
            _stopLocationStream(order.id!);
          }
          return;
        }

        if (currentOrder.driverRequestedDelivery) {
          emit(
            state.copyWith(
              order: currentOrder.order,
              step: OrderStep.delivered,
              updateState: const BaseState(data: true),
            ),
          );
          SecureStorageService.deleteCurrentOrderId();
          _stopLocationStream(order.id!);
          return;
        }

        final step = OrderStep.fromState(currentOrder.state);

        if (step != null) {
          emit(state.copyWith(order: currentOrder.order, step: step));
          _startLocationStreamIfNeeded(order.id!, step);
        }
      },
    );

    final currentStep = state.step;
    if (currentStep != null) {
      _startLocationStreamIfNeeded(order.id!, currentStep);
    }
  }

  Future<void> _advance() async {
    final order = state.order;
    final current = state.step;
    final next = current?.nextStateValue;

    if (order == null || current == null) {
      return;
    }

    emit(state.copyWith(updateState: const BaseState(isLoading: true)));

    // ================================
    // Driver Arrived
    // ================================
    if (current == OrderStep.outForDelivery) {
      await _saveCurrentOrderUseCase(
        order: order,
        state: OrderStateValues.arrived,
        driverRequestedDelivery: true,
        driverName: _driverName,
        driverPhone: _driverPhone,
        vehicleType: _vehicleType,
        vehicleNumber: _vehicleNumber,
        vehicleLicense: _vehicleLicense,
      );

      await _createNotificationRequestUseCase(
        userId: order.user!.id!,
        orderId: order.id!,
        title: "Driver Arrived",
        body: "Your driver has arrived.",
        type: "driver_arrived",
      );

      _stopLocationStream(order.id!);

      emit(
        state.copyWith(
          step: OrderStep.arrived,
          updateState: const BaseState(data: true),
        ),
      );

      return;
    }

    if (current == OrderStep.arrived) {
      emit(state.copyWith(updateState: const BaseState(data: true)));
      return;
    }

    // ================================
    // Save Current Order
    // ================================
    await _saveCurrentOrderUseCase(
      order: order,
      state: next!,
      driverRequestedDelivery: false,
      driverName: _driverName,
      driverPhone: _driverPhone,
      vehicleType: _vehicleType,
      vehicleNumber: _vehicleNumber,
      vehicleLicense: _vehicleLicense,
    );

    // ================================
    // Send Notification
    // ================================
    String title = "";
    String body = "";
    String type = "";

    switch (next) {
      case OrderStateValues.picked:
        title = "Order Picked Up";
        body = "Your order has been picked up.";
        type = "order_picked_up";
        break;

      case OrderStateValues.outForDelivery:
        title = "Out For Delivery";
        body = "Your order is on the way.";
        type = "out_for_delivery";
        break;
    }

    if (title.isNotEmpty) {
      await _createNotificationRequestUseCase(
        userId: order.user!.id!,
        orderId: order.id!,
        title: title,
        body: body,
        type: type,
      );
    }

    emit(
      state.copyWith(
        step: OrderStep.fromState(next),
        updateState: const BaseState(data: true),
      ),
    );
  }

  bool _isOrderActive(OrderStep step) {
    return step == OrderStep.accepted ||
        step == OrderStep.picked ||
        step == OrderStep.outForDelivery;
  }

  void _startLocationStreamIfNeeded(String orderId, OrderStep step) {
    if (!_isOrderActive(step)) {
      _stopLocationStream(orderId);
      return;
    }

    if (_isStreamingLocation && _streamingOrderId == orderId) return;

    _isStreamingLocation = true;
    _streamingOrderId = orderId;
    _logger.i('Starting location stream for order $orderId');

    _initPositionStream(orderId);
  }

  Future<void> _initPositionStream(String orderId) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _logger.w('Location services disabled');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _logger.w('Location permission denied');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _logger.w('Location permission permanently denied');
        return;
      }

      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 30),
          ),
        );
        await _updateDriverLocation(orderId, position);
      } on TimeoutException {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 30),
          ),
        );
        await _updateDriverLocation(orderId, position);
      }

      await _positionSubscription?.cancel();
      _positionSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            ),
          ).listen(
            (Position pos) => _updateDriverLocation(orderId, pos),
            onError: (err) => _logger.e('Position stream error: $err'),
          );

      _locationWriteTimer?.cancel();
      _locationWriteTimer = Timer.periodic(
        const Duration(seconds: 10),
        (_) async {
          if (!_isStreamingLocation || _streamingOrderId != orderId) return;
          try {
            final pos = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high,
                timeLimit: Duration(seconds: 10),
              ),
            );
            await _updateDriverLocation(orderId, pos);
          } catch (e) {
            _logger.e('Periodic location write failed: $e');
          }
        },
      );
    } catch (e) {
      _logger.e('Failed to init location stream: $e');
    }
  }

  Future<void> _updateDriverLocation(String orderId, Position pos) async {
    if (!_isStreamingLocation || _streamingOrderId != orderId) return;
    try {
      await _setDriverLocationUseCase(
        orderId: orderId,
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
    } catch (e) {
      _logger.e('Failed to update driver location: $e');
    }
  }

  Future<void> _stopLocationStream(String orderId) async {
    if (!_isStreamingLocation) return;

    _logger.i('Stopping location stream for order $orderId');
    _isStreamingLocation = false;
    _streamingOrderId = null;

    await _positionSubscription?.cancel();
    _positionSubscription = null;

    _locationWriteTimer?.cancel();
    _locationWriteTimer = null;

    try {
      await _deleteDriverLocationUseCase(orderId: orderId);
    } catch (e) {
      _logger.e('Failed to delete driver location: $e');
    }
  }

  void _loadDriverProfile() {
    _getDriverDataUseCase.call().then((result) {
      if (result is SuccessBaseResponse<ProfileDataResponseEntity>) {
        final driver = result.data.driver;
        _driverName = driver?.name;
        _driverPhone = driver?.phone;
        _vehicleType = driver?.vehicleType;
        _vehicleNumber = driver?.vehicleNumber;
        _vehicleLicense = driver?.vehicleLicense;
      }
    });
  }

  @override
  Future<void> close() async {
    _isStreamingLocation = false;
    _streamingOrderId = null;
    await _stateSubscription?.cancel();
    await _positionSubscription?.cancel();
    _locationWriteTimer?.cancel();
    return super.close();
  }
}
