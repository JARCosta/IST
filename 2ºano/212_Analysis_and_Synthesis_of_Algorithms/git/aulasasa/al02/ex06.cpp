int f(int n) {
    int i = 0, j = n;
    if (n <= 1) return 1;
    while(j > 1) {      // O(log(n))
        i++;
        j = j / 2;
    }
    for (int k = 0; k < 8; k++)
        j += f(n/2);
    while (i > 0) {    // O( log(n))
        j = j + 2;
        i--;
    }
    return j;
}

// T(n) = 8T(n/2) + O(log(n))
//        a    b           d

// log2(8) >> 1
//   3


// Θ(n^3)