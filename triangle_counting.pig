A = load 'roadNet-CA.txt' as (nodeA:chararray, nodeB:chararray);
B = foreach A generate nodeA as nodeB , nodeB as nodeC;
C = join A by $1,B by $0;
D = foreach C generate $0,$1,$3;

E = join D by ($0,$2),B by ($1,$0);

F = group E all;
G = foreach F generate SIZE(E);

dump G;

