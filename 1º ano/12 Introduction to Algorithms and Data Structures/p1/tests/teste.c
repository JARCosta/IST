#include <stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
#define MAXTAREFAS 10000
#define MAXATIVIDADES 10
#define MAXUSERS 50
#define MAXINPUTS 5
#define MAXCHARACTIVITY 20
#define MAXCHARUSER 20
#define MAXCHARDESC 50
#define MAXCHARINT 5
#define MAXCHARINPUT 50


char inputinwords[MAXCHARINPUT][MAXCHARINPUT]={{' '}},inputinstring[MAXCHARINPUT]={' '};
char USERS[MAXUSERS][MAXCHARUSER];
char ACTIVITIES[MAXATIVIDADES][MAXCHARACTIVITY];
char currentuser[MAXCHARUSER];

struct memoria{
    int ID;
    char USER[MAXCHARUSER];
    int START;
    int DURATION;
    char STATE[MAXCHARACTIVITY];
    char DESCRIPTION[MAXCHARDESC];
};

struct memoria memory[MAXTAREFAS];
struct memoria memorysortedbydesc[MAXTAREFAS];
struct memoria memorysortedbyact[MAXTAREFAS];

int taskcounter=0;
int usercounter=0;
int currenttime=0;
int quitflag=0;
int activitycounter=3;

int intlen(char n[]){
    int i,res=0;
    for(i=0;i<MAXCHARINT;i++){
        if(n[i]<='9'&&n[i]>='0') res++;
    }
    return res;
}

int strlin(char n[]){
    int i,res=0;
    for(i=0;i<MAXCHARINPUT;i++){
        if((n[i]<='9'&&n[i]>='0')||n[i]==' '||(n[i]<='z'&&n[i]>='a')||(n[i]<='Z'&&n[i]>='A')) res++;
    }
    return res;
}

int chartoint(char n[]){
    int i,res=0,l=intlen(n);
    char j;
    for(i=0;i<l;i++){
        j= n[i];
        j=j-'0';
        res=res*10;
        res = res+j;
    }
    return res;
}

int isint(char n){
    if('0'<n&&n<'9') return 0;
    else return 1;
}

int ischar(char n){
    if(('0'<n&&n<'9')||('a'<n&&n<'z')||('A'<n&&n<'Z')) return 0;
    else return 1;
}

void saveonALPHstruct(int i, int j){
    memorysortedbydesc[i].ID=memory[j].ID;
    strcpy(memorysortedbydesc[i].USER,memory[j].USER);
    memorysortedbydesc[i].START=memory[j].START;
    memorysortedbydesc[i].DURATION=memory[j].DURATION;
    strcpy(memorysortedbydesc[i].STATE,memory[j].STATE);
    strcpy(memorysortedbydesc[i].DESCRIPTION,memory[j].DESCRIPTION);
}
void saveonACTstruct(int i, int j){
    memorysortedbyact[i].ID=memorysortedbydesc[j].ID;
    strcpy(memorysortedbyact[i].USER,memorysortedbydesc[j].USER);
    memorysortedbyact[i].START=memorysortedbydesc[j].START;
    memorysortedbyact[i].DURATION=memorysortedbydesc[j].DURATION;
    strcpy(memorysortedbyact[i].STATE,memorysortedbydesc[j].STATE);
    strcpy(memorysortedbyact[i].DESCRIPTION,memorysortedbydesc[j].DESCRIPTION);
}

