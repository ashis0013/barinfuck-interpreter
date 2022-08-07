module Utils (
  fi, se, th, uncurry3
) where

fi (a, _, _) = a
se (_, b, _) = b
th (_, _, c) = c

uncurry3 :: (a -> b -> c -> d) -> (a, b, c) -> d
uncurry3 f t = f (fi t) (se t) (th t)
