#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
#include <sstream>
#include <chrono>
#include <map>
using namespace std;

struct Node{
  int value;
  Node* papas[2];
  int num_papas;
};
map<int,Node*> Vs;

Node* create_node(int val){
  Node* node = new Node();
  Vs[val] = node;
  Vs[val] -> value = val;
  Vs[val] -> num_papas = 0;
  Vs[val] -> papas[0] = NULL;
  return node;
}

Node* get_node(int val){
  if(Vs[val] == NULL)
    return create_node(val);
  else 
    return Vs[val];
}

int add_arco(int v1,int v2){
  Node* node1 = get_node(v1);
  Node* node2 = get_node(v2);
  if(node2 -> num_papas == 2) return -1;
  node2 -> papas[node2 -> num_papas] = node1;
  node2 -> num_papas++;
  return 0;
}

vector<int> get_papas(int value){
  vector<int> values;
  for(int i = 0; i < Vs[value]->num_papas; i++){
    values.push_back(Vs[value] -> papas[i] -> value);
  }
  return values;
}

vector<int> serch_closest_commun_ansestral(int value1, int value2){
  //for every ancestral check if its commun to both values,
    //else repeate to its ancestrals
  vector<int> ret;
  vector<int> papas1 = get_papas(value1);
  vector<int> papas2 = get_papas(value2);
  int size1 = papas1.size();
  int size2 = papas2.size();
  for(int i = 0; i < size1; i++){
    int i_value = papas1[i];
    for(int j = 0; j < size2; j++){
      if(i_value == papas2[j]) ret.push_back(i_value);
    }
  }
  return ret;
}

int problem(){
  int value1,value2,num_nodes,num_arcos;
  cin >> value1;
  cin >> value1; 
  cin >> num_nodes;
  cin >> num_arcos;
  int temp1,temp2;
  while(cin >> temp1){
    cin >> temp2;
    if(add_arco(temp1,temp2) == -1){
      cout << "0\0";
      return -1;
    }

  }

  serch_closest_commun_ansestral(value1,value2);
  return 0;
}


int main() {
  problem();
  return 0;
}
