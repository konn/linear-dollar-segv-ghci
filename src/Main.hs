{-# LANGUAGE GADTs #-}
{-# LANGUAGE LinearTypes #-}

module Main (main) where

data Ur a where
  Ur :: a -> Ur a

unur :: Ur a %1 -> a
unur (Ur a) = a

lseq :: () %1 -> a %1 -> a
lseq () a = a

segvGHCi :: () %1 -> Either (Ur (Maybe ())) ()
segvGHCi u = u `lseq` Left (Ur $ Just ())

eitherL :: (a %1 -> c) -> (b %1 -> c) -> Either a b %1 -> c
eitherL f _ (Left x) = f x
eitherL _ g (Right y) = g y

main :: IO ()
main = print (unur (eitherL (\x -> x) (`lseq` Ur Nothing) (segvGHCi ())))
