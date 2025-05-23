import 'package:flutter/material.dart';



class AppTheme {

  final ColorScheme colorScheme;
  final Gradient? backgroundGradient;
  final Gradient? containerGradient;

  AppTheme({required this.colorScheme, this.backgroundGradient, this.containerGradient});
}






enum ThemeType {
  light(label: 'Light'),
  dark(label: 'Dark'),
  auto(label: 'Auto'),
  pinkSaruka(label: 'Pink Saruka'),
  jangle(label: 'Jangle'),
  darkPurple(label: 'Dark Purple'),
  blurpleMidnight(label : "Blurple Midnight"),
  aurora(label: 'Aurora'),
  chromaGlow(label : "Chroma Glow");
  final String label;
  const ThemeType({ required this.label });
}



Map<ThemeType, AppTheme> themes = {
  ThemeType.light : light,
  ThemeType.dark : dark,
  ThemeType.auto : getSystemThemeMode(),
  ThemeType.pinkSaruka : pinkSakura,
  ThemeType.jangle : jangle,
  ThemeType.darkPurple : darkPurple,
  ThemeType.blurpleMidnight : blurpleMidnight,
  ThemeType.aurora : aurora,
  ThemeType.chromaGlow : chromaGlow,
};

AppTheme getSystemThemeMode() {
  return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.light ? light : dark;
}



 AppTheme light = AppTheme(
  backgroundGradient: null,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF485D92),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDAE2FF),
    onPrimaryContainer: Color(0xFF001947),
    primaryFixed: Color(0xFFDAE2FF),
    primaryFixedDim: Color(0xFFB1C5FF),
    onPrimaryFixed: Color(0xFF001947),
    onPrimaryFixedVariant: Color(0xFF304578),
    secondary: Color(0xFF585E71),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDCE2F9),
    onSecondaryContainer: Color(0xFF151B2C),
    secondaryFixed: Color(0xFFDCE2F9),
    secondaryFixedDim: Color(0xFFC0C6DC),
    onSecondaryFixed: Color(0xFF151B2C),
    onSecondaryFixedVariant: Color(0xFF404659),
    tertiary: Color(0xFF735572),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFED7F9),
    onTertiaryContainer: Color(0xFF2A122C),
    tertiaryFixed: Color(0xFFFED7F9),
    tertiaryFixedDim: Color(0xFFE0BBDD),
    onTertiaryFixed: Color(0xFF2A122C),
    onTertiaryFixedVariant: Color(0xFF593D59),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFFAF8FF),
    onSurface: Color(0xFF1A1B21),
    surfaceDim: Color(0xFFDAD9E0),
    surfaceBright: Color(0xFFFAF8FF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF4F3FA),
    surfaceContainer: Color(0xFFEEEDF4),
    surfaceContainerHigh: Color(0xFFE8E7EF),
    surfaceContainerHighest: Color(0xFFE2E2E9),
    onSurfaceVariant: Color(0xFF44464F),
    outline: Color(0xFF757780),
    outlineVariant: Color(0xFFC5C6D0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF2F3036),
    onInverseSurface: Color(0xFFF1F0F7),
    inversePrimary: Color(0xFFB1C5FF),
    surfaceTint: Color(0xFF485D92),
  ),

);


