# Menu-scaffold

This is a very lightweight sliding nav system, which is made up of a couple different elements, which will be displayed below in a delightfully visual way:

scaffold
-nav

--nav-contents

-content

As coded, the menu just slides in from the left when needed, and slides away when not needed.

# UPDATE
7/13/2015: Added the beginnings of a class called "SizeMatters," which calculates the size of a DIV prior to insertion on the screen. It'll eventually get blown out into its own repo, but is sort of working right now.

# TODO
Add a top-menu.
SizeMatters: Need to add support for margin and padding.
SizeMatters: Need to make willItFit functionality; this lets you determine if a provided string of text will actually fit in the area.
SizeMatters: Need to make howMuchWillFit functionality; this will give you a substring of text you provide, which will fit in a provided area. (Sort of an intelligent excerpt)
