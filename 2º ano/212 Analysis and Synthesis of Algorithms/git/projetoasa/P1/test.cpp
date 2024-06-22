#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
#include <sstream>
#include <chrono>
#include <map>

using namespace std;

struct Node{
  Node* next;
  int size;
  vector<int> values;
  int val;
  Node* previous;
};

void P1_inputHandling() {
  int value;

  int max = 0;
  int max_occurs=0;

  cin >> value;
  Node* first;
  first -> values.push_back(1);
  first -> val = value;
  first -> size = 1;
  
  Node* iterator=first;
  while (cin >> value) {

    // if value is the lowers seen, continue;

    Node* add;
    add -> val = value;
    add -> size = 1;

    // find add -> previous and add -> next
    if( add-> val < first -> val){
      //  1 2 add 4 first 6
      while(iterator->previous->val > value || iterator->previous == NULL){
        iterator = iterator->previous;
      }
      //  1 p     i n 6
      //  1 p add n 5 6
      add -> previous = iterator -> previous;
      add -> next = iterator;
      iterator -> previous = add;
    } else{
      // 1 2 first 4 add 6
      while(iterator->next->val < value){
        iterator = iterator->next;
      }
      // 1 2 p i     n
      // 1 2 3 p add n
      add -> previous = iterator;
      add -> next = iterator -> next;
      iterator -> next = add;
    }

    // get size of LIS ending in add ( saving it in add -> values[end])
    iterator = add;
    int addingValue = 1;
    while(iterator -> previous != NULL){ // for all lowers
      // iterator -> val > add -> val , will always happen
      for(int i = 0; i < iterator->size;i++){ // for all LIS values
        if(iterator->values[i] > addingValue + 1){ // set highes LIS value
          addingValue = iterator -> values[i] + 1;
        }
      }
      iterator = iterator->previous;
    }

    add->values.push_back(addingValue);
    add->size++;
  }

  // iterator = Node with lowest val, at the moment
    // lets get the max LIS value and the occurs of it
  while(iterator -> next != NULL){
    for(int i = 0; i < iterator->size; i++){
      if(iterator->values[i] > max){
        max = iterator -> values[i];
        max_occurs = 1;
      } else if(iterator->values[i] == max){
        max_occurs++;
      }
    }
  }

  cout << max << " " << max_occurs << " \n";
}

int main() {
  int problem;
  cin >> problem;
  if (problem == 1) P1_inputHandling();

  return 0;
}