AppTheme dark = AppTheme(
  backgroundGradient: null,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFB1C5FF),
    onPrimary: Color(0xFF172E60),
    primaryContainer: Color(0xFF304578),
    onPrimaryContainer: Color(0xFFDAE2FF),
    primaryFixed: Color(0xFFDAE2FF),
    primaryFixedDim: Color(0xFFB1C5FF),
    onPrimaryFixed: Color(0xFF001947),
    onPrimaryFixedVariant: Color(0xFF304578),
    secondary: Color(0xFFC0C6DC),
    onSecondary: Color(0xFF2A3042),
    secondaryContainer: Color(0xFF404659),
    onSecondaryContainer: Color(0xFFDCE2F9),
    secondaryFixed: Color(0xFFDCE2F9),
    secondaryFixedDim: Color(0xFFC0C6DC),
    onSecondaryFixed: Color(0xFF151B2C),
    onSecondaryFixedVariant: Color(0xFF404659),
    tertiary: Color(0xFFE0BBDD),
    onTertiary: Color(0xFF412742),
    tertiaryContainer: Color(0xFF593D59),
    onTertiaryContainer: Color(0xFFFED7F9),
    tertiaryFixed: Color(0xFFFED7F9),
    tertiaryFixedDim: Color(0xFFE0BBDD),
    onTertiaryFixed: Color(0xFF2A122C),
    onTertiaryFixedVariant: Color(0xFF593D59),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF121318),
    onSurface: Color(0xFFE2E2E9),
    surfaceDim: Color(0xFF121318),
    surfaceBright: Color(0xFF38393F),
    surfaceContainerLowest: Color(0xFF0D0E13),
    surfaceContainerLow: Color(0xFF1A1B21),
    surfaceContainer: Color(0xFF1E1F25),
    surfaceContainerHigh: Color(0xFF282A2F),
    surfaceContainerHighest: Color(0xFF33343A),
    onSurfaceVariant: Color(0xFFC5C6D0),
    outline: Color(0xFF8F9099),
    outlineVariant: Color(0xFF44464F),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE2E2E9),
    onInverseSurface: Color(0xFF2F3036),
    inversePrimary: Color(0xFF485D92),
    surfaceTint: Color(0xFFB1C5FF),
  ),
  );


AppTheme pinkSakura = AppTheme(
  colorScheme: ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFB1C0),
  onPrimary: Color(0xFF551D2C),
  primaryContainer: Color(0xFF713342),
  onPrimaryContainer: Color(0xFFFFD9DF),
  primaryFixed: Color(0xFFFFD9DF),
  primaryFixedDim: Color(0xFFFFB1C0),
  onPrimaryFixed: Color(0xFF3A0717),
  onPrimaryFixedVariant: Color(0xFF713342),
  secondary: Color(0xFFE4BDC3),
  onSecondary: Color(0xFF43292E),
  secondaryContainer: Color(0xFF5B3F44),
  onSecondaryContainer: Color(0xFFFFD9DF),
  secondaryFixed: Color(0xFFFFD9DF),
  secondaryFixedDim: Color(0xFFE4BDC3),
  onSecondaryFixed: Color(0xFF2B151A),
  onSecondaryFixedVariant: Color(0xFF5B3F44),
  tertiary: Color(0xFFECBE91),
  onTertiary: Color(0xFF462A08),
  tertiaryContainer: Color(0xFF5F401D),
  onTertiaryContainer: Color(0xFFFFDCBC),
  tertiaryFixed: Color(0xFFFFDCBC),
  tertiaryFixedDim: Color(0xFFECBE91),
  onTertiaryFixed: Color(0xFF2C1700),
  onTertiaryFixedVariant: Color(0xFF5F401D),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: Color(0xFF191113),
  onSurface: Color(0xFFEFDEE0),
  surfaceDim: Color(0xFF191113),
  surfaceBright: Color(0xFF413738),
  surfaceContainerLowest: Color(0xFF140C0D),
  surfaceContainerLow: Color(0xFF22191B),
  surfaceContainer: Color(0xFF261D1F),
  surfaceContainerHigh: Color(0xFF312829),
  surfaceContainerHighest: Color(0xFF3C3234),
  onSurfaceVariant: Color(0xFFD6C2C4),
  outline: Color(0xFF9F8C8F),
  outlineVariant: Color(0xFF524345),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFEFDEE0),
  onInverseSurface: Color(0xFF382E2F),
  inversePrimary: Color(0xFF8D4959),
  surfaceTint: Color(0xFFFFB1C0),
),
);



