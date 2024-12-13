import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> myData = [
  {
    'icon': const FaIcon(FontAwesomeIcons.burger, /*color: Colors.white*/ size: 20),
    'color': Colors.blue,
    'name': 'Food',
    'total': '-R350.00',
    'date': 'Today',
  },
  {
    'icon': const FaIcon(FontAwesomeIcons.bagShopping, size: 20),
    'color': Colors.purple,
    'name': 'Shopping',
    'total': '-R900.00',
    'date': 'Today',
  },
  {
    'icon': const FaIcon(FontAwesomeIcons.plane, size: 20),
    'color': Colors.red,
    'name': 'Travel',
    'total': '-R550.00',
    'date': 'Today',
  },
  {
    'icon': const FaIcon(FontAwesomeIcons.wrench, size: 20),
    'color': Colors.yellow,
    'name': 'Utlities',
    'total': '-R700.00',
    'date': 'Today',
  },
  {
    'icon': const FaIcon(FontAwesomeIcons.shuffle, size: 20),
    'color': Colors.pink,
    'name': 'Misc',
    'total': '-R400.00',
    'date': 'Today',
  }
];