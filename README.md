Welltory DDS
====================

Welltory partnership program calculates stress by measuring user’s HRV and allows to share the results in your app.

# Integration #

Welltory doesn't provide any integration SDKs, all applications interaction are performed with universal links. [Universal links Apple](https://developer.apple.com/ios/universal-links/)

**You should start your integration filling out an [Integration Request Form](https://welltory.typeform.com/to/epJ3PR).**

Please contact our support team if you have any questions [Welltory Help Center](https://support.welltory.com/content).


# Measurement request #

To start a measurement you should launch a specific universal link.

Measurement request link
---------

For the very first measurement from your application, launch this link: **https://welltory.onelink.me/2180424117/bf497b9**.
It will take the user to the measurement screen in case Welltory is installed, or redirect them to App Store to install it.

Every following measurement request should be done using direct Welltory link: **https://welltory.com/action/dds/measurement**

Measurement request parameters
---------

Every time your application requests a measurement, it should send out the following url parameters:

* **source** - your application name (from the [Integration Request Form](https://welltory.typeform.com/to/epJ3PR)). *Is used to verify your application and inform the user that measurement results will be shared with this application.*
* **callback** - your application callback url (from the [Integration Request Form](https://welltory.typeform.com/to/epJ3PR)). *Is used to verify your application and send back measurement results.*

Examples:

First measurement request: https://welltory.onelink.me/2180424117/bf497b9?source=DemoApp&callback=https%3A%2F%2Fwww.demoapp.com%2Fdds%2F
Every following measurement request: https://welltory.com/action/dds/measurement?source=DemoApp&callback=https%3A%2F%2Fwww.demoapp.com%2Fdds%2F

```swift
guard let url = URL(string: String(format: "%@?source=%@&callback=%@",
                                           "https://welltory.onelink.me/2180424117/bf497b9",
                                           "DemoApp",
                                           "https%3A%2F%2Fwww.demoapp.com%2Fdds%2F")) else { return }
UIApplication.shared.open(url, options: [:])

```


# Stress results overview #

After the user data has been processed, Welltory application it will use your **callback** url to send measurement results to your application.
Welltory will append the following parameters to your callback url:


| name | type | description |
| ------ | ------ | ------ |
| stress | Float (0.0 - 1.0) | user's stress % |
| energy | Float (0.0 - 1.0) | user's energy % |
| productivity | Float (0.0 - 1.0) | user's productivity % |
| rmssd | Float | user's rmssd index |
| sdnn | Float | user's sdnn index |
| power | Float | user's power index |
| token | String | Measurement share token. It allows to open a measurement webpage https://app.welltory.com/share-measurement?token=<token> |
| productivity_c | String | Productivity parameter interpretation color |
| energy_c | String | Energy parameter interpretation color |
| stress_c | String | Stress parameter interpretation color |

Colours:
* green = GreatGood
* yellow = Normal
* red = Bad
* unknown = Unknown

Callback example: https://demoapp.com/dds/?stress=0.32&energy=0.75&productivity=0.63&rmssd=90.3&sdnn=45.1&power=100&stress_c=green&productivity_c=red&energy_c=yellow

# Stress results processing #

To receive measurement results, your app should support Universal links.

Configure your app to add it the list of approved domains:
------------
1. Register your app at developer.apple.com
2. Enable ‘Associated Domains’ on your app identifier *(Go your Apple developer account -> Certificates, Identifiers & Profiles -> Identifiers. Select your application identifier and turn on 'Associated Domains')*
3. Enable ‘Associated Domain’ on in your Xcode project *(Open XCode project configuration, select a project target, Add a capability 'Associated Domains', Press '+' and add your domain ex: 'mydomain.com' )*

Configure your website to host the ‘apple-app-site-association’ file
------------
The AASA (short for apple-app-site-association) is a file that lives on your website and associates your website domain with your native app.
The AASA file contains a JSON object with a list of apps and the URL paths on the domain that should be included or excluded as Universal Links. Here is a sample AASA file:

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": “JHGFJHHYX.com.yourapp.bundle",
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


After you have configured config universal links, you can catch callback url with AppDelegate method:

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

# Demo Applications #
This repository contains a working Demo DDS application.


# Questions? #
If you have questions about the partnership, please visit our help center [Welltory Help Center](https://support.welltory.com/content).
