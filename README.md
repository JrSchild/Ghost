# Ghost
A two player word-game app where each player must pick a letter trying not to complete a word.

### Rules
The person who creates a word first, loses. Each player chooses a letter on its turn. A word must be over three letters. Whenever you complete a word you gain a letter, when it spells the word 'Ghost', you loose.

### Features
- Usernames
- Highscores
- Dutch or English
- Two player game

### Sketches
#### Screen 1 (LanguageViewController): Language
(On first start) Choose your preferred language, you can always change this at any time. When a choise is made, go to screen 2.

#### Screen 2 (IntroductionViewController): Introduction (optional for later)
(On first start) An introduction is shown with how to play the game. It has a slideshow with the goal and rules of the game. This view can be brought back between any game.

#### Screen 3 (MainViewController): Main view
Start a game from here. On the top are three buttons: language, introduction and highscores.

#### Screen 4 (GameViewController): Game on
Game starts, first player chooses a letter.

#### Screen 5 (GameOverViewController): Game over
Game finishes and shows a final screen with who won.

#### Screen 6 (HighscoreViewController): Highscores
Show a list of highscores.

![Sketches](/doc/screens.jpg)

### Class design
#### View classes
```
@class RootViewController - Instantiates Lanuage- and IntroductionViewController on first startup or starts MainViewController. Listens to when IntroductionViewController is finished and then starts the MainView.
@class LanguageViewController - Set the preferred language of the dictionary.
@class IntroductionViewController - Introduction and explanation of the game.
@class MainViewController - Main view where a game can be started, highscores opened, preferences changed and introductions introduced.
@class GameViewController - The actual game view.
@class GameOverViewController - Screen after game is finished.
@class HighscoreViewController - Renders the highscores.
```

#### Model classes
```
@class DictionaryModel - Storing dictionary in memory and look up words.
@property dictionary: [String]!
@property filtered: [String]!
@method @public init(words: String)
@method @public filter(word: String) -> void - Filters the complete list with a given word.
@method @public count() -> Int - Returns the length of the words remaining in the filtered list.
@method @public result() -> String? - Returns the single remaining word in the list. If count != 1, return nil.
@method @public reset() -> void - Reset filtered list to original dictionary.
@method @public @isWord() -> Bool - Checks if the current word is in the filterd list of words.

@class GameModel - Holds all data for a specific game.
@property dictionary: Dictionary
@property user1: String
@property user2: String
@property score: Int
@property currentUser: Bool
@property currentWord: String!
@method @public guess(letter: String) -> void - add a letter to the current word.
@method @public turn() -> Bool - returns the new player
@method @public ended() -> Bool - Check if current word is more than three letters and inside the dictionary.
@method @public winner() -> Bool? - Returns boolean indicating who won, nil if no user won.

@class UserModel - Store and retrieve a list of usernames.
@property data -> [String]
@method @public addUser(username: String) -> void
@method @public getUsers() -> [String]

@class HighscoreModel - Keep track of highscore entries.
@property data -> [?]
@method @public addUser(user: String, score: Int)
@method @public getHighscore() -> [?]

@class LanguageModel - Store the chosen language in NSUserDefaults
@property currentLanguage: String!
@method @public setLanguage(String: language)
@method @public getLanguage() -> String
```

### Frameworks, libraries and others
- Swift - Programming language used.
- UIKit Framework - Provides infrastructure (window and view) needed to create and manage the app.
- Foundation Framework - Provides basic classes such as wrapper classes and data structures.
- AudioToolbox - Phone vibrations and playing sounds.
- Reading images
- File reader/writer

### Links
- http://stackoverflow.com/questions/24021950/how-do-i-put-different-types-in-a-dictionary-in-the-swift-language
- http://www.raywenderlich.com/85578/first-core-data-app-using-swift
- https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID309
- http://www.raywenderlich.com/81879/storyboards-tutorial-swift-part-1
- http://www.raywenderlich.com/81880/storyboards-tutorial-swift-part-2
- http://stackoverflow.com/questions/24836369/programmatically-create-and-show-uipickerview
- http://stackoverflow.com/a/26819547
- http://stackoverflow.com/a/24098149