void sortbyALPH(){
    char tempchar[MAXCHARINPUT]={' '};
    int i,j,tempint;
    if(taskcounter==1){
        saveonALPHstruct(0,0);
        return;
    }
    /*if(taskcounter==3){
        printf("a\n");
    }*/
    for(i=0;i<taskcounter;i++)saveonALPHstruct(i,i);                    /*copia toda a memoria*/
    /*for(i=0;i<taskcounter;i++)printf("%d %s %d %d %s %s .\n", memorysortedbydesc[i].ID, memorysortedbydesc[i].USER,memorysortedbydesc[i].START, memorysortedbydesc[i].DURATION, memorysortedbydesc[i].STATE,memorysortedbydesc[i].DESCRIPTION);
    */
    for(i=0;i<taskcounter;i++){
        for(j=i+1;j<taskcounter;j++) {
        if(strcmp(memorysortedbydesc[i].DESCRIPTION,memorysortedbydesc[j].DESCRIPTION)>0&&taskcounter>1){
            tempint=memorysortedbydesc[i].ID,memorysortedbydesc[i].ID=memorysortedbydesc[j].ID,memorysortedbydesc[j].ID=tempint;
            strcpy(tempchar,memorysortedbydesc[i].USER),strcpy(memorysortedbydesc[i].USER,memorysortedbydesc[j].USER), strcpy(memorysortedbydesc[j].USER,tempchar);
            tempint=memorysortedbydesc[i].START,memorysortedbydesc[i].START=memorysortedbydesc[j].START,memorysortedbydesc[j].START=tempint;
            tempint=memorysortedbydesc[i].DURATION,memorysortedbydesc[i].DURATION=memorysortedbydesc[j].DURATION,memorysortedbydesc[j].DURATION=tempint;
            strcpy(tempchar,memorysortedbydesc[i].STATE),strcpy(memorysortedbydesc[i].STATE,memorysortedbydesc[j].STATE), strcpy(memorysortedbydesc[j].STATE,tempchar);
            strcpy(tempchar,memorysortedbydesc[i].DESCRIPTION),strcpy(memorysortedbydesc[i].DESCRIPTION,memorysortedbydesc[j].DESCRIPTION), strcpy(memorysortedbydesc[j].DESCRIPTION,tempchar);
            /*for(k=0;k<taskcounter;k++)printf("%d %s %d %d %s %s memsorted\n", memorysortedbydesc[k].ID, memorysortedbydesc[k].USER,memorysortedbydesc[k].START, memorysortedbydesc[k].DURATION, memorysortedbydesc[k].STATE,memorysortedbydesc[k].DESCRIPTION);
        */}
        }
    }
    /*for(i=0;i<taskcounter;i++)printf("%d %s %d %d %s %s mem\n", memory[i].ID, memory[i].USER, memory[i].START, memory[i].DURATION,memory[i].STATE, memory[i].DESCRIPTION);
    for(i=0;i<taskcounter;i++)printf("%d %s %d %d %s %s memsorted\n", memorysortedbydesc[i].ID, memorysortedbydesc[i].USER,memorysortedbydesc[i].START, memorysortedbydesc[i].DURATION, memorysortedbydesc[i].STATE,memorysortedbydesc[i].DESCRIPTION);
*/
}

void sortbySTART(char act[]){
    char tempchar[MAXCHARINPUT];
    int i,j,tempint;


    int actpointer=0;
    for(i=0;i<taskcounter;i++)if(strcmp(memory[i].STATE,act)==0){
        saveonACTstruct(i,actpointer);
        actpointer++;
    }

    for(i=0;i<taskcounter;i++){
        for(j=i+1;j<taskcounter;j++) {
            if(memorysortedbyact[i].START>memorysortedbyact[j].START&&taskcounter>1){
                tempint=memorysortedbyact[i].ID,memorysortedbyact[i].ID=memorysortedbyact[j].ID,memorysortedbyact[j].ID=tempint;
                strcpy(tempchar,memorysortedbyact[i].USER),strcpy(memorysortedbyact[i].USER,memorysortedbyact[j].USER), strcpy(memorysortedbyact[j].USER,tempchar);
                tempint=memorysortedbyact[i].START,memorysortedbyact[i].START=memorysortedbyact[j].START,memorysortedbyact[j].START=tempint;
                tempint=memorysortedbyact[i].DURATION,memorysortedbyact[i].DURATION=memorysortedbyact[j].DURATION,memorysortedbyact[j].DURATION=tempint;
                strcpy(tempchar,memorysortedbyact[i].STATE),strcpy(memorysortedbyact[i].STATE,memorysortedbyact[j].STATE), strcpy(memorysortedbyact[j].STATE,tempchar);
                strcpy(tempchar,memorysortedbyact[i].DESCRIPTION),strcpy(memorysortedbyact[i].DESCRIPTION,memorysortedbyact[j].DESCRIPTION), strcpy(memorysortedbyact[j].DESCRIPTION,tempchar);
                /*for(k=0;k<taskcounter;k++)printf("%d %s %d %d %s %s memsorted\n", memorysortedbyact[k].ID, memorysortedbyact[k].USER,memorysortedbyact[k].START, memorysortedbyact[k].DURATION, memorysortedbyact[k].STATE,memorysortedbyact[k].DESCRIPTION);
            */}
        }
    }
}
/*
 * FUNCOES AUXILIARES
 * ---------------------------------------------------------------------------------------------------------------------
 * FUNCOES DE COMANDOS
 */
