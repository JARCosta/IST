#include <iostream>
#include <vector>

using namespace std;
#define VISITABLE 1
#define CLOSED 2

typedef struct point
{
  int number_of_parents;
  vector<int> parents_id;
  vector<int> children_id;
  int color;
}Point;

vector<point> points;
int v1_id;
int v2_id;
int n;  // number of points;
int m;  // number of connections between points


// In order to simplify the problem len(points) = n+1 and we
// ignore the first point (0), so that the id of the point 
// is the same as the id on the vector.

void add_init_point() {
  point new_point;
  new_point.number_of_parents = 0; 
  points.push_back(new_point);
}

void inputHandling() {

  // y é filho de x
  int x;
  int y;
  scanf("%d %d",&v1_id,&v2_id);
  scanf("%d %d",&n,&m);


  // 0: null position to simplify problem
  for (int i = 0; i <= n; i++) {
    add_init_point();
  }

  for(int i = 0; i < n; i++){
    scanf("%d %d",&x,&y);

    point node = points[y];
    node.number_of_parents++;
    node.parents_id.push_back(x);
    points[x].children_id.push_back(y);
    
    // DEBUG
    cout << "Posso ir de " << y << " para " << x << "\n";
  }
}

vector<int> distances_to_id(1,n);
int get_distances_aux(int id){
  int distance = 0;
  vector<int> parents = points[id].parents_id;
  int number_of_parents = points[id].number_of_parents;
  for(int i = 0; i < number_of_parents; i++){
    distance = get_distances_aux(parents[i]) - 1;
    distances_to_id[parents[i]] = distance;
  }
  return distance;
}
// set distances_to_id according to v
  // future, return a vector of ids sorted by distance, decreasing?
  // nah, only after getting the sum distance to both v1 and v2
vector<int> get_distances(int v1, int v2){
  vector<int> ret;
  get_distances_aux(v1);
  for(int i = 0; i < n; i++){
    distances_to_id[i] = -1 * distances_to_id[i];
    ret[i] = distances_to_id[i];
  }
  get_distances_aux(v2);
  for(int i = 0; i < n; i++){
    if(ret[i] != -1){
      distances_to_id[i] = -1 * distances_to_id[i];
      ret[i] += distances_to_id[i];
    }
  }
  return ret; 
  // sort this, and ignore ret[i] == -1, so we start checking if its the closest ancestor from the flosest ones
    // will have to iterate it all so, doesnt really matter
}

int check_loop(int id){
  point node = points[id];
  vector<int> parents = node.parents_id;

  for(int i = 0; i < points[id].number_of_parents; i++){
    point parent = points[node.parents_id[i]];
    if(parent.color == VISITABLE) return -1; // there is a loop
    parent.color = VISITABLE;
    if(check_loop(node.parents_id[i]) == -1) return -1;
  }
  for(int i = 0; i < points[id].number_of_parents; i++){
    points[node.parents_id[i]].color == CLOSED;
  }
  return 0;
}

// Check if tree is valid
bool verify_tree() {
  for (int i = 1; i <= n; i++) {
    if (points[i].number_of_parents > 2) {
      return false;
    }
  }
  return true;
}

int main() {
  inputHandling();
  // Valid tree
  if (verify_tree) {
    
  }
  // Invalid tree
  else{
    cout << "0";
  }
}