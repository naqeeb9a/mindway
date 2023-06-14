import 'package:get/get.dart';
import 'package:mindway/src/account/controller/account_controller.dart';
import 'package:mindway/src/account/upload_profile_pic_screen.dart';
import 'package:mindway/src/auth/choose_screen.dart';
import 'package:mindway/src/auth/time/select_time_screen.dart';
import 'package:mindway/src/auth/time/select_time_screen_new.dart';
import 'package:mindway/src/auth/views/login_screen.dart';
import 'package:mindway/src/auth/views/signup_form_screen.dart';
import 'package:mindway/src/auth/views/signup_screen.dart';
import 'package:mindway/src/entry_screen.dart';
import 'package:mindway/src/favourite/fav_controller.dart';
import 'package:mindway/src/favourite/fav_controller_new.dart';
import 'package:mindway/src/favourite/favourite_screen.dart';
import 'package:mindway/src/home/controller/home_controller.dart';
import 'package:mindway/src/home/views/home_audio_screen.dart';
import 'package:mindway/src/journal/add_journal_screen.dart';
import 'package:mindway/src/journal/controller/journal_controller.dart';
import 'package:mindway/src/journey/journey_controller.dart';
import 'package:mindway/src/journey/views/emotion_screen.dart';
import 'package:mindway/src/journey/views/emotion_tracker_screen.dart';
import 'package:mindway/src/main_screen.dart';
import 'package:mindway/src/meditate/controller/meditate_controller.dart';
import 'package:mindway/src/meditate/views/course_outline_screen.dart';
import 'package:mindway/src/meditate/views/meditate_course_detail_screen.dart';
import 'package:mindway/src/meditate/views/meditate_course_screen.dart';
import 'package:mindway/src/music/controller/music_controller.dart';
import 'package:mindway/src/music/music_screen.dart';
import 'package:mindway/src/onboarding/onboarding_screen1.dart';
import 'package:mindway/src/onboarding/onboarding_screen2.dart';
import 'package:mindway/src/player/course_meditate_audio_screen.dart';
import 'package:mindway/src/player/course_session_audio_screen.dart';
import 'package:mindway/src/player/music_audio_screen.dart';
import 'package:mindway/src/player/single_audio_screen.dart';
import 'package:mindway/src/player/sleep_dedicated_audio_screen.dart';
import 'package:mindway/src/player/sleep_session_audio_screen.dart';
import 'package:mindway/src/sleep/controller/sleep_controller.dart';
import 'package:mindway/src/sleep/views/sleep_course_detail_screen.dart';
import 'package:mindway/src/sleep/views/sleep_screen.dart';
import 'package:mindway/src/splash_screen.dart';
import 'package:mindway/src/splash_screen_image.dart';
import 'package:mindway/src/subscription/views/subscription_offer_screen.dart';
import 'package:mindway/src/subscription/views/subscription_screen.dart';

final List<GetPage<dynamic>> routes = [
  GetPage(
    name: SplashScreen.routeName,
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: SplashScreenImage.routeName,
    page: () => SplashScreenImage(),
  ),
  GetPage(
    name: EntryScreen.routeName,
    page: () => const EntryScreen(),
  ),
  GetPage(
    name: LogInScreen.routeName,
    page: () => const LogInScreen(),
  ),
  GetPage(
    name: SignUpScreen.routeName,
    page: () => const SignUpScreen(),
  ),
  GetPage(
    name: SignUpFormScreen.routeName,
    page: () => const SignUpFormScreen(),
  ),
  GetPage(
    name: ChooseScreen.routeName,
    page: () => const ChooseScreen(),
  ),
  GetPage(
    name: SelectTimeAndDayToNotifyNew.routeName,
    page: () => const SelectTimeAndDayToNotifyNew(),
  ),
  GetPage(
    name: OnboardingScreen1.routeName,
    page: () => const OnboardingScreen1(),
  ),
  GetPage(
    name: OnboardingScreen2.routeName,
    page: () => const OnboardingScreen2(),
  ),
  GetPage(
    name: UploadProfilePicScreen.routeName,
    page: () => const UploadProfilePicScreen(),
  ),
  GetPage(
    name: MainScreen.routeName,
    page: () => const MainScreen(),
    binding: BindingsBuilder(() {
      Get.put(HomeController());
      Get.put(SleepController());
      Get.put(MeditateController(), permanent: true);
      Get.put(JourneyController());
      Get.put(AccountController());
    }),
  ),
  GetPage(
    name: MeditateCourseScreen.routeName,
    page: () => MeditateCourseScreen(),
  ),
  GetPage(
    name: MeditateCourseDetailScreen.routeName,
    page: () => MeditateCourseDetailScreen(),
  ),
  GetPage(
    name: CourseOutlineScreen.routeName,
    page: () => CourseOutlineScreen(),
  ),
  GetPage(
    name: CourseSessionAudioPlayerScreen.routeName,
    page: () => const CourseSessionAudioPlayerScreen(),
  ),
  GetPage(
    name: CourseMeditateAudioPlayerScreen.routeName,
    page: () => const CourseMeditateAudioPlayerScreen(),
  ),
  GetPage(
    name: SleepSessionAudioPlayerScreen.routeName,
    page: () => const SleepSessionAudioPlayerScreen(),
  ),
  GetPage(
    name: SleepDedicatedAudioPlayerScreen.routeName,
    page: () => const SleepDedicatedAudioPlayerScreen(),
  ),
  GetPage(
    name: SingleAudioPlayerScreen.routeName,
    page: () => const SingleAudioPlayerScreen(),
  ),
  GetPage(
    name: FavouiteScreen.routeName,
    page: () => const FavouiteScreen(),
    binding: BindingsBuilder(() {
      Get.put(FavControllerNew());
    }),
  ),
  GetPage(
    name: SleepScreen.routeName,
    page: () => SleepScreen(),
  ),
  GetPage(
    name: SleepCourseDetailScreen.routeName,
    page: () => SleepCourseDetailScreen(),
  ),
  GetPage(
    name: EmotionScreen.routeName,
    page: () => EmotionScreen(),
    binding: BindingsBuilder(() {
      Get.put(JournalController());
    }),
  ),
  GetPage(
    name: EmotionTrackerScreen.routeName,
    page: () => EmotionTrackerScreen(),
  ),
  GetPage(
    name: HomeAudioPlayerScreen.routeName,
    page: () => HomeAudioPlayerScreen(),
  ),
  GetPage(
    name: AddJournalScreen.routeName,
    page: () => const AddJournalScreen(),
    binding: BindingsBuilder(() {
      Get.put(JournalController());
    }),
  ),
  // Subscription Screens
  GetPage(
    name: SubscriptionScreen.routeName,
    page: () => SubscriptionScreen(),
  ),
  GetPage(
    name: SubscriptionOfferScreen.routeName,
    page: () => SubscriptionOfferScreen(),
  ),
  GetPage(
    name: MusicScreen.routeName,
    page: () => MusicScreen(),
    binding: BindingsBuilder(() {
      Get.put(MusicController());
    }),
  ),
  GetPage(
    name: MusicAudioPlayerScreen.routeName,
    page: () => MusicAudioPlayerScreen(),
  ),
];