AppTheme jangle = AppTheme(colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF3A693B),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFBBF0B6),
      onPrimaryContainer: Color(0xFF002105),
      primaryFixed: Color(0xFFBBF0B6),
      primaryFixedDim: Color(0xFFA0D49B),
      onPrimaryFixed: Color(0xFF002105),
      onPrimaryFixedVariant: Color(0xFF225025),
      secondary: Color(0xFF52634F),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFD5E8CF),
      onSecondaryContainer: Color(0xFF101F10),
      secondaryFixed: Color(0xFFD5E8CF),
      secondaryFixedDim: Color(0xFFB9CCB4),
      onSecondaryFixed: Color(0xFF101F10),
      onSecondaryFixedVariant: Color(0xFF3B4B39),
      tertiary: Color(0xFF39656B),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFBCEBF1),
      onTertiaryContainer: Color(0xFF001F23),
      tertiaryFixed: Color(0xFFBCEBF1),
      tertiaryFixedDim: Color(0xFFA1CED5),
      onTertiaryFixed: Color(0xFF001F23),
      onTertiaryFixedVariant: Color(0xFF1F4D53),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: Color(0xFFF7FBF1),
      onSurface: Color(0xFF181D17),
      surfaceDim: Color(0xFFD7DBD2),
      surfaceBright: Color(0xFFF7FBF1),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF1F5EC),
      surfaceContainer: Color(0xFFEBEFE6),
      surfaceContainerHigh: Color(0xFFE6E9E0),
      surfaceContainerHighest: Color(0xFFE0E4DB),
      onSurfaceVariant: Color(0xFF424940),
      outline: Color(0xFF72796F),
      outlineVariant: Color(0xFFC2C9BD),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF2D322C),
      onInverseSurface: Color(0xFFEEF2E9),
      inversePrimary: Color(0xFFA0D49B),
      surfaceTint: Color(0xFF3A693B),
    ),
    );



AppTheme darkPurple = AppTheme(colorScheme: ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFCCBEFF),
  onPrimary: Color(0xFF33275E),
  primaryContainer: Color(0xFF4A3E76),
  onPrimaryContainer: Color(0xFFE7DEFF),
  primaryFixed: Color(0xFFE7DEFF),
  primaryFixedDim: Color(0xFFCCBEFF),
  onPrimaryFixed: Color(0xFF1E1148),
  onPrimaryFixedVariant: Color(0xFF4A3E76),
  secondary: Color(0xFFCAC3DC),
  onSecondary: Color(0xFF322E41),
  secondaryContainer: Color(0xFF494458),
  onSecondaryContainer: Color(0xFFE6DFF8),
  secondaryFixed: Color(0xFFE6DFF8),
  secondaryFixedDim: Color(0xFFCAC3DC),
  onSecondaryFixed: Color(0xFF1D192B),
  onSecondaryFixedVariant: Color(0xFF494458),
  tertiary: Color(0xFFEEB8CB),
  onTertiary: Color(0xFF492534),
  tertiaryContainer: Color(0xFF623B4B),
  onTertiaryContainer: Color(0xFFFFD9E5),
  tertiaryFixed: Color(0xFFFFD9E5),
  tertiaryFixedDim: Color(0xFFEEB8CB),
  onTertiaryFixed: Color(0xFF30111F),
  onTertiaryFixedVariant: Color(0xFF623B4B),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: Color(0xFF141318),
  onSurface: Color(0xFFE6E1E9),
  surfaceDim: Color(0xFF141318),
  surfaceBright: Color(0xFF3A383E),
  surfaceContainerLowest: Color(0xFF0F0D13),
  surfaceContainerLow: Color(0xFF1C1B20),
  surfaceContainer: Color(0xFF201F24),
  surfaceContainerHigh: Color(0xFF2B292F),
  surfaceContainerHighest: Color(0xFF36343A),
  onSurfaceVariant: Color(0xFFCAC4CF),
  outline: Color(0xFF938F99),
  outlineVariant: Color(0xFF48454E),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFE6E1E9),
  onInverseSurface: Color(0xFF312F35),
  inversePrimary: Color(0xFF625690),
  surfaceTint: Color(0xFFCCBEFF),
),
);




