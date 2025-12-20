int f(int n) {
    int i = 0, j=0, z=0;
    while (j + z < n) { // Loop 1  z = 0, 1, 2, 3, ... ,k   z(k) = k    #iterações em função de k
                        //         i = 0, 2, 4, 6, ... ,2k  i(k) = 2k
                        //         j = 0, 0(+0), 0(+2), 2(+4), 6(+6), 12(+8), 20(+10), 30(+12)
                        //              j(k) = j(k-1) + i(k) = j(k-1) + 2k
                        //                   = j(k-2) + 2(k-1) + 2k
                        //                   = j(k-3) + 2(k-2) + 2(k-1) + 2k 
                        //                     .....
                        //                   = j(k-y) + 2(k-y+1)+ ... +  2y     k=y
                        //                   = j(0) + 2[1 + 2 + 3 + 4 + ... + y]
                        //                     O(n^2)
                        //      2Ek = 2 ( k(k+1)/2) = k^2 + k
            // condição de paragem : j + z < n
            // k + k^2 = n
            //     k^2 = n
            //       k = √n    n^1/2
        z += 1;
        j += i;
        i += 2;
    }
    int r = 0;
    if (n > 0) r = 3*f(n/2);

    j = 1; z = 0;
    while (j<n) {    // Loop 2  O(log(n))
        j *= 2;
        z += 1;
    }
    return r+i+z;
}
// T(n) = 1*T(n/2) + O(n^1/2)
//        a     b         d

// log1(2)  ?  1/2
//  0       <  1/2

// pelo 3 caso do teorema mestre
//  T(n) = Θ(n^d) = Θ(√n)