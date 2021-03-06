state("COI")
{
	string25 levelName : "COI.exe", 0x649D08, 0x7c, 0x0;
	byte cutsceneStatus : "COI.exe", 0xB0388, 0x1;
	int bossHP : "COI.exe", 0x64EC5C, 0x34, 0x8,0x10,0x4,0xf0;
}

start
{
	return old.levelName.Equals("Castle of Illusion") && current.levelName.Equals("");
}


split
{
	if( old.cutsceneStatus != current.cutsceneStatus )
	{
		current.previousCutsceneStatus = current.cutsceneStatus;
	}
	// The level name is empty except for on the loading screen.
	bool loadingScreen = ( old.levelName.Equals("") && !current.levelName.Equals("") );
	String currSplitName = timer.CurrentSplit.Name;
	
	bool newLevel = false;


	int maxBossHP = 6;
	int currIndex = timer.CurrentSplitIndex;

	// Initialize the boss HP variable that we'll keep between samples.
	// If the player dies, and the boss hp goes back to max hp, we need to handle that.
	// Otherwise, the previous value should be null.
	if( currIndex > 0 )
	{
		if( current.bossHP > 0  && current.bossHP <= maxBossHP  )
		{
			current.previousBossHP = current.bossHP;
		}
		else if( old.previousBossHP == 1 && current.bossHP == 0)
		{
			current.previousBossHP = 0;
		}
	}
	else
	{
		current.previousBossHP = maxBossHP;
		current.cutsceneCount = 0;
	}

	switch( currIndex )
	{
		case 0:
			newLevel = !current.levelName.Equals("Castle of Illusion");
			break;
		case 1:
			newLevel = !current.levelName.Equals("Enchanted Forest - Act 1");
			break;
		case 2: 
			newLevel = !current.levelName.Equals("Enchanted Forest - Act 2");
			break;
		case 3:
			newLevel = !current.levelName.Equals("Enchanted Forest - Act 3");
			break;
		case 4:
			newLevel = !current.levelName.Equals("Castle of Illusion");
			break;
		case 5:
			newLevel = !current.levelName.Equals("Toyland - Act 1");
			break;
		case 6:
			newLevel = !current.levelName.Equals("Toyland - Act 2");
			break;
		case 7:
			newLevel = !current.levelName.Equals("Toyland - Act 3");
			break;
		case 8:
			newLevel = !current.levelName.Equals("Castle of Illusion");
			break;
		case 9:
			newLevel = !current.levelName.Equals("The Storm - Act 1");
			break;
		case 10:
			newLevel = !current.levelName.Equals("The Storm - Act 2");
			break;
		case 11:
			newLevel = !current.levelName.Equals("The Storm - Act 3");
			break;
		case 12:
			newLevel = !current.levelName.Equals("Castle of Illusion");
			break;
		case 13:
			newLevel = !current.levelName.Equals("The Library - Act 1");
			break;
		case 14:
			newLevel = !current.levelName.Equals("The Library - Act 2");
			break;
		case 15:
			newLevel = !current.levelName.Equals("The Library - Act 3");
			break;
		case 16:
			newLevel = !current.levelName.Equals("Castle of Illusion");
			break;
		case 17:
			newLevel = !current.levelName.Equals("The Castle - Act 1");
			break;
		case 18:
			newLevel = !current.levelName.Equals("The Castle - Act 2");
			break;
		case 19:
			newLevel = !current.levelName.Equals("The Castle - Act 3");
			break;
		case 20:
			newLevel = !current.levelName.Equals("Castle of Illusion");
			break;
		case 21:
			newLevel = !current.levelName.Equals("Mizrabel's Tower");
			break;
		case 22:
			newLevel = !current.levelName.Equals("Mizrabel's Tower - Finale");
			if( old.cutsceneStatus == 0 && current.cutsceneStatus == 1 )
			{
				current.cutsceneCount = old.cutsceneCount+1;
			}	
			break;
		default:
			break;
	}

	bool theFinalSplit = currIndex == 22 && old.cutsceneCount > 2 && current.cutsceneStatus == 1 && old.previousBossHP == 0;

	bool isLoadingToLobby = current.levelName.Equals("Castle of Illusion");
	bool lobbyMeansSplit =  currIndex == 3 || 
				currIndex == 7 ||
				currIndex == 11 ||
				currIndex == 15 ||
				currIndex == 19;

	bool shouldSplit = theFinalSplit || (loadingScreen && newLevel && (!isLoadingToLobby || lobbyMeansSplit));

	// reset all persisted state variables to their default values.
	if( shouldSplit || ( loadingScreen && !newLevel) )
	{
		current.cutsceneCount = 0;
		current.previousBossHP = maxBossHP;
	}

	return shouldSplit;
}

isLoading
{
	return !current.levelName.Equals("");
}

gameTime
{
}
