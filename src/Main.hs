module Main where

import CodegenElisp

import Idris.AbsSyntax
import Idris.ElabDecls
import Idris.Options
import Idris.Main (loadInputs, runMain)

import IRTS.Compiler

import Control.Monad (void)
import System.Environment
import System.Exit

data Opts = Opts
  { inputs :: [FilePath]
  , output :: FilePath
  }

showUsage :: IO ()
showUsage = do
  putStrLn "Usage: idris-codegen-elisp <ibc-files> [-o <output-file>]"
  exitWith ExitSuccess

getOpts :: IO Opts
getOpts = do
  xs <- getArgs
  let initialInputs = []
  let defaultOutput = "a.el"
  pure $ process (Opts initialInputs defaultOutput) xs
  where
    process opts ("-o":o:xs) = process (opts {output = o}) xs
    process opts (x:xs) = process (opts {inputs = x : inputs opts}) xs
    process opts [] = opts

elispMain :: Opts -> Idris ()
elispMain opts = do
  elabPrims
  void $ loadInputs (inputs opts) Nothing
  mainProg <- elabMain
  ir <- compile (Via IBCFormat "elisp") (output opts) (Just mainProg)
  runIO $ codegenElisp ir

main :: IO ()
main = do
  opts <- getOpts
  if null (inputs opts)
    then showUsage
    else runMain $ elispMain opts
