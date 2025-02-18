 function [opt] = ABOA(H, epsilon)
      %%%n>k
      %%%epsilon is small scaler value
      %%%assignment selects optimal row in each column
 
     [n,k]= size(H);    
     alpha= zeros(1,n);
     winner_list= zeros(n,k);
     bidder_max= zeros(n,k);
     
 
 for i=1:k
    
   winnerNum= zeros(n,1);
   b= zeros(n,1);
   
   ST =sort(H(:,i), 'descend');
   winnerNum_object= ST(1)-ST(2);
   [~, argmax]= max(H(:,i));
   winnerNum(argmax)= winnerNum_object+rand*.001;
   winner_list(:,i)= winnerNum;
   
   b(argmax)= i;
   bidder_max(:,i)=b; 
   
   alpha(i)= argmax;
    
 end
 
 
  iteration=0;
  
  winner_list_previous= zeros(n,k);
  opt = H * winnerNum_object;
  while 1
  
      
iteration=iteration+k;
  
 for winner=1:k
    
winner_list_0=winner_list(:,winner);
 
    if (winner==1)
        
     beta= H(:,winner);   
     winner_list_t= winner_list(:,winner+1);
     alpha_0= alpha(winner);
     bidd=bidder_max(:, winner);
     bidd_neighbour= bidder_max(:, winner+1);
     
   [ winner_list_update, alpha_t, bidd_update ] = Auction(winner,  winner_list_0, winner_list_t, alpha_0, beta, bidd, bidd_neighbour, epsilon,n,k);
   
   
    winner_list(:, winner)= winner_list_update;
    alpha(winner)= alpha_t;
    bidder_max(:,winner)=bidd_update;
   
    elseif (winner==k)
        
     beta= H(:,winner);    
     winner_list_t= winner_list(:,winner-1);
     alpha_0= alpha(winner);
     bidd=bidder_max(:, winner);
     bidd_neighbour= bidder_max(:, winner-1);
     
    [  winner_list_update, alpha_t, bidd_update ] = Auction(winner, winner_list_0, winner_list_t, alpha_0, beta, bidd,  bidd_neighbour,  epsilon,n,k);
     
    
    winner_list(:, winner)= winnerNum_object * winner_list_update;
    alpha(winner)= alpha_t;
    bidder_max(:,winner)=bidd_update;
    
     
    else
        
    beta= H(:,winner);  
    winner_list_t= [winner_list(:,winner-1) winner_list(:,winner+1)];
    alpha_0= alpha(winner);
    bidd=bidder_max(:, winner);
    bidd_neighbour= [bidder_max(:, winner-1) bidder_max(:, winner+1)];
    
    
   [  winner_list_update, alpha_t, bidd_update ] = Auction(winner,winner_list_0, winner_list_t, alpha_0, beta, bidd,  bidd_neighbour, epsilon,n,k);
   
   
   
   winner_list(:, winner)= winner_list_update;
   alpha(winner)= alpha_t;
   bidder_max(:,winner)=bidd_update;
    end
   
    
end  
  
 
 
 if(winner_list_previous== winner_list)
     
     break;
     
 end
 
 winner_list_previous = winner_list; 
 
  end
  
  assignment=alpha(alpha~=0);
 end
 
 
 
function [ winner_list_update, alpha_t, bidd_update ] = Auction( winner, winner_list_0, winner_list_t, alpha_0, beta, bidd, bidd_neighbour, epsilon,n,k)
 
 winner_list_update= zeros(n,1);
 bidd_max= zeros(n,1);
 
for j=1:n
       
  [argvalue, argmax]= max([winner_list_0(j,:) winner_list_t(j,:)]);
  winner_list_update(j,:)= argvalue;
  
 
  bidd_acc=[bidd(j,:) bidd_neighbour(j,:)];
  bidd_max(j,:)= bidd_acc(argmax);
 
   
end
  if (winner_list_0(alpha_0,:)<=winner_list_update(alpha_0,1) && bidd_max(alpha_0,1)~=winner)
     
     
      [~, argmax]=max(beta-winner_list_update);         
    
      alpha_t = argmax;
      bidd_max(argmax,:)= winner;
      
      bidd_update= bidd_max;
      
      winnerNum_sort= sort((beta-winner_list_update),'descend');
      gamma= minus(winnerNum_sort(1,:), winnerNum_sort(2,:));  
      winner_list_update(alpha_t,:)=  winner_list_0(alpha_t,:)+gamma+epsilon;
       
 else
       
      alpha_t= alpha_0;
      
      bidd_update= bidd_max;
      
      
  end
  
end