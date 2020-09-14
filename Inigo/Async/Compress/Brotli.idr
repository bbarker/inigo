module Inigo.Async.Compress.Brotli

import Data.Buffer
import Extra.Buffer
import Inigo.Async.FS
import Inigo.Async.Promise
import Inigo.Async.Util

-- Compresses a String using Brotli, returning a Buffer
%foreign (promisifyPrimReq "zlib,util" "(datum)=>{return __require_util.promisify(__require_zlib.brotliCompress)(datum)}")
brotli_compress__prim : Buffer -> promise Buffer

-- Decompresses a buffer encoded in Brotli, returning the original data
%foreign (promisifyPrimReq "zlib,util" "(buf)=>__require_util.promisify(__require_zlib.brotliDecompress)(buf)")
brotli_decompress__prim : Buffer -> promise Buffer

export
compress: Buffer -> Promise Buffer
compress datum =
  promisify (brotli_compress__prim datum)

export
decompress: Buffer -> Promise Buffer
decompress buf =
  promisify (brotli_decompress__prim buf)

export
compressFile : String -> Promise Buffer
compressFile path =
  do
    contents <- fs_readFileBuf path
    compress contents
