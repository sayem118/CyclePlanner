import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';


export 'package:geolocator_android/geolocator_android.dart'
    show AndroidSettings, ForegroundNotificationConfig;
export 'package:geolocator_apple/geolocator_apple.dart'
    show AppleSettings, ActivityType;
export 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

/// Wraps CLLocationManager (on iOS) and FusedLocationProviderClient or
/// LocationManager
/// (on Android), providing support to retrieve position information
/// of the device.
///
/// Permissions are automatically handled when retrieving position information.
/// However utility methods for manual permission management are also
/// provided.

