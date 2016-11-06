A = load 'roadNet-CA.txt' as (nodeA:chararray, nodeB:chararray);
/*
count the frequency of each out-degree value
*/
B = group A by nodeA;
C = foreach B generate group,COUNT(A) as freq;
/*
count the frequency of each in-degree value
*/
D= group A by nodeB;
E = foreach D generate group,COUNT(A) as freq;
/*
count the number of all node
*/
F = join C by $0 full,E by $0;
H = group F all;
I = foreach H generate COUNT_STAR(F.C::freq);
/*
count the number of dead-end node
*/
GG = filter F by C::freq is null;
HH = group GG all;
II = foreach HH generate COUNT_STAR(GG.C::freq);
/*
caculate the percentage of dead-end nodes
*/
J = cross I,II;
P = foreach J generate (float)$1/$0; 
dump P;
/*
caculate the average degree of the graph
*/
sum_in_out_degree = foreach H generate SUM(F.C::freq)+SUM(F.E::freq);
P = cross sum_in_out_degree,I;
Q = foreach P generate (float)$0/$1; 
dump Q;
