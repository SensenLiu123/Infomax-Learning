function makemovie(XXX,output)

%% for Xticklabel


lenth = size(output,2); % columns
Alphabet = 'abcdefghijklmnopqrstuvwxyz ';
Name = [];


for i=1:lenth,
    Letter = Alphabet(output(:,i)>0);
    Name = [Name,Letter];
end

XTickL = mat2cell(Name,1,ones(length(Name),1));


%% make movie full time

% 
% [nodenum,time]=size(XXX);
% background = zeros(nodenum,time);
% 
% nframe = time;
% 
% 
% mov(1:nframe)= struct('cdata',[],'colormap',[]);
% set(gca,'nextplot','replacechildren')
% for k=1:nframe
%     learning = background;
%     learning(:,1:k)=XXX(:,1:k);
%     imagesc(learning);
%     axis([1 441 1 240]);
%     ylabel('node index');
%     set(gca,'YDir','reverse');
%     set(gca,'fontsize',12,'FontName', 'Arial','Xtick',1:k,'XTickLabel',XTickL(1:k));
%     mov(k)=getframe(gcf);
% end
% movie2avi(mov, 'm1.avi', 'compression', 'None'); 


%% make movie time window 50
% 
[nodenum,time]=size(XXX);
background = zeros(nodenum,50);

nframe = time;


mov(1:3*nframe)= struct('cdata',[],'colormap',[]);
set(gca,'nextplot','replacechildren')
set(gca,'YDir','reverse');
for t=1:3*nframe
    k = ceil(t/3);
    if t/3<=50,
        learning = background;
        learning(:,1:k)=XXX(:,1:k);
        imagesc(learning);
        axis([1 50 1 240]);ylabel('node index');
        set(gca,'Ytick',1:60:240,'YTickLabel',{'1','60','120','180','240'});
        set(gca,'fontsize',12,'FontName', 'Arial','Xtick',1:k,'XTickLabel',XTickL(1:k));
        mov(t)=getframe(gcf);
    else 
        learning = XXX(:,k-50+1:k);
        imagesc(learning);
        axis([1 50 1 240]);ylabel('node index');
        set(gca,'Ytick',1:60:240,'YTickLabel',{'1','60','120','180','240'});
        set(gca,'fontsize',12,'FontName', 'Arial','Xtick',1:k,'XTickLabel',XTickL(k-50+1:k));
        mov(t)=getframe(gcf);
    end
end
movie2avi(mov, 'm2.avi', 'compression', 'None');