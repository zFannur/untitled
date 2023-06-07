// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "routerScreenAppBarTitle": "Fin-plan",
  "bottomBarStatistic": "statistic",
  "bottomBarOperation": "operation",
  "bottomBarPlan": "plan",
  "operationAdd": "ADD OPEARTION",
  "operationFromTable": "From table",
  "operationToSend": " for send: ",
  "operationAddAppBarTitle": "ADD OPEARTION",
  "operationEditAppBarTitle": "EDIT OPEARTION",
  "operationDateName": "Date",
  "operationDateLabelText": "date of operation",
  "operationTypeName": "Type",
  "operationTypeLabelText": "type of transaction",
  "operationFormName": "Form",
  "operationFormLabelText": "form of transaction",
  "operationSumName": "Sum",
  "operationSumLabelText": "Date",
  "operationNoteName": "Note",
  "operationNoteLabelText": "note of transaction"
};
static const Map<String,dynamic> ru = {
  "routerScreenAppBarTitle": "ФИН-ПЛАН",
  "bottomBarStatistic": "статистика",
  "bottomBarOperation": "операции",
  "bottomBarPlan": "план",
  "operationAdd": "ДОБАВИТЬ ОПЕРАЦИЮ",
  "operationFromTable": "Из таблицы",
  "operationToSend": " для отправки: ",
  "operationAddAppBarTitle": "ДОБАВИТЬ ОПЕРАЦИЮ",
  "operationEditAppBarTitle": "РЕДАКТИРОВАТЬ ОПЕРАЦИЮ",
  "operationDateName": "Дата",
  "operationDateLabelText": "день добавления",
  "operationTypeName": "Тип",
  "operationTypeLabelText": "тип операции",
  "operationFormName": "Направление",
  "operationFormLabelText": "направление операции",
  "operationSumName": "Стоимость",
  "operationSumLabelText": "Стоимость операции",
  "operationNoteName": "Примечание",
  "operationNoteLabelText": "примечание для уточнения"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "ru": ru};
}
