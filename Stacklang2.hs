module Stacklang2 where

-- Define types for the program and the stack
type Prog = [Cmd]
type Stack = [Either Bool Int]

-- Define the data type for the commands in the stack language
data Cmd
    = LDI Int			-- Load int onto stack
    | LDB Bool			-- Load bool onto stack
    | LEQ				-- Compare top 2 ints on stack, push result as bool
    | ADD				-- Add top 2 ints on stack, push result
    | MULT				-- Multiply top 2 integers on stack, push result
    | DUP				-- Duplicate top element on stack
    | IFELSE Prog Prog	-- If top element true, execute program 1, otherwise program 2
    deriving Show

-- Main function to execute a program on a given stack
run :: Prog -> Stack -> Maybe Stack
run [] s = Just s -- If no commands left, return stack
-- Execute current command, continue with remaining commands
run (c:cs) s = maybe Nothing (run cs) (semCmd c s)

-- Function to execute individual commands
semCmd :: Cmd -> Stack -> Maybe Stack
semCmd (LDI n) s = Just (Right n : s)	-- Load int onto stack
semCmd (LDB b) s = Just (Left b : s)	-- Load bool onto stack
semCmd ADD (Right x : Right y : xs)		-- Add top 2 ints on stack
    = Just (Right (x + y) : xs)
semCmd MULT (Right x : Right y : xs)	-- Multiply top 2 ints on stack
    = Just (Right (x * y) : xs)
semCmd DUP (x:xs) = Just (x:x:xs)		-- Duplicate top element on stack
semCmd LEQ (Right x : Right y : xs)		-- Compare top 2, push result as bool
    = Just (Left (x <= y) : xs)

-- Execute program 1 if top element is true, otherwise, execute program 2
semCmd (IFELSE prog1 prog2) (Left b : xs) = if b
                                            then run prog1 xs
                                            else run prog2 xs
                                            
semCmd _ _ = Nothing -- If invalid operation, return Nothing
