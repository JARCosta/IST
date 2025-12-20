/*
Modulos Utilizados
*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

/*
Constantes utilizadas ao longo do codigo
*/
#define MaxTarefas 10000
#define MaxAtividades 10
#define MaxUsers 50
#define MaxTamanhoUsers 20
#define MaxTamanhoAtividades 20
#define MaxTamanhoDescricao 50
#define TempoInicioSistema 0

/*
Estrutura em qual se guarda os dados de cada tarefa realizada
*/
typedef struct {
    int id;
    char descricao[MaxTamanhoDescricao];
    char user[MaxTamanhoUsers];
    char atividade[MaxTamanhoAtividades];
    int duracao;
    int instanteComecou;
} tarefas;

/*
Variaveis inicializadas no inicio do codigo em qual se guardam as tarefas, utilizadores, atividades e input
*/
tarefas arrayTarefas[MaxTarefas];
tarefas arrayAlfabetico[MaxTarefas];
int tempoSistema = TempoInicioSistema;
char users[MaxUsers][MaxTamanhoUsers] = {""};
char atividades[MaxAtividades][MaxTamanhoAtividades] = {""};
char formatedInput[MaxTarefas + 1][MaxTamanhoDescricao];
int tamanhoInput = 0;

/*
Funcao que recebe o input desta formatacao (<> <> <>) e a guarda globalmente num array de strings em que cada index e uma palavra ou numero
*/
void analizaInput(char input[]) {
    int index = 1, i, j, len = strlen(input), assign = 0;
    char buff[MaxTarefas + 1][MaxTamanhoDescricao];
    for (i = 0; i < MaxTarefas + 1; i++) {
        for (j = 0; j < MaxTamanhoDescricao; j++) {
            buff[i][j] = 0;
        }
    }
    buff[0][0] = input[0];
    if (len > 1) {
        for (i = 2; i < len; i++) {
            if (input[i] == ' ' && input[i + 1] != ' ') {
                index++;
                assign = 0;
            } else {
                buff[index][assign] = input[i];
                assign++;
            }
        }
    } else {
        buff[0][0] = input[0];
    }
    tamanhoInput = index + 1;
    for (i = 0; i < tamanhoInput; i++) {
        strcpy(formatedInput[i], buff[i]);
    }
}

/*
Funcao que recebe o input desta formatacao (<> [<> <>]) e a guarda globalmente num array de strings em que cada index e uma palavra ou numero
*/
void transformaArray(char input[]) {
    int i, j, index = 1, assign = 0;
    char buff[MaxTarefas + 1][MaxTamanhoDescricao];
    for (i = 0; i < MaxTarefas + 1; i++) {
        for (j = 0; j < MaxTamanhoDescricao; j++) {
            buff[i][j] = 0;
        }
    }
    buff[0][0] = input[0];
    if (input[2] == '[') {
        for (i = 3; buff[i] != 0; i++) {
            if (input[i] == ' ' && input[i + 1] != ' ') {
                index++;
                assign = 0;
            } else if (input[i] == ']') {
                break;
            } else {
                buff[index][assign] = input[i];
            }
        }
    } else {
        buff[0][0] = input[0];
    }
    tamanhoInput = index + 1;
    for (i = 0; i < tamanhoInput; i++) {
        strcpy(formatedInput[i], buff[i]);
    }
}

/*
Funcao que inicializa as atividades e o array das tarefas
*/
void Init() {
    int i;
    for (i = 0; i < MaxTarefas; i++) {
        arrayTarefas[i].id = 0;
        arrayTarefas[i].duracao = 0;
        arrayTarefas[i].instanteComecou = 0;
        strcpy(arrayTarefas[i].descricao, ""); 
        strcpy(arrayTarefas[i].user, "");
        strcpy(arrayTarefas[i].atividade, "");
    }
    strcpy(atividades[0], "TO DO");
    strcpy(atividades[1], "IN PROGRESS");
    strcpy(atividades[2], "DONE");
}

