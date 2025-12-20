#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
#include <sstream>
#include <chrono>
#include <map>

using namespace std;

struct Node{
  Node* nextVal;
  int LIS;
  Node* LISrep;
  int val;
  int ocurr;
  Node* previousVal;
};

void P1_inputHandling() {
  int value;

  int max = 0;
  int max_occurs=0;

  cin >> value;
  Node* first = NULL;
  first = new Node();
  first -> val = value;
  first -> LIS = 1;
  first -> ocurr = 1;
  
  Node* iterator=first;
  while (cin >> value) {

    // if value is the lowers seen, continue;

    Node* add;
    add = new Node();
    add -> val = value;
    add -> ocurr = 0;
    if(value == 3){
      int b = 2;
    }

    iterator = first;
    if( add-> val < iterator -> val){
      while(iterator->previousVal != NULL){
        if(iterator -> previousVal -> val <= value) break;
        iterator = iterator->previousVal;
      }

    } else if(add-> val > iterator -> val){
      while(iterator -> nextVal != NULL){
        if(iterator -> nextVal -> val >= value) break;
        iterator = iterator->nextVal;
      }

    }

    // iterator -> value is the highest seen which is under or equal to add -> val

    if(iterator -> val < add -> val){
      // adding to the right of iterator
        if(iterator-> nextVal == NULL){
          iterator -> nextVal = add;
          add -> previousVal = iterator;
        }else{
          add -> previousVal = iterator;
          add -> nextVal = iterator -> nextVal;
          iterator -> nextVal -> previousVal = add;
          iterator -> nextVal = add;
        }
    } else if( iterator -> val == add -> val){
      // add a new rep to iterator
      add -> previousVal = iterator -> previousVal;
      add -> nextVal = iterator -> nextVal;
      iterator -> LISrep = add;
    }else if(iterator -> val > add -> val){
      // add to the left of iterator
      if(iterator -> previousVal == NULL){
        add -> nextVal = iterator;
        iterator -> previousVal = add;
      }else{
        add -> previousVal = iterator -> previousVal;
        add -> nextVal = iterator;
        iterator-> previousVal -> nextVal = add;
        iterator -> previousVal = add;
      }
    } else{
      printf("error 1\n");
    }

    // get size of LIS ending in add ( saving it in add -> values[end])
    iterator = add;
    int addingValue = 1;
    while(iterator != NULL){ // for all lowers
      // iterator -> val > add -> val , will always happen

      while(iterator != NULL){ // for all LIS values
        if(iterator -> LIS + 1 > addingValue){ // set highes LIS value
          addingValue = iterator -> LIS + 1;
        }
        if(iterator -> LISrep == NULL) break;
        iterator = iterator -> LISrep;
      }
      if(iterator->previousVal == NULL) break;
      iterator = iterator->previousVal;
    }
    add->LIS = addingValue;


    if(add -> val == 8){
      int a = 1;
    }


    iterator = add -> previousVal;
    while(iterator != NULL){
      if(iterator -> LIS + 1 == add -> LIS && iterator -> val < add -> val){
        add -> ocurr += iterator -> ocurr;
      }
      if(iterator->previousVal == NULL) break;
      iterator = iterator->previousVal;
    }
    if(add-> ocurr == 0) add -> ocurr++;
  }

  // iterator = Node with lowest val, at the moment
    // lets get the max LIS value and the occurs of it
  iterator = first;
  while(iterator-> previousVal != NULL){
    iterator = iterator-> previousVal;
  } 

  while(iterator != NULL){
    while( iterator != NULL){
      if(iterator->LIS > max){
        max = iterator -> LIS;
        max_occurs = iterator -> ocurr;
      } else if(iterator->LIS == max){
        max_occurs += iterator -> ocurr;
      }
      if(iterator -> LISrep == NULL) break;
      iterator = iterator -> LISrep;
    }
    if(iterator -> nextVal == NULL) break;
    iterator = iterator -> nextVal;
  }

  cout << max << " " << max_occurs << " \n";
}

int main() {
  int problem;
  cin >> problem;
  if (problem == 1) P1_inputHandling();

  return 0;
}
