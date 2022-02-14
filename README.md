# esx_hidecar
GTA5 - Hide your stolen cars and then tranfer the titles to you

Needs:
esx
some sort of car dealer or garage that uses owned_vehicles in the database
This uses the document forgery office  so you need that enabled or choose your own location


1. steal car
2. find a place to hide your car
3. while still sitting in the stolen car, type /hidecar in your chat menu to activate


You can only hide player owner vehicles.


If you want to steal NPC cars your only option it to leave it somewhere or take it to the chop shop. The chop shop is
located at the recycle place just off the freeway near Sandy. 


Park in front of the building. The AI seems to have issues avoiding objects. 



To transfer the car into your name you need to go to the Doument Forgery Office. It will cost you 1500 to transfer the title.



server\main.lua


If you want to change how much it cost to transfer the title, modify line 51 and 54

client\main.lua


If you want to change how much you get for a chopped vehicle, modify lines 238,254,270,286,305,321,338 and 354


To change the the location of the Document Forgery Office, modify line 166
