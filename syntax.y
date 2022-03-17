%{
#include <string.h>
int nb_ligne =1,nb_col=1;
char sauvType[10]; 
char typeDECL[50][50];
char cstDECL[50][50];
char idfDECL[50][50];

int j=0;
int k=0;
int l=0;
int n;
%}
 

 
%union {
        int INT;
        float FLOAT;
        char* STRING;
        char CHAR;
}

 
%left   token_OU token_NOT
%left   token_ET
%left   token_G token_GE token_EQ token_DI token_LE token_L
%left   token_PLUS token_MOINS
%left   token_Mult token_DIV




%token   token_IDF_div
%token  token_prog_id
%token  token_date_div
%token  token_work_section 
%token  token_proc_div
%token  token_stop
%token<STRING>  token_int
%token<STRING>  token_float
%token<STRING>  token_char
%token<STRING>  token_string
%token<STRING>  token_const
%token  token_LINE
%token  token_SIZE
%token<FLOAT>  token_CST_REAL
%token<INT>  token_CST_INT
%token<STRING>  token_CST_STRING
%token<CHAR>  token_CST_CHAR
%token<STRING>  token_IDF
%token  token_Par_Ouvrante
%token  token_Par_Fermante
%token  token_Deux_Points
%token  token_Adresse
%token  token_Plus
%token  token_Moins
%token  token_Mult
%token  token_DIV
%token  token_ET
%token  token_OU
%token  token_NOT
%token  token_G
%token  token_L
%token  token_GE
%token  token_LE
%token  token_EQ
%token  token_DI
%token  token_AFFECTATION
%token  token_ACCEPT
%token  token_DISPLAY
%token  token_IF
%token  token_END
%token  token_ELSE
%token  token_MOVE
%token  token_TO
%token<STRING>  token_point
%token  token_virgule
%token  token_PIPE
%token  token_int_positive
%token  token_READ
%token<STRING>  token_formatage

%type <STRING> TYPE
%start code


 

%%

code: IDF_DIV PROG_ID DATA_DIV WORKING PROC_DIV  {printf("----------Code syntaxiquement correcte-----------"); YYACCEPT;};

IDF_DIV: token_IDF_div token_point ;
PROG_ID: token_prog_id token_point token_IDF token_point;
DATA_DIV: token_date_div token_point;
WORKING: token_work_section token_point declaration;
PROC_DIV: token_proc_div token_point INSTRUCTION token_stop token_point;

CST_Num:     token_CST_REAL   
            |token_CST_INT

TYPE:  token_int {strcpy(sauvType,"INTEGER"); }
      |token_float  {strcpy(sauvType,"FLOAT");}    
      |token_char {strcpy(sauvType,"CHAR");} 
      |token_string {strcpy(sauvType,"STRING");} ;

