-------------------------- Iniciando a matriz --------------------------

initialize :: [[String]]
initialize  = [ [ mapValue m n  | n <- [0..8] ] | m <- [0..8] ]

mapValue :: Int -> Int -> String
mapValue x y	| (x == 0 && y == 0) = "-"
		| (y == 0) = show(x)
		| (x == 0) = " " ++ show(y)
		| (x >= 1 && x <= 3) && (x `mod` 2 /= 0 && y `mod` 2 == 0) = "O"
		| (x >= 1 && x <= 3) && (x `mod` 2 == 0 && y `mod` 2 /= 0) = "O"
		| (x >= 6 && x <= 8) && (x `mod` 2 /= 0 && y `mod` 2 == 0) = "X"
		| (x >= 6 && x <= 8) && (x `mod` 2 == 0 && y `mod` 2 /= 0) = "X"
		| otherwise = " " 

-------------------------- Exibindo a matriz ---------------------------

showMatrix :: [[String]] -> String
showMatrix m = concat ( concat [ [ mapMatrix y | y <- x] ++ ["\n"]| x <- m])

mapMatrix :: String -> String
mapMatrix value	| (value == "O") = " O"
		| (value == "X") = " X"
		| (value == "-") = "-"
		| (value /= " ") = value
		| otherwise = " ~"

-------------------------- Logica das jogadas --------------------------

-- Muda a posicao das pecas passando linhas e colunas antigas e novas
changePosition :: Int -> Int -> String -> [[String]] -> [[String]]
changePosition x y value matrix = [ [ verifyPosition x y m n value ( ( matrix !! n ) !! m) | m <- [0..8] ] | n <- [0..8] ]

-- Verifica as posicoes no tabuleiro mudar o valor da peca especificada
verifyPosition :: Int -> Int -> Int -> Int -> String -> String -> String
verifyPosition x y m n value old_value	| (x == n && y == m) = value
					| otherwise = old_value

-- Verifica se uma posicao eh valida nos limites do tabuleiro
verifyIndex :: Int -> Int -> Int -> Int -> Bool
verifyIndex oldL oldC newL newC	| ((oldL >= 1 && oldL <= 8) && (oldC >= 1 && oldC <= 8) && (newL >= 1 && newL <= 8) && (newC >= 1 && newC <= 8)) = True
				| otherwise = False

-- Move a peca do tipo "O" para a esquerda ou para a direita, respeitando as regras de locomocao do jogo
moveToLeftOrRightO :: Int -> Int -> Int -> Int -> [[String]] -> Bool
moveToLeftOrRightO oldL oldC newL newC matrix	| ((( matrix !! oldL ) !! oldC) /= "O") = False
						| (((oldL - newL == -1) && (oldC - newC == 1) && (((matrix !! newL) !! newC) == " ")) || ((oldL - newL == -1) && (oldC - newC == -1) && (((matrix !! newL) !! newC) == " "))) = True
						| otherwise = False

-- Come a peca do tipo "O" para a direita, respeitando as regras de locomocao do jogo
eatToRightO :: Int -> Int -> Int -> Int -> [[String]] -> Bool
eatToRightO oldL oldC newL newC matrix	| ((( matrix !! oldL ) !! oldC) /= "O") = False
					| ((oldL - newL == -2) && (oldC - newC == 2) && (((matrix !! newL) !! newC) == " ") && (((matrix !! (newL - 1)) !! (newC + 1)) == "X")) = True
					| otherwise = False

-- Come a peca do tipo "O" para a esquerda, respeitando as regras de locomocao do jogo
eatToLeftO :: Int -> Int -> Int -> Int -> [[String]] -> Bool
eatToLeftO oldL oldC newL newC matrix	| ((( matrix !! oldL ) !! oldC) /= "O") = False
					| ((oldL - newL == -2) && (oldC - newC == -2) && (((matrix !! newL) !! newC) == " ") && (((matrix !! (newL - 1)) !! (newC - 1)) == "X")) = True
					| otherwise = False

-- Move a peca do tipo "X" para a esquerda ou para a direita, respeitando as regras de locomocao do jogo
moveToLeftOrRightX :: Int -> Int -> Int -> Int -> [[String]] -> Bool
moveToLeftOrRightX oldL oldC newL newC matrix	| ((( matrix !! oldL ) !! oldC) /= "X") = False
						| (((oldL - newL == 1) && (oldC - newC == -1) && (((matrix !! newL) !! newC) == " ")) || ((oldL - newL == 1) && (oldC - newC == 1) && (((matrix !! newL) !! newC) == " "))) = True
						| otherwise = False
						
