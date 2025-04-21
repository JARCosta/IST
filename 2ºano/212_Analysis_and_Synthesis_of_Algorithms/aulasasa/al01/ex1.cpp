#include <stdio.h>
#include <string>
#include <list>
#include <vector>

using namespace std;



int _V, _E;
list<int>* _flistadj;
list<int>* _rlistadj;

void readGraph() {
  scanf("%d,%d", &_V, &_E);
  _flistadj = new list<int>[_V];
  _rlistadj = new list<int>[_V];
  for (int i = 0; i < _E; i++) {
    int u, v;
    scanf("%d %d", &u, &v);
    _flistadj[u-1].push_back(v-1);
    _rlistadj[v-1].push_back(u-1);
  }
}

void freq(list<int>* _adjList) {
  vector<int> _hist;
  _hist.resize(_V);
  for(int i = 0; i < _V; i++) _hist[i] = 0;
  for(int i = 0; i < _V; i++)
    _hist[_adjList[i].size()]++;
    //hist[_adjList -> size()]++;
  for (int i = 0; i < _V; i++) {
    printf("%d\n", _hist[i]);
  }
}
void output2() {
  for (int i = 0; i < _V; i++) {
    string line = "";
    for (int j = 0; j < _V; j++) {
      int c = 0;
      for (list<int>::iterator it = _flistadj[i].begin(); it != _flistadj[i].end(); it++)
        for (list<int>::iterator itj = _flistadj[j].begin(); itj != _flistadj[j].end(); itj++)
          if ((*it)==(*itj)) c++;
    line += to_string(c) + " ";
    }
    printf("%s\n", line.c_str());
  }
}

int main() {
  readGraph();
  printf("Histograma 1\n");
  freq(_flistadj);
  printf("Histograma 2\n");
  freq(_rlistadj);
  printf("Output 2\n");
  output2();
  return 0;
}