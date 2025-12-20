int f(int n) {
    int i = 0, j = 0;
    for (i = 0; i < n; i++) { // Loop 1 O(n) -------------------------->  i | j
                                                                    //    0 | 0
                                                                    //    0 | 1
                                                                    //    0 | 2
                                                                    //      |
                                                                    //    1 | 3
                                                                    //    2 | 4
                                                                    //      |
                                                                    //  n-1 | n
        while (j - i < 2) { // O(1)
            j++;
            }
}
if (n > 0)
    i = 2*f(n/2) + f(n/2) + f(n/2); //O(n) ?

while ( j > 0) { // Loop 2 O(log(n))
    j = j / 2;
}

    return j;
}

// T(n) = 3 T(n/2) + O(n^1)
//        a     b        d

// log2(3)  ?  1
// 1,*****  >  1

// Pelo caso do teorema mestre:
//   T(n) = Θ(n^logb(a)) 
//        = Θ(n^log2(3))
