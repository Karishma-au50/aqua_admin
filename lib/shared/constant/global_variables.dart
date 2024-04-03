import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_utils/src/platform/platform.dart';

const Color greenColor = Color.fromRGBO(22, 99, 81, 1);
const Color blackColor = Color(0xFF0E0F0C);

const String apiHost = "https://api-main.aquagenixpro.com/";
// const String apiHost = "https://api-dev.aquagenixpro.com/";
// String apiHost =
//     GetPlatform.isAndroid ? "http://10.0.2.2:3001" : "http://localhost:3001";

RxBool isFabOpen = false.obs;

const List<String> pondUnits = ["Acres", "Hectares"];
const List<String> pondCultureType = [
  "L. Vannamei",
  "Scampi",
  "Catla",
  "Rohu",
  "Grass Carp",
  "Mrigcal Carp",
  "Catfish",
  "Chinese carp",
  "Tilapia (GIFT)",
  "Pearls",
  "Roopchand",
  "Channa Striatus",
  "Pangasius",
  "Seabass",
  "Penaeus Monodon"
];

// subSensor values
const List<String> nh4no3subSensorValues = [
  "0.1",
  "1",
  "10",
  "100",
  "1000",
  "10000"
];

const List<String> ecSubSesnsorValues = ["84", "147", "1413", "12.88"];

String standardPlanText =
    "You are changing the aerator operations schedule from ‘efficient’ to ‘standard’. From now on, aerators will operate in line with the specified schedule and will not depend on DO.";
String efficientPlanText =
    "You are changing the aerator operations schedule from ‘standard’ to ‘efficient’. From now on, during the night block, aerators will be ON when DO is below 5.0 mg/L.";

String aeratorUnderMaintainanceText =
    "You are marking the aerator as 'Under maintenance'.\nScheduled automation operations will be suspended until the the aerator is reverted to 'Active' status.";
String aeratorActiveText =
    "You are moving the aerator from maintenance to active state. Automation operations will resume immediately.";

List<Map<String, double>> shrimpStaticPoints = [
  // {"days": 0, "abw": 0},
  {"days": 7, "abw": 0.4},
  {"days": 14, "abw": 0.11},
  {"days": 21, "abw": 0.48},
  {"days": 28, "abw": 1.25},
  {"days": 35, "abw": 2.37},
  {"days": 42, "abw": 3.81},
  {"days": 49, "abw": 5.45},
  {"days": 56, "abw": 7.27},
  {"days": 63, "abw": 9.37},
  {"days": 70, "abw": 11.27},
  {"days": 77, "abw": 13.40},
  {"days": 84, "abw": 15.11},
  {"days": 91, "abw": 16.65},
  {"days": 98, "abw": 18.09},
  {"days": 105, "abw": 19.45},
  {"days": 119, "abw": 23.80},
];