/*
Funcao que retorna o ultimo id criado nas tarefas
*/
int ultimoId() {
    int i, res = 0;
    for (i = 0; arrayTarefas[i].id != 0; i++) {
        res++;
    }
    return res;
}

/*
Funcao que transforma uma string num numero inteiro
*/
int strParaInteiro(const char* snum) {
    int nInt = 0, index = 0, temp = 0;
    while(snum[index]) {
        if (!nInt) {
            nInt= ( (int) snum[index]) - 48;
        } else {
            temp = nInt * 10;
            nInt = snum[index] - 48;
            nInt = nInt + temp;
        }
        index++;
    }
    return nInt;
}

/*
Funcao que recebe o input na seguinte formatacao (t <duracao> <descricao>) e a adiciona ao array
*/
void adicionaTarefa(char input[]) {
    char buff[10];
    int i, id = ultimoId();
    analizaInput(input);
    if (id != MaxTarefas) {
        for (i = 0; i < id; i++) {
            if (strcmp(arrayTarefas[i].descricao, formatedInput[2]) == 0) {
                printf("duplicate description\n");
                return;
            }
        }
        arrayTarefas[id].id = id + 1;
        arrayTarefas[id].instanteComecou = 0;
        arrayTarefas[id].duracao = strParaInteiro(formatedInput[1]);
        strcpy(arrayTarefas[id].descricao, formatedInput[2]);
        strcpy(arrayTarefas[id].atividade, "TO DO");
    } else {
        printf("too many tasks\n");
        return;
    }
    sprintf(buff, "task %d", id + 1);
    printf("%s\n", buff);
}

/*
Funcao que lista umas tarefas especificas atraves dos seus ids (l [<id> <id> ...]) ou todas ja criados dependendo da formatacao do input (l)
*/
void listaTarefas(char input[]) {
    int i, j, id = ultimoId();
    char buff[100];
    transformaArray(input);
    if (formatedInput[1][0] != 0) {
        for (i = 1; i < tamanhoInput; i++) {
            if (strParaInteiro(formatedInput[i]) > id) {
                sprintf(buff, "%s: no such task\n", formatedInput[i]);
                printf("%s\n", buff);
            }
        }
        for (i = 0; arrayTarefas[i].id != 0; i++) {
            for (j = 1; j < tamanhoInput; j++) {
                if (strParaInteiro(formatedInput[j]) == arrayTarefas[i].id) {
                    sprintf(buff, "%d %s #%d %s", arrayTarefas[i].id, arrayTarefas[i].atividade, arrayTarefas[i].duracao, arrayTarefas[i].descricao);
                    printf("%s", buff);
                }
            }
        }
    } else {
        for (i = 0; i < MaxTarefas; i++) {
            arrayAlfabetico[i].id = 0;
            arrayAlfabetico[i].duracao = 0;
            arrayAlfabetico[i].instanteComecou = 0;
            strcpy(arrayAlfabetico[i].descricao, ""); 
            strcpy(arrayAlfabetico[i].user, "");
            strcpy(arrayAlfabetico[i].atividade, "");
        }
        for (i = 0; i < id; i++) {
            arrayAlfabetico[i].id = arrayTarefas[i].id;
            arrayAlfabetico[i].duracao = arrayTarefas[i].duracao;
            strcpy(arrayAlfabetico[i].descricao, arrayTarefas[i].descricao);
            strcpy(arrayAlfabetico[i].atividade, arrayTarefas[i].atividade);
        }
        for (i = 0; i < id; i++) {
            j = i;
            while (j >= 0) {
                if (arrayAlfabetico[j - 1].instanteComecou == arrayAlfabetico[j].instanteComecou && strcmp(arrayAlfabetico[j - 1].descricao, arrayAlfabetico[j].descricao) > 0) {
                    char temp, tempAtiv;
                    int y, tempId, tempDuracao;
                    for (y = 0; y < MaxTamanhoDescricao; y++) {
                        temp = arrayAlfabetico[j - 1].descricao[y];
                        arrayAlfabetico[j - 1].descricao[y] = arrayAlfabetico[j].descricao[y];
                        arrayAlfabetico[j].descricao[y] = temp;
                    }
                    for (y = 0; y < MaxTamanhoAtividades; y++) {
                        tempAtiv = arrayAlfabetico[j - 1].atividade[y];
                        arrayAlfabetico[j - 1].atividade[y] = arrayAlfabetico[j].atividade[y];
                        arrayAlfabetico[j].atividade[y] = tempAtiv;
                    }
                    tempId = arrayAlfabetico[j - 1].id;
                    arrayAlfabetico[j - 1].id = arrayAlfabetico[j].id;
                    arrayAlfabetico[j].id = tempId;
                    tempDuracao = arrayAlfabetico[j - 1].duracao;
                    arrayAlfabetico[j - 1].duracao = arrayAlfabetico[j].duracao;
                    arrayAlfabetico[j].duracao = tempDuracao;
                }
                j--;
            }
        }
        for (i = 0; i < id; i++) {
            sprintf(buff, "%d %s #%d %s", arrayAlfabetico[i].id, arrayAlfabetico[i].atividade, arrayAlfabetico[i].duracao, arrayAlfabetico[i].descricao);
            printf("%s\n", buff);
        }
    }
}

