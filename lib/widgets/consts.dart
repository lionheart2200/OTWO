import 'package:flutter/material.dart';

const TextStyle myTextStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

const myBackgroundColor = Color.fromRGBO(49, 54, 63, 1);
const myWhiteColor = Color.fromRGBO(238, 238, 238, 1);
const myBlackColor = Color.fromRGBO(34, 40, 49, 1);
const myLightblueColor = Color.fromRGBO(118, 171, 174, 1);

const mainGradientDT = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.black,
      Colors.green,
    ]);
 const myBottomBarFont = TextStyle(
  fontSize: 15, // حجم الخط للعناصر المحددة
  fontWeight: FontWeight.bold, // جعل الخط عريض للعناصر المحددة
  fontFamily: 'jazera',
); // نوع الخط;

const myBarFont = TextStyle(
  fontSize: 18, // حجم الخط للعناصر المحددة
  color: myWhiteColor,
  fontWeight: FontWeight.bold, // جعل الخط عريض للعناصر المحددة
  fontFamily: 'jazera',
); // نوع الخط;

const myCardTitleFont = TextStyle(
  fontSize: 18, // حجم الخط للعناصر المحددة
  color: myBlackColor,
  fontWeight: FontWeight.bold, // جعل الخط عريض للعناصر المحددة
  fontFamily: 'jazera',
); // نوع الخط;


const myDrobdownWhiteFont = TextStyle(
  fontSize: 15, // حجم الخط للعناصر المحددة
  fontWeight: FontWeight.bold, // جعل الخط عريض للعناصر المحددة
  color: myWhiteColor,
  fontFamily: 'jazera',
); // نوع الخط;
const myDrobdownBlackFont = TextStyle(
  fontSize: 15, // حجم الخط للعناصر المحددة
  fontWeight: FontWeight.bold, // جعل الخط عريض للعناصر المحددة
  color: myBlackColor,
  fontFamily: 'jazera',
); // نوع الخط;

const myCardSubTitleFont = TextStyle(
  fontSize: 15, // حجم الخط للعناصر المحددة
  fontWeight: FontWeight.bold, // جعل الخط عريض للعناصر المحددة
  color: Colors.grey,
  fontFamily: 'jazera',
); // نوع الخط;