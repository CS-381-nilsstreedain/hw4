module Stacklang1 where

-- Define the type for a program
type Prog = [Cmd]

-- Define the data type for commands in the stack language
data Cmd
    = LD Int	-- Load int onto stack
    | ADD		-- Add top 2 ints on stack
    | MULT		-- Multiply top 2 ints on stack
    | DUP		-- Duplicate top element on stack
    deriving Show

-- Define the type for the stack
type Stack = [Int]

-- Function to run a program on a given stack
run :: Prog -> Stack -> Maybe Stack
run [] s = Just s						-- If no commands left, return stack
run (c:cs) s = semCmd c s >>= run cs	-- Execute cmd, continue with remaining

-- Function to execute individual commands
semCmd :: Cmd -> Stack -> Maybe Stack
semCmd (LD n) s = Just (n : s)				-- Load int onto stack
semCmd ADD (x:y:xs) = Just (x + y : xs)		-- Add top 2 ints on stack
semCmd ADD _ = Nothing						-- If too few elements, return
semCmd MULT (x:y:xs) = Just (x * y : xs)	-- Multiply top 2 ints on stack
semCmd MULT _ = Nothing						-- If too few elements, return
semCmd DUP (x:xs) = Just (x : x : xs)		-- Duplicate top element on stack
semCmd DUP _ = Nothing						-- If stack is empty, return
