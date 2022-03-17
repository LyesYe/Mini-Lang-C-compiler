%{  
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "syntax.tab.h"
    #include "ts.h"
    extern int nb_col,nb_ligne;
    extern YYSTYPE yylval;
%}
lettreMin [a-z]
lettreMaj [A-Z]
chiffre [0-9]
commentaire [^!]*
CST_REAL \([+-]{chiffre}+\.{chiffre}+\)|{chiffre}+\.{chiffre}+
CST_INT \([+-]{chiffre}+\)|{chiffre}+
CST_CHAR '.'
CST_STRING \"[^"]*\"
IDF ({lettreMaj})({lettreMin}|{chiffre})*
formatage (\"\$\"|\"#\"|\"%\"|\"&\")
%%
"IDENTIFICATION DIVISION"    {printf("\n Mc_IdfDiv reconnu \n");nb_col += yyleng; rechercher(yytext,"MC","",40000,1);  return (token_IDF_div); }
"PROGRAM-ID"                 {printf("\n Mc_PROG_ID reconnu \n");nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);     return (token_prog_id);}
"DATA DIVISION"              {printf("\n Mc_DATA reconnu \n");nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);     return (token_date_div);}
"WORKING-STORAGE SECTION"    {printf("\n Mc_WORKING_STORAGE reconnu \n");nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);     return (token_work_section);}
"PROCEDURE DIVISION"         {printf("\n Mc_ProcDiv reconnu \n");nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);     return (token_proc_div);}
"STOP RUN"                   {printf("\n Mc_StopRun reconnu \n");nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);     return (token_stop);}
"INTEGER"                      {printf("\n Mc_Int reconnu \n");nb_col += yyleng;  yylval.STRING=strdup(yytext);  rechercher(yytext,"MC","",40000,1);     return (token_int);}
"FLOAT"                       {printf("\n Mc_FLOAT reconnu \n");nb_col += yyleng;  yylval.STRING=strdup(yytext);  rechercher(yytext,"MC","",40000,1);    return (token_float);}
"CHAR"                         {printf("\n Mc_CHAR reconnu \n"); nb_col += yyleng;  yylval.STRING=strdup(yytext);yylval.STRING=strdup(yytext);  rechercher(yytext,"MC","",40000,1);     return (token_char);}
"STRING"                       {printf("\n Mc_STRING reconnu \n"); nb_col += yyleng;  yylval.STRING=strdup(yytext);  rechercher(yytext,"MC","",40000,1);     return (token_string);}
"CONST"                        {printf("\n Mc_CONST reconnu \n"); nb_col += yyleng;  yylval.STRING=strdup(yytext);  rechercher(yytext,"MC","",40000,1);     return (token_const);}
"LINE"                         {printf("\n Mc_LINE reconnu \n"); nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);     return (token_LINE);}
"SIZE"                         {printf("\n Mc_SIZE reconnu \n"); nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);     return (token_SIZE);}
"#"{commentaire}"!"          {int nb_car=0;
                     while(yytext[nb_car]!='\0')
                             {if(yytext[nb_car]=='\n')
                             {nb_col=1;nb_ligne++;}
                         else nb_col++;
                         nb_car++;} } 
{formatage}    {printf("\n formatage reconnu \n"); nb_col += yyleng; yylval.STRING=strdup(yytext);    rechercher(yytext,"MC","",40000,1);      return (token_formatage);}
{CST_REAL}                   {printf("\n CST_REAL reconnu \n");nb_col += yyleng;
                              if(yytext[0]=='(')
                              {char yytext2[strlen(yytext)];   
                              strcpy(yytext2,yytext);
                              char *result = yytext+1;
                              result[strlen(result)-1] = '\0'; 
                              yylval.FLOAT = atoi(yytext2);
                              rechercher(yytext2,"CONST","FLOAT",atof(result),0);}
                              else 
                              {yylval.FLOAT = atoi(yytext);
                               rechercher(yytext,"CONST","FLOAT",atof(yytext),0);   }     
                               return (token_CST_REAL);}
{CST_INT}                    {printf("\n CST_REAL reconnu \n");nb_col += yyleng;
                               if(yytext[0]=='(')
                              {char yytext2[strlen(yytext)];
                              strcpy(yytext2,yytext); 
                              char *result = yytext+1;
                              result[strlen(result)-1] = '\0'; 
                              yylval.INT = atoi(yytext2);
                              rechercher(yytext2,"CONST","INT",atof(result),0);}
                              else 
                              {
                            rechercher(yytext,"CONST","INT",atof(yytext),0);}
                              yylval.INT = atoi(yytext);
                              return (token_CST_INT);}
{CST_CHAR}                   {printf("\n CST_CHAR reconnu \n"); nb_col += yyleng; yylval.CHAR = yytext[1];  rechercher(yytext,"CONST","CHAR",atof(yytext),0);     return (token_CST_CHAR);}
{CST_STRING}                 {printf("\n CST_STRING reconnu \n"); nb_col += yyleng; yylval.STRING = strdup(yytext);  rechercher(yytext,"CONST","STRING",atof(yytext),0);     return (token_CST_STRING);}
"("                          {printf("\n Mc_ParOuvrante reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_Par_Ouvrante);}
")"                          {printf("\n Mc_ParFermante reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_Par_Fermante);}
":"                          {printf("\n Mc_Deux_Points reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_Deux_Points);}
"@"                          {printf("\n Mc_Adresse reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_Adresse);}
"+"                          {printf("\n Mc_add reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_Plus);}
"-"                          {printf("\n Mc_sub reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_Moins);}
"*"                          {printf("\n Mc_mult reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_Mult);}
"/"                          {printf("\n Mc_div reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_DIV);}
"="                          {printf("\n Mc_affectation reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_AFFECTATION);}
"."                          {printf("\n MC_point reconnu \n"); nb_col += yyleng; yylval.STRING = strdup(yytext);   rechercher(yytext,"SEP","",1,2);       return (token_point);}
","                          {printf("\n MC_virgule reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_virgule);}
"|"                          {printf("\n MC_pipe reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_PIPE);}
"AND"                        {printf("\n Mc_et reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_ET);}
"OR"                         {printf("\n Mc_ou reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_OU);}
"NOT"                        {printf("\n Mc_negation reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_NOT); }
"G"                          {printf("\n Mc_sup reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_G);}
"L"                          {printf("\n Mc_inf reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_L);}
"GE"                         {printf("\n Mc_sup_ou_egal reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_GE);}
"LE"                         {printf("\n Mc_inf_ou_egal reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);     return (token_LE);}
"EQ"                         {printf("\n Mc_egal reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);        return (token_EQ);}
"DI"                         {printf("\n Mc_diff reconnu \n"); nb_col += yyleng;    rechercher(yytext,"SEP","",1,2);        return (token_DI);}
"ACCEPT"                       {printf("\n Mc_accept reconnu \n"); nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);      return (token_ACCEPT);}
"DISPLAY"                      {printf("\n Mc_display reconnu \n"); nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);        return (token_DISPLAY);}
"IF"                           {printf("\n Mc_if reconnu \n"); nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);      return (token_IF);}
"ELSE"                         {printf("\n Mc_else reconnu \n"); nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);        return (token_ELSE);}
"END"                          {printf("\n Mc_end reconnu \n"); nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);     return (token_END);}
"MOVE"                         {printf("\n Mc_move reconnu \n"); nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);        return (token_MOVE);}
"TO"                           {printf("\n Mc_to reconnu \n"); nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);      return (token_TO);}
"READ"                         {printf("\n Mc_read reconnu \n"); nb_col += yyleng;    rechercher(yytext,"MC","",40000,1);      return (token_READ);}
[ \t]   nb_col += yyleng;
[\n]                           {nb_ligne++; nb_col=1;}
{IDF}                         { if(yyleng<=8) {printf("IDF reconnu \n"); nb_col += yyleng; 
                                yylval.STRING=strdup(yytext);
                                rechercher(yytext,"IDF","",40000,0);  
                                return (token_IDF);} 
                                else printf("ERREUR : IDF trop long");    }    
.                            {printf("Erreur lexicale au niveau de la ligne %d et colone %d \n",nb_ligne, nb_col); nb_col++;  }
%%