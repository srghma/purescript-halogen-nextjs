module RecursiveReaddirAsync where

import Control.Promise
import Effect.Uncurried
import Protolude

import Foreign (Foreign)
import Foreign as Foreign
import Pathy


-- e.g. returns
-- [
--   {
--     name: 'Basic.purs',
--     path: '/home/srghma/projects/purescript-halogen-nextjs/app/Nextjs/Pages',
--     fullname: '/home/srghma/projects/purescript-halogen-nextjs/app/Nextjs/Pages/Basic.purs',
--     isDirectory: false
--   },
--   {
--     name: 'Buttons',
--     path: '/home/srghma/projects/purescript-halogen-nextjs/app/Nextjs/Pages',
--     fullname: '/home/srghma/projects/purescript-halogen-nextjs/app/Nextjs/Pages/Buttons',
--     isDirectory: true,
--     content: [
--       {
--         name: 'Buttons.purs',
--         path: '/home/srghma/projects/purescript-halogen-nextjs/app/Nextjs/Pages/Buttons',
--         fullname: '/home/srghma/projects/purescript-halogen-nextjs/app/Nextjs/Pages/Buttons/Buttons.purs',
--         isDirectory: false
--       },
--     ]
--   }
-- ]

data DirOrFile
  = DirOrFile__File (Path Abs File)
    -- | { name     :: Name File
    -- | , path     :: Path Abs Dir
    -- | { fullname :: Path Abs File
    -- | }
  | DirOrFile__Dir
    -- { name     :: Name Dir
    -- , path     :: Path Abs Dir
    { fullname :: Path Abs Dir
    , content  :: Array DirOrFile
    }

recursiveTreeList :: Path Abs Dir -> { include :: Array String } -> Aff DirOrFile
recursiveTreeList = undefined
  where
    foreignToDirOrFile :: Foreign -> Foreign.F DirOrFile
    foreignToDirOrFile = undefined

foreign import _recursiveTreeList :: EffectFn2 String { include :: Array String } (Promise Foreign)