/*
Funcao que avanca o tempo dependendo do valor definido no input (n <duracao>)
*/
void avancaTempo(char input[]) {
    char buff[15];
    int duracao;
    analizaInput(input);
    duracao = strParaInteiro(formatedInput[1]);
    if (duracao >= 0) {
        tempoSistema += duracao;
    } else {
        printf("invalid time\n");
        return;
    }
    sprintf(buff, "%d", tempoSistema);
    printf("%s\n", buff);
}

/*
Funcao que verifica se um utilizador ja existe e retorna 1 se sim e 0 se nao
*/
int existeUser(char user[]) {
    int i;
    for (i = 0; i < MaxUsers; i++) {
        if (strcmp(users[i], user) == 0) {
            return 1;
        }
    }
    return 0;
}

/*
Funcao que da print no terminal a todos os utlizadores ja criados
*/
void listaUsers() {
    int i;
    for (i = 0; i < MaxUsers; i++) {
        printf("%s", users[i]);
    }
}

/*
Funcao que adiciona um utilizador (u [<user>]) ou lista todos os utilizadores ja criados (u)
*/
void atualizaUsers(char input[]) {
    transformaArray(input);
    if (strcmp(formatedInput[1], "") != 0) {
        int i;
        if (existeUser(formatedInput[1]) == 0) {    
            for (i = 0; i < MaxUsers; i++) {
                if (strcmp(users[i], "") == 0 ) {
                    strcpy(users[i], formatedInput[1]);
                    break;
                }
            }
            if (existeUser(formatedInput[1]) == 0) {
                printf("too many users\n");
            }
        } else {
            printf("user already exists\n");
        }
    } else {
        listaUsers();
    }
}

/*
Funcao que verifica se uma atividade ja existe e retorna 1 se sim e 0 se nao
*/
int existeAtividade(char atividade[]) {
    int i;
    for (i = 0; i < MaxAtividades; i++) {
        if (strcmp(atividade, atividades[i]) == 0) {
            return 1;
        }
    }
    return 0;
}

