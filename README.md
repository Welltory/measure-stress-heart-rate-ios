# Welltory Integration iOS Demo

<p>
  <img src="/screens/Frame.jpg?raw=true" alt="Welltory flow">
</p>

This demo app is intended for people who want to integrate with the Welltory app to collect stress, energy, and other HRV data about their users. Demo app shows how your app can work with the Welltory app. This integration is free, and it’s created to help you add value for your users who use Welltory. [Read more here](#install)

To become integration partner - [apply here](https://welltory.typeform.com/to/epJ3PR)


Welltory is an app that measures people’s HRV with just a smartphone camera to calculate their stress and energy levels. You can send out users to our app and get them back with measurement results. Welltory integration will allow you to collect data on the following parameters:

* Stress (Welltory's proprietary algorithm, trained on millions of measurements)
* Energy (Welltory's proprietary algorithm, trained on millions of measurements)
* Productivity index (Welltory's proprietary algorithm, trained on millions of measurements)
* RMSSD index
* SDNN index
* Total power

We made this demo to show you:
* how the user will be navigated to the App Store,
* the process of taking a measurement,
* a request for sharing,
* the return to the application,
* an example of the presentation of the results,
and also the source code of the integration.

Continue reading for installation.

### Table of Contents
1. [How to install](#install)
   1. [Requirements](#requirements)
   2. [Installation guide](#guide)
2. [Example usage](#usage)
3. [Integration](#integration)
4. [Measurement request](#request)
   1. [Measurement request link](#link)
   2. [Measurement request parameters](#request_parameters)
5. [Stress results overview](#result)
   1. [Configure your app to add it the list of approved domains](#configure_domain)
   2. [Configure your website to host the 'apple-app-site-association' file](#configure_aasa)
6. [Stress results processing](#result_processing)
7. [Demo Applications](#demo)
8. [Questions](#questions)
9. [License and author info](#license)

# How to install <a name="install"></a>

### Requirements: <a name="requirements"></a>


* XCode 10.0 or later
* Swift 4.2 or later

No additional tools required.

### Installation guide: <a name="guide"></a>


* Clone the repository master brunch using ``` git clone https://github.com/Welltory/measure-stress-heart-rate-ios.git ```
* Open *WelltoryDDSDemo.xcodeproj* file with the XCode 10.0+
* Run the project

# Example usage <a name="usage"></a>

1. In the DDS Demo application press "Measure now" button to start the measurement
<p>
  <img src="/screens/screen_1.jpg?raw=true" width="200" alt="Measure now">
</p>

2. Welltory will launch and automatically starts the measurement
<p>
    <img src="/screens/screen_2.jpg?raw=true" width="200" alt="Measurement process">
</p>

3. After the measurement is complete, the results window will appear
<p>
  <img src="/screens/screen_3.jpg?raw=true" width="200" alt="Measurement result">
</p>

4. After the user presses "ok, let's do it" button, measurement results and the user controll pull back to the DDS application
<p>
  <img src="/screens/screen_4.jpg?raw=true" width="200" alt="Presenting result">
</p>


# Integration <a name="integration"></a>

Welltory doesn’t provide any integration SDKs; all applications interaction are performed with universal links. [Universal links Apple](https://developer.apple.com/ios/universal-links/)

**You should start your integration filling out an [Integration Request Form](https://welltory.typeform.com/to/epJ3PR).**

Please send us a live chat message [on our website](https://welltory.com/) if you have any questions.


# Measurement request <a name="request"></a>

To start the measurement, you should launch a specific universal link.

### Measurement request link <a name="link"></a>


For the very first measurement from your application, you need to launch the link  **[FIRST_LAUNCH_LINK], which we will send you in our approval of integration email**.
It will take the user to the measurement screen in case Welltory is installed, or redirect them to the App Store to install it.\
`Retargeting limitations: If the user has the Welltory app installed within the last 90 days using the [FIRST_LAUNCH_LINK] link, the measurement will not start automatically.`



Every subsequent measurement request should be made using direct Welltory link: **https://welltory.com/action/dds/measurement**

### Measurement request parameters <a name="request_parameters"></a>


Every time your application requests a measurement, it should send out the following URL parameters:

* **source** - your application's name (from the [Integration Request Form](https://welltory.typeform.com/to/epJ3PR)). *It's used to verify your application and inform the user that measurement results will be shared with this application.*
* **callback** - your application callback URL (from the [Integration Request Form](https://welltory.typeform.com/to/epJ3PR)). *Is used to verify your application and send back measurement results.*

Examples:

First measurement request: [FIRST_LAUNCH_LINK]?source=YourApp&callback=https%3A%2F%2Fwww.yourapp.com%2Fdds%2F

Every subsequent measurement request: https://welltory.com/action/dds/measurement?source=YourApp&callback=https%3A%2F%2Fwww.yourapp.com%2Fdds%2F

```swift
guard let url = URL(string: String(format: "%@?source=%@&callback=%@",
                                           "[FIRST_LAUNCH_LINK]",
                                           "YourApp",
                                           "https%3A%2F%2Fwww.yourapp.com%2Fdds%2F")) else { return }
UIApplication.shared.open(url, options: [:])

```


# Stress results overview <a name="result"></a>

After the user data has been processed, the Welltory app it will use your **callback** URL to send measurement results to your application.
Welltory will append the following parameters to your callback URL:


| name | type | description |
| ------ | ------ | ------ |
| stress | Float&nbsp;(0.0&nbsp;-&nbsp;1.0) | user's stress % |
| energy | Float (0.0 - 1.0) | user's energy % |
| productivity | Float (0.0 - 1.0) | user's productivity % |
| rmssd | Float | user's rmssd index |
| sdnn | Float | user's sdnn index |
| power | Float | user's power index |
| token | String | Measurement share token. It allows to open the measurement's webpage https://app.welltory.com/share-measurement?token=<token> |
| productivity_c | String | Productivity score interpretation color |
| energy_c | String | Energy score interpretation color |
| stress_c | String | Stress score interpretation color |

Colors:
* green - Good
* yellow - Normal
* red - Bad
* unknown - Unknown

Callback example: https://yourapp.com/dds/?stress=0.32&energy=0.75&productivity=0.63&rmssd=90.3&sdnn=45.1&power=100&stress_c=green&productivity_c=red&energy_c=yellow

# Stress results processing <a name="result_processing"></a>

To receive measurement results, your app should support Universal links.

### Configure your app to add it the list of approved domains: <a name="configure_domain"></a>

1. Register your app at developer.apple.com
2. Enable ‘Associated Domains’ on your app identifier *(Go your Apple developer account -> Certificates, Identifiers & Profiles -> Identifiers. Select your application identifier and turn on 'Associated Domains')*
3. Enable ‘Associated Domain’ on in your Xcode project *(Open XCode project configuration, select a project target, Add a capability 'Associated Domains', Press '+' and add your domain ex: 'mydomain.com' )*

### Configure your website to host the 'apple-app-site-association' file <a name="configure_aasa"></a>

The AASA (short for apple-app-site-association) is a file that is located on your website and associates your website domain with your native app. The AASA file contains a JSON object with a list of apps and the URL paths on the domain that should be included or excluded as Universal Links. Here is a sample AASA file:

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "JHGFJHHYX.com.yourapp.bundle",
        "paths": [
          "*"
        ]
      }
    ]
  }
}
```

* **appID**: Built by combining your app’s Team ID (goto https://developer.apple.com/account/#/membership/ to get the teamID) and the Bundle Identifier. In the example above, JHGFJHHYX is the Team ID and com.yourapp.bundle is the Bundle ID.
* **paths**: Array of strings that specify which paths are included or excluded from association. You can use NOT (before the path — as in the example JSON above) to disable paths. In this case, all the links on this path will go to the web instead of opening the app. You can use * as a wildcard to enable all paths in a directory (apple doc says: Use * to specify your entire website) and ? to match a single character (/archives/201?/ example in the sample JSON). Please note that these strings are case sensitive and that query strings and fragment identifiers are ignored.

Once you are ready with your AASA file, you can now host it on your domain either at https://<<yourdomain>>/apple-app-site-association or at https://<<yourdomain>>/.well-known/apple-app-site-association.
Upload the apple-app-site-association file to your HTTPS web server. You can place the file at the root of your server or in /.well-known subdirectory.

`Important: iOS will only attempt to fetch the AASA file over a secure connection (HTTPS).`


After you have configured config universal links, you can catch callback URL with AppDelegate method:

```swift
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme,
            scheme.localizedCaseInsensitiveCompare("[YOUR_APP_DOMAIN]") == .orderedSame {
            var parameters: [String: String] = [:]
            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                parameters[$0.name] = $0.value
            }
            // Process callback parameters here ...
        }
        return true
    }
```

# Demo Applications <a name="demo"></a>
This repository contains a working Demo DDS application.


# Questions? <a name="questions"></a>
If you have questions about the partnership, send us a live chat message [on our website](https://welltory.com/).

# License and author info <a name="license"></a>

```
Welltory Integration iOS Demo

The MIT License (MIT)

Copyright (c) 2019 Welltory Integration iOS Demo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
