# Reddit unofficial

An unofficial WebApp for [Reddit](https://www.reddit.com) on Ubuntu Touch (Lomiri).
It wraps the mobile Reddit website in a full-screen `WebEngineView` and adds a
floating menu for navigation.

> This project is not affiliated with, endorsed by, or sponsored by Reddit, Inc.

Based on the "X unofficial" WebApp.

## Features

- Full-screen web view, no top bar.
- Floating Reddit logo button at the bottom centre: Back, Home, Popular, Search,
  Notifications, Create, Refresh.
- Edge swipe back from the left edge.
- Offline screen with a retry button, splash screen, persistent login.
- Photo/video upload through the Lomiri Content Hub.
- Notification, microphone and camera requests are granted automatically.

## Building

You need [Clickable](https://clickable-ut.dev/) (7.1.2 or newer).

```
clickable desktop      # run on the desktop
clickable              # build and install on a connected device
```

## Customising

- Menu entries: `entries` in `qml/FabMenu.qml`. `back` and `reload` are handled in
  `onNavigate` in `qml/Main.qml`; the other keys in `paths` in `qml/scrollBarTheme.js`.
- Accent colour: `accentColor` in `qml/Main.qml`.
- Menu size/spacing: `arcRadius` and `itemSize` in `qml/FabMenu.qml`.

## License

GPL-3.0. See the header of each source file.
