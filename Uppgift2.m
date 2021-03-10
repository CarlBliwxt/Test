 %Uppgift 2 Matlab-uppgift Carl Blixt 20000702-0191 Kurskod: 1FA527
 
close all
clear all 

%Börjar med allt känt från given uppgift. 
P1=0.1; % Trycket känt i punkt 1 angivet i bar samt att detta är en mättad vätska. 
P2=90;  % Angivet i uppgift
P6=P1; %Dessa antagande baseras på det som skrivs i förklarande text. 
P3=P2;  % Isobar 


s1=XSteam('sL_p', P1); % Läser in entropi för den mättadevätskan, med känt tryck
s2=s1; %På grund av att den är isentropisk så är s2=s1, entropin bevaras alltså. 
%För att kunna få ut verkningsgraden behöver vi nu hitta de olika
%entaliperna för de olika tillstånden och sedan använda att verkningsgraden för en rankinecykel anges av:  nth=1-(qut/qin)

%Beräkning av h1.
h1=XSteam('hL_p',P1); % Beräkning av h1 för en mättad vätska mha av XSteam
%Beräkning av h2. 
h2=XSteam('h_ps',P2,s2); % Läser in entalpin som en funktion av de två kända variabler som är givna, tryck och entropi 

%Beräkning av h3 
T3=304:10:604; %Skapar en vektor mellan 304 och 604, där vektorn tar 10 steg i taget. 
s3=zeros(size(T3)); % Array av nollor, storlek av T3. 
for i=1:length(T3) % for loop från 1 till längden av T3. 
    s3(i)=XSteam('s_pT',P3, T3(i)); % Beräkning av entropin av den mättade gasen, samma for loop som innan. 
end    

h3=zeros(size(T3)); % Skapar en array av nollor som har samma storlek som vektor T3, denna använder sedan för att fylla på med värden.
    for i=1:length(T3) %Skriver en for loop som går från att läsa in första elemetet till längden på vektor T3. 
       h3(i)=XSteam('h_pT',P3,T3(i)); % Det går även att använda trycket och entropin med h_ps och input p3 och s3(i), samma resultat fås. 
    end 

%Beräkning av h6 
%För att kunna beräkna denna behövs ångkvaliten av gasen. 
%Isentropisk process, vilket inebär att entropin är den samma vid tillstånd 3 som 6.  
%Ångkvaliten kan beräknas med hjälp av följande formel: x=(s4-sf)/sfg 
s6=s3; %På grund av att entropin bevaras från 3 till 6. 
sf=XSteam('sL_p',P6); % hämtar in värden för mättad vätskan .
sfg=XSteam('sV_p', P6)-XSteam('sL_p',P6); % Beräknar differensen mellan mättad gas och mättad vätska
x=(s6-sf)./sfg; % Beräkning av ångkvaliten, obs x blir en vektor på grund av massa olika värden på s6. 

h6=zeros(size(T3)); % Array av noller storlek T3. 
for i=1:length(T3) % Från 1 till längen T3. 
    h6(i)=XSteam('h_px',P6,x(i)); %Beräkning av entalpi som en funktion av det konstanta trycket och den varierande ångkvaliten. 
end 


%Nu har vi allt vi behöver för att kunna beräkna verkningsgraden för en rankinecykel. 
qin=h3-h2;
qut=h6-h1;

nth=1-(qut./qin);
    
figure(1) % Formalia. 
plot(T3,nth,'r')
xlabel('Temperatur [Celcius]')
ylabel('Verkningsgrad')
title ('Verkningsgraden mot temperatur')
grid on
 %% Uppgift 2   
 
T5=input('Ange ett värde mellan 304 till 600 grader celcius: '); %Låter användaren sätta in ett värde mellan Tsat och Tmax, se motivering i dokumentet. 

if (304<=T5 && T5 <=600) % Sätter upp en if sats för att kontrollera att värdet verkligen ligger inom givna intervallet. 
    T5;
else 
    disp('Angivet värde ligger inte inom intervallet, vänligen försök igen') 
    T5=input('Ange ett värde mellan 304 till 600 grader celcius: '); %Låter användaren försöka igen. 
end 
   
   
%Vill nu studera hur verkningsgraden varierar med kvoten P4/P3, för att
%kunna få ut denna kan vi ytterligare en gång beräkna entalpier och
%entropier för att sedan använda kända givna formler för en rankinecykel
%med mellanhettning. 
s3=XSteam('s_pT', P3, T5) ; % Beräkningar av entropi vid trycket P3 och det angivna Temperaturen. 
s4=s3;
P4=0.1:0.1:90;
h4=zeros(size(P4)); %Array av noller av storleken P4
h5=zeros(size(P4)); % ibid
s5=zeros(size(P4)); %ibid 
h3=XSteam('h_pT',P3,T5); % beräkning av entropi som en funktion av trycket och temperaturen, T3=T5 angivet i uppgift. 
for i=1:length(P4) %från 1 till längden av P4. 
s5(i)=XSteam('s_pT', P4(i),T5); %Räknar ut entropi för de olika trycken, och lagar i respektive s(1) s(2) ... s(n) 
h4(i)=XSteam('h_ps',P4(i),s4);  %Beräkning av entalpi vid tillstånd 4 med varje element från tryckvektorn, som en funktion av varierande tryck och konstant entropi. 
h5(i)=XSteam('h_pT',P4(i),T5); % Beräkning av entalpi som en funktion av varierande tryck och konstant temperatur 
h6(i)=XSteam('h_ps', P6 ,s5(i)); %Beräkning av entalpi vid tillstånd 6, som en funktion av tryck och entropi, trycket är desamma som i tillstånd 1. 
end 

% Nu har vi alla entaliper som behövs med givna formler. 
qin2=(h3-h2) + (h5-h4);
qut2=h6-h1;
%Beräkningen av verkningsgrad 
nth2= 1-(qut2./qin2);
%Kvoten av P4/P3 som eftertraktas i upgiften. 
k=P4/P3;
%Sätter en ny figur och plottar sedan 
figure(2)
plot(k,nth2)
xlabel('Kvoten P4/P3 ')
ylabel('Verkningsgrad')
title ('Hur verkningsgraden varierar beroende på kvoten')
grid on
%Uppgift 3  
[nth2, index] = max(nth2); % Hittar max värde för nth och motsvarande index, alltså vart i självaste vektorn den befinner sig
A=max(nth2);
% Vill nu få ut vad motsvarande tryck är vid detta index. 
P4_max=P4(index); %Kollar sedan vilket tryck som ger den maximala verkningsgradet genom att 
disp(['Den maximala verkningsgraden är ', num2str(A), ' vid temperaturen ', num2str(T5), ' C och trycket ', num2str(P4_max), ' Bar']) %Display av svar i Command Window   