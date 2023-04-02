%% First we need to set up the term-document matrix
% we use titles of papers instead of entire documents for simplicity
clear
d1 = ["assessing", "environmental", "diversity"];
d2 = ["planetary", "exploration"];
d3 = ["lsd" "drugs" "doses" "and" "biodistribution"];
d4 = ["tasmanian", "devil", "field", "study", "on", "devil", "facial", "tumour", "disease"];
d5 = ["basal", "cell", "carcinoma", "review"];
d6 = ["frequency", "of", "acid", "rain", "on", "arugula", "population", "growth", "on", "aphids"];
d7 = ["a", "review", "of", "pembrolizumab", "a", "treatment", "for", "esophagael", "cancer"];
d8 = ["a", "review", "of", "idursulfase", "for", "hunter", "syndrome"];
d9 = ["the", "first", "scientific", "classification", "of", "a", "dinosaur"];
d10 = ["review", "of", "current", "online", "and", "in-person", "mathematical", "education", "practices", "from", "undergraduate", "students", "perspectives"];
%d10 = ["review", "of", "current", "online", "and", "in-person", "mathematical"];
d11 = ["the", "effects", "of", "moderated", "red", "wine", "consumption", "on", "our", "gut", "microbiome"];
d12 = ["sustainable", "communities", "to", "mitigate", "climate", "change"];
d13 = ["planetary", "formation", "using", "our", "solar", "system", "as", "a", "case", "study"];
l = max([length(d1), length(d2), length(d3), length(d4), length(d5), length(d6), length(d7), length(d8), length(d9), length(d10), length(d11), length(d12), length(d13)])
d = [[d1 zeros(1, l-length(d1))]' [d2 zeros(1, l-length(d2))]' [d3 zeros(1, l-length(d3))]' [d4 zeros(1, l-length(d4))]' [d5 zeros(1, l-length(d5))]' [d6 zeros(1, l-length(d6))]' [d7 zeros(1, l-length(d7))]' [d8 zeros(1, l-length(d8))]' [d9 zeros(1, l-length(d9))]' [d10 zeros(1, l-length(d10))]' [d11 zeros(1, l-length(d11))]' [d12 zeros(1, l-length(d12))]' [d13 zeros(1, l-length(d13))]']
terms = unique(d);
terms_sort = terms(2:length(terms)); %these are the terms present in our documents, in alphabetical order
term_doc = zeros(length(terms_sort),length(d));
for j = 1:size(d,2)
     for i = 1:length(terms_sort)    
         for k = 1:length(d(:,j))
            if terms_sort(i) == d(k,j)
                term_doc(i,j) = term_doc(i,j) + 1;
            end
        end
    end
end
term_doc

%% At this point term_doc is our term-document matrix, now we perform SVD
[U, S, V] = svd(term_doc);

% find low rank (code already exists)
ksigma = 13;
latent = zeros(size(term_doc));
for i = 1:ksigma
    latent = latent + (S(i,i) * U(:,i) * V(:,i)');
end

labels1 = cellstr(num2str([1:74]'))
labels2 = ["d1", "d2", "d3", "d4", "d5", "d6", "d7", "d8", "d9", "d10", "d11", "d12", "d13"]
fig1 = figure; clf;
hold on
%plot(U(:,1)*S(1,1), U(:,2)*S(2,2), 'o')
%text(U(:,1)*S(1,1), U(:,2)*S(2,2), labels1,'VerticalAlignment','bottom','HorizontalAlignment','right')
plot(V(:,1)*S(1,1), V(:,2)*S(2,2), 'o')
text(V(:,1)*S(1,1), V(:,2)*S(2,2), labels2,'VerticalAlignment','bottom','HorizontalAlignment','right')


% find the error of the best rank k approximation of A
err = norm(term_doc-latent)
err_A_best = norm(err)/norm(term_doc)

%%
% enter query vector and compute dot products (for loop)
query = ["cancer", "review"];
q = zeros(length(terms_sort),1);
for k = 1:length(query)
    for i = 1:length(terms_sort)
        if terms_sort(i) == query(k)
             q(i) = q(i) + 1;
        end
    end
end
q
qhat = q'*(U(:,1:ksigma))*(inv(S(1:ksigma,1:ksigma)));
dotprod = zeros(13,1);

for i = 1:13
    f1 = qhat*V(1:ksigma,i);
    if abs(f1) > eps
        dotprod(i) = acos(f1/(norm(qhat)*norm(V(1:ksigma,i))));
    else
        dotprod(i) = pi/2;
    end
end
dotprod
[M I] = min(dotprod)
% for i = 1:length(dotprod)
%     if abs(dotprod(i))<1
%         disp(i)
%     end
% end
labels3 = ["q"]
hold on
%plot(U(:,1)*S(1,1), U(:,2)*S(2,2), 'o')
%text(U(:,1)*S(1,1), U(:,2)*S(2,2), labels1,'VerticalAlignment','bottom','HorizontalAlignment','right')
plot(V(:,1)*S(1,1), V(:,2)*S(2,2), 'o')
text(V(:,1)*S(1,1), V(:,2)*S(2,2), labels2,'VerticalAlignment','bottom','HorizontalAlignment','right')
plot(q'*(U(:,1))*(inv(S(1,1))),q'*(U(:,2))*(inv(S(2,2))), 'o')
text(q'*(U(:,1))*(inv(S(1,1))),q'*(U(:,2))*(inv(S(2,2))), labels3,'VerticalAlignment','top','HorizontalAlignment','right')
%%Folding in
% we add three new titles
d14 = ["defining", "luxury", "what", "makes", "wine", "expensive"]
d15 = ["ocean", "acidification", "on", "marine", "ecosystems"]
d16 = ["the", "great", "lakes", "from", "formation","to", "documentation"]
