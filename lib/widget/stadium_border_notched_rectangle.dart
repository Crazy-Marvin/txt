import 'dart:math';

import 'package:flutter/material.dart';

/// A rectangle with a smooth circular notch.
/// Borrowed from https://github.com/JarrodCColburn/flutter/commit/17a0fe61269823c7f9e462596b5aedf794d243bc (BSD-style license).
class StadiumBorderNotchedRectangle implements NotchedShape {
  /// Creates a `CircularNotchedRectangle`.
  ///
  /// The same object can be used to create multiple shapes.
  const StadiumBorderNotchedRectangle();

  /// Creates a [Path] that describes a rectangle with a smooth circular notch.
  ///
  /// `host` is the bounding box for the returned shape. Conceptually this is
  /// the rectangle to which the notch will be applied.
  ///
  /// `guest` is the bounding box of a circle that the notch accomodates. All
  /// points in the circle bounded by `guest` will be outside of the returned
  /// path.
  ///
  /// The notch is curve that smoothly connects the host's top edge and
  /// the guest circle.
  @override
  Path getOuterPath(Rect host, Rect guest) {
    if (!host.overlaps(guest)) return Path()..addRect(host);

    // The guest's shape is a circle bounded by the guest rectangle.
    // So the guest's radius is half the guest width.
    final double notchRadius = guest.width / 2.0;

    // We build a path for the notch from 3 segments:
    // Segment A - a Bezier curve from the host's top edge to segment B.
    // Segment B - an arc with radius notchRadius.
    // Segment C - a Bezier curver from segment B back to the host's top edge.
    //
    // A detailed explanation and the derivation of the formulas below is
    // available at: https://goo.gl/Ufzrqn

    const double s1 = 15.0;
    const double s2 = 1.0;

    final double r = notchRadius;
    final double a = -1.0 * r - s2;
    final double b = host.top - guest.center.dy;

    final double n2 = sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = sqrt(r * r - p2xA * p2xA);
    final double p2yB = sqrt(r * r - p2xB * p2xB);

    // p0, p1, and p2 are the control points for segment A.
    Offset p0 = Offset(a - s1, b);
    Offset p1 = Offset(a, b);
    double cmp = b < 0 ? -1.0 : 1.0;
    Offset p2 = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    // p3, p4, and p5 are the control points for segment B, which is a mirror
    // of segment A around the y axis.
    Offset p3 = Offset(-1.0 * p2.dx, p2.dy);
    Offset p4 = Offset(-1.0 * p1.dx, p1.dy);
    Offset p5 = Offset(-1.0 * p0.dx, p0.dy);

    // translate all points back to the absolute coordinate system.
    p0 += guest.center;
    p1 += guest.center;
    p2 += guest.center;
    p3 += guest.center;
    p4 += guest.center;
    p5 += guest.center;

    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(p0.dx, p0.dy)
      ..quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy)
      ..arcToPoint(
        guest.bottomLeft + Offset(guest.height / 2, 0),
        radius: Radius.circular(guest.height / 2),
        clockwise: false,
      )
      ..lineTo(guest.right - guest.height / 2, guest.bottom)
      ..arcToPoint(
        p3,
        radius: Radius.circular(guest.height / 2),
        clockwise: false,
      )
      ..quadraticBezierTo(p4.dx, p4.dy, p5.dx, p5.dy)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}
