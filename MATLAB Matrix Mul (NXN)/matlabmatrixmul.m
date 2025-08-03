


% Prompt for matrix size
n = input('Enter the size of the square matrices (n): ');

% Initialize matrices
A = zeros(n, n);
B = zeros(n, n);

% Input matrix A
disp('Enter elements for matrix A:');
for i = 1:n
    for j = 1:n
        A(i, j) = input(sprintf('A(%d,%d): ', i, j));
    end
end

% Input matrix B
disp('Enter elements for matrix B:');
for i = 1:n
    for j = 1:n
        B(i, j) = input(sprintf('B(%d,%d): ', i, j));
    end
end

% Matrix multiplication
C = A * B;

% Display result
disp('Matrix A * Matrix B =');
disp(C);
