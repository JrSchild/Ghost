# Ghost
A two player word-game app where each player must pick a letter trying not to complete a word.

### Rules
The person who creates a word first, loses. Each player chooses a letter on its turn. A word must be over three letters. Whenever you complete a word you gain a letter, when it spells the word 'Ghost', you loose.

### Features
- Usernames
- Highscores
- Dutch or English
- Easy, Medium or Hard levels

### Sketches
#### Screen 1: Language
(On first start) Choose your preferred language, you can always change this at any time. When a choise is made, go to screen 2.
1) Button: Choose Dutch
2) Button: Choose English
![screen 1](/doc/screen-1.jpg)

#### Screen 2: Introduction
(On first start) An introduction is shown with how to play the game. It has a slideshow with the goal and rules of the game. This view can be brought back between any game.
1) Slideshow with explanation
2) Indicator of how many slides there are
3) Button: Continue to main screen (-> screen 3)
![screen 2](/doc/screen-2.jpg)

#### Screen 3: Main view
On the top are three buttons: language, introduction and highscores.
1) Button: See the highscore list (-> screen 6)
2) Button: Choose language (-> screen 1)
3) Button: Tutorial (-> screen 2)
4) Input: Enter your name or pick one from a list of used names
5) Button: Choose the difficulty of your choice to start a game.
![screen 3](/doc/screen-3.jpg)

#### Screen 4: Game on
Game starts, computer or first player chooses a letter. 
1) Players current status of game. How many letters he has.
2) Current score
3) Button: Stop the game (-> screen 3)
4) Letters in current word
5) Keyboard is always visible.
![screen 4](/doc/screen-4.jpg)

#### Screen 5: Game over
Game finishes and shows a final screen with players score.
1) Final score
2) Button: Exit final screen (-> screen 3)
![screen 5](/doc/screen-5.jpg)

#### Screen 6: Highscores
Show a list of highscores.
1) Button: Exit highscores (-> screen 3)
2) Button: Choose difficulty in highscores
3) Rank of player
4) Name of player
5) Score of player
![screen 6](/doc/screen-6.jpg)

### Frameworks, libraries and others
- Swift
- Cocoa touch
- Vibrations
- Reading images
- Playing sounds