# Reviews
Sample App Using MVVM and Reactive Cocoa

## Environment 

- Xcode: 7.3.1
- iOS Target: 9.0
- Language: Swift
- Cocoapods: 1.0.0

## Installation Instructions

To install Cocoapods (in case they are not present) run the following:

- `sudo gem install cocoapods`

To build the project:

- Run `pod install` in the project directory
- Open workspace reviews.xcworkspace
- Run in simulator

## Assumptions

The app assumes that it will always be checking reviews of one tour, so there are no mentions of tours or cities in the app, just for simplicity sake

## Technical choices

I used in the app Reactive Cocoa and reactive programming comes with a learning curve so I hope you have used it before, I have been using it for the last 2 years and i got used to it. But If needed, i can switch back to delegates and closures/blocks in no time though :)

The app tries to follow typical MVVM pattern with Dependency Injection, in order to increase testability and encapsulation. 
I preferred to go with MVVM and Reactive cocoa to show that i am interesting in new trends of programming, and i am always trying to learn new things.
As for caching choices, I went with Realm because it is extremely easy to use, and could work nicely in this simple case.

## Limitations

Due to time restrictions, I did not fully implement some of the features, causing the following limitations to the app:

- While submitting a review, it is not (yet) possible to send rating. 
- Reviews will never get refreshed (so if some review get modified, once you downloaded you will never see it)
- Old reviews will never be deleted (Reviews will be saved forever in the database)
- When reviews are filtered for language, the loading new might not add any review on the list just because the new downloaded ones are all in foreign language, causing not a great user experience
- Not extensive tests 

## What to add

Besides taking care of the limitations described above, it could be useful:

- Adding more tours and cities
- Adding more filters (rating filter would be useful)
- Better UI
