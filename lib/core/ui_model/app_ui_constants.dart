import 'package:flutter/material.dart';
import 'package:flutter_firebase_itp_app/core/ui_model/nav_item.dart';
import 'package:flutter_firebase_itp_app/features/feed/feed_page.dart';
import 'package:flutter_firebase_itp_app/features/profile/profile.dart';

class AppUiConstants {
  AppUiConstants._();

  static List<NavItem> items = [
    NavItem(title: 'Home', icon: Icons.home, route: FeedPage()),
    NavItem(title: 'Search', icon: Icons.search, route: Container()),
    NavItem(title: 'Profile', icon: Icons.person, route: Profile()),
  ];
}
