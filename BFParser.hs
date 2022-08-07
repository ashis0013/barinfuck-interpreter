module BFParser (
  parse
) where

import Control.Applicative
import Data.Maybe
import Instructions

newtype Parser a = Parser { runParser:: String -> Maybe(String, a) }

charP :: Char -> Parser Char
charP c = Parser f
  where
    f (x:xs)
      | x == c = Just(xs, c)
      | otherwise = Nothing
    f [] = Nothing

instance Functor Parser where
  fmap f (Parser p) = Parser $ \input -> do
    (output, a) <- p input
    Just(output, f a)

instance Applicative Parser where
  pure x = Parser $ \inp -> Just(inp, x)
  (Parser a) <*> (Parser b) = Parser $ \inp -> do
    (out1, f) <- a inp
    (out2, x) <- b out1
    Just(out2, f x)

instance Alternative Parser where
  empty = Parser $ \_ -> Nothing
  (Parser a) <|> (Parser b) = Parser $ \inp -> (a inp) <|> (b inp)

charTok c t = fmap(\_ -> t) (charP c)

tokLoop :: Parser Token
tokLoop = Loop <$> (charP '[' *> tokens <* charP ']')
  where
    tokens = many tokenParser

tokenParser :: Parser Token
tokenParser = (charTok '+' Inc) <|> (charTok '-' Dec) <|> (charTok '<' ShiftL) <|> (charTok '>' ShiftR) <|> (charTok ',' Inp)<|> (charTok '.' Out)<|>tokLoop

parse :: String -> [Token]
parse inp
  | isNothing result = []
  | otherwise = fromJust $ snd <$> result
    where
      result = runParser (many tokenParser) inp
