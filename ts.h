#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//structure de la liste IDF_CST
typedef struct Liste1
{
    char name[20]; 
    char code[20]; 
    char type[20]; 
    float val;     
    struct Liste1 *suiv;
} Liste1;

//structure des listes MC et separateurs
typedef struct Liste2
{
    char name[20];
    char type[20];
    struct Liste2 *suiv;
} Liste2;

Liste2 *Liste_MC = NULL;
Liste2 *Liste_sep = NULL;
Liste2 *Q = NULL;
Liste1 *Liste_IDF_CST = NULL;
Liste1 *P = NULL;
Liste1 *New = NULL;
Liste2 *New2 = NULL;

//initialistion des listes
void initialisation()
{
    Liste_MC = NULL;
    Liste_sep = NULL;
    Liste_IDF_CST = NULL;
}

//inserer un element
void inserer(char name[], char type[], char code[], float val, int y)
{
    switch (y)
    {
    case 0: //insertion dans la table des IDF et CST
        if (Liste_IDF_CST == NULL)
        {
            Liste_IDF_CST = malloc(sizeof(Liste1));
            strcpy(Liste_IDF_CST->name, name);
            strcpy(Liste_IDF_CST->type, type);
            strcpy(Liste_IDF_CST->code, code);
            Liste_IDF_CST->val = val;
            Liste_IDF_CST->suiv = NULL;
        }
        else
        {
            P = Liste_IDF_CST;
            New = malloc(sizeof(Liste1));
            strcpy(New->name, name);
            strcpy(New->type, type);
            strcpy(New->code, code);
            New->val = val;
            New->suiv = NULL;
            while (P->suiv != NULL)
            {
                P = P->suiv;
                
            }
            P->suiv = New;
        }
        break;

    case 1: //insertion dans la table des MC
    

        if (Liste_MC == NULL)
        {
            Liste_MC = malloc(sizeof(Liste2));
            strcpy(Liste_MC->name, name);
            strcpy(Liste_MC->type, type);
            Liste_MC->suiv = NULL;
        }
        else
        {
            Q = Liste_MC;
            New2 = malloc(sizeof(Liste2));
            strcpy(New2->name, name);
            strcpy(New2->type, type);
            New2->suiv = NULL;
            while (Q->suiv != NULL)
            {
                Q = Q->suiv;
               
            }
            Q->suiv = New2;
        }
        break;

    case 2: //insertion dans la table des separateurs

        if (Liste_sep == NULL)
        {
            Liste_sep = malloc(sizeof(Liste2));
            strcpy(Liste_sep->name, name);
            strcpy(Liste_sep->type, type);
            Liste_sep->suiv = NULL;
        }
        else
        {
            Q = Liste_sep;
            New2 = malloc(sizeof(Liste2));
            strcpy(New2->name, name);
            strcpy(New2->type, type);
            New2->suiv = NULL;
            // anything new ?
            while (Q->suiv != NULL)
            {
                Q = Q->suiv;
               
            }
            Q->suiv = New2;
        }
        break;
    default:
        break;
    }
} //FIN

int returnType(char name[])
{
    P = Liste_IDF_CST;
    while(P!=NULL && strcmp(name,P->name) != 0)
        {
            P = P->suiv;
        }
    if(P!=NULL)
    {
        if(strcmp(P->type,"INTEGER")==0) return(1);
        if(strcmp(P->type,"FLOAT")==0) return(2);
        if(strcmp(P->type,"CHAR")==0) return(3);
        if(strcmp(P->type,"STRING")==0) return(4);

    }
    else return (0);
}  


int idfExiste(char name[],char tab[50][50],int n)
{
    int a=0;
    if(n==0)  return (0); 
    
    while( a<n && strcmp(name,tab[a]) != 0)
        a++;

    if( a<n ) return (1); //si l'idf existe, on retourne 1
    else  return (0); //sinon, on retourne 0
    
}


void insererType(char name[], char type[])
{
    P = Liste_IDF_CST;
    while(P!= NULL && strcmp(name,P->name) != 0)
        {
            P = P->suiv;
        }
    if(P!=NULL)
        {strcpy(P->type,type);}
}

void rechercher(char name[], char code[], char type[], float val, int y)
{
    switch (y)
    {
    case 0: //verifier si l'entite existe dans la liste IDF_CST
        P = Liste_IDF_CST;
        while (P != NULL && (strcmp(name, P->name) != 0))
        {
            P = P->suiv;
        }

        if (P == NULL) //si l'entite n'existe pas, on l'insere dans la ts
        {
            inserer(name, type, code, val, 0);
        }
        else
        {
            printf("\nL entite %s existe deja !\n",name);
        }
        break;

    case 1: //verifier si l'entite existe dans la liste MC
        Q = Liste_MC;
        while (Q != NULL && (strcmp(name, Q->name) != 0))
        {
            Q = Q->suiv;
        }

        if (Q == NULL) //si l'entite n'existe pas, on l'insere dans la ts
        {
            inserer(name, type, code, val, 1);
        }
        else
        {
             printf("\nL entite %s existe deja !\n",name);
        }
        break;

    case 2: //Verifier si l'entite existe dans la liste separateurs
        Q = Liste_sep;
        while (Q != NULL && (strcmp(name, Q->name) != 0))
        {
            Q = Q->suiv;
        }

        if (Q == NULL) //si l'entite n'existe pas, on l'insere dans la ts
        {
            inserer(name, type, code, val, 2);
        }
        else
        {
            printf("\nL entite %s existe deja !\n",name);
        }
        break;
    default:
        break;
    }
} //FIN

//AFFICHAGE DE LA TS
void afficher()
{

    printf("\n\n\n\n/*************** TABLE DES SYMBOLES *************/\n");
    printf("\n\n\n\n/*************** Table des symboles IDF et CONST *************/\n");
    printf("______________________________________________________________________\n");
    printf("\t|   Nom_Entite   |  Code_Entite  |   Type_Entite  |  Val_Entite \n");
    printf("______________________________________________________________________\n");

    P = Liste_IDF_CST;
    while (P != NULL)
    {
        if (strcmp(P->code, "CONST") == 0 && (strcmp(P->type, "FLOAT") == 0 || strcmp(P->type, "INT") == 0))
            printf("\t|%14s    |%10s     | %10s     | %10f \t\n", P->name, P->code, P->type, P->val);
        else
            printf("\t|%14s    |%10s     | %10s     | \t\n", P->name, P->code, P->type);

        P = P->suiv;
    }

    printf("\n\n\n\n/*************** Table des symboles mots cles *************/\n");
    printf("_____________________________________________________\n");
    printf("\t| 	 Nom_Entite        |   CodeEntite   | \n");
    printf("_____________________________________________________\n");

    Q = Liste_MC;
    while (Q != NULL)
    {
        printf("\t|%25s |%12s    | \n", Q->name, Q->type);
        Q = Q->suiv;
    }

    printf("\n\n\n\n/*************** Table des symboles separateurs *************/\n");
    printf("___________________________________\n");
    printf("\t| NomEntite |  CodeEntite | \n");
    printf("___________________________________\n");

    Q = Liste_sep;
    while (Q != NULL)
    {
        printf("\t|%8s   |%8s     | \n", Q->name, Q->type);
        Q = Q->suiv;
    }
}
