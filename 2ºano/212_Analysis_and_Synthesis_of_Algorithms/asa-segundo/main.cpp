#include <iostream>
#include <vector>

using namespace std;

#define WHITE 0
#define GRAY 1
#define BLACK 2
#define RED 3
#define GREEN 4

int v1_id;  // Id do primeiro
int v2_id;  // Id do segundo

int n;    // Numero de vértices
int m;    // Numero de arcos

typedef struct node {
    int color;
    int number_of_ancestors;
    vector<int> ancestors;
}Node;

vector<Node> nodes;

void init_nodes(int n) {
    for (int i = 0; i <= n; i++) {
        // novo node
        Node newNode;
        newNode.number_of_ancestors = 0;
        newNode.color = WHITE;
        nodes.push_back(newNode);
    }
}

bool inputhandle(){
    int x,y;
    // Meter variaveis globais
    scanf("%d %d\n%d %d", &v1_id, &v2_id, &n, &m);
    
    // Inicializar n+1 vertices
    init_nodes(n);

    // Ler arcos
    for(int i = 0; i < m; i++){
        if (scanf("%d %d", &x, &y) != 2) {
            return false;
        }
        // Criar novo arco
        nodes[y].number_of_ancestors++;
        nodes[y].ancestors.push_back(x);
        //cout << "Posso ir de " << y << " para " << x << "\n";
    }
    return true;
}

bool DFS_Visit(int u) {
    Node ver = nodes[u];
    nodes[u].color = GRAY;
    for (int i = 0; i < ver.number_of_ancestors; i++) {
        int v = ver.ancestors[i];
        if (nodes[v].color == WHITE) {
            DFS_Visit(v);
        }
        if (nodes[v].color == GRAY) {
            return false;
        }
    }
nodes[u].color = BLACK;
    return true;
}
  
bool DFS(){
    for(int i = 0; i < n; i++) {
        if (nodes[i].color == WHITE) {
            if(!DFS_Visit(i)) {
                return false;                
            }
        }
    }
    return true;
}

bool verify_ancestors() {
    for (int i = 1; i <= n; i++) {
        if (nodes[i].number_of_ancestors > 2) {
            return false;
        }
    }
    return true;
}
///////////////////////////////////////////////////////////
void DFS_Visit_v1(int u) {

    Node ver = nodes[u];
  
    // Ver se usamos uma variavel ou nao
    nodes[u].color = RED;
    /*
    if (u != v1_id) {
        //ver.color = RED;
        nodes[u].color = RED;
        //cout << "FICA A VERMELHO: " << u << "\n";
    }
    else {
        nodes[u].color = BLACK;
    }
    
    */
    for (int i = 0; i < ver.number_of_ancestors; i++) {
        int v = ver.ancestors[i];
        if (nodes[v].color == WHITE) {
            DFS_Visit_v1(v);
        }
    }
}

void DFS_v1() {
    for (int i = 1; i <= n; i++) {
        nodes[i].color = WHITE;
    }
    DFS_Visit_v1(v1_id);
}

///////////////////////////////////////////////////////////

void make_them_all_black(int u){
    Node ver = nodes[u];
    for(int i = 0; i < ver.number_of_ancestors ; i++) {
        nodes[ver.ancestors[i]].color = BLACK;
        make_them_all_black(ver.ancestors[i]);
    }
}

void DFS_Visit_v2(int u){
    Node ver = nodes[u];
    for(int i = 0; i < ver.number_of_ancestors; i++) {
        int v = ver.ancestors[i];
        if(nodes[v].color == RED){
            nodes[v].color = GREEN;
            make_them_all_black(v);
            //cout << "ENCONTRADO:" << v << "\n";
        } else if(nodes[v].color == WHITE){
            DFS_Visit_v2(v);
            //cout << "ERA BRANCO EM V2: " << v << "\n";
        }
    }
}

void DFS_v2() {
    if (nodes[v2_id].color == RED) {
        nodes[v2_id].color = GREEN;
        return;
    }
    DFS_Visit_v2(v2_id);
}

///////////////////////////////////////////////////////////

int main() {
    if (!inputhandle()) {
        cout << "0\n";
        return 0;
    }

    // Ver numero de ancestrais (>2 => falso)
    if (!verify_ancestors()) {
        cout << "0\n";
        return 0;
    }
    // Ver existência de loops
    if (!DFS()) {
        cout << "0\n";
        return 0;
    }
    // obter ancestrais de v1
    DFS_v1();
    // obter ancestrais de v2, comuns a v1-
    DFS_v2();

    // ordenar ancestrais, sort(answers)
    int i;
    int check = 0;
    for (i = 1; i <= n; i++) {
        if (nodes[i].color == GREEN) {
            cout << i << " ";
            check++;
        }
    }
    if (check == 0) {
        cout << "-";
    }
    cout << "\n";
    return 0;
}