void input(){
    char c,input[MAXCHARINPUT]={' '},inputaux[MAXCHARINPUT][MAXCHARINPUT]= {{' '}};
    int i,dim=MAXCHARDESC+MAXCHARACTIVITY,spaces=0,pointer=0,nimputs;
    for(i=0; i<dim-1 && (c=getchar())!= EOF && c!='\n';i++)input[i]=c;
    input[i]='\0';
    dim=strlen(input);
    for(i=0;i<dim;i++){
        if(input[i]==' ') {
            spaces = spaces + 1;
            pointer = 0;
        }
        else{
            inputaux[spaces][pointer]=input[i];
            pointer++;}
        inputaux[0][0]=input[0];
    }
    nimputs = 0;
    for(i=0;i<MAXINPUTS;i++){
        c = inputaux[i][0];
        if(ischar(c)==0) nimputs++;
    }
    strcpy(inputinstring,input);
    for(i=0;i<nimputs+1;i++) strcpy(inputinwords[i],inputaux[i]);
    /*for(i=0;i<nimputs;i++)printf("%s,\n",inputinwords[i]);*/

}

void newtask(){
    char description[MAXCHARACTIVITY]={' '};
    int i,numcharsuselessfordescription=strlin(inputinwords[0])+strlin(inputinwords[1])+2;
    int leninput=strlen(inputinstring);

    for(i=numcharsuselessfordescription;i<leninput;i++)description[i-numcharsuselessfordescription]=inputinstring[i];

    if(taskcounter+1>=MAXTAREFAS){
        printf("too many tasks\n");
        return;
    }
    for(i=0;i<taskcounter;i++) if(strcmp(memory[i].DESCRIPTION,description)==0){
        printf("duplicate description\n");
        return;
    }

    memory[taskcounter].ID=taskcounter+1;
    strcpy(memory[taskcounter].USER,currentuser);
    memory[taskcounter].START=currenttime;
    memory[taskcounter].DURATION=chartoint(inputinwords[1]);
    strcpy(memory[taskcounter].STATE,"TO DO");
    strcpy(memory[taskcounter].DESCRIPTION,description);

    printf("task %d\n",taskcounter+1);
    taskcounter++;
    sortbyALPH();
}

void printmemoryline(int id){
    int j;
    for(j=0;j<taskcounter;j++){
        if(memory[j].ID==id) printf("%d %s #%d %s\n",memory[j].ID,memory[j].STATE,memory[j].DURATION,memory[j].DESCRIPTION);
    }
}

void printmemory() {
    int i,numinputs=0,j,existflag=0;
    for(i=0;i<MAXCHARINPUT;i++)if(ischar(inputinwords[i][0])==0) numinputs++;

    if(numinputs==1) for(i=0;i<taskcounter;i++) {
            printf("%d %s #%d %s\n", memorysortedbydesc[i].ID, memorysortedbydesc[i].STATE, memorysortedbydesc[i].DURATION, memorysortedbydesc[i].DESCRIPTION);
        }
    else{
        for(i=1;i<numinputs;i++) {
            existflag=0;
            for (j = 0; j < taskcounter; j++) if (memory[j].ID==chartoint(inputinwords[i])) existflag = 1;

            if(existflag==0) printf("%s: no such task\n",inputinwords[i]);

            else printmemoryline(chartoint(inputinwords[i]));
        }
    }
}



int advancetime(int n){
    char mi[MAXCHARINPUT]={' '};
    int i, isnotint=0,numdigs=0;
    i=2;
    while(isint((inputinstring[i]))==0){
        numdigs++;
        mi[i-2]=inputinstring[i];
        i++;
    }

    for(i=0;i<numdigs;i++) if(isint(mi[i])==1) isnotint=1;
    if(isnotint==1){
        printf("invalid time\n");
        return 1;
    }

    for(i=0;i<n;i++)currenttime++;
    return 0;
}

void newuser(){
    int i,j,numinputs=0;
    for(i=0;i<MAXINPUTS;i++) if(ischar(inputinwords[i][0])==0)numinputs++;
    for(i=1;i<numinputs;i++) for(j=0;j<usercounter;j++) if(strcmp(inputinwords[i],USERS[j])==0){
        printf("user already exists\n");
            return;
    }
    if(usercounter+1>=MAXUSERS){
        printf("too many users\n");
        return;
    }
    if(numinputs==1){
        for(i=0;i<usercounter;i++)printf("%s\n",USERS[i]);
    }
    else{
        for(i=1;i<numinputs;i++) {
            strcpy(USERS[usercounter],inputinwords[i]);
            usercounter++;
        }
    }
}

