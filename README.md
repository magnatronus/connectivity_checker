# connectivity_checker

This project is a test/demo of 2 things:

- a way of checking for a valid internet connection
- the use of Riverpod for state management

## Running demo

The demo has a faux API call to generate the QRCODE which has a test delay of 2 seconds.

### Step 1

- To test the example code simple run the app in a simulator with the internet connected, then click the **SHOW QRCODE** button.
- The QRCode page should show (with green background) a QRCODE and a number underneath
- Go back to the main screen and try the QRCode screen again, a few times.
- Each time this is done a different Code should show (make a note of the last number you see)

### Step 2

- Now go back to the main screen then turn off Your WiFi connection(  or unplug you cat 5)
- Click the **SHOW QRCODE** button
- This time the page should be red and the code displayed should be the same as the last one with a retry underneath.
- Each time retry is pressed the page should be the same (stay on the QRCODE page)

### Step 3

- Now Turn on your WiFi(or plug cat 5 back in) and wait for the connection to re-establish
- If you now click the **retry** button it should generate a new QRCODE and the screen will go green.
- If it does not do this straight away try again, the connection may not have finished completed on the computer.

## Architecture and code structure

### Providers

Following the naming convention used in the Riverpod examples, ALL providers are called as such, i.e.:

- sharedPreferencesProvider
- connectivityProvider
- qrcodeProvider

### sharePreferencesProvider

This is a simple example of a FutureProvider that wraps the SharedPreferences plugin. The idea here is that once it has be created the plugin functionality can be used by any other code without te need to re-create it. See <https://riverpod.dev/docs/providers/future_provider> for more info.

### connectivityProvider

This contains the code for testing and reporting the current status of the internet connection. As with the **sharedPreferencesProvider** once this is created it can be used and **watch**ed in other parts of the code.

Just issue a ```ref.read(connnectivityProvider.notifier).checkConnection``` to check and update the connection status before anything that relies on an internet connection.

### qrcodeProvider

This is slightly different as it watches the **connectivityProvider** and will be re-created when the state of that changes. It also uses the **sharedPreferencesProvider** to allow it to maintain a cache of the last 'faux' generated QRCODE.
