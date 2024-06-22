int f(int n) {
    int x = 0;
                                    //              l1  l2
    for (int i = 0; i < n; i++) { // Loop 1 (l1)    E(  E1) => E(i+1)           O(n)*O(1) = O(i+1) = O(n^2)
        for (int j=0; j < i; j++) { // Loop 2 (l2)
            x++;
        }
    }
    if ((n > 0) && ((n%2) == 1)) { // faz um # constante de chamadas a f(n) (O(c))
        x = x + f(n - 1);           // O(1)
    }
    else if ((n > 0) && ((n%2) == 0)) { // faz a recursão normalmente
        x = 2*f(n/2);
    }
        return x;
}

// T(n) = 1T(n/2) + O(n^2)
//        a    b        d

//  log2(1)  ?  2
//    0      <  2

// Pelo caso 3 do teorema mestre
//  T(n) = Θ(n^d) = Θ(n^2)