# GIANT MONSTER COMBAT
This monstrous program offers hours of fun. Think carefully before accepting its offer.

## Description
Monster Combat is a game in which you go wandering through a forest trying to win as much treasure as you can from various monsters without getting yourself killed in the process. It was written in Basic for a KIM microprocessor and for display on a high speed video board, but can easily be converted to almost any other Basic or video board. It requires at least 16K of RAM to be run, which is the main reason there are no spaces between commands on the program listing.

## Play
When you play the game you will be randomly placed in a forest ten by ten squares in size. Only one of these squares, the one you are in, is displayed, thus allowing you to see only a small part of the forest at a time. The sector you are in is again divided into ten by ten squares. Each of these, too, is divided up ten by ten; but these hundred smallest squares you see. Each of these little squares is shown by a single character. It covers an area of forest ten by ten yards, making the fuller square that is displayed a hundred by a hundred yards and the entire forest a thousand by a thousand yards. T's are trees, '-'s are paths, I's are walls, ↑'s are inns, and M's are enchanted castles. The '0' is you.

Also displayed with the portion of forest you are in is your combat strength, treasure total, and the various magic spells you have. Your combat strength is used to fight the various monsters you meet, each monster having a combat strength of his own; these range from five (for a goblin) to a hundred (for a basilisk). Your combat strength is also used in movement, the amount used depending upon how far you go, how much treasure you're lugging around, and the type of terrain you end up on after you move.

## Inns
At the inns you are allowed to regain the strength you began with and all the magic you had at the start. Don't worry when you find yourself displayed in the square below the inn when you stop there; that is the way the program is set up. Of course, the innkeeper takes some of your treasure for providing you with his services. However, sometimes he has information which he passes on to you at no additional cost -- like where the forest edge is, or where an enchanted castle might be found.

## Castles
There may be up to fifteen enchanted castles in the forest. These usually contain items of great value to treasure hunters, as you will see. (However, they tend to vanish if you make the wrong move, such as falling into a pit when you land on the castle square.)

## Gameplay
Most of the time you will not be visiting inns and castles. You will be hacking your way through thick underbrush or trotting along forest paths in search of treasure. And you will find it, usually guarded by some sort of monster. Upon encountering one or more of these creatures you are given a choice of fighting them, running away, bribing them, or casting a spell on them.

### Fight
To fight you must hit a '1'; then, when it asks you to, you enter however much of your combat strength you wish to use against the monster. If you choose to use strength equal to the monster's strength you then have a fifty-fifty chance of winning. The more strength you use the greater the odds are of winning, the less you use the smaller your odds of winning. Also affecting what you use to fight the monster is your treasure total. The more treasure you have the more strength you must use.

The first and third parts of the sample run give examples of fighting a monster or monsters. In the first case there are three cyclopses. Cyclopses have a combat strength of 20 which means that three of them have a total strength of 60. I used 121 of my combat strength to fight them, over twice the cyclopses' strength, which gave me over a 95% chance of winning. And, as can be seen in the example, I did beat him.

In the third part of the sample run I am fighting 19 goblins. Since goblins have a combat strength of 5, 19 have a combined strength of 95. I used only 60 combat points that time, giving me around a 30% chance of winning. And, as can be seen in the example, I did get myself killed.

### Run
If you do not wish to fight the monster you can always run. However, the higher the strength of the monster the less likely you will get away and the more likely that you will be forced to fight. Whether or not you do get away is based upon a random number and the strength of the monster. If you do get away you are randomly placed in an adjacent square and get to find out what is there. Once in a while, when you attempt to run, the monster catches you and kills you.

### Bribe
If you don't care to run or fight you can try to bribe the monster. Few people like to do this since it means handing over some of your hard-earned treasure. Whether your bribe is accepted or not depends upon how much treasure the monster is guarding, his strength, and a random number. The greater the value of the treasure the monster has, the more you'll have to pay him if you don't care to fight. Usually if the monster doesn't care for your bribe you have to fight him. Sometimes, though, he just kills you anyway.

### Spells
Finally, if you don't care for any of the previous choices, you may cast a spell. There are three types of spells: sleep, charms, and invisibility. Sleep spells tend to be the least effective and invisibility the most effective, with charms somewhere in the middle. Spells, no matter what kind they are, don't always work too well, sometimes not working at all, thus causing you to have to fight the monster.

## Other Things
In addition to the various monsters, there are other things you will occasionally run into; some are good and some bad, as you will see when you run the program. Everything is determined randomly and thus you can go back to a spot you were previously at and find something different there.

## Time Constraint
You have thirty days to hunt for treasure in the forest. Each little square you move through takes a tenth of a day to cross, meaning it takes an entire day to cross the entire displayed square. To move you enter the direction you wish to go (N meaning North, which is upwards, S meaning South, E meaning East, which is to the right, and W meaning West) Then you enter the distance, each little square being one. For example, in the first part of the sample run I enter S (south) for the direction and then 3 for the distance. This places me on top of the arrow, which is an inn, and thus I am shown in the square below the inn when the next map of the area is drawn. In moving from the inn I again go south, this time a distance of 7, which causes me to end up in the next large square.

