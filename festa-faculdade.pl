:- use_module(library(clpfd)).

%% festa_faculdade(?E1, ?E2, ?E3, ?E4) is nondet
%
%  Verdadeiro se E1, E2, E3 e E4 são termos estudante(Nome, Idade, Curso, AnoCurso)
%  que atendem as restrições do seguinte problema de lógica.
%
% Festa da Faculdade
%
% Quatro estudantes estão aproveitando uma festa da faculdade para se divertirem. Através da lógica,
% descubra as características delas.
% 1. Cecília não tem 21 anos.
% 2. Nem a Helena nem a estudante de 20 anos estão no terceiro ano da faculdade.
% 3. Entre as estudantes de 20 anos e 21 anos, uma cursa enfermagem e a outra está no primeiro ano, não
% necessariamente nessa ordem.
% 4. A estudante do primeiro ano é mais velha do que a Angélica.
% 5. A estudante de direito é mais velha do que a estudante do primeiro ano.
% 6. Nayara cursa medicina.
% 7. Entre a estudante do segundo ano e a estudante de 20 anos, uma cursa direito e a outra é a Nayara, não
% necessariamente nessa ordem.

festa_faculdade(E1, E2, E3, E4) :-
    Estudantes = [E1, E2, E3, E4],
    E1 = estudante(angelica, _, _, _),
    E2 = estudante(cecilia, _, _, _),
    E3 = estudante(helena, _, _, _),
    E4 = estudante(nayara, _, _, _),
    % Idade dos estudantes
    member(estudante(_, 19, _, _), Estudantes),
    member(estudante(_, 20, _, _), Estudantes),
    member(estudante(_, 21, _, _), Estudantes),
    member(estudante(_, 22, _, _), Estudantes),
    % Curso dos estudantes
    member(estudante(_, _, administracao, _), Estudantes),
    member(estudante(_, _, direito, _), Estudantes),
    member(estudante(_, _, enfermagem, _), Estudantes),
    member(estudante(_, _, medicina, _), Estudantes),
    % Ano que os estudantes estão cursando nos cursos
    member(estudante(_, _, _, 1), Estudantes),
    member(estudante(_, _, _, 2), Estudantes),
    member(estudante(_, _, _, 3), Estudantes),
    member(estudante(_, _, _, 4), Estudantes),
    % 1. Cecília não tem 21 anos
    \+(member(estudante(cecilia, 21, _, _), Estudantes)),
    % 2. Nem a Helena nem a estudante de 20 anos estão no terceiro ano da faculdade.
    \+(member(estudante(helena, _, _, 3), Estudantes)),
    \+(member(estudante(_, 20, _, 3), Estudantes)),
    % 3. Entre as estudantes de 20 anos e 21 anos, uma cursa enfermagem e a outra está no primeiro ano, não
    % necessariamente nessa ordem.
    ((member(estudante(_, 20, enfermagem, _), Estudantes),
        \+(member(estudante(_, 20, _, 1), Estudantes))) ;
    (member(estudante(_, 20, _, 1), Estudantes),
        \+(member(estudante(_, 20, enfermagem, _), Estudantes)))),
    ((member(estudante(_, 21, enfermagem, _), Estudantes),
        \+(member(estudante(_, 21, _, 1), Estudantes))) ;
    (member(estudante(_, 21, _, 1), Estudantes),
        \+(member(estudante(_, 21, enfermagem, _), Estudantes)))),
    % 4. A estudante do primeiro ano é mais velha do que a Angélica.
    mais_velho(Estudantes, estudante(_, _, _, 1), estudante(angelica, _, _, _)),
    % 5. A estudante de direito é mais velha do que a estudante do primeiro ano.
    mais_velho(Estudantes, estudante(_, _, direito, _), estudante(_, _, _, 1)),
    % 6. Nayara cursa medicina.
    member(estudante(nayara, _, medicina, _), Estudantes),
    % 7. Entre a estudante do segundo ano e a estudante de 20 anos, uma cursa direito e a outra é a Nayara, não
    % necessariamente nessa ordem.
    ((member(estudante(_, _, direito, 2), Estudantes),
        \+(member(estudante(_, 20, direito, _), Estudantes))) ;
    (member(estudante(_, 20, direito, _), Estudantes),
        \+(member(estudante(_, _, direito, 2), Estudantes)))),
    ((member(estudante(nayara, _, _, 2), Estudantes),
        \+(member(estudante(nayara, 20, _, _), Estudantes))) ;
    (member(estudante(nayara, 20, _, _), Estudantes),
        \+(member(estudante(nayara, _, _, 2), Estudantes)))).

%% mais_velho(?Estudantes, ?E1, ?E2) is nondet
%
%  Verdadeiro se E1 e E2 estão na lista Estudantes e tem E1 idade maior que a idade de E2.

:- begin_tests(mais_velho).

test(t1, nondet) :-
    A = estudante(_, 19, _, _),
    B = estudante(_, 20, _, _),
    C = estudante(_, 21, _, _),
    mais_velho([A, B, C], B, A).

test(t2, fail) :-
    A = estudante(_, 19, _, _),
    B = estudante(_, 20, _, _),
    C = estudante(_, 21, _, _),
    mais_velho([A, B, C], A, B).

test(t3, fail) :-
    A = estudante(_, 19, _, _),
    B = estudante(_, 20, _, _),
    C = estudante(_, 21, _, _),
    mais_velho([A, C], B, A).

test(t4, nondet) :-
    A = estudante(_, 19, _, _),
    C = estudante(_, 21, _, _),
    mais_velho([A, B, C], B, A).

test(t5, nondet) :-
    B = estudante(_, 20, _, _),
    C = estudante(_, 21, _, _),
    mais_velho([A, B, C], B, A).

test(t6, all(IdadeD == [20, 21])) :-
    A = estudante(_, 19, _, _),
    B = estudante(_, 20, _, _),
    C = estudante(_, 21, _, _),
    D = estudante(_, IdadeD, _, _),
    mais_velho([A, B, C], D, A).

:- end_tests(mais_velho).

mais_velho(Estudantes, E1, E2) :-
    E1 = estudante(_, IdadeE1, _, _),
    E2 = estudante(_, IdadeE2, _, _),
    IdadeE1 #> IdadeE2,
    member(E1, Estudantes),
    member(E2, Estudantes).