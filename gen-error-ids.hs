#!/usr/bin/env stack
{- stack
   script
   --nix
   --nix-path "nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz"
   --nix-packages "zlib pcre-cpp pcre git"
   --resolver lts-16.17
   --package turtle
   --package protolude
   --package directory
   --package filepath
   --package text
   --package foldl
   --package directory-tree
   --package containers
   --package regex
   --package regex-base
   --package regex-tdfa
   --package string-qq
   --package cases
-}

-- #!/usr/bin/env nix-shell
-- #!nix-shell -i runghc -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [protolude turtle FindBin])"
-- #!nix-shell -i "ghcid -T main" -p "haskellPackages.ghcid" -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [protolude turtle FindBin])"

-- vim: set ft=haskell tabstop=2 shiftwidth=2 expandtab

{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE CPP #-}
{-# LANGUAGE PackageImports #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE BlockArguments #-}

module Main where

-- TODO: use http://hackage.haskell.org/package/managed instead of turtle

-- TODO
-- dont use system-filepath (Filesystem.Path module, good lib, turtle is using it,         FilePath is just record)
-- dont use filepath        (System.FilePath module, bad lib,  directory-tree is using it, FilePath is just String)
-- use https://hackage.haskell.org/package/path-io-1.6.0/docs/Path-IO.html walkDirAccumRel

-- import qualified Filesystem.Path.CurrentOS
import "protolude" Protolude hiding (find, (<.>))
import qualified "turtle" Turtle
import "turtle" Turtle ((</>), (<.>))
import qualified "directory" System.Directory
import qualified "filepath" System.FilePath
import "base" Data.String (String)
import qualified "base" Data.String as String
import qualified "base" Data.List as List
import "text" Data.Text (Text)
import qualified "text" Data.Text as Text
import qualified "foldl" Control.Foldl
import qualified "directory-tree" System.Directory.Tree
import "directory-tree" System.Directory.Tree (DirTree (..), AnchoredDirTree (..))
import qualified "containers" Data.Map.Strict as Data.Map
import Text.Regex.Base
import Text.RE.TDFA.Text
import Data.String.QQ
import Data.Tree
import qualified Cases as Cases

filterDirTreeByFilename :: (String -> Bool) -> DirTree a -> Bool
filterDirTreeByFilename _ (Dir ('.':_) _) = False
filterDirTreeByFilename pred (File n _) = pred n
filterDirTreeByFilename _ _ = True

dirTreeToMigrationTree :: DirTree [a] -> IO [a]
dirTreeToMigrationTree = go
  where
    go (Failed name err) = Turtle.die $ "Dir tree error: filename " <> show name <> ", error " <> show err
    go (File name a) = do
      pure a
    go (Dir name dirtreeList) = do
      migrationTrees :: [[a]] <- traverse go dirtreeList
      pure (List.concat migrationTrees)

maybeDo f x y =
  case f x y of
       Nothing -> y
       Just z -> z

main :: IO ()
main = Turtle.sh $ do
  projectRoot :: Turtle.FilePath <- Turtle.pwd

  let migrationsDir :: Turtle.FilePath = projectRoot </> "migrations/"

  liftIO $ print ("migrationsDir " <> migrationsDir)

  let fullPathToPathToModule :: System.FilePath.FilePath -> IO [Text]
      fullPathToPathToModule fullPath = do
        content :: Text <- readFile fullPath

        -- traceShowM content

        let exceptions :: [Text] =
              catMaybes
              $ map (`atMay` 0)
              $ traceShowId
              $ (content =~ [re|APP_EXCEPTION__[A-Z_]+|] :: [[Text]])

        return exceptions

  _base :/ (dirTree :: DirTree [Text]) <- liftIO $ System.Directory.Tree.readDirectoryWith fullPathToPathToModule (Turtle.encodeString migrationsDir)

  let (dirTreeWithOnlySqlFiles :: DirTree [Text]) =
        System.Directory.Tree.filterDir
          (filterDirTreeByFilename (\n -> ".up.sql" `List.isSuffixOf` System.FilePath.takeExtensions n))
          dirTree

  migrationTree :: [Text] <- liftIO $ dirTreeToMigrationTree dirTreeWithOnlySqlFiles

  let toFunctionName x = Text.intercalate "_" $ map (Cases.process Cases.lower Cases.camel) $ Text.splitOn "__" $ maybeDo Text.stripPrefix "APP_EXCEPTION__" x

  let fileContent :: Text = Text.unlines $
        [ "module NextjsApp.ServerExceptions where"
        , ""
        , "-- generated by ./gen-error-ids.hs"
        , ""
        ] <> flip fmap (List.nub migrationTree) \indent -> Text.unlines $
          [ toFunctionName indent <> " :: String"
          , toFunctionName indent <> " = " <> show indent
          ]

  -- liftIO $ putStrLn fileContent
  liftIO $ Turtle.writeTextFile (projectRoot </> "packages/client/" </> "NextjsApp/" </> "ServerExceptions" <.> "purs") fileContent
