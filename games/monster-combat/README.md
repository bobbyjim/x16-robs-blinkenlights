# MONSTER COMBAT
By Lee Chapel, from Byte Dec. 1980 p288

## Description
In the game Monster Combat, you attempt to win treasure from various 
loathsome creatures and leave the forest with as much treasure as 
possible - without getting killed in the process. This program was 
written in BASIC on a KIM microprocessor and uses less than 4 K bytes 
of memory. It is easy to change to almost any other form of BASIC.

In the game, you are placed at a randomly chosen location in a forest 
with a certain combat strength that is randomly determined. Also, you 
encounter monsters guarding various tempting treasures and are given 
a choice of fighting them, running from them, or bribing them; greed
and wit are certainly tested here.

## Fight
To fight the monster, enter a 1. When the program asks you for the 
number of combat points you wish to use, enter any number smaller than
your combat strength (ie: the amount you think it will take to defeat the monster).
Each monster has its own combat strength. If you enter a number of combat
points equal to the monster's strength, you have a fifty-fifty chance of 
defeating it. Entering a higher number increases your chances of winning, 
while entering a smaller number lowers your chance of winning. No matter how
much strength you use, there is always at least a one-in-a-thousand chance 
that the monster will kill you- not bad odds, unless you have cold feet. Also,
the more treasure you have, the more strength you need to use to achieve the 
same odds against the monster in combat.

## Run
If you choose to run (option 2), your chances of getting away from a monster 
successively decrease as each new monster's strength possibly increases. Thus 
you are more likely to get away from a minotaur than from a basilisk. If you 
succeed in running away, you are placed in a new randomly selected square;
not getting away usually results in a battle. Occasionally, while you are 
running, the monster will catch and kill you - one of the risks you must accept. 

## Bribe
Of course trying to bribe (option 3) your foe is an ageold alternative to 
running or fighting. For this, you must use your hard-earned treasure. Whether
or not you win depends on the value of the treasure he is guarding. The greater
the treasure, the more you have to pay to successfully bribe the monster. If 
he doesn't care for your bribe, you usually have to fight him.

## Other Things
There are other things in the forest besides monsters, but these are best left
for the player to discover. One thing that I will mention is the mirror you may
find. This kills basilisks, the most fearsome of all the creatures you will 
meet. A basilisk can kill people by looking them in the face, but when it looks
into a mirror it frightens itself to death.

## Movement
Movement through the forest is easy: just enter the direction you want to go - 
for north, E for east, NE for northeast, and so on. North is the top of the map
and east is the right. The Xs mark out the forest in the display, the Is are 
walls through which you cannot pass, and the 0 is you. To leave the forest, 
just move onto any blank area around the edge of forest.

## Scores and Thoughts
Scores for this game generally range from 500 to 700. If you get over 1000, you
are doing very well. Experience has shown me that this game becomes more 
exciting as the map gets larger. If you have more than 4 K bytes of memory in 
your system, you can increase the map size by changing the proper lines in the 
program (mainly lines 10, 15, 705, and 900). You can also add more monsters and
treasure or add other options to the game.

Load up, enter the forest, and hunt!
