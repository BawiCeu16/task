/// Responsive breakpoints for consistent screen size handling
class ResponsiveBreakpoints {
  // Desktop breakpoint
  static const double desktopBreakpoint = 800.0;

  // Tablet breakpoint
  static const double tabletBreakpoint = 600.0;

  // Mobile breakpoint
  static const double mobileBreakpoint = 0.0;

  // Grid configurations based on screen width
  static int getGridCrossAxisCount(double screenWidth) {
    if (screenWidth > desktopBreakpoint) {
      return 7; // Desktop: 7 columns
    } else if (screenWidth > tabletBreakpoint) {
      return 3; // Tablet: 3 columns
    } else {
      return 2; // Mobile: 2 columns
    }
  }

  // Check if device is in wide (desktop-like) layout
  static bool isWideLayout(double screenWidth) {
    return screenWidth >= desktopBreakpoint;
  }

  // Check if device is in tablet layout
  static bool isTabletLayout(double screenWidth) {
    return screenWidth >= tabletBreakpoint && screenWidth < desktopBreakpoint;
  }

  // Check if device is in mobile layout
  static bool isMobileLayout(double screenWidth) {
    return screenWidth < tabletBreakpoint;
  }
}
