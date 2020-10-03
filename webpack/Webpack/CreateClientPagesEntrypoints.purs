module Webpack.CreateClientPagesEntrypoints where
-- Copy of
--
-- https://github.com/vercel/next.js/blob/b88f20c90bf4659b8ad5cb2a27956005eac2c7e8/packages/next/build/entries.ts#L131
-- https://github.com/vercel/next.js/blob/90638c70010310ba19aa0f28847b6226fdd20339/packages/next/build/webpack-config.ts#L665-L676
--
-- More how everything should work:
--
-- https://github.com/vercel/next.js/blob/b88f20c90bf4659b8ad5cb2a27956005eac2c7e8/packages/next/build/webpack/loaders/next-client-pages-loader.ts
-- https://github.com/vercel/next.js/blob/7dbdf1d89eef004170d8f2661b4b3c299962b1f8/packages/next/client/index.js#L58
-- https://github.com/vercel/next.js/blob/42a328f3e44a560d45821a582beb257fdeea10af/packages/next/client/link.tsx#L204
-- script prefetched https://github.com/vercel/next.js/blob/3036463080d7905aa22da46e63f6c50dd50adc3c/packages/next/client/page-loader.js#L36-L49
-- script added https://github.com/vercel/next.js/blob/42a328f3e44a560d45821a582beb257fdeea10af/packages/next/client/page-loader.js#L254

import Pathy
import Protolude

import Control.Parallel (parSequence)
import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Map (Map)
import Data.Map as Map
import Data.String as String
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.String.Regex as Regex
import Data.String.Regex.Flags as Regex
import Data.String.Regex.Unsafe as Regex
import Firstline (firstline)
import Node.FS.Stats as Node.FS.Stats
import Protolude.Node as Protolude.Node
import RecursiveReaddirAsync (DirOrFile(..), recursiveTreeList)
import Unsafe.Coerce
import ModuleName

-- TODO: extract the the settings!!!
manifestPageIdSeparator :: String
manifestPageIdSeparator = "__"

moduleNameToManifestPageId :: ModuleName -> String
moduleNameToManifestPageId (ModuleName m) = String.joinWith manifestPageIdSeparator (NonEmptyArray.toArray $ map NonEmptyString.toString m)

moduleNameToName :: forall n . ModuleName -> Name n
moduleNameToName = printModuleName >>> \n -> joinName { name: n, ext: Nothing }

type ClientPagesLoaderOptions =
  { absoluteCompiledPagePursPath :: Path Abs File         -- e.g. ".../output/Foo/index.js"
  , absoluteJsDepsPath           :: Maybe (Path Abs File) -- e.g. ".../app/Pages/Foo.deps.js" or null
  }

getFileModule :: Path Abs File -> Aff ModuleName
getFileModule = \filePath -> do
  firstLine <- firstline filePath

  let
      (trimmedModuleName :: Maybe String) = (Regex.match moduleNameRegex firstLine >>= NonEmptyArray.head) <#> String.trim

      (trimmedModuleName' :: Maybe (NonEmptyArray NonEmptyString)) = trimmedModuleName >>= moduleNameFromString (String.Pattern " ")

  case trimmedModuleName' of
       Nothing -> throwError $ error $ "cannot find module name on the first line " <> firstLine
       Just moduleName -> pure (ModuleName moduleName)
  where
    moduleNameRegex = Regex.unsafeRegex """module (\S+)""" Regex.noFlags

processTree :: Path Abs Dir -> DirOrFile -> Aff (Array (ModuleName /\ ClientPagesLoaderOptions))
processTree spagoAbsoluteOutputDir =
  case _ of
       DirOrFile__File fullname -> do
          (moduleName :: ModuleName) <- getFileModule fullname -- moduleName = e.g. Nextjs.Pages.Foo

          let (absoluteCompiledPagePursPath :: Path Abs File) = spagoAbsoluteOutputDir </> dir' (moduleNameToName moduleName) </> file (SProxy :: SProxy "index.js") -- e.g. ".../output/Foo/index.js"

          let (absoluteJsDepsPath :: Path Abs File) = rename (alterExtension (const $ Just $ NonEmptyString.nes (SProxy :: SProxy ".deps.js"))) fullname

          (exisingAbsoluteJsDepsPath :: Maybe (Path Abs File)) <-
            Protolude.Node.filePathExistsAndIs Node.FS.Stats.isFile (printPath posixPrinter (sandboxAny absoluteJsDepsPath)) <#>
              if _
                then Just absoluteJsDepsPath
                else Nothing

          pure $ Array.singleton $ moduleName /\
            { absoluteCompiledPagePursPath
            , absoluteJsDepsPath: exisingAbsoluteJsDepsPath
            }
       DirOrFile__Dir { content } -> map join $ parTraverse (processTree spagoAbsoluteOutputDir) content

createClientPagesEntrypoints :: { pagesDir :: Path Abs Dir, spagoAbsoluteOutputDir :: Path Abs Dir } -> Aff (Map ModuleName ClientPagesLoaderOptions)
createClientPagesEntrypoints { pagesDir, spagoAbsoluteOutputDir } = do
  tree <- recursiveTreeList pagesDir { include: [ ".purs" ] }

  processTree spagoAbsoluteOutputDir tree <#> Map.fromFoldable