declaration_const:    token_const token_IDF token_AFFECTATION token_CST_REAL token_point 
                     {
                        
                         if ( idfExiste($2,cstDECL,k) == 0 && idfExiste($2,idfDECL,l) == 0 )
                           {
                              strcpy(cstDECL[l],$2); k++;
                              
                              insererType($2,"FLOAT"); 
                           }
                         else 
                         {
                             printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> L'IDF %s Existe deja \n",nb_ligne,$2);
                                  afficher();
                                  exit (-1);
                         }
                     }
                     |token_const token_IDF token_AFFECTATION token_CST_INT token_point 
                     {
                        
                         if ( idfExiste($2,cstDECL,k) == 0 && idfExiste($2,idfDECL,l) == 0 )
                           {
                              strcpy(cstDECL[k],$2); k++;
                             
                              insererType($2,"INTEGER"); 
                           }
                         else 
                         {
                             printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> L'IDF %s Existe deja \n",nb_ligne,$2);
                                  afficher();
                                  exit (-1);
                         }
                     }
                     |token_const token_IDF token_AFFECTATION token_CST_CHAR token_point 
                     {
                         if ( idfExiste($2,cstDECL,k) == 0 && idfExiste($2,idfDECL,l) == 0 )
                           {
                              strcpy(cstDECL[l],$2); k++;
                              insererType($2,"CHAR"); 
                           }
                         else 
                         {
                             printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> L'IDF %s Existe deja \n",nb_ligne,$2);
                                  afficher();
                                  exit (-1);
                         }
                     }
                     |token_const token_IDF token_AFFECTATION token_CST_STRING token_point 
                     {
                         if ( idfExiste($2,cstDECL,k) == 0 && idfExiste($2,idfDECL,l) == 0 )
                           {
                              strcpy(cstDECL[l],$2); k++;
                              insererType($2,"STRING"); 
                           }
                         else 
                         {
                             printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> L'IDF %s Existe deja \n",nb_ligne,$2);
                                  afficher();
                                  exit (-1);
                         }
                     }
                     |token_const  token_IDF TYPE token_point
                     { if ( idfExiste($2,cstDECL,k) == 0 && idfExiste($2,idfDECL,l) == 0 )
                           {
                             
                              strcpy(cstDECL[k],$2); k++; 
                              insererType($2,$3);
                           }
                         else 
                         {
                             printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> L'IDF %s Existe deja \n",nb_ligne,$2);
                                  afficher();
                                  exit (-1);
                         }}   ; 


declaration_simple:   token_IDF token_PIPE declaration_simple 
                          {if(idfExiste($1,idfDECL,j) == 0 && idfExiste($1,cstDECL,k) == 0) 
                           {
                                strcpy(typeDECL[j],$1); strcpy(idfDECL[l],$1);   j++; l++;
                                n = j;
                                for(j=0;j<n;j++)
                                {
                                    insererType(typeDECL[j],sauvType);
                                }
                                j=0;
                            }
                            else  
                                { printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> L'IDF %s Existe deja \n",nb_ligne,$1);
                                  afficher();
                                  exit (-1);
                                }
                               
                       }
                      |token_IDF TYPE token_point  
                        {if(idfExiste($1,idfDECL,l)==0 && idfExiste($1,cstDECL,k) == 0 ) 
                                {strcpy(typeDECL[j],$1); strcpy(idfDECL[l],$1);  l++; j++;}
                            else  
                                {printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> L'IDF %s Existe deja \n",nb_ligne,$1);
                                  afficher();
                                  exit (-1);
                               }
                              
                              };


declaration_tab:     token_IDF token_LINE token_CST_INT token_virgule token_SIZE token_CST_INT TYPE token_point
                        {
                        if(idfExiste($1,idfDECL,l) == 0 && idfExiste($1,cstDECL,k) == 0) 
                           {
                                strcpy(idfDECL[l],$1); l++;
                            }
                            else  
                                { printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> L'IDF %s Existe deja \n",nb_ligne,$1);
                                  afficher();
                                  exit (-1);
                                }
                        if(($6<1)||($3<=0)) 
                        {printf ("\n!!!!! Erreur semantique dans la ligne -> %d, colonne -> %d !!!!! ====> Borne inferieure ou Taille du tableau ,\n",nb_ligne,nb_col);
                        afficher();
                        exit (-1);}
                        }
                        

declaration:     declaration_const declaration
                |declaration_tab declaration
                |declaration_simple declaration
                |;

INSTRUCTION:     AFFECTATION token_point INSTRUCTION
                |ACCEPT token_point INSTRUCTION
                |DISPLAY INSTRUCTION
                |IF INSTRUCTION
                |boucle INSTRUCTION
                |;

