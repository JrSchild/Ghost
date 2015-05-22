# Native Appstudio: Project Report
Name: Joram Ruitenschild  
Student number: 11005289

## Introduction
This report describes a slightly high level overview of the app Ghost. It describes the classes, their relations and it clarifies why certain design decisions have been made. The project was entirely written in Swift 1.1 and makes use of storyboards to navigate through the application. There are two storyboard segues, each with a unique identifier, to determine which segues are performed when navigating away from a view.

## Class overview: Views
Only three views with ViewControllers have been created. This simplifies the amount of steps the user is required to go through. A ViewController can be destroyed and re-created at any given time. The class only stores data that is related to this specific view.

### MainViewController
This controller is instantiated on the initial application load. From this view the user is able to perform most other actions like starting a game, going to highscores, chaning language, entering usernames, etc. The view will live through the entire lifetime of the application.

Features:
- Enter username for player 1 and player 2 in a Text Field.
- Optionally pick an existing username through a Picker View and fill it in the input fields.
- Change language through a Picker View.
- Start game
- Go to highscores
- Loads current game from NSUserDefaults if it was saved. If so, programmatically perform segue to start the GameViewController and pass the current game to the controller.

Notable properties
- UserModel and LanguageModel are instantiated on init.

### GameViewController
This view is destroyed when the game is finished and the MainViewController is shown.

Features:
- Menu, a UIActionSheet with the options: exit game, restart game and change language. The latter two will cause the game to restart.
- Each player can take turns and guess a letter.
- A keyboard is always visible; the GO button is disabled when no letter has been entered. This is done by focusing a hidden Text Field. 
- The current word is shown in the middle of the screen, the letter entered by the user is colored red.
- Show the score of each user by substringing the word GHOST with the score of the user.
- When the game is over a winner is shown in an Alert View and the GameViewController is destroyed.

Notable properties
- DictionaryModel instantiates when view loads.
- MainViewController, reference to communicate with.
- CurrentGame is passed through from MainViewController if a game was saved.
- GameModel gets created when view loads, either from currentGame if set or with new data.

### HighscoreViewController
Shows the usernames with their score in a table. This view is destroyed when the user navigates back and the MainViewController is shown.

Features: 
- Show list of users with their highscore.
- Clear users, clear scores with a UIActionSheet.
- Go back to MainViewController.

Notable properties
- UserModel passed through from MainViewController

## Class Overview: Models
Models store data that need to be shared across the application. Some of them can be persisted by implementing storage methods. More on that in the next chapter.

### DictionaryModel
Stores an entire dictionary for a language.
- It can filter the dictionary with a given word.
- Provide the length of the filtered dictionary.
- Reset the filtered dictionary.
- Check if a given word is in the filtered list of words.

### GameModel
Holds the logic for an entire game.
- Keep score and names of both players
- Save and restore game state.
- Instantiates GameRoundModel for each new round.

### GameRoundModel
Instance of a single round in a game.
- Guess letters
- Remember who’s turn it is and the current word.
- Check if a round is over.

### UserModel
Has methods for storing user related data like usernames and scores. The data is stored in a dictionary, [String:Int], with the username as key and the score as value.  
- Add new users.
- Sort usernames based on score.
- Clear score and usernames.

### LanguageModel
Stores current language and has methods for choosing new language.

## Storage
Structs with static methods and properties have been used to create storage methods. These structs are easily replaceable by another type of key-value store. This keeps the models independent of implementation and platform. Currently I have chosen to use NSUserDefaults because it is easy to get up and running and is the recommended way of storing data.

### Storage
A basic key-value store that allows saving, loading and removing any type of data.

### GameStorage
Can accept a GameModel object and save its state. Vice versa it can load data and restore it into an instance of a GameModel.

### DictionaryStorage
Reads a flat file dictionary and return a string.

## Decisions and methods
In this chapter I will clarify why I made certain decisions, where I moved away from the original requirements and what things require extra attention.

### Input validation and feedback
When a game starts, a keyboard will be visible. The current word is shown in the middle of the screen, the entered letter is colored red with NSMutableAttributedString. A regular expression validates the input. Any character that is not alphanumeric, hyphen or dash will be discarded. Uppercase characters will automatically be converted to lowercase.

### Restoring game state
When the application loads, the MainViewController gets initialized. This will check if a game was saved and if so, it performs the segue for the GameViewController. It passes the game data to that controller. The GameViewController checks if game-data was passed through and if so, restores the previous game.

### Choosing a usernames and language
Usernames can be entered in the main view with two text field boxes. Next to these boxes is a button that opens a picker view to choose a username. Choosing a language also opens a picker view like this. The delegate methods for these views have been implemented outside the MainViewController as class extensions.