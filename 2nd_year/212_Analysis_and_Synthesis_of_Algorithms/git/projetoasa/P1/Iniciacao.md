# Projeto ASA - DIÁRIO DO PROJETO

### 6/12/2021


@Goaum
```cpp

int try( int h, int i, int j, int k) {
    int[] vals = [];
    while ( i != h ) {
        vals += [i, ];
        i++;
    }
    while ( j != k ) {
        vals += [j, ];
        j++;
    }
    for(int i = 0 ; i < sizeof(vals); i++){
        printf("%d", vals[i]);
    }

```


### 7/12/2021

@TheXjosep
```

Tratar do input:

1. Linha com o n (o numero do problema a resolver)
2. n linhas, cada uma contem uma seq de inteiros separados por um espaço entre eles + End of line

Fazer make file para os testes e para compilar tudo automaticamente

                Problema 1: Longest Increasing subsequence

> Primeira tentativa [ERRADA]: 
```
```cpp
int increased_depth(vector<int> inBuild,int index, vector<int> *ocurrences) {
    int size = sequence.size();
    int increased = 0;
    vector<int> copy_prev = inBuild;
    if (index == size) {
        return 0;
    }

    inBuild.push_back(sequence[index]);
    for (int i = index; i < size; i++) {
        int added = 0;
        if (inBuild.back() < sequence[i+1]) {
            added = increased_depth(inBuild,i+1,ocurrences);
        }
        else {
            added = increased_depth(copy_prev,i+1,ocurrences) - 1;
        }
        if (added > increased) {
            increased = added;
        }
        (*ocurrences)[added]++;
    }  
    return 1 + increased;
}

void solve_problem_one() {
    vector<int> inBuild;
    int max = 0;    
    for (int i = 0; i < sequence.size(); i++) {
        if (max < sequence[i]) {
            max = sequence[i];
        }
    }
    vector<int>  occurs;
    for (int i = 0; i <= max; i++) {
        occurs.push_back(0);
    }


    max = 0;
    int checkpoint;
    for (int i = 0; i < sequence.size(); i++) {
        checkpoint = increased_depth(inBuild,i,&(occurs));
        if (checkpoint > max) {
            max = checkpoint; 
        }
        occurs[checkpoint]++;
    }
    cout << max << " " << occurs[max];
}    
```
### 8/12/2021
@TheXjosep
```
Hoje vou tentar resolver este problema usando memória dinâmica

> complexidade de O(n²)
> DFS with cache (Programação dinâmica)
> Nota: Esta solução funciona mas não trata do contador de lis [INCOMPLETA]
```
```cpp
void solve_problem_one() {
    vector<int> lis;
    int ocurrences = 0;
    int size = sequence.size();
    for (int i = 0; i < size; i++) {
        lis.push_back(1);
    }
    for (int i = size-1; i > -1; i--) {
        for (int j = i+1; j < size; j++) {
            if (sequence[i] < sequence[j]){
                lis[i] = max(lis[i], 1 + lis[j]);
            }
        }
    }
    int max = 0;
    for (int i = 0; i < size; i++) {
        if (lis[i] > max) {
            max = lis[i];
        }
    }
    cout << max << " " << ocurrences; // MISSING OCURRENCES
}
```
### 9/12/2021
@TheXjosep
```
Hoje vou tentar resolver o primeiro problema usando um algortimo melhor
O(nlog(n)) 
O Famoso Patience Sort

Primeira tentativa:
```
```cpp
void solve_problem_one() {
    int size = sequence.size(); 
    int depth = 0;
    vector<vector<int>> pile;
    vector<vector<int>> sequencePointers;
    pile[0].push_back(sequence[0]);

    for (int i = 0; i < size; i ++) {
        sequencePointers[0].push_back(-1);
    }

    for (int i = 1; i < size; i++) {
        for (int j = 0;j <= depth; j++) {
            if (j == depth && sequence[i] > pile[j].back()) {
                depth++;
                pile[depth].push_back(sequence[i]);
                sequencePointers[j].push_back(pile[j].size()-1);
                break;
            }
            if (pile[j].back() > sequence[i]) {
                pile[j].push_back(sequence[i]);
                break;
            }
        }
    }
    int maximum = 0;
    int maximum_counter = 0;
    for (int i = pile.size()-1; i >= 0; i--) {
        for (int j = 0; j < pile[i].size(); j++) {
            int connections = 0;
            int pointer = j;
            while (pointer != -1) {
                pointer = sequencePointers[i][j];
                connections++;
                if (connections > maximum) {
                    maximum = connections;
                    maximum_counter = 0;
                }
                if (connections == maximum) {
                    maximum_counter++;
                }
            }
        }
    }
    cout << maximum << " " << maximum_counter;
}
```

