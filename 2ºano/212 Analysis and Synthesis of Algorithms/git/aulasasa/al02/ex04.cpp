int f(int n) {
    int sum = 0;
    for (int j = n; j>0; j/=2) { // j = n, n/2, n/4, n/2^k      #iteraçoes n= 2^k   k = log2(n)
                                 // O(log(n))

        for (int k=0; k<j; k+=1) { // Loop 1 E(O(1)) = O(n)
            sum += 1;

        }                       // T(n) = O(n*log(n))
    }


    for (int i=1; i<n; i*=2) {  // i = 1,2,4,8,16, ...., 2^k    #iterações em função de n
                                // 2^k = n   K = log2(n)

        for (int k=n; k>0; k/=2) { // Loop 2  k = n, n/2, ..., n/2^k
                                   // k = n/2^x   n = 2^x
                                   //             x = log2(n)
            sum += 1;

        }                           // T(n) = (log(n))^2
    }
    return sum+4*f(n/2);
}
// T(n) = 1*T(n/2) + O(n log(n))
// a = 1  b = 2  d = 1 +  ε
//                       >0

// log1(2)  ?  d
// 0 < d

// pelo caso 3 do teorema mestre
// T(n) = Θ(n^d) = Θ(n log(n))