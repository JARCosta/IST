/*************************************
 * ASA 2021/2022 - Pedro T. Monteiro *
 *   pequeno projecto exemplo - P0   *
 *************************************/
#include <stdio.h>
#include <string>
#include <list>
#include <vector>

using namespace std;

int _V, _E;
list<int>* _fwrAdjList;
list<int>* _revAdjList;

//---------------------------------------------------------------
void readGraph() {
	scanf("%d,%d", &_V, &_E);
	_fwrAdjList = new list<int>[_V];
	_revAdjList = new list<int>[_V];
	for (int i = 0; i < _E; i++) {
		int u, v;
		scanf("%d %d", &u, &v);
		_fwrAdjList[u-1].push_front(v-1);
		_revAdjList[v-1].push_front(u-1);
	}
}

//---------------------------------------------------------------
void computeDegrees(list<int>* _adjList) {
	vector<int> _hist;
	_hist.resize(_V);
	for (int i = 0; i < _V; i++) _hist[i] = 0;
	for (int i = 0; i < _V; i++) {
		_hist[_adjList[i].size()]++;
	}
	for (int i = 0; i < _V; i++) {
		printf("%d\n", _hist[i]);
	}
}

//---------------------------------------------------------------
void commonFriends() {
	for (int i = 0; i < _V; i++) {
		string line = "";
		for (int j = 0; j < _V; j++) {
			int c = 0;
			for (list<int>::iterator it_i = _fwrAdjList[i].begin(); it_i != _fwrAdjList[i].end(); it_i++) {
				for (list<int>::iterator it_j = _fwrAdjList[j].begin(); it_j != _fwrAdjList[j].end(); it_j++) {
					if ((*it_i)==(*it_j)) c++;
				}
			}
			line += to_string(c) + " ";
		}
		printf("%s\n", line.c_str());
	}
}

//---------------------------------------------------------------
int main() {
	// Read the graph
	readGraph();

	// First output
	printf("Histograma 1\n");
	computeDegrees(_fwrAdjList);
	printf("Histograma 2\n");
	computeDegrees(_revAdjList);

	// Second output
	commonFriends();

	return 0;
}
