import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracking_app/core/firebase/firestore_notification_service.dart';
import 'package:tracking_app/core/notifications/local_notification_service.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';

@lazySingleton
class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirestoreNotificationService _firestoreService;
  final LocalNotificationService _localNotificationService;

  FcmService(this._localNotificationService, this._firestoreService);

  Future<void> initialize() async {
    await _requestPermissions();

    await _setupForegroundOptions();

    _listenToForegroundNotifications();

    _listenToNotificationOpened();

    _listenToTokenRefresh();

    await _handleInitialMessage();

    final token = await getToken();

    if (token != null) {
      await _saveToken(token);
    }
  }

  // ================= Permissions =================

  Future<void> _requestPermissions() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  // ================= Foreground =================

  Future<void> _setupForegroundOptions() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _listenToForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground Notification");

      final notification = message.notification;

      if (notification == null) return;

      _localNotificationService.showNotification(
        title: notification.title,
        body: notification.body,
        payload: message.data['orderId'],
      );
    });
  }

  // ================= Click Notification =================

  void _listenToNotificationOpened() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Notification Opened");

      _handleNotificationNavigation(message);
    });
  }

  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();

    if (message == null) return;

    log("Opened From Terminated");

    _handleNotificationNavigation(message);
  }

  void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;

    final orderId = data['orderId'];

    if (orderId != null) {
      debugPrint("Navigate To Order : $orderId");

      /// هنربط Navigation هنا بعدين
    }
  }

  // ================= Token =================

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  void _listenToTokenRefresh() {
    _messaging.onTokenRefresh.listen((token) async {
      await _saveToken(token);
    });
  }

  Future<void> _saveToken(String token) async {
    final driverId = await SecureStorageService.getDriverId();

    if (driverId == null || driverId.isEmpty) return;

    await _firestoreService.saveDriverToken(driverId: driverId, token: token);

    debugPrint("Driver Token Saved");
  }

  // ================= Topics =================

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