AFFECTATION: token_IDF token_AFFECTATION EXP_ARITHMETIQUE
             {
                 if( idfExiste($1,cstDECL,k) == 1 )
                 { printf ("\n!!!!! Erreur semantique dans la ligne -> %d, colonne -> %d !!!!! ====> Affectation d'une CONST impossible \n",nb_ligne,nb_col);
                   afficher();
                   exit (-1);}
                 if ( idfExiste($1,idfDECL,l) == 0 )
                     {
                        printf ("\n!!!!! Erreur semantique dans la ligne -> %d, colonne -> %d !!!!! ====> Affectation impossible : variable %s non declaree ,\n",nb_ligne,nb_col,$1);
                        afficher();
                        exit (-1); 
                     }
                 
             }

ACCEPT: token_ACCEPT token_Par_Ouvrante token_formatage token_Deux_Points token_Adresse token_IDF token_Par_Fermante
           {
                 if ( idfExiste($6,idfDECL,l) == 0 )
                     {
                        printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> Lecture impossible : variable %s non declaree ,\n",nb_ligne,$6);
                        afficher();
                        exit (-1); 
                     }
                    
                 if (strcmp($3,"\"$\"") == 0)
                  {
                      
                      if(returnType($6)!=1)
                      {
                        printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> Le signe de formatage ne correspond pas au type de l'IDF ,\n",nb_ligne);
                        afficher();
                        exit (-1); 
                      }
                   }
                  if (strcmp($3,"\"%\"") == 0)
                  {
                      if(returnType($6)!=2)
                      {
                        printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> Le signe de formatage ne correspond pas au type de l'IDF ,\n",nb_ligne);
                        afficher();
                        exit (-1); 
                      }
                   }
                   if (strcmp($3,"\"&\"") == 0)
                  {
                      if(returnType($6)!=3)
                      {
                        printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> Le signe de formatage ne correspond pas au type de l'IDF ,\n",nb_ligne);
                        afficher();
                        exit (-1); 
                      }
                   }
                   if (strcmp($3,"\"#\"") == 0)
                  {
                      if(returnType($6)!=4)
                      {
                        printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> Le signe de formatage ne correspond pas au type de l'IDF ,\n",nb_ligne);
                        afficher();
                        exit (-1); 
                      }
                   }
            };   
        

DISPLAY: token_DISPLAY token_Par_Ouvrante string_temp token_Deux_Points token_IDF token_Par_Fermante token_point
             {
                 if ( idfExiste($5,idfDECL,l) == 0 )
                     {
                        printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> Operation impossible : variable %s non declaree ,\n",nb_ligne,$5);
                        afficher();
                        exit (-1); 
                     }
            };

string_temp:    token_formatage
                |token_CST_STRING;

boucle:   token_MOVE  token_IDF token_TO  token_IDF INSTRUCTION token_END
            {
                if ( idfExiste($2,idfDECL,l) == 0 && idfExiste($2,cstDECL,k) == 0 )
                     {
                        printf ("\n!!!!! Erreur semantique dans la ligne -> %d, colonne -> %d !!!!! ====> Variable %s non declaree \n",nb_ligne,nb_col,$2);
                        afficher();
                        exit (-1); 
                     }
                if ( idfExiste($4,idfDECL,l) == 0 || idfExiste($4,cstDECL,k) == 0 )
                     {
                        printf ("\n!!!!! Erreur semantique dans la ligne -> %d, colonne -> %d !!!!! ====> Variable %s non declaree \n",nb_ligne,nb_col,$4);
                        afficher();
                        exit (-1); 
                     }
            }
         |token_MOVE  token_IDF token_TO  CST_Num INSTRUCTION token_END
         {
              if ( idfExiste($2,idfDECL,l) == 0 && idfExiste($2,cstDECL,k) == 0 )
                     {
                        printf ("\n!!!!! Erreur semantique dans la boucle MOVE !!!!! ====> Variable %s non declaree \n",$2);
                        afficher();
                        exit (-1); 
                     }
         }
         |token_MOVE token_CST_INT token_TO token_CST_INT INSTRUCTION token_END
         {
             if( $2 > $4 )
            { printf ("\n!!!!! Erreur semantique dans la boucle MOVE !!!!! ====>La borne sup %d est inferieur a la borne inf %d ,\n",$4,$2);
                        afficher();
                        exit (-1); }
         }
         |token_MOVE token_CST_REAL token_TO token_CST_REAL INSTRUCTION token_END
         {
             if( $2 > $4 )
             {printf ("\n!!!!! Erreur semantique dans la boucle MOVE !!!!! ====>La borne sup %d est inferieur a la borne inf %d ,\n",$4,$2);
                        afficher();
                        exit (-1); }
         }
         ;




