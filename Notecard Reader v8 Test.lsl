//Read Notecard DataServer Example
//by Hank Ramos
string  notecardName = "My Notecard";
integer lineCounter;
key     dataRequestID;
float delaySeconds = 1.7; //pause doesn't matter any more

// this version is touch the when you're ready for the next line
// notecard reader object seems to work fine as a HUD
// LO 2014-02-17





// ********** DIALOG FUNCTIONS **********
// Dialog constants
integer lnkDialog = 14001;
integer lnkDialogNotify = 14004;
integer lnkDialogResponse = 14002;
integer lnkDialogTimeOut = 14003;
 
integer lnkDialogReshow = 14011;
integer lnkDialogCancel = 14012;
 
integer lnkMenuClear = 15001;
integer lnkMenuAdd = 15002;
integer lnkMenuShow = 15003;
 
string seperator = "||";
integer dialogTimeOut = 0;
// ********** END DIALOG FUNCTIONS **********
 
string texturesDialog; //Actually Notecards Dialog!
 
initTextures(){
// Please me reminded that Nargus Dialog script autometicly add Back/Next buttons for you.
// Optimised dialog generator script. Much more memory efficient than usage of Dialog+Menus control function
 
    llOwnerSay("Inventory change detected; re-initializing...");
 
    texturesDialog = "Click BACK/NEXT to change page.\n" +
        "Click a texture button to choose." +
        seperator + (string)dialogTimeOut;
 
    integer count = llGetInventoryNumber(INVENTORY_NOTECARD);
    integer i;
    for(; i<count; ++i){
        string name = llGetInventoryName(INVENTORY_NOTECARD, i);
        texturesDialog += seperator + name + seperator + llGetSubString(name, 0, 15);
    }
    texturesDialog += seperator + "CLOSE" + seperator;
 
    llOwnerSay("Initializing completed.");
}
 
default{
    state_entry(){
        initTextures();
    }
 
    changed(integer changes){
        if(changes & CHANGED_INVENTORY) initTextures();
    }
 
    link_message(integer sender_num, integer num, string str, key id){
        if(num == lnkDialogResponse){
            //if(llGetInventoryType(str) == INVENTORY_TEXTURE) llSetTexture(str, ALL_SIDES);
            if(llGetInventoryType(str) == INVENTORY_NOTECARD) {
                notecardName = str;
                //llSay(0, notecardName);
            
                state readNotecard;
            }
        }
    }
 
    touch_start(integer num_detected){
        llMessageLinked(LINK_THIS, lnkDialog, texturesDialog, llDetectedOwner(0));
    }
}




// Script Name: Read_Notecard_DataServer_Example.lsl
//Read Notecard DataServer Example.lsl

// Downloaded from : http://www.free-lsl-scripts.com/cgi/freescripts.plx?ID=1089

// This program is free software; you can redistribute it and/or modify it.
// Additional Licenes may apply that prevent you from selling this code
// and these licenses may require you to publish any changes you make on request.
//
// There are literally thousands of hours of work in these scripts. Please respect
// the creators wishes and follow their license requirements.
//
// Any License information included herein must be included in any script you give out or use.
// Licenses are included in the script or comments by the original author, in which case
// the authors license must be followed.

// A GNU license, if attached by the author, means the original code must be FREE.
// Modifications can be made and products sold with the scripts in them.
// You cannot attach a license to make this GNU License 
// more or less restrictive.  see http://www.gnu.org/copyleft/gpl.html

// Creative Commons licenses apply to all scripts from the Second Life
// wiki and script library and are Copyrighted by Linden Lab. See
// http://creativecommons.org/licenses/

// Please leave any author credits and headers intact in any script you use or publish.
// If you don't like these restrictions, then don't use these scripts.
//////////////////////// ORIGINAL AUTHORS CODE BEGINS ////////////////////////////////////////////
// CATEGORY:Notecards
// DESCRIPTION:Read Notecard DataServer Example.lsl
// ARCHIVED BY:Ferd Frederix

//Read Notecard DataServer Example
//by Hank Ramos
//string  notecardName = "My Notecard";
//integer lineCounter;
//key     dataRequestID;

//default
//{
//    state_entry()
//    {
//        llSay(0, "Ready. Click to start.");

// This just looks awful.  You have to know that this script goes inside an object you wear and you touch the opbject to make it work
//        llSay(0, "\n...: (Ready (touch start).\n...: ");
//    }
//    touch_start(integer num_detected)
//    {
//        notecardName = llGetInventoryName(INVENTORY_NOTECARD,0);
//        state readNotecard;
//    }
//}

state readNotecard
{
    state_entry()
    {
        lineCounter = 0;
        dataRequestID = llGetNotecardLine(notecardName, lineCounter);
    }

	touch_start(integer num_det)
	{
	    lineCounter += 1;
        dataRequestID = llGetNotecardLine(notecardName, lineCounter);
	}

	
    dataserver(key queryid, string data)
    {
        //Check to make sure this is the request we are making.
        //Remember that when data comes back from the dataserver, 
        //it goes to *all* scripts in your prim.
        //So you have to make sure this is the data you want, and
        //not data coming from some other script.
        if (dataRequestID)
        {
            //If we haven't reached the end of the file
            //Display the incoming data, then request the next line #
            if (data != EOF)
            { 
//                llSay(0, "Line #" + (string)lineCounter + ": " + data);
                // llSleep(delaySeconds);
                llSay(0, data);
                // lineCounter += 1;
                // dataRequestID = llGetNotecardLine(notecardName, lineCounter);
            }
            else
            {
                state default;
            }
        }
    }
}// END //

