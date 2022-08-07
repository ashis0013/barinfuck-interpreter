import BFParser
import Data.Char
import Instructions
import Utils

data Tape = Tape [Int] [Int] deriving (Show)

getval (Tape left (x:xs)) = x
getval (Tape left [])     = 0

goLeft (Tape (x:xs) right) = Tape xs (x:right)
goLeft (Tape [] right)     = Tape [] (0:right)

goRight (Tape left (x:xs)) = Tape (x:left) xs
goRight (Tape left [])     = Tape (0:left) []

modify :: (Int -> Int) -> Tape -> Tape
modify f (Tape left (x:xs)) = Tape left (f x:xs) 
modify f (Tape left [])     = Tape left [f 0]

readTape :: [Char] -> [Char] -> Tape -> ([Char], [Char], Tape)
readTape (x:xs) op tape  = (xs, op, modify (\_ -> ord x) tape)
readTape [] op tape      = ("", op, tape)

printTape :: [Char] -> [Char] -> Tape -> ([Char], [Char], Tape)
printTape inp output tape = (inp, chr (getval tape): output, tape)

interpret :: [Token] -> [Char] -> [Char] -> Tape -> ([Char], [Char], Tape)
interpret [] i o tape     = (i, o, tape)
interpret (t:ts) i o tape =
  case t of
    Inc      -> interpret ts i o $ modify (+1) tape
    Dec      -> interpret ts i o $ modify (subtract 1) tape 
    ShiftL   -> interpret ts i o $ goLeft tape 
    ShiftR   -> interpret ts i o $ goRight tape 
    Inp      -> (uncurry3 $ interpret ts) $ readTape i o tape
    Out      -> (uncurry3 $ interpret ts) $ printTape i o tape 
    Loop ins ->
      case (getval tape) of
        0 -> interpret ts i o tape
        _ -> (uncurry3 $ interpret (t:ts)) $ interpret ins i o tape

run :: String -> [Char] -> [Char]
run code inp = reverse $ se $ interpret (parse code) inp "" (Tape [] [])

main :: IO()
main = do
  putStrLn "Enter brainfuck code:"
  code <- getLine
  putStrLn "Enter your input:"
  inp <- getLine
  print $ run code inp


