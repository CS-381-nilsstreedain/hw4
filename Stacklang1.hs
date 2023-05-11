module Stacklang1 where

type Prog = [Cmd]
data Cmd = LD Int | ADD | MULT | DUP deriving Show
type Stack = [Int]

run :: Prog -> Stack -> Maybe Stack
run [] s = Just s
run (c:cs) s = semCmd c s >>= run cs

semCmd :: Cmd -> Stack -> Maybe Stack
semCmd (LD n) s = Just (n : s)
semCmd ADD (x:y:xs) = Just (x + y : xs)
semCmd ADD _ = Nothing
semCmd MULT (x:y:xs) = Just (x * y : xs)
semCmd MULT _ = Nothing
semCmd DUP (x:xs) = Just (x : x : xs)
semCmd DUP _ = Nothing

-- Test cases
-- stack1 = [1, 2, 3, 4, 5]
-- test1 = [LD 3, DUP, ADD, DUP, MULT]
-- test2 = [LD 3, ADD]
-- test3 = []
-- test4 = [ADD, ADD, ADD, ADD]