IF: token_IF token_Par_Ouvrante CONDITION token_Par_Fermante token_Deux_Points INSTRUCTION token_END 
    |token_IF token_Par_Ouvrante CONDITION token_Par_Fermante token_Deux_Points INSTRUCTION token_ELSE token_Deux_Points INSTRUCTION token_END

EXP_ARITHMETIQUE:  OPERANDE operateur_ar EXP_ARITHMETIQUE
                   |token_Par_Ouvrante EXP_ARITHMETIQUE token_Par_Fermante operateur_ar EXP_ARITHMETIQUE
                   |token_Par_Ouvrante EXP_ARITHMETIQUE token_Par_Fermante
                   |OPERANDE token_DIV token_CST_INT
                   {
                     if($3 == 0)
                    {
                     printf ("\n!!!!! Erreur semantique dans la ligne -> %d, colonne -> %d !!!!! ====> DIVISION SUR ZERO IMPOSSIBLE \n",nb_ligne,nb_col);
                        afficher();
                        exit (-1);    
                    }
                 }
                   |OPERANDE token_DIV token_CST_REAL
                   {
                     if($3 == 0)
                    {
                     printf ("\n!!!!! Erreur semantique dans la ligne -> %d, colonne -> %d !!!!! ====> DIVISION SUR ZERO IMPOSSIBLE \n",nb_ligne,nb_col);
                        afficher();
                        exit (-1);    
                    }
                 }
                   |OPERANDE;



operateur_ar: token_Plus | token_Moins | token_Mult;

OPERANDE:  token_IDF 
            {
                 if ( idfExiste($1,idfDECL,l) == 0 )
                     {
                        printf ("\n!!!!! Erreur semantique dans la ligne -> %d !!!!! ====> Operation impossible : variable %s non declaree ,\n",nb_ligne,$1);
                        afficher();
                        exit (-1); 
                     }
                 
            }
           |CST_Num;
        
COMPARAISON:    EXP_ARITHMETIQUE token_point operateur_comp token_point EXP_ARITHMETIQUE
                |token_Par_Ouvrante EXP_ARITHMETIQUE token_point operateur_comp token_point EXP_ARITHMETIQUE token_Par_Fermante;


operateur_comp:  token_G
                |token_L
                |token_GE
                |token_LE
                |token_EQ
                |token_DI;

EXP_BOOL:        COMPARAISON 
                |token_NOT COMPARAISON
                |token_Par_Ouvrante token_NOT COMPARAISON token_Par_Fermante;

EXP_LOGIQUE:    EXP_BOOL operateur_logique EXP_LOGIQUE
                |token_NOT token_Par_Ouvrante EXP_BOOL operateur_logique EXP_LOGIQUE token_Par_Fermante 
                |token_Par_Ouvrante token_NOT token_Par_Ouvrante EXP_BOOL operateur_logique EXP_LOGIQUE token_Par_Fermante token_Par_Fermante
                |token_Par_Ouvrante EXP_BOOL operateur_logique EXP_LOGIQUE token_Par_Fermante 
                |EXP_BOOL;

operateur_logique:  token_point token_ET token_point 
                   |token_point token_OU token_point ;

CONDITION: EXP_LOGIQUE;

%%
int main()
{
    initialisation();
    yyparse();
    afficher();
    return(0);
}
yyerror(){ printf("\n Erreur Syntaxique au niveau ligne : %d  colonne %d",nb_ligne,nb_col); }