-- Come a peca do tipo "X" para a direita, respeitando as regras de locomocao do jogo
eatToRightX :: Int -> Int -> Int -> Int -> [[String]] -> Bool
eatToRightX oldL oldC newL newC matrix	| ((( matrix !! oldL ) !! oldC) /= "X") = False
					| ((oldL - newL == 2) && (oldC - newC == -2) && (((matrix !! newL) !! newC) == " ") && (((matrix !! (newL + 1)) !! (newC - 1)) == "O")) = True
					| otherwise = False

-- Come a peca do tipo "X" para a esquerda, respeitando as regras de locomocao do jogo
eatToLeftX :: Int -> Int -> Int -> Int -> [[String]] -> Bool
eatToLeftX oldL oldC newL newC matrix	| ((( matrix !! oldL ) !! oldC) /= "X") = False
					| ((oldL - newL == 2) && (oldC - newC == 2) && (((matrix !! newL) !! newC) == " ") && (((matrix !! (newL + 1)) !! (newC + 1)) == "O")) = True
					| otherwise = False

-- Faz a jogada, movendo ou comendo uma peca de um lugar para outro, respeitando as regras de locomocao do jogo
makePlay :: Int -> Int -> Int -> Int -> String -> [[String]] -> [[String]]
makePlay oldL oldC newL newC value matrix	| (not (verifyIndex oldL oldC newL newC)) = matrix
						| ((( matrix !! oldL ) !! oldC) == " ") = matrix
						| ((( matrix !! oldL ) !! oldC) /= value) = matrix
						| (moveToLeftOrRightO oldL oldC newL newC matrix) = changePosition newL newC value (changePosition oldL oldC " " matrix)
						| (eatToRightO oldL oldC newL newC matrix) = changePosition newL newC value (changePosition oldL oldC " " (changePosition (newL - 1) (newC + 1) " " matrix))
						| (eatToLeftO oldL oldC newL newC matrix) = changePosition newL newC value (changePosition oldL oldC " " (changePosition (newL - 1) (newC - 1) " " matrix))
						| (moveToLeftOrRightX oldL oldC newL newC matrix) = changePosition newL newC value (changePosition oldL oldC " " matrix)
						| (eatToRightX oldL oldC newL newC matrix) = changePosition newL newC value (changePosition oldL oldC " " (changePosition (newL + 1) (newC - 1) " " matrix))
						| (eatToLeftX oldL oldC newL newC matrix) = changePosition newL newC value (changePosition oldL oldC " " (changePosition (newL + 1) (newC + 1) " " matrix))
						| otherwise = matrix

-- Verifica se as pecas de um tipo ou de outro nao existem mais no tabuleiro						
verifyPeaces :: String -> [[String]] -> Bool
verifyPeaces value [] = False
verifyPeaces value (a:as)	| (value `elem` a) = True
				| otherwise = False || (verifyPeaces value as)

-- Retorna o vencedor do jogo
verifyWinner :: [[String]] -> String
verifyWinner matrix	| (not (verifyPeaces "O" matrix)) = "X"
			| (not (verifyPeaces "X" matrix)) = "O"
			| otherwise = " "

------------------------------- Jogadas -------------------------------

changePlayer value
	| value == "X" = "O" 
	| otherwise = "X"

verifyPlay matrix changedMatrix = do
	if (matrix == changedMatrix) then
		putStrLn("Jogada Inválida!")
	else
		putStrLn("Jogada aceita!")
	
verifyPlayer value matrix changedMatrix
	| (matrix == changedMatrix) = game (verifyWinner matrix) value matrix
	| otherwise = game (verifyWinner changedMatrix) (changePlayer value) changedMatrix

printMatrix matrix = do
	let viewMatrix = showMatrix (matrix)
	putStrLn(viewMatrix)

game "X" _ matrix = do
	printMatrix matrix
	putStrLn("Fim de jogo! O vencedor é: X")

game "O" _ matrix = do 
	printMatrix matrix
	putStrLn("Fim de jogo! O vencedor é: O")

game _ value matrix = do
	printMatrix matrix

	putStrLn("Jogador da rodada: " ++ value)

	putStrLn("Digite a linha na qual a peca se encontra:")
	oldL <- getLine
	putStrLn("Digite a coluna na qual a peca se encontra:")
	oldC <- getLine
	putStrLn("Digite a linha que desejas para nova posicao da peca:")
	newL <- getLine
	putStrLn("Digite a coluna que desejas para nova posicao da peca:")
	newC <- getLine
	
	let changedMatrix = (makePlay (read oldL) (read oldC) (read newL) (read newC) value matrix)
	
	verifyPlay matrix changedMatrix
	
	verifyPlayer value matrix changedMatrix

main :: IO()
main = do
	let matrix = initialize	
	game (verifyWinner matrix) "X" matrix
