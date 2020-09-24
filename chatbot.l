%{
	int yywrap(void);
	void yyerror (char *s);
	#include <stdio.h>
	#include "y.tab.h"
	#include <string.h>
	int found = 0;
%}

%%
"ME" 				{return ME;}
"What's your name?"	{return START;}
"My name is"	|
"I'm"			|
"I am"				{return PRESENTING;}
"Thank you"		|
"Thanks"		|
"Thx"			|
"Bye"				{return THANKS;}
"feel"				{return FEEL;}
"I"					{return I;}
"didn't"			{return DIDNT;}
"can't"				{return CANT;}
"q"					{return FINISH;}

sad 		 |
overwhelmed  |
tired  				{yylval.feeling = strdup(yytext); return FEELING;}

"Does it worth it" 			{return WORTH;}
"What if I don't succeed"	{return SUCCEED;}

"understand " |
"had a hard " |
"finish " 	  |
"focus "			{yylval.action = strdup(yytext); return ACTION;}

"You're right"	|
"Maybe"			|
"Ok"				{return RIGHT;}

"You're wrong"		|
"I don't think so"	|
"Don't think so"	|
"Neh"				{return WRONG;}

"like"				{return LIKE;}

reading  |
writing	 |
nature	 |
music 	 			{yylval.activity = strdup(yytext); return ACTIVITY;}

"Hi"			|
"Hello"			|
"Good morning"	|
"Good evening"	|
"Good afternoon"	{return HELLO;}

[\n?]				{return *yytext;}

"I don't think so "	|
"Don't think so "	|
"Nope"				|
"Neh "				|
"Nup"				|
"No"				{return NO;}

"That's "		|
"Awesome"		|
"Great"			|
"Of course"		|
"Fantastic"		|
"Maybe "		|
"Ofc"			|
"Yeah"			|
"Yes"			|
"Yep"			|
"Ok "				{return YES;}

[A-Z][a-z]*			{yylval.name = strdup(yytext); 
					if(!found)
					{
						found = 1;
						return NAME;}
					}

[,?!\t]				;
.					;

%%
int yywrap(void){
	return 1;
}
