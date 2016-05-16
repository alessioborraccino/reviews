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

I actually implemented a version where refreshing was happening, but it was implied that the api call always synchronized with the reviews, and that was going to exclude the newly entered submitted review from the app (because the api was mocked), unless by complicating the code quite a bit, and i preferred in the end to keep it simple.

- Old reviews will never be deleted (Reviews will be saved forever in the database)
- When reviews are filtered for language, the loading new might not add any review on the list just because the new downloaded ones are all in foreign language, causing not a great user experience
- Not extensive tests 
- Not extensive Code documentation

## What to add

Besides taking care of the limitations described above, it could be useful:

- Adding more tours and cities
- Adding more filters (rating filter would be useful)
- Better UI

## Mock API for submitting reviews

In the app the API call for submitting reviews was not available so i had to mock it. I already wrote it down in the ReviewAPI class but i explicit it here as well:

Request could be for example:

https://www.getyourguide.com/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/addreview.json?author=alessio&title=super&message=super&rating=5&type=solo&date_of_review=date

Response could be for example:
 `{
  "review_id" : 456
}`

So that review IDs are always managed by the backend, and are consistant through all the app.