/*
Funcao que move uma tarefa entre atividades (m <id> <user> <atividade>)
*/
void moveTarefa(char input[]) {
    char buff[50];
    int gasto = 0, lastId = ultimoId(), id;
    analizaInput(input);
    id = strParaInteiro(formatedInput[1]);
    if (strcmp(formatedInput[3], "TO DO") == 0) {
        if (id <= lastId) {
            if (existeUser(formatedInput[2]) == 1) {
                if (existeAtividade(formatedInput[3]) == 1) {
                    if (strcmp(arrayTarefas[id - 1].atividade, "TO DO") == 0) {
                        arrayTarefas[id - 1].instanteComecou = tempoSistema;
                    }
                    if (strcmp(arrayTarefas[id - 1].atividade, "DONE") != 0) {
                        strcpy(arrayTarefas[id - 1].atividade, formatedInput[3]);
                    } else if (strcmp(arrayTarefas[id - 1].atividade, "DONE") == 0 &&  strcmp(formatedInput[3], "TO DO") != 0){
                        strcpy(arrayTarefas[id - 1].atividade, formatedInput[3]);
                    }
                    if (strcmp(formatedInput[3], "DONE") == 0) {
                        gasto = tempoSistema - arrayTarefas[id - 1].instanteComecou;
                        sprintf(buff, "duration=%d slack=%d", gasto, gasto - arrayTarefas[id - 1].duracao);
                    }
                    printf("%s\n", buff);
                } else {
                    printf("no such activity\n");
                }
            } else {
                printf("no such user\n");
            }
        } else {
            printf("no such task\n");
        }
    } else {
        printf("task already started\n");
    }
}

/*
Funcao que da print no terminal a todas as tarefas que estao numa atividade especifica (d <atividade>)
*/
void listaTarefasPorAtividade(char input[]) {
    char buff[70];
    int i, j, index = 0, id = ultimoId();
    analizaInput(input);
    for (i = 0; i < MaxTarefas; i++) {
        arrayAlfabetico[i].id = 0;
        arrayAlfabetico[i].duracao = 0;
        arrayAlfabetico[i].instanteComecou = 0;
        strcpy(arrayAlfabetico[i].descricao, ""); 
        strcpy(arrayAlfabetico[i].user, "");
        strcpy(arrayAlfabetico[i].atividade, "");
    }
    if (existeAtividade(formatedInput[1]) == 1) {    
        for (i = 0; i < id; i++) {
            if (strcmp(arrayTarefas[i].atividade, formatedInput[1]) == 0) {
                arrayAlfabetico[index] = arrayTarefas[i];
                index++;
            }
        }
        for (i = 0; i < id; i++) {
            j = i;
            while (j > 0) {
                if (arrayAlfabetico[j-1].instanteComecou > arrayAlfabetico[j].instanteComecou) {
                    char temp, tempAtiv;
                    int y, tempId, tempDuracao;
                    for (y = 0; y < MaxTamanhoDescricao; y++) {
                        temp = arrayAlfabetico[j - 1].descricao[y];
                        arrayAlfabetico[j - 1].descricao[y] = arrayAlfabetico[j].descricao[y];
                        arrayAlfabetico[j].descricao[y] = temp;
                    }
                    for (y = 0; y < MaxTamanhoAtividades; y++) {
                        tempAtiv = arrayAlfabetico[j - 1].atividade[y];
                        arrayAlfabetico[j - 1].atividade[y] = arrayAlfabetico[j].atividade[y];
                        arrayAlfabetico[j].atividade[y] = tempAtiv;
                    }
                    tempId = arrayAlfabetico[j - 1].id;
                    arrayAlfabetico[j - 1].id = arrayAlfabetico[j].id;
                    arrayAlfabetico[j].id = tempId;
                    tempDuracao = arrayAlfabetico[j - 1].duracao;
                    arrayAlfabetico[j - 1].duracao = arrayAlfabetico[j].duracao;
                    arrayAlfabetico[j].duracao = tempDuracao;
                }
                j--;
            }
        }
        for (i = 0; i < id; i++) {
            j = i;
            while (j > 0) {
                if (arrayAlfabetico[j - 1].instanteComecou == arrayAlfabetico[j].instanteComecou && strcmp(arrayAlfabetico[j - 1].descricao, arrayAlfabetico[j].descricao) > 0) {
                    char temp, tempAtiv;
                    int y, tempId, tempDuracao;
                    for (y = 0; y < MaxTamanhoDescricao; y++) {
                        temp = arrayAlfabetico[j - 1].descricao[y];
                        arrayAlfabetico[j - 1].descricao[y] = arrayAlfabetico[j].descricao[y];
                        arrayAlfabetico[j].descricao[y] = temp;
                    }
                    for (y = 0; y < MaxTamanhoAtividades; y++) {
                        tempAtiv = arrayAlfabetico[j - 1].atividade[y];
                        arrayAlfabetico[j - 1].atividade[y] = arrayAlfabetico[j].atividade[y];
                        arrayAlfabetico[j].atividade[y] = tempAtiv;
                    }
                    tempId = arrayAlfabetico[j - 1].id;
                    arrayAlfabetico[j - 1].id = arrayAlfabetico[j].id;
                    arrayAlfabetico[j].id = tempId;
                    tempDuracao = arrayAlfabetico[j - 1].duracao;
                    arrayAlfabetico[j - 1].duracao = arrayAlfabetico[j].duracao;
                    arrayAlfabetico[j].duracao = tempDuracao;
                }
                j--;
            }
        }
        for (i = 0; i < id; i++) {
            sprintf(buff, "%d %d %s", arrayAlfabetico[i].id, arrayAlfabetico[i].instanteComecou, arrayAlfabetico[i].descricao);
            printf("%s\n", buff);
        }
    } else {
        printf("no such activity\n");
    }
}