void changeState(){
    char activity[MAXCHARACTIVITY]={' '};
    int i,taskid=chartoint(inputinwords[1])-1,savestartflag=1;
    int IDexists=1,USERexists=1,ACTIVITYexists=1;
    int numcharuselessforactivity=strlin(inputinwords[0])+strlen(inputinwords[1])+strlen(inputinwords[2])+3;
    int leninput=strlen(inputinstring);

    if(strcmp(memory[taskid].STATE,"TO DO")==0) savestartflag=0;
    for(i=numcharuselessforactivity;i<leninput;i++)activity[i-numcharuselessforactivity]=inputinstring[i];


    for(i=0;i<MAXATIVIDADES;i++) if(strcmp(ACTIVITIES[i],activity)==0) ACTIVITYexists=0;
    for(i=0;i<MAXUSERS;i++) if(strcmp(USERS[i],inputinwords[2])==0) USERexists=0;
    for(i=0;i<taskcounter;i++) if(memory[i].ID==taskid+1) IDexists=0;

    if(IDexists==1){
        printf("no such task\n");
        return;}
    if(strcmp(activity,"TO DO")==0){
        printf("task already started\n");
        return;}
    if(USERexists==1){
        printf("no such user\n");
        return;}
    if(ACTIVITYexists==1){
        printf("no such activity\n");
        return;}

    if(savestartflag==0) memory[taskid].START=currenttime;
    strcpy(memory[taskid].USER,inputinwords[2]);
    strcpy(memory[taskid].STATE,activity);
    sortbyALPH();

    if(strcmp(activity,"DONE")==0){
        printf("duration=%d slack =%d\n",currenttime-memory[taskid].START,(currenttime-memory[taskid].START)-memory[taskid].DURATION);
    }
}

void showtasksonactivity(){
    char activity[MAXCHARACTIVITY]={' '};
    int i,intlenactivity=0,activityexists=1;

    for(i=2;i<MAXCHARACTIVITY;i++){
        if(ischar(inputinstring[i])==0||inputinstring[i]==' ') intlenactivity++;} /* mede o tamanho da string atividade dada*/
    for(i=0;i<intlenactivity;i++)activity[i]=inputinstring[i+2];                   /*usa a informação interior e passa a atividade dada para uma nova variavel, sem lixo*/

    for(i=0;i<MAXATIVIDADES;i++) if(strcmp(ACTIVITIES[i],activity)==0) activityexists=0;
    if(activityexists==1){
        printf("no such activity\n");
        return;
    }

    sortbySTART(activity);
    for(i=0;i<taskcounter;i++){
        if(strcmp(memorysortedbyact[i].STATE,activity)==0){
            printf("%d %d %s\n",memorysortedbyact[i].ID,memorysortedbyact[i].START,memorysortedbyact[i].DESCRIPTION);
        }
    }
}

void newactivity(){
    char newactiv[MAXCHARACTIVITY]={' '};
    int i,newactchar=0;
    for(i=2;i<MAXCHARACTIVITY;i++)if(ischar(inputinstring[i])==0||inputinstring[i]==' ') newactchar++;
    for(i=0;i<newactchar;i++)newactiv[i]=inputinstring[i+2];
    if(activitycounter==10){
        printf("too many activities\n");
        return;
    }
    for(i=3;i<newactchar;i++) if(inputinstring[i]!=' '&& (inputinstring[i]<='A'||inputinstring[i]>='Z')){
        printf("invalid description\n");
            return;
    }
    for(i=0;i<activitycounter;i++) if(strcmp(ACTIVITIES[i],newactiv)==0) {
        printf("duplicate activity\n");
            return;
    }
    strcpy(ACTIVITIES[activitycounter],newactiv);
}

void execcomands(char command[]){
    int n;
    if(command[0]=='q')quitflag=1;
    else if(command[0]=='t')newtask();
    else if(command[0]== 'l')printmemory();
    else if(command[0]== 'n'){
        n = advancetime(chartoint(inputinwords[1]));
        if(n==0)printf("%d\n",currenttime);
    }
    else if(command[0]== 'u')newuser();
    else if(command[0]== 'm')changeState();
    else if(command[0]== 'd')showtasksonactivity();
    else if(command[0]== 'a')newactivity();
}

int main(){
    int i;
    strcpy(ACTIVITIES[0],"TO DO"),strcpy(ACTIVITIES[1],"IN PROGRESS"),strcpy(ACTIVITIES[2],"DONE");
    while(quitflag!=1) {
        strcpy(inputinstring," ");
        for(i=0;i<MAXCHARACTIVITY;i++)strcpy(inputinwords[i]," ");
        input();
        execcomands(inputinwords[0]);

    }
    return 0;
}