module Stacklang2 where

type Prog = [Cmd]
type Stack = [Either Bool Int]
data Cmd = LDI Int | LDB Bool | LEQ | ADD | MULT | DUP | IFELSE Prog Prog deriving Show

run :: Prog -> Stack -> Maybe Stack
run [] s = Just s
run (c:cs) s = maybe Nothing (run cs) (semCmd c s)

semCmd :: Cmd -> Stack -> Maybe Stack
semCmd (LDI n) s = Just (Right n : s)
semCmd (LDB b) s = Just (Left b : s)
semCmd ADD (Right x : Right y : xs) = Just (Right (x + y) : xs)
semCmd MULT (Right x : Right y : xs) = Just (Right (x * y) : xs)
semCmd DUP (x:xs) = Just (x:x:xs)
semCmd LEQ (Right x : Right y : xs) = Just (Left (x <= y) : xs)
semCmd (IFELSE prog1 prog2) (Left b : xs) = if b
                                            then run prog1 xs
                                            else run prog2 xs
semCmd _ _ = Nothing