/*
Funcao que conta quantas atividades ja foram criadas e retorna o valor
*/
int numeroAtividades() {
    int i, res = 0;
    for (i = 0; i < MaxAtividades; i++) {
        if (strcmp(atividades[i], "") != 0) {
            res++;
        }
    }
    return res;
}

/*
Funcao que verifica se uma string tem letras minusculas e retorna 1 se tiver e 0 se nao
*/
int existeMinusculas(char frase[]) {
    int i;
    for (i = 0; frase[i] != 0; i++) {
        if (islower(frase[i])) {
            return 1;
        }
    }
    return 0;
}

/*
Funcao que da print no terminal a todas as atividades que ja foram criadas
*/
void listaAtividades(int ativ) {
    int i;
    for (i = 0; i < ativ; i++) {
        printf("%s\n", atividades[i]);
    }
}

/*
Funcao que adiciona uma atividade (a [<atividade>]) ou lista todas as atividades ja criadas (a) dependendo da formatacao
*/
void adicionaAtividade(char input[]) {
    int ativ = numeroAtividades();
    transformaArray(input);  
    if (strcmp(formatedInput[1], "") != 0) {
        if (existeAtividade(formatedInput[0]) == 0) {
            if (existeMinusculas(formatedInput[0]) == 0) {
                if (ativ < MaxAtividades) {
                    strcpy(atividades[ativ], formatedInput[0]);
                } else {
                    printf("too many activities\n");
                }
            } else {
                printf("invalid description\n");
            }
        } else {
            printf("duplicate activity\n");
        }
    } else {
        listaAtividades(ativ);
    }
}

/*
Funcao principal do programa que recebe uns inputs e executas as funcoes respetivas
*/
int main() {
    char input[100];
    Init();
    do {
        fgets(input, 60, stdin);
        switch (input[0]) {
        case 't':
            adicionaTarefa(input);
            break;
        case 'l':
            listaTarefas(input);
            break;
        case 'n':
            avancaTempo(input);
            break;
        case 'u':
            atualizaUsers(input);
            break;
        case 'm':
            moveTarefa(input);
            break;
        case 'd':
            listaTarefasPorAtividade(input);
            break;
        case 'a':
            adicionaAtividade(input);
            break;
        default:
            break;
        }
    } while (input[0] != 'q');
    return 0;
}