<p align="center" width="100%">
  <img src="https://github.com/KristerMoen/oddvar/assets/59565176/e6f470a3-f56f-41cd-817d-0ec7f33e9314" alt="oddvar logo" />
</p>

## Table of Contents  
- [**Getting started**](#getting-started)
- [**Project**](#project)
  - [Code](#code)
  - [Tasks](#tasks)
  - [Design](#design)
  - [API and Enviroment](#api-and-enviroment)
    - [Testing Mock APIs](#testing-mock-apis)
  - [Testing](#testing)
    - [Note: UI Testing](#ui-testing)
  - [Dependencies](#dependencies)
    - [Firstparty](#firstparty)
    - [Thirdparty](#thirdparty)
  - [If there’s anything you feel particularly proud of](#if-there-is-anything-you-feel-particularly-proud-of)
  - [If there’s anything you believe could have been done better](#if-there-is-anything-you-believe-could-have-been-done-better)
  - [What else you could have done with more time](#what-else-you-could-have-done-with-more-time)
##

# oddvar
A simple little app displaying ads in a beautiful way. 

## Getting started
To get started in this app, simply clone the repository and open the project in Xcode or your preferred IDE. When opened the project should be easy to use and ready to go out of the box. If you stumble on problems regarding Swift Package Manager (SPM), try the following command: `File` -> `Packages` -> `Reset Package Caches`

The app uses the `OddvarApi` to do requests, it's essential that the package are downloaded. If it's missing it could be found [HERE](https://gitfront.io/r/user-1550696/eYNWXTZASJVY/oddvarApi/)

## Project
Develop an adaptable app that can handle changing JSON ads, potentially receiving more than currently available. Allow users to favorite ads, enabling offline access.
Include a toggle to switch between displaying favorite ads and all ads.

### Code
The app uses a MVC-type arcitechture, with SwiftUI for UI and controller for logic. All the apps functionality is packet into a dynamic framework `oddvarFramework`, for easier implementing Unit- and UI-tests.
The arcitehture makes it really easy to implement new UI functionality, since the enviroment `DependencyEnviroment` uses an APIClient `OddvarAPi` for manageing API-requests. 
The enviroment is being passed to any view and is initalized like this:

```swift
public struct PickerContainerView: View {
    @StateObject var pickerContainerViewModel: PickerContainerViewModel
    public init(enviroment: DependencyEnviroment) {
        _pickerContainerViewModel = StateObject(wrappedValue: PickerContainerViewModel(enviroment: enviroment))
    }
    ....
```

and in a controller:

```swift
public class PickerContainerViewModel: ObservableObject {
    ...
    var enviroment: DependencyEnviroment
    init(enviroment: DependencyEnviroment) {
        self.enviroment = enviroment
    }
    ....
```

### Tasks
As mentioned in [Finn's Technical Challenge](https://github.com/KristerMoen/oddvar/files/12585586/apps-technical-challenge.pdf):
For each ad we want to see at least the following information:
- Photo
- Price
- Location
- Title

Your project should be available in GitHub, just send us the
URL. Please keep in mind that this assignment is not a test
in setting up the most over-engineered project using all the
latest libraries and frameworks. This is a small, simple
app. Use third-party libraries where it makes sense, but
there’s no need to go full enterprise.

A few things that we will evaluate are:
- Attention to detail in the UI
- Scrolling performance
- API design
- Project structure and architecture in terms of scalability
- Separation of concerns
- Understandable class and variable naming
- Cleanness (absence of commented code, non-used
functions, consistent formatting, code duplication,
resources duplication etc)
- Proper use of comments (comments should say why,
not what)

Finally, include in the README file:
- A description of your solution
- If there’s anything you feel particularly proud of
- If there’s anything you believe could have been done
better
- What else you could have done with more time


### Design
If i had more time i would spend it on sketching in Figma and customizing the app for senior citizens for more user-friendly application.
<p align="center" width="100%">
    <img src="https://github.com/KristerMoen/oddvar/assets/59565176/c641be73-7732-42d3-88d9-a6e6c1e3871a" width="200" alt="picture of odddvar app" />
    <img src="https://github.com/KristerMoen/oddvar/assets/59565176/7a38ec94-9d2e-41b8-987d-e7f3c9237b6c" width="200" alt="picture of odddvar app" />
    <img src="https://github.com/KristerMoen/oddvar/assets/59565176/fba706b5-4de6-4214-b4ea-b7d8d76b8c0e" width="200" alt="picture of odddvar app" />
</p>

### API and Enviroment
In the project there is implemeted an `OddvarAPI` managing requests done to the "API" that consists of an JSON on Github gist. 

```
"https://gist.githubusercontent.com/baldermork/6a1bcc8f429dcdb8f9196e917e5138bd/raw/discover.json"
```

`OddvarAPI` is a dynamic swift package containing and handling of requests using a clever little `Protocol Resource`. Which is used to generate crisp and clean requests. 

```swift
protocol Resource {
    var parameters: Parameter { get }
    associatedtype Parameter
    associatedtype Response
    
    var path: [String] { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
}

...

/// Example request
struct GetSomeCoolItems: Resource {
    typealias Parameter = User
    typealias Response = ItemGroup
    
    public struct User: Encodable {
        let id: UUID
        let name: String
    }
    
    var path: [String]
    
    var parameters: User
    var method = HTTPMethod.GET
    
    init(id: UUID, name: String) {
        self.path = []
        self.parameters = User(id: id, name: name)
    }
}

/// Example calling the api-request
static func live(baseURL: URL) -> OddvarApiClient {
    return OddvarApiClient(
        getOddvarItems: {
            let getOddvarRequest = GetOddvarItems(id: UUID(), name: "Oddvar")
            return try await getOddvarRequest.request(withBaseURL: baseURL)
        }
    )
}

```

The package has as mentioned the power to mock the whole api and this is how you would initialize it in the app:
```swift
PickerContainerView(enviroment: .init(apiClient: .live(baseURL: Constants.baseURL), oddvarState: OddvarState()))
PickerContainerView(enviroment: .init(apiClient: .demo, oddvarState: OddvarState()))
PickerContainerView(enviroment: .init(apiClient: .demoWithError, oddvarState: OddvarState()))  
```

And in `Preview`:
```swift
struct PickerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerContainerView(enviroment: .init(apiClient: .demoWithError, oddvarState: OddvarState()))
    }
}
```

These are the mocked api's in `OddvarClient`
```swift
static var demo = Self.init(
    getOddvarItems: {
        .mock
    }
)
static var demoWithManyFavorites = Self.init(
    getOddvarItems: {
        .mockManyFavorites
    }
)
static var demoSlowLoading = Self.init(
    getOddvarItems: {
        try await Task.sleep(seconds: 5)
        return .mock
    }
)
static var demoWithError = Self.init(
    getOddvarItems: {
        try await Task.sleep(seconds: 2)
        throw APIClientError.serverError
    }
)
```
#### Testing Mock APIs
When testing some of the mock APIs - the stored values may not reload, so i've added a "Tøm lagrede elementer"-button to erase the stored elements.
This is something that would only be a part of a staging or beta target/version of the app. But are added here for conviniently testing `OddvarAPI`.

### Testing
The app has a Test Plan - `OddvarTestPlan`. Containing some tests for API, logic and UI

#### UI Testing
When the UI tests runs the first time it caches screenshots to simulators disk, and needs to be runned one more time. 
This is because ther isn't any screenshots to check with on initial test run.
If the tests still failes, set `let record = true` to record new screenshots. REMEMBER to set `let record = false` when you run the tests again.

```swift
final class oddvarUITests: XCTestCase {
    let record = true //<- set true to record new screen shot
    // RUN TESTS
    ....
    let record = false //<- set to false after run
```

### Dependencies
In the project we use different dependencies. Some of them are thirdparty dependencies, while others are projects i've created myself. 

#### Firstparty:
- `OddvarApi` containing and handling of requests using a clever little `Protocol Resource`.

#### Thirdparty:
- `SnapshotTesting` Delightful Swift snapshot testing. - https://github.com/pointfreeco/swift-snapshot-testing
- `CachedAsyncImage` Little Swift package for caching `AsyncImage` - https://github.com/lorenzofiamingo/swiftui-cached-async-image

##### If there is anything you feel particularly proud of
Learning and implementing a new kind of arcitechture. Really cool to get the UITests working and also i'm proud of the API package with switchable requests.

##### If there is anything you believe could have been done better
The UI should have been i bit more sleek and crisp, but the app is meant for senior citizents - so maybe it's not that bad?

##### What else you could have done with more time
It's never enough tests and of course a `DetailView`should have been implmented.
