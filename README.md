Name: Niki Durzynski

## Implementation

Snack Circle validates name, email, and password fields and shows a green success message for valid input. The tip feature uses the fixed category `password_help` to cycle through three stored tips under 240 characters each. It includes loading, a simulated error, and Retry.

Tips are labeled "Preset demo tip—not live AI." No server, credentials, or live AI service is used. The tip feature does not access form values or approve signup.

## Reflection 1

Tapping "Get a signup tip" sets the loading state and displays a progress bar. After 600 milliseconds, the app shows a preset tip or a simulated error. Tapping Retry recovers from the simulated error.

## Reflection 3

The fixed category `password_help` selects the preset tips. The feature ignores names, emails, and passwords because general advice does not need personal information. This also keeps tips separate from signup validation.