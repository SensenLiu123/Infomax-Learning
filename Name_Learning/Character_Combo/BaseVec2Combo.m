function ConvertedName  =  BaseVec2Combo (nameMat)

len = size(nameMat,2);
ConvertedName = zeros(8, len);



        A = [1 1 0 0 0 0 0 0];
        B = [1 0 1 0 0 0 0 0];
        C = [1 0 0 1 0 0 0 0];
        D = [1 0 0 0 1 0 0 0];
        E = [1 0 0 0 0 1 0 0];
        F = [1 0 0 0 0 0 1 0];
        G = [1 0 0 0 0 0 0 1];
        H = [0 1 1 0 0 0 0 0];
        I = [0 1 0 1 0 0 0 0];
        J = [0 1 0 0 1 0 0 0];
        K = [0 1 0 0 0 1 0 0];
        L = [0 1 0 0 0 0 1 0];
        M = [0 1 0 0 0 0 0 1];
        N = [0 0 1 1 0 0 0 0];
        O = [0 0 1 0 1 0 0 0];
        P = [0 0 1 0 0 1 0 0];
        Q = [0 0 1 0 0 0 1 0];
        R = [0 0 1 0 0 0 0 1];
        S = [0 0 0 1 1 0 0 0];
        T = [0 0 0 1 0 1 0 0];
        U = [0 0 0 1 0 0 1 0];
        V = [0 0 0 1 0 0 0 1];
        W = [0 0 0 0 1 1 0 0];
        X = [0 0 0 0 1 0 1 0];
        Y = [0 0 0 0 1 0 0 1];
        Z = [0 0 0 0 0 1 1 0];
    space = [0 0 0 0 0 1 0 1];
        template = [A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V;W;X;Y;Z;space]';



for i=1:len, 
    BaseVec = nameMat(:,i);
    NewVec = Base2Combo(BaseVec, template);
    ConvertedName(:,i) = NewVec; 
end



function NewVec = Base2Combo(BaseVec, template)

AlphabetIndex = BaseVec==1;
% construct 26 letters      
 NewVec = template(:,AlphabetIndex);
        
        
        


    
    
