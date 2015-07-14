# Menu-scaffold

This is a very lightweight sliding nav system, which is made up of a couple different elements, which will be displayed below in a delightfully visual way:

scaffold
-nav

--nav-contents

-content

As coded, the menu just slides in from the left when needed, and slides away when not needed.

# UPDATE
7/13/2015: Added the beginnings of a class called "SizeMatters," which calculates the size of a DIV prior to insertion on the screen. It'll eventually get blown out into its own repo, but is sort of working right now.

7/15/2015: SizeMatters mostly works, calculating with two methods:
SizeMatters.howMuchWillFit - this returns a substring of a chunk of text which fits in a specified DOM element.
SizeMatters.howBigWillThisBe - this returns the size of a specified chunk of text, in a specified class.

# TODO
Add drop-downs for top-level top menu
