# DummyDronie
A simple app to control DJI drone devices and perform a dronie without distance and altitude limits.
![SplashScreen](https://user-images.githubusercontent.com/8620461/231183232-5ce785fe-f7e8-4220-8c6f-d2291acf4c14.png)

## Features

- Connect and manage DJI drone devices
- Control the drone using virtual sticks mode
- Monitor drone's battery percentage, altitude, and distance
- Start and stop video recording
- Perform a dronie without distance and altitude limits

## Requirements

- Compatible DJI drone (e.g., DJI Phantom, Mavic or Inspire series)
- Compatible iOS device (iOS >=16.2)
- Xcode

## Setup

1. Clone the repository to your local machine.
2. Obtain a DJI Mobile SDK App Key from the [DJI Developer Portal](https://developer.dji.com/user/apps/).
3. Add the App Key to the project's `Info.plist` file, associating it with the `SDK_APP_KEY_INFO_PLIST_KEY` key.
4. Ensure that the application has required permissions in the `Info.plist` file, such as `NSLocationWhenInUseUsageDescription`, `NSBluetoothAlwaysUsageDescription`, etc.
5. Build and run the project on a supported iOS device.

## Usage

1. Turn on your DJI drone and connect your iOS device to the drone's remote controller.
2. Run the app on the iOS device.
3. The app will automatically detect and connect to the drone.
4. Once connected, you can perform dronie and other available features using the app.

## Contributing

Feel free to contribute to this project by submitting issues or pull requests.

## License

This project is licensed under the MIT License.
