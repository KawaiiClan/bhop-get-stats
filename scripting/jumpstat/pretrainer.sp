float g_fPreCurrentSpeed[MAXPLAYERS+1];
static int g_iTickNumber;

void PreStrafeTrainer_Tick(int client, float speedy, bool inbhop)
{
	if(!g_hEnabledPreTrainer.BoolValue)
	{
		return;
	}

	g_iTickNumber++;

	if(g_iTickNumber % SPEED_UPDATE_INTERVAL != 0)
	{
		return;
	}

	if(!IsValidClient(client))
	{
		return;
	}

	g_iTickNumber = 0;
	
	if((GetEntityFlags(client) & FL_ONGROUND) && !inbhop)
	{
		g_fPreCurrentSpeed[client] = speedy;
	}
		
	int speedColorIdx;

	if(g_fPreCurrentSpeed[client] > 270.0)
	{
		speedColorIdx = GainReallyGood;
	}
	else if (g_fPreCurrentSpeed[client] > 260.0)
	{
		speedColorIdx = GainGood;
	}
	else
	{
		speedColorIdx = GainReallyBad;
	}

	int speed = RoundToFloor(g_fPreCurrentSpeed[client]);

	for(int j = -1; j < g_iSpecListCurrentFrame[client]; j++)
	{
		int messageTarget = j == -1 ? client:g_iSpecList[client][j];

		if(!(g_iSettings[messageTarget][Bools] & PRESTRAFETRAINER_ENABLED) || !BgsIsValidPlayer(messageTarget))
		{
			continue;
		}

		char message[256];
		if(speed < 10)
		{
			Format(message, sizeof(message), "   %i", speed);
		}
		else if(speed < 100)
		{
			Format(message, sizeof(message), "  %i", speed);
		}
		else if(speed < 1000)
		{
			Format(message, sizeof(message), " %i", speed);
		}
		else
		{
			Format(message, sizeof(message), "%i", speed);
		}
		
		int channel = 5;
		if(!(g_iSettings[messageTarget][Bools] & TRAINER_ENABLED))
		{
			channel = 0;
		}
		else if(!(g_iSettings[messageTarget][Bools] & JHUD_ENABLED))
		{
			channel = 1;
		}
		else if(!(g_iSettings[messageTarget][Bools] & OFFSETS_ENABLED))
		{
			channel = 2;
		}
		else if(!(g_iSettings[messageTarget][Bools] & SHOWKEYS_ENABLED))
		{
			channel = 3;
		}
		else if(!(g_iSettings[messageTarget][Bools] & SPEEDOMETER_ENABLED))
		{
			channel = 4;
		}
		
		BgsDisplayHud(messageTarget, g_fCacheHudPositions[messageTarget][PreStrafeTrainer], g_iBstatColors[g_iSettings[messageTarget][speedColorIdx]], 0.2, GetDynamicChannel(channel), false, message);
	}
}
