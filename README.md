<p align="center" >
<img src="https://raw.githubusercontent.com/appspector/msgpack-swift/master/Resources/logo.png" width=169px height=150px alt="AppSpector MessagePack" title="AppSpector MessagePack">
</p>

<p align="center" >Ultra fast 🚀, zero-dependency MessagePack impelementation in pure swift.<br/>
No recursion in decoding path 🧐 and very little additional memory allocation.
<p/>
<p align="center" >★★ <b>Star our github repository to help us!</b> ★★</p>
<p align="center" >Created by <a href="https://github.com/sergeyzenchenko">Serge Zenchenko</a> (<a href="http://www.twitter.com/sergeyzenchenko">@sergeyzenchenko</a>) for <a href="http://www.appspector.com">AppSpector</a></p>

# MessagePack Swift

Supports Apple platforms and Linux.

Based on original MessagePack parser architecture. This is the only Swift version with streaming parsing support.
Using this library you can parse endless streams of msgpack data without consuming all memory on your machine.

# Installation

### SPM (Swift Package Manager)

You can easily integrate MessagePack.swift in your app with SPM. Just add MessagePack.swift as a dependency:

```swift
import PackageDescription

let package = Package(
name: "CoolAppName",
dependencies: [
.Package(url: "https://github.com/appspector/msgpack-swift.git", majorVersion: 0.1),
]
)
```

# About Us

Looking for better debugging instrument? Try [AppSpector](https://appspector.com). With AppSpector you can remotely debug your app running in the same room or on another continent. You can measure app performance, view CoreData and SQLite content, logs, network requests and many more in realtime. This is the instrument that you've been looking for.

![](https://storage.googleapis.com/appspector-support/screenshots/appspector_twittercover2.png)

## Authors

Serge Zenchenko, zen@appspector.com

## License

msgpack-swift is available under the MIT license. See the LICENSE file for more info.

