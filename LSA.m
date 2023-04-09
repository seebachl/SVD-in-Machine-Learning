%% An example of LSA using SVD
% First we set up the term-document matrix
% we use titles of first and second year math textbooks at McMaster University for simplicity
clear

% Enter the titles 
d1 = ["calculus", "early", "transcendentals"];
d2 = ["linear", "algebra", "and", "its", "applications"];
d3 = ["the" "tools" "of" "mathematical" "reasoning"];
d4 = ["applied", "calculus", "for", "business", "economics", "and", "the", "social", "and", "life", "sciences"];
d5 = ["calculus", "for", "the", "life", "sciences", "modelling", "the", "dynamics", "of", "life"];
d6 = ["elementary", "linear", "algebra", "applications", "version"];
d7 = ["finite", "mathematics", "and", "its", "applications"];
d8 = ["elementary", "differential", "equations", "with", "boundary", "value", "problems"];
d9 = ["mathematics", "of", "investment", "and", "credit"];
d10 = ["linear", "algebra", "done", "right"];
d11 = ["99", "numbers", "mathematics", "of", "everyday", "life"];
d12 = ["biostatistics", "for", "the", "biological", "and", "health", "sciences"];
d13 = ["introduction", "to", "probability"];
d14 = ["probability", "and", "statistics", "for", "engineering", "and", "the", "sciences"];
l = max([length(d1), length(d2), length(d3), length(d4), length(d5), length(d6), length(d7), length(d8), length(d9), length(d10), length(d11), length(d12), length(d13), length(14)]);

% creating a matrix of the documents 
d = [[d1 zeros(1, l-length(d1))]' [d2 zeros(1, l-length(d2))]' [d3 zeros(1, l-length(d3))]' [d4 zeros(1, l-length(d4))]' [d5 zeros(1, l-length(d5))]' [d6 zeros(1, l-length(d6))]' [d7 zeros(1, l-length(d7))]' [d8 zeros(1, l-length(d8))]' [d9 zeros(1, l-length(d9))]' [d10 zeros(1, l-length(d10))]' [d11 zeros(1, l-length(d11))]' [d12 zeros(1, l-length(d12))]' [d13 zeros(1, l-length(d13))]' [d14 zeros(1, l-length(d14))]'];

% replacing words three letters or less with "0" 
for i = 1:size(d,1)
    for j = 1:size(d,2)
        if strlength(d(i,j))<=3
            d(i,j) = 0;
        end
    end
end

% removing duplicate words and turning matrix into vector 
terms = unique(d);
terms_sort = terms(2:length(terms)); %these are the terms present in our documents, in alphabetical order, not including words less than three letters
term_doc = zeros(length(terms_sort),size(d,2));

% creating term-document matrix
% for simplicity, we use term frequency local weighting and no global weighting
for j = 1:size(d,2)
     for i = 1:length(terms_sort)    
         for k = 1:length(d(:,j))
            if terms_sort(i) == d(k,j)
                term_doc(i,j) = term_doc(i,j) + 1;
            end
        end
    end
end

term_doc; % this is our term-document matrix
%% Performing SVD on the term-document matrix 
[U, S, V] = svd(term_doc);

% Finding the low rank approximation 
ksigma = 5; % change this to change the dimension
latent = zeros(size(term_doc));
for i = 1:ksigma
    latent = latent + (S(i,i) * U(:,i) * V(:,i)'); % this is our approximation matrix 
end

%% Creating a figure for the semantic vector space (ksigma = 2) 
labels1 = cellstr(num2str([1:length(terms_sort)]'));
labels2 = ["d1", "d2", "d3", "d4", "d5", "d6", "d7", "d8", "d9", "d10", "d11", "d12", "d13", "d14"];
fig1 = figure; clf;
hold on

% plot U for the terms 
%plot(U(:,1)*S(1,1), U(:,2)*S(2,2), 'o')
%text(U(:,1)*S(1,1), U(:,2)*S(2,2), labels1,'VerticalAlignment','bottom','HorizontalAlignment','right')

%plot V for the documents
scatter(V(:,1)*S(1,1), V(:,2)*S(2,2))
text(V(:,1)*S(1,1), V(:,2)*S(2,2), labels2,'VerticalAlignment','bottom','HorizontalAlignment','right')
grid on; axis([-3 1 -3 1])
title('A Two-Dimensional Plot of Documents')

%% Finding documents based on a query
% enter a query vector
query = ["statistics"];
q = zeros(length(terms_sort),1);
for k = 1:length(query)
    for i = 1:length(terms_sort)
        if terms_sort(i) == query(k)
             q(i) = q(i) + 1; % find query's document representation
        end
    end
end

qhat = q'*(U(:,1:ksigma))*(inv(S(1:ksigma,1:ksigma))); % find q's mapping to the semantic space

%compute cosine similarity
cos_sim = zeros(length(l),1);
for i = 1:14
        f1 = V(i,1:ksigma)*qhat';
        cos_sim(i) = (f1/(norm(qhat)*norm(V(i,1:ksigma)')));
end

% find the documents with a cosine similarity larger than 0.9
L = cos_sim>0.9;
for i = 1:length(L)
    if L(i) == 1
        fprintf("This search returns textbook d%d \n", i);
    end
end

% compute the query in 2-D
q2d = q'*(U(:,1:2))*inv(S(1:2,1:2));

labels3 = ["q"];
hold on
%plot(U(:,1)*S(1,1), U(:,2)*S(2,2), 'o')
%text(U(:,1)*S(1,1), U(:,2)*S(2,2), labels1,'VerticalAlignment','bottom','HorizontalAlignment','right')
% plot(V(:,1)*S(1,1), V(:,2)*S(2,2), 'o')
% text(V(:,1)*S(1,1), V(:,2)*S(2,2), labels2,'VerticalAlignment','bottom','HorizontalAlignment','right')

scatter(V(:,1)*S(1,1), V(:,2)*S(2,2))
text(V(:,1)*S(1,1), V(:,2)*S(2,2), labels2,'VerticalAlignment','bottom','HorizontalAlignment','right')
plot(q2d(1), q2d(2), 'o')
text(q2d(1), q2d(2), labels3,'VerticalAlignment','top','HorizontalAlignment','right')
grid on; axis([-3 1 -3 1])
title('A Two-Dimensional Plot of Documents with Query')

%% Updating
% we add select third year textbooks
d18 = ["introduction", "to", "mathematical", "statistics"];
d19 = ["applied", "statistics", "and", "probability", "for", "engineering"];

% creating a matrix of the documents 
l1 = max([length(d18), length(d19)]);
d1 = [[d18 zeros(1, l-length(d18))]' [d19 zeros(1, l-length(d19))]'];

% replacing words three letters or less with "0" 
for i = 1:size(d1,1)
    for j = 1:size(d1,2)
        if strlength(d1(i,j))<=3
            d1(i,j) = 0;
        end
    end
end

% finding document vectors for new documents 
newterm_doc = zeros(length(terms_sort),size(d1,2));
for j = 1:size(d1,2)
     for i = 1:length(terms_sort)    
         for k = 1:length(d1(:,j))
            if terms_sort(i) == d1(k,j)
                newterm_doc(i,j) = newterm_doc(i,j) + 1;
            end
        end
    end
end

% adding mapped documents to V_k
Vkp = V(:,1:ksigma)';
for i = 1:size(newterm_doc,2)
    Vkp = [Vkp [newterm_doc(:,i)'*(U(:,1:ksigma))*(inv(S(1:ksigma,1:ksigma)))]'];
end