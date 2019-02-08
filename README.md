## WinkNavigation

This is a sample app built in swift that uses your winks to navigation a carousel view left or right.  Using ARKit's face geometry, we can capture each eye's coefficients to determine the level of the blink.  Timing the eye blink interval from open to close will determine if the blink should trigger the navigation.  We are blocking unintended blinks if both eyes are closed.

### Preview

![Preview](Preview/preview.gif)


### License

This project is available under the MIT license. See the LICENSE file for more info.
