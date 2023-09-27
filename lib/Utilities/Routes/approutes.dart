import 'package:designerdigger/Utilities/ThemeChanger/themechanger.dart';
import 'package:designerdigger/Views/AddProducts/addproducts.dart';
import 'package:designerdigger/Views/AddProducts/addpromotions.dart';
import 'package:designerdigger/Views/Authentication/SignUpView/PhoneNumber/phonenumber.dart';
import 'package:designerdigger/Views/Authentication/SignUpView/PhoneNumber/verifynumber.dart';
import 'package:designerdigger/Views/CartView/cartview.dart';
import 'package:designerdigger/Views/HomeView/DetailView/detailview.dart';
import 'package:designerdigger/Views/HomeView/homeview.dart';
import 'package:designerdigger/Views/MainView/mainview.dart';
import 'package:designerdigger/Views/OnboardingView/onboardingview.dart';
import 'package:designerdigger/Views/Profileview/EditProfile/editprofile.dart';
import 'package:designerdigger/Views/Authentication/SignInView/signinview.dart';
import 'package:designerdigger/Views/Authentication/SignUpView/Profilepic/profilepic.dart';
import 'package:designerdigger/Views/Authentication/SignUpView/SignUpView.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'errorwidget.dart' as e;

class AppRoute {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingView(),
      ),
      GoRoute(
        path: '/signup',
        builder: (BuildContext context, GoRouterState state) =>
            const SignUpView(),
      ),
      GoRoute(
        path: '/profilepic',
        builder: (BuildContext context, GoRouterState state) =>
            const Profilepic(),
      ),
      GoRoute(
        path: '/signin',
        builder: (BuildContext context, GoRouterState state) =>
            const SignInView(),
      ),
      GoRoute(
        path: '/homeview',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeView(),
      ),
      GoRoute(
        path: '/cartview',
        builder: (BuildContext context, GoRouterState state) =>
            const CartView(),
      ),
      GoRoute(
        path: '/addproductsview',
        builder: (BuildContext context, GoRouterState state) =>
            const AddProducts(),
      ),
      GoRoute(
        path: '/addpromotionsview',
        builder: (BuildContext context, GoRouterState state) =>
            const AddPromotions(),
      ),
      GoRoute(
        path: '/darkview',
        builder: (BuildContext context, GoRouterState state) =>
            const DarkTheme(),
      ),
      GoRoute(
        path: '/mainview',
        builder: (BuildContext context, GoRouterState state) =>
            const MainView(),
      ),
      GoRoute(
        path: '/editprofileview',
        builder: (BuildContext context, GoRouterState state) => EditProfile(
          name: state.extra.toString(),
        ),
      ),
      GoRoute(
        path: '/phonenumberview',
        builder: (BuildContext context, GoRouterState state) =>
            const PhoneNumberView(),
      ),
      GoRoute(
          path: '/verifyphonenumberview',
          builder: (BuildContext context, GoRouterState state) {
            final queryParams = state.uri.queryParameters;
            final id = queryParams['id'];
            return VerifyPhoneNumberView(
              phonenumb: state.extra.toString(),
              id: id.toString(),
            );
          }),
      GoRoute(
        path: '/detailview',
        builder: (BuildContext context, GoRouterState state) => DetailView(
          detail: state.extra.toString(),
        ),
      ),
    ],
    errorBuilder: (context, state) =>
        e.ErrorWidget(error: state.error.toString()),
  );
}