// const Color darkBlurple = Color(0xFF404EED);
// const Color blurple     = Color(0xFF5865F2);
const Color containerDarkBlurple = Color(0xFF0f0b29);
const Color containerBlurple     = Color(0xFF0b103f);

const Color backgroundDarkBlurple = Color(0xFF070315);
const Color backgroundBlurple     = Color(0xFF070924);
AppTheme blurpleMidnight = AppTheme(
    colorScheme: ColorScheme.fromSeed(seedColor: backgroundBlurple, brightness: Brightness.dark),
    backgroundGradient: LinearGradient(
      colors: [backgroundDarkBlurple, backgroundBlurple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  containerGradient: LinearGradient(
    colors: [containerDarkBlurple, containerBlurple],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  ),

);




// const Color containerFirst = Color(0xFFbdc3c7);
// const Color containerSecond = Color(0xFF2c3e50);
//
// const Color backgroundFirst = Color(0xff8e9296);
// const Color backgroundSecond = Color(0xff1f2d38);
//
//
// AppTheme zinc = AppTheme(colorScheme: ColorScheme.fromSeed(seedColor: containerFirst, brightness: Brightness.dark),
//   backgroundGradient: LinearGradient(
//     colors: [backgroundFirst, backgroundSecond],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   ),
//
//   containerGradient: LinearGradient(
//     colors: [containerFirst, containerSecond],
//     begin: Alignment.topRight,
//     end: Alignment.bottomLeft,
//   ),
// );




// const Color backgroundContainerFirst = Color(0xff49456c);
// const Color backgroundContainerSecond = Color(0xff394f41);
// const Color containerFirst = Color(0xFF34317B);
// const Color containerSecond = Color(0xffDDB8B0);
//
// AppTheme eagle = AppTheme(
//   colorScheme: ColorScheme.fromSeed(seedColor: containerFirst, brightness: Brightness.dark),
//   backgroundGradient: LinearGradient(
//     colors: [backgroundContainerFirst, backgroundContainerSecond],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   ),
//   containerGradient: LinearGradient(
//     colors: [containerFirst, containerSecond],
//     begin: Alignment.topRight,
//     end: Alignment.bottomLeft,
//   ),
//
// );



const Color backgroundContainerFirst = Color(0xff00060c);
const Color backgroundContainerSecond = Color(0xff011514);
const Color containerFirst = Color(0xFF00091a);
const Color containerSecond = Color(0xff070937);
const Color containerThird = Color(0xFF002a28);
const Color containerFourth = Color(0xff000514);

AppTheme aurora = AppTheme(
  colorScheme: ColorScheme.fromSeed(seedColor: containerFirst, brightness: Brightness.dark),
  backgroundGradient: LinearGradient(
    colors: [backgroundContainerFirst, backgroundContainerSecond],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  ),
  containerGradient: LinearGradient(
    colors: [containerFirst, containerSecond, containerThird, containerFourth],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  ),

);



const Color backgroundChromaGlowContainerFirst = Color(0xff001c1c);
const Color backgroundChromaGlowContainerSecond = Color(0xff180824);
const Color backgroundChromaGlowContainerThird = Color(0xff031725);
const Color chromaGlowContainerFirst = Color(0xff014356);
const Color chromaGlowContainerSecond = Color(0xff24116e);
const Color chromaGlowContainerThird = Color(0xFF4c075a);
const Color chromaGlowContainerFourth = Color(0xff462374);
const Color chromaGlowContainerFive = Color(0xFF00426d);


AppTheme chromaGlow = AppTheme(
  colorScheme: ColorScheme.fromSeed(seedColor: chromaGlowContainerFirst, brightness: Brightness.dark),
  backgroundGradient: LinearGradient(
    colors: [backgroundChromaGlowContainerFirst, backgroundChromaGlowContainerSecond, backgroundChromaGlowContainerThird],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  containerGradient: LinearGradient(
    colors: [chromaGlowContainerFirst, chromaGlowContainerSecond, chromaGlowContainerThird, chromaGlowContainerFourth, chromaGlowContainerFive],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

);

