function[pr2_fr]=overlap(pr2,fr_curr,fr_new)
//this function reads the current and a new overlap function for testing it with updated inversions.
//A. Mortier 
//29/10/2015
    
//errcatch(-1,"continue")
fr_c=fscanfMat(strcat(['data/fr/',fr_curr]));
fr_n=fscanfMat(strcat(['data/fr/',fr_new]));

fr_c(length(fr_c):size(pr2,1))=1;
fr_n(length(fr_n):size(pr2,1))=1;

//construct matrices
mat_fr_c=ones(size(pr2,2),1)*fr_c';
mat_fr_n=ones(size(pr2,2),1)*fr_n';


pr2_fr=pr2.*(mat_fr_c')./(mat_fr_n');

endfunction
