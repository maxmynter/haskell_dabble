{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_TT (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/Users/maxmynter/Desktop/projects/haskell_dabble/TT/.stack-work/install/aarch64-osx/49d14b15036151a4c967484d96bef0d7372f77088f0216ad5db8dc28b2d92626/9.4.8/bin"
libdir     = "/Users/maxmynter/Desktop/projects/haskell_dabble/TT/.stack-work/install/aarch64-osx/49d14b15036151a4c967484d96bef0d7372f77088f0216ad5db8dc28b2d92626/9.4.8/lib/aarch64-osx-ghc-9.4.8/TT-0.1.0.0-AiFAVmdEBjt8ufxWUwgvWj-TT"
dynlibdir  = "/Users/maxmynter/Desktop/projects/haskell_dabble/TT/.stack-work/install/aarch64-osx/49d14b15036151a4c967484d96bef0d7372f77088f0216ad5db8dc28b2d92626/9.4.8/lib/aarch64-osx-ghc-9.4.8"
datadir    = "/Users/maxmynter/Desktop/projects/haskell_dabble/TT/.stack-work/install/aarch64-osx/49d14b15036151a4c967484d96bef0d7372f77088f0216ad5db8dc28b2d92626/9.4.8/share/aarch64-osx-ghc-9.4.8/TT-0.1.0.0"
libexecdir = "/Users/maxmynter/Desktop/projects/haskell_dabble/TT/.stack-work/install/aarch64-osx/49d14b15036151a4c967484d96bef0d7372f77088f0216ad5db8dc28b2d92626/9.4.8/libexec/aarch64-osx-ghc-9.4.8/TT-0.1.0.0"
sysconfdir = "/Users/maxmynter/Desktop/projects/haskell_dabble/TT/.stack-work/install/aarch64-osx/49d14b15036151a4c967484d96bef0d7372f77088f0216ad5db8dc28b2d92626/9.4.8/etc"

getBinDir     = catchIO (getEnv "TT_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "TT_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "TT_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "TT_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "TT_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "TT_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
