#!/usr/bin/env stack
{- stack
   script
   --nix
   --nix-packages zlib
   --resolver lts-14.22
   --package turtle
   --package protolude
   --package directory
   --package filepath
   --package text
   --package foldl
   --package directory-tree
   --package containers
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
import "base" Data.String
import "base" Data.List
import "text" Data.Text
import qualified "foldl" Control.Foldl
import qualified "directory-tree" System.Directory.Tree
import "directory-tree" System.Directory.Tree (DirTree (..), AnchoredDirTree (..))
import qualified "containers" Data.Map.Strict as Data.Map

filterDirTreeByFilename :: (String -> Bool) -> DirTree a -> Bool
filterDirTreeByFilename _ (Dir ('.':_) _) = False
filterDirTreeByFilename pred (File n _) = pred n
filterDirTreeByFilename _ _ = True

type MigrationRoot = Text -- e.g. 0000000001-start

type RelativeToMigrationPath = Text -- e.g. 02_tables/01_product_manufacturers.up.sql

type MigrationTree
  = Map MigrationRoot [RelativeToMigrationPath]

dirTreeToMigrationTree :: DirTree (MigrationRoot, RelativeToMigrationPath) -> IO MigrationTree
dirTreeToMigrationTree = go Data.Map.empty
  where
    go :: MigrationTree -> DirTree (MigrationRoot, RelativeToMigrationPath) -> IO MigrationTree
    go migrationTree (Failed name err) = Turtle.die $ "Dir tree error: filename " <> show name <> ", error " <> show err
    go migrationTree (File name (migrationRoot, relativeToMigrationPath)) = do
      let migrationTree' = Data.Map.insertWith (++) migrationRoot [relativeToMigrationPath] migrationTree
      pure migrationTree'
    go migrationTree (Dir name dirtreeList) = do
      migrationTrees :: [MigrationTree] <- traverse (go migrationTree) dirtreeList
      let migrationTree'' :: MigrationTree = Data.Map.unionsWith (++) migrationTrees
      pure migrationTree''

main :: IO ()
main = Turtle.sh $ do
  projectRoot :: Turtle.FilePath <- Turtle.pwd

  let migrationsDir :: Turtle.FilePath = projectRoot </> "migrations/"

  liftIO $ print ("migrationsDir " <> migrationsDir)

  let fullPathToPathToModule :: System.FilePath.FilePath -> IO (MigrationRoot, RelativeToMigrationPath)
      fullPathToPathToModule fullPath = do
        let fullPath' :: Turtle.FilePath = Turtle.decodeString fullPath
        let base :: Turtle.FilePath = migrationsDir

        -- e.g. 0000000001-start/02_tables/01_product_manufacturers.up.sql
        relativePath :: Turtle.FilePath <- maybe (Turtle.die $ "Cannot strip base " <> show base <> " from path " <> show fullPath) pure $ Turtle.stripPrefix base fullPath'

        let dirnames = Turtle.splitDirectories relativePath

        migrationRoot :: Text <- maybe (Turtle.die $ "Cannot find head in " <> show relativePath) (pure . dropAround (=='/'). toS . Turtle.encodeString) $ headMay dirnames
        relativeToMigrationPath :: Text <- maybe (Turtle.die $ "Cannot find tail in " <> show relativePath) (pure . Data.Text.intercalate "" . fmap (toS . Turtle.encodeString)) $ tailMay dirnames
        return (migrationRoot, relativeToMigrationPath)

  _base :/ (dirTree :: DirTree (MigrationRoot, RelativeToMigrationPath)) <- liftIO $ System.Directory.Tree.readDirectoryWith fullPathToPathToModule (Turtle.encodeString migrationsDir)

  let (dirTreeWithOnlySqlFiles :: DirTree (MigrationRoot, RelativeToMigrationPath)) =
        System.Directory.Tree.filterDir
          (filterDirTreeByFilename (\n -> System.FilePath.takeExtensions n == ".up.sql"))
          dirTree

  migrationTree :: MigrationTree <- liftIO $ dirTreeToMigrationTree dirTreeWithOnlySqlFiles

  void $ flip Data.Map.traverseWithKey migrationTree (\migrationRoot relativeToMigrationPath -> do
      let relativeToMigrationPath' = Data.List.sort relativeToMigrationPath

      let includes = Data.Text.unlines $ relativeToMigrationPath' <&> (\(path :: Text) -> "\\include " <> migrationRoot <> "/" <> path)

      let fileContent :: Text = Data.Text.unlines
            [ "-- generated by ./gen-migrations.hs"
            , ""
            , "-- ====  UP  ===="
            , ""
            , "begin;"
            , ""
            , includes
            , ""
            , "commit;"
            , ""
            , "-- ==== DOWN ===="
            , ""
            , "-- do nothing, this should never happen"
            ]

      -- liftIO $ putStrLn fileContent
      liftIO $ Turtle.writeTextFile (migrationsDir </> (Turtle.decodeString . toS $ migrationRoot) <.> "sql") fileContent
    )
