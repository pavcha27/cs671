% m,n,nnz to study
ms = (1000:500:7999);
ns = (1000:500:7999);
nnzs = (11:10:70);

% hold values of times each iteration
ts = zeros(1,4);

% store each time with averaging over iterations
mn_times = zeros(6, (size(ms,2)*size(ns,2)));
nnz_times = zeros(5, size(nnzs, 2));
counter_mn = 1;

% sparse_function(ms(1), ns(1), nnz(1))

for i = 1:size(ms,2)
    for j = 1:size(ns,2)
        mn_times(1,counter_mn) = ms(i);
        mn_times(2,counter_mn) = ns(j);

        for k = 1:size(nnzs,2)
            nnz_times(1,k) = nnzs(k);

            % print initial state
            fprintf('\n-------------------\n\n (m, n, nnz) = (%g, %g, %g) \n\n----------------\n', ms(i),ns(j), nnzs(k))
            
            ts = sparse_function(ms(i),ns(j),nnzs(k));
            
            % print times
            fprintf('\n-------------------\n\n (t_ss, t_ff, t_sf, t_fs) = (%g, %g, %g, %g) \n\n----------------\n', ts(1),ts(2),ts(3),ts(4))
            
            mn_times(3:6, counter_mn) = mn_times(3:6, counter_mn) + ts(1:4,1);
            nnz_times(2:5,k) = nnz_times(2:5,k) + ts(1:4,1);

        end
        % average the mn times over the different nnz's
        mn_times(3:6, counter_mn) = mn_times(3:6, counter_mn)/size(nnzs,2);
        counter_mn = counter_mn + 1;
    end
end

% average the nnz times over the different m's and n's
nnz_times(2:5,:) = nnz_times(2:5,:) .* (ones(4,size(nnzs,2))/(size(ms,2)*size(ns,2)));

format long g
disp(mn_times)

disp(nnz_times)

% plot surfaces for mn times
[x,y] = meshgrid(ms,ns);
z1 = reshape(mn_times(3,:),[size(ms,2),size(ns,2)]);
z2 = reshape(mn_times(4,:),[size(ms,2),size(ns,2)]);
z3 = reshape(mn_times(5,:),[size(ms,2),size(ns,2)]);
z4 = reshape(mn_times(6,:),[size(ms,2),size(ns,2)]);

% graph each timing
figure('Name','Times related to size of matrix')
s1 = surf(x,y,z1);
hold on
s2 = surf(x,y,z2);
hold on
s3 = surf(x,y,z3);
hold on
s4 = surf(x,y,z4);
hold off

s1.EdgeColor = 'none'; s1.FaceColor = 'red'; s1.FaceAlpha = 0.5;
s2.EdgeColor = 'none'; s2.FaceColor = 'green'; s2.FaceAlpha = 0.5;
s3.EdgeColor = 'none'; s3.FaceColor = 'yellow'; s3.FaceAlpha = 0.5;
s4.EdgeColor = 'none'; s4.FaceColor = 'blue'; s4.FaceAlpha = 0.5;

xlabel('rows = m')
ylabel('columns = n')
zlabel('time in seconds')
legend('SparseSparse', 'FullFull', 'SparseFull', 'FullSparse')

drawnow

% plot graph of time versus number of nonzeros
figure('Name','Times related to number or nonzero entries')
p1 = plot(nnz_times(1,:), nnz_times(2,:));
hold on
p2 = plot(nnz_times(1,:), nnz_times(3,:));
p3 = plot(nnz_times(1,:), nnz_times(4,:));
p4 = plot(nnz_times(1,:), nnz_times(5,:));
hold off

p1.LineWidth = 5;
p2.LineWidth = 5;
p3.LineWidth = 5;
p4.LineWidth = 5;

xlabel('number of non-zero elements per row')
ylabel('time in seconds')
legend('SparseSparse', 'FullFull', 'SparseFull', 'FullSparse')

drawnow
