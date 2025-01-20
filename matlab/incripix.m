function [ipix,fidt]=incripix(ipix,fidt,fidtv,file1siz,val,nbitq)


    ipix=ipix+1;
    if (ipix==file1siz)
        fprintf(fidtv,"to_sfixed(%d.0/%d.0,1,-nbitq) ) ; \n\n",val,2^nbitq);
        fprintf(fidtv,"%s",'constant allcoef2 : typtabcst := ( ');

        fclose(fidt) ;
        fidt = fopen('coeft2.txt', 'wt');
    else
        fprintf(fidtv,'to_sfixed(%d.0/%d.0,1,-nbitq), \n', val,2^nbitq);
    end
