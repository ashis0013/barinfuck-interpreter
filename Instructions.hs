module Instructions (
  Token(Inc, Dec, ShiftL, ShiftR, Inp, Out, Loop)
) where

data Token = Inc | Dec | ShiftL | ShiftR | Inp | Out | Loop [Token] deriving (Show, Eq)