## Leaving the Forest
When you leave the forest, intentionally or accidentally, you can obtain a listing of the number of monsters you've killed, bribed and run from, plus the amount of treasure you have won so far. If you decide not to return to the forest or your thirty days are up, you are offered several choices: you may go to a new forest with the same strength and magic (the treasure total going back to zero); you may go to a new forest with new strength and magic; or you can stop playing the game. If you should wish to use the strength and magic left over from the game you just played, you can obtain a listing of these at the very end of the game and then write them down or store them however you wish. Then, the next time you play the game, you just answer the initial question asking if you wish to use an old combat strength and magic with a 'Y' and then enter the various things you are asked for.

## Background
This game was very popular at my dorm at the University of Wisconsin in Madison. The record treasure total so far, as of this writing, is 7562, set by me. Most of the time the scores run between a thousand and two thousand, with many lower and a few higher. If you get above two thousand you're doing well.

## Possible Changes
A few of the major changes for use on other systems would be the random number generators which occur throughout the program and lines in which PRINTCHR$(3);CHR$(8)  occurs, this being the command for clearing the screen and homing the cursor on my system. Also, if you don't have graphics you will want to leave out lines 1400 to 1487 and take out the GOSUB1400 from line 1210. If you do have graphics you'll have to change the POKE statements in lines 1400 and 1487 to suit your machine. The starting address for the display on my system is BC00 (48128), so you will probably have to subtract 48128 from all the POKEs and add whatever your start address is.

## Cast of Characters
The following is a description of each monster, giving its combat strength and telling something about the tales and myths surrounding it.

Goblin (5) -- A mischievous little sprite only about a yard in height. Rather ugly, uses coarse and uncouth language, is generally evil and malicious; all in all, a rather unpleasant little fellow. Even though they're little they can be very vicious, and more than one warrior has been killed underestimating them.

Minotaur (10) -- From Greek mythology, a monster with the head of a bull and the body of a man. Minos, king of Crete, received a bull from Poseidon, god of the sea, which he refused to sacrifice to the god. Poseidon inspired an unnatural love for the bull in Pasiphae, Minos' wife, and the minotaur resulted from the union. Minos enclosed the creature in a labyrinth constructed in the city of Knossos, and fed it seven young men and women (whom Athens had to pay as tribute to Crete) every few years. The original minotaur was eventually slain by the Athenian hero Theseus.

Cyclops (20) -- Also from Greek mythology, a member of a race of one-eyed giants. According to Homer, the cyclopses were shepherds living on an island in the western area. The best known of these was Polyphemus who had his eye poked out by the hero, Odysseus. According to Hesiod, the cyclopses were three of the children of Uranus and Gaea. They forged the thunderbolt for Zeus, king of the gods, and became the assistants of Hephaestus, god of the forge.

Zombie (30) -- From legends in the West Indies, a corpse which has been reanimated. A rather unpleasant person to meet, he generally smells of rot and decay. He often has rotting pieces of himself falling off his body, yet never seems to fall apart completely. He is difficult to kill, since he is already dead. A person has to chop him into tiny pieces and then get away before the monster can pull himself back together.

Giant (40) -- Appears in the mythology of almost all nations, huge beings of terrible aspect. In the Greek myths the giants are said to live in volcanic regions where they were banished after an unsuccessful war against the gods. Some giants are peaceful, but others, like the ones in the forest, would think nothing of having you or anyone else for a snack.

Harpy (50) -- From Greek mythology, disgusting women with the wings and lower body of a bird, generally a bird of prey. They stole and befouled the food of blind Phineus as punishment from the gods. Phineus nearly died before Jason and the Argonauts arrived while sailing in search of the Golden Fleece. Two of the Argonauts, Zetes and Calais, drove the harpies away and were then told by one of the gods that the harpies would bother Phineus no more. The harpies continued their disgusting practices elsewhere.

Griffin (60) -- From Eastern mythology, a creature usually represented as having the head, beak, and wings of an eagle, and the body and legs of a lion. It builds its nest of gold, making it very tempting to hunters and forcing the griffin to keep vigilant guard. It instinctively knows where buried treasure is hidden and does its best to keep any plunderers at a distance.

Chimera (70) -- From Greek mythology, a monster with the foreparts of a lion, the rearparts of a goat with a goat's head in the middle of its back, and with a serpent for a tail. The original chimera was slain by Bellerophon, who was riding on Pegasus, the winged horse. Ironically, Pegasus was a distant relative of the chimera.

Dragon (80) -- Found in many of the world's mythologies, a reptilic monster resembling a giant lizard and usually represented as having wings, huge claws, and a fiery breath. In some places the dragon is considered to be a peaceful creature, notably in Japan and China, where it is regarded as a symbol of good fortune. However, the dragons in the forest are of the other sort; they will kill and eat you if you let them, and they take very unkindly to anyone trying to steal their treasure.

Wyvern (90) -- A distant relative of the dragon, this is a fabulous two-legged creature, with wings and the head of a dragon on a basilisk's body. Although he cannot kill you with one glance like the basilisk, he is still a very unpleasant creature to meet.

Basilisk (100) -- The worst of all eleven monsters, his deadly glare kills anyone who gazes upon his face. From Greek mythology, the basilisk was called the king of serpents, being endowed with a scaly crest upon his head like a crown. This monster was supposedly produced from the egg of a cock hatched under toads or serpents. The weasel, the only animal which can withstand the basilisk's glare, often fought it to the death. Humans must use a mirror if they wish to be assured of victory over a basilisk, for the mirror will reflect the creature's gaze back upon it and kill it. This monster is not to be confused with the basilisk of South America, a harmless lizard with the ability to run across water.