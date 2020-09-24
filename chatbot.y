%{
char* subject_name;
char* keywords[5] = {"finish", "sleep", "focus", "understand", "had"};
char* activities[4] = {"nature", "music", "reading", "writing"};
int order = 0;
int action_flag = 0;//1=project, 2=had hard week
int right_flag = 0;//wrong=2
int yes_no_flag = 0;//no=2
int second_yes_no = 0;//no=2
int used = 0;///already asked for another activity	, nature => used = 1

int size = 4;
int ct = 0;


void yyerror (char *s);
#include <stdio.h>     
#include <stdlib.h>
#include <string.h>

int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val, char* activ);
%}

%union{char* name; char* feeling; char* action; char* activity;}
%token START ME PRESENTING HELLO THANKS FEEL I DIDNT YES NO LIKE CANT WORTH RIGHT WRONG SUCCEED CONTINUE FINISH
%token <name> NAME
%token <feeling> FEELING
%token <action> ACTION
%token <activity> ACTIVITY

%%
program :  program  sentence '\n'
		|
		;

introducing : PRESENTING NAME 
			{
				subject_name = strdup($2);
			}
			| NAME
			{
				subject_name = strdup($1);
			}
			;
			
sentence :	HELLO 
			{
				printf("friend : Hi! What's your name?\n");
			}
			| introducing 
			{
				printf("friend : How is your day, %s?\n", subject_name);
			}
			| I FEEL FEELING 
			{
				printf("friend :  What's the matter?\n");
				order ++;//order = 1
			}
			| I ACTION
			{
				int i;
				for(i = 0; i < size; i++)
				{
					if((strcmp(keywords[i], $2) == 0))
						{
							break;
						}
				}
					if(i == 4)//had a hard week
					{
						action_flag = 2;
						printf("friend :  Were you busy at work?\n");
						order ++;//order = 2
					}	
			}
			| I DIDNT ACTION
			{
				int i;
				for(i = 0; i < size; i++)
				{
					if((strncmp(keywords[i], $3, 5) == 0) || strncmp(keywords[i], $3, 6) == 0 )
						{
							break;
						}
				}
					if(i == 0)
					{
						action_flag = 1;//project
						printf("friend :  Have you even tried?\n");
						order ++;//order = 2
					}	
			}
			| I CANT ACTION
			{
				int i;
				for(i = 0; i < size; i++)
				{
					if((strncmp(keywords[i], $3, 5) == 0))
					{
						break;
					}
				}
				if(i == 2)
				{
					printf("friend :  Well, let's do something else in order to de-stress yourself! What do you like?\n");
					order ++;
				}
				else
					if(order == 3)
				{
					printf("friend : Try to do more research and maybe you'll figure out how it works!\n");
					order ++;
				}
			}
			| WORTH
			{
				printf("friend : Definitely, you can do more then that!\n");
				order ++;//order = 4
			}
			| I LIKE ACTIVITY
			{
				int i;
				for(int i = 0; i < 4; i++)
				{
					if(strcmp(activities[i], $3) == 0)
					{
						break;
					}
				}
				if(i == 0 && used != 1)//nature
				{
					printf("friend :  Oh, that's good! How about going for a walk and take some fresh air?\n");
					used = 1;
					order ++;
				}
				else
					if(used == 1 && i == 0)
					{
						for(int i = 1; i < 4; i++)
						{
							if(strcmp(activities[i], $3) == 0)
							{
								if(i == 2)
								{
									printf("friend : Oh, that’s nice! You could escape a little from this chaotic world and penetrate into the infinite universe of books in order to find yourself…\n");
									order ++;
									break;
								}
								else
									if(i == 1)//music
									{
										printf("friend : Oh, that's nice! You could listen to your favourite music and travel through your own universe!\n");
										order ++;
										break;
									}
									else
										if(i == 3)//writing
										{
											printf("You could write in your diary and exteriorize your feelings and emotions! It reassures you!\n");
											order ++;
											break;
										}
							}
						}
					}
			}
			| RIGHT
			{
				if(order ==7 && action_flag == 1)
				{
					printf("friend : Is everything ok now?\n");
					order ++;
				}
				else
					if(order == 6)
					{
						printf("friend : Ok, then! Enjoy your favourite activity!\n");
					}
					else
						if((order == 3 && action_flag == 2) || (order == 4 && action_flag == 2))
						{
							printf("friend : Well, let's do something else in order to de-stress yourself! What do you like?\n");
							order ++;
						}
			}
			| WRONG 
			{
				if(order == 5 && action_flag == 1)
				{
					printf("friend : How about asking your mates? Maybe they could help you to clarify your perplexities! Communication is always the best solution!\n");
					order ++;//order = 6
				}
				else
					if((order == 4 && action_flag == 2 && yes_no_flag == 2) || (order == 3 && action_flag == 2 && yes_no_flag !=2))
					{
						right_flag = 2;
						printf("friend : You could try to finish your tasks. But I still think you should get some rest then! If you are refreshed, you can work more efficiently!\n");
						order ++;
					}
			}
			| SUCCEED
			{
				if(order == 5)
				{
					printf("friend : How about asking your mates? Maybe they could help you to clarify your perplexities! Communication is always the best solution!\n");
					order ++;
				}
			}	
			| YES 
			{
				if(order == 2 && action_flag == 1)
				{
					printf("friend :  What difficulties do you encounter?\n");
					order ++;//order = 3
				}
				else
					if((order == 6  && action_flag == 1) || (order == 8 && action_flag == 1))//inca o conditie pt project
					{
						printf("friend : Ok, then! Get to work, %s! Good luck!\n", subject_name);
						order ++;
					}
					else
					{
						if((order == 9 && action_flag == 2 && yes_no_flag == 2 && right_flag == 2 && second_yes_no == 2) || (order == 5 && action_flag == 1) || (order == 5 && action_flag == 2 && yes_no_flag != 2) || (order == 7 && action_flag == 2 && yes_no_flag == 2) || (order == 7 && action_flag == 2 && second_yes_no == 2)|| (order == 6 && action_flag == 2 && right_flag == 2 && yes_no_flag != 2) ||(order == 6 && action_flag == 2 && yes_no_flag == 2 && right_flag != 2) || (order == 8 && action_flag == 2 && right_flag == 2 && second_yes_no == 2))
						{
							printf("friend : Ok, then! Enjoy your favourite activity!\n");
						}
						else
							if(order == 2 && action_flag == 2 && yes_no_flag != 2)
							{
								printf("friend : Enjoy that it passed and get some rest now to regain your strength!\n");
								order ++;
							}
								else
									if(order == 3 && action_flag == 2 && yes_no_flag != 2)
									{
										printf("friend : Well, let's do something else in order to de-stress yourself! What do you like?\n");
										order ++;
									}
									else
										if((order == 5 && action_flag == 2 && right_flag == 2 && yes_no_flag ==2) || (order == 4 && action_flag == 2 && right_flag == 2 && yes_no_flag != 2))
										{
											printf("friend : Well, let's do something else in order to de-stress yourself! What do you like?\n");
											order ++;
										}
										else
											if(order == 3 && action_flag == 2 && yes_no_flag == 2)
											{
												printf("friend : Enjoy that it passed and get some rest now to regain your strength!\n");
												order ++;
											}
					}
			}
			| NO
			{
				if(order == 2 && action_flag == 1)
				{
					yes_no_flag = 2;
					printf("friend :  What keeps you away from that?\n");
					order++;//order = 3
				}
				else
					if(order == 5 && action_flag == 1)
					{
						printf("friend : Ok, but if you do something else in order to disconnect your mind, you'll be able then to focus on your tasks!\n");
						order ++;
					}
					else
					{
						if(order == 6 && action_flag == 1)
						{
							printf("friend : Try it by your own and I'm sure that you'll catch the idea!Being independent helps you to drive your life and provides you confidence!\n");
							order ++;
						}
						else
							if(order == 2 && action_flag == 2)
							{
								yes_no_flag = 2;
								printf("friend : I suppose you had other obligations to fulfill.\n");
								order ++;
							}
							else
								if((order == 5 && action_flag == 1 && yes_no_flag == 1) || (order == 5 && action_flag == 2 && yes_no_flag != 2 && right_flag != 2) || (order == 6 && action_flag == 2 && yes_no_flag == 2 && right_flag != 2) || (order == 7 && action_flag == 2 && yes_no_flag == 2 && right_flag == 2) || (order == 6 && action_flag == 2 && yes_no_flag != 2 && right_flag == 2))
								{
									second_yes_no = 2;
									printf("friend : Maybe we should find another alternative. What else do you like to do?\n");
									order ++;
								}
					}
			}
			| THANKS
			{
				printf("friend : Good bye! See you next time!\n");
				return;
			}
			| FINISH
			{
				printf("friend : Good bye! See you next time!\n");
				return;
			}
			|
			{
				printf("That's not clear!\n");
			}
            ;

%%

int main (void) {

	 yyparse();
	 return 0;
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 