```
Temos também outra solução que tenta calcular o número de 
ocorrências da solução, contudo esta solução não é funcional
    ->Problema: para considerar todas as soluções seguindo este algoritmo
    teriamos que aumentar a complexidade para O(n²logn), pelo menos seguindo
    a este processo. 
    -> Não só a complexidade do problema iria aumentar, como a leitura do código
    seria muito pior, [ver abaixo].
```
```cpp
typedef struct combo
{
    int value;
    int pointer; // ultimo valor da pile à esquerda
    int depth; // para que pile é que está
} Combo;

/* Problem One: Longest Increasing Subsequence*/
void solve_problem_one() {
    int size = sequence.size(); 
    int depth = 0;
    vector<vector<Combo>> pile;
    vector<int> connections;
    Combo c0;
    c0.pointer = -1;
    c0.value = sequence[0];
    c0.depth = 0;
    for (int i = 0; i < size; i++) {
        vector <Combo> init0;
        pile.push_back(init0);
    }

    for (int i = 1; i < size; i++) {
        Combo ci;
        ci.value = sequence[i];
        for (int j = 0;j <= depth; j++) {
            if (j == depth && ci.value > pile[j].back().value) {
                depth++;
                ci.depth = depth;
                ci.pointer = pile[j].size()-1; 
                pile[depth].push_back(ci);
                break;
            }
            if (pile[j].back().value > ci.value) {
                ci.depth = pile[j].back().depth;
                if (j == 0) {
                    ci.pointer = -1;
                }
                else{
                    ci.pointer = pile[j-1].size() -1;
                }
                pile[j].push_back(ci);
                break;
            }
        }
        //cout << "VALOR: " << ci.value << "APONTA: " << ci.pointer << "PROFUNDIDADE: " << ci.depth << "\n";
    }

    // Por enquanto só vai servir para calcular o len(lis)
    int maximum = 0;
    int maximum_counter = 0;
    for (int i = pile.size()-1; i >= 0; i--) {
        int extrai = i;
        for (int j = 0; j < pile[extrai].size(); j++) {
            int extraj = j;
            int connections = 0;
            int pointer = extraj;
            while (pointer != -1) {
                pointer = pile[extrai][extraj].pointer;
                extrai = pile[extrai][extraj].depth - 1;
                extraj = pointer;
                connections++;
                if (connections > maximum) {
                    maximum = connections;
                    maximum_counter = 0;
                }
                if (connections == maximum) {
                }
            }
        }
    }
    cout << maximum << " " << maximum_counter;
}


```
### 10/12/2021

```
Solução do problema 1:
    De modo a evitar confusões decidimos utilizar o aprouch original
    seguindo o algoritmo DFS with cache
    Apesar da complexidade para o problema ser O(n²) esta será 
    uma das melhores soluções para o problema em causa

[Código da solução]: 
(com pequenos erros)
```
```
/* Problem One: Longest Increasing Subsequence*/
void solve_problem_one() {
    int size = sequence.size();
    vector<int> LIS;
    vector<int> COUNTER;
    COUNTER.push_back(0);
    for (int i = 0; i < size; i++) {
        LIS.push_back(1);
        COUNTER.push_back(0);
    }
    for (int i = size -1 ; i >= 0; i--) {
        for (int j = i + 1; j < size; j++) {
            if (sequence[j] > sequence[i] && LIS[i] <= LIS[j] +1) {
                LIS[i] = LIS[j] + 1;
                COUNTER[LIS[i]]++;
            }
        }
    }
    int max_index = 0;
    for (int i = 0; i < size; i++) {
        //cout << "LEN: " << LIS[i] << " SIZE: " << COUNTER[LIS[i]] << "\n";
        if (LIS[i] > LIS[max_index])
            max_index = i;
    }
    cout << LIS[max_index] << " " << COUNTER[max_index+2];
}
```

### 12/12/2021 - Solução final para o primeiro problema

@TheXjosep
```

```