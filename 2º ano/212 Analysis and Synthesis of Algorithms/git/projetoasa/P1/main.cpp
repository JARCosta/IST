#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
#include <sstream>
#include <chrono>
#include <map>

using namespace std;

void solve_problem_one();
struct Element{
  int val;
  Element* next;
  int lis;
  int ocurr;
};

void solve_problem_two();
vector <int> seq1;
int seq1_size;
vector <int> seq2;
int seq2_size;
map<int,int> hash_map;
vector<int> LCIS;

/* Problem One: Longest Increasing Subsequence*/

vector<int> get_maxes(Element* first){
  Element* iterator = first;
  vector<int> ret;
  
  int max = first -> lis;
  int max_occurs = 0;
  
  while(iterator -> lis == max){
    max_occurs += iterator -> ocurr;
    iterator = iterator -> next;
  }
  ret.push_back(max);
  ret.push_back(max_occurs);
  return ret;
}

void update_LIS(Element* first, Element* add){
  Element* iterator = first;
  bool LIS_set = false;
  while(iterator != NULL){
    if(add -> val > iterator -> val && add -> lis < (iterator -> lis + 1) ){
      add -> lis = iterator -> lis + 1;
      add -> ocurr = iterator -> ocurr;
      LIS_set = true;
    } 
    else if(add -> val > iterator -> val && add -> lis == (iterator -> lis + 1) ){
      add -> ocurr += iterator -> ocurr;
    } 
    else if(LIS_set && add -> lis > iterator -> lis + 1){
      break;
    }
    else{
      add -> lis = 1;
      add -> ocurr = 1;
    }
    iterator = iterator -> next;
  }
}

Element* insert_value(Element* first, Element* add){
  Element* iterator = first;
  while(iterator -> lis >= add -> lis) {
    if (iterator -> next == NULL || \
        iterator -> next -> lis < add -> lis || \
        (iterator -> lis == add -> lis && add -> val > iterator -> next -> val)) {
      break;
    }
    iterator = iterator -> next;
  }
  if(add -> lis > iterator -> lis){
    add -> next = iterator;
    first = add;
  }
  else {
    add -> next = iterator -> next;
    iterator -> next = add;
  }
  return first;
}

void solve_problem_one() {
  
  int value;
  Element* iterator;
  Element* first;
  
  first = new Element();
  cin >> value;
  first -> val = value;
  first -> next = NULL;
  first -> lis = 1;
  first -> ocurr = 1;

  while(cin >> value) {
    Element* add;
    add = new Element();
    add -> val = value;
    add -> lis = 0;
    add -> ocurr = 0;
    update_LIS(first, add);
    first = insert_value(first, add);
  }
  vector<int> ret = get_maxes(first);
  cout << ret[0] << " " << ret[1] << "\n";
}

/* Problem two: */

void process_second_sequence(int value){

  if (seq2_size == 0) {                       // initialise LCIS 
    for (int i = 0; i < seq1_size; i++) {
      LCIS.push_back(0);
    }
  }

  int curr = 0;
  seq2_size++;
  for (int i = 0; i < seq1_size; i++) {
    if (value == seq1[i]) {
      LCIS[i] = max(curr+1,LCIS[i]);
    }
    if (value > seq1[i]) {
      curr = max(curr,LCIS[i]);
    }
  }
}

int get_max_len(){
  int max_len = 0;
  for (int i = 0; i < seq1_size; i++) {
    max_len = max(max_len,LCIS[i]);
  }
  return max_len;
}

void solve_problem_two() {
  int value;
  char lixo;
  int line = 1;

  while (cin >> value) {
    scanf("%c",&lixo);
    if (line == 1) {
      seq1.push_back(value);
      hash_map[value] = value;
      seq1_size++;
    }
    if (line == 2) {
      if (hash_map.count(value) == 0) { continue; } // if value isnt in sequence 1
      process_second_sequence(value);
    }
    if(lixo != ' ') { line++; } // line change => finished reading sequence 1
  }
  cout << get_max_len() << '\n';
} 

int main() {
    int problem;
    cin >> problem;
    if (problem == 1) {
        //auto start = chrono::high_resolution_clock::now();
        solve_problem_one();
        //auto stop = chrono::high_resolution_clock::now();
        //auto input = chrono::duration_cast<chrono::microseconds>(stop - start);
        //cout << "input: " << input.count() << " μs\n";
    }
    else {
        solve_problem_two();

    }
    return 0;
}
