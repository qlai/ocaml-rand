let digestmode = 
  let doc = "MD5 hash function" in
  let md5 = MD5, Arg.info ["md5"] ~doc in
  let doc = "SHA1 hash function" in
  let sha1 = SHA1, Arg.info ["sha1"] ~doc in
  let doc = "SHA224 hash function" in
  let sha224 = SHA224, Arg.info["sha224"] ~doc in
  let doc = "SHA384 hash function" in
  let sha256 = SHA256, Arg.info["sha256"] ~doc in
  let doc = "SHA256 hash function" in
  let sha384 = SHA384, Arg.info["sha384"] ~doc in
  let doc = "SHA512 hash function" in
  let sha512 = SHA512, Arg. info["sha512"] ~doc in
  Arg.(last & vflag_all [MD5] [md5; sha1; sha224; sha256; sha384; sha512])

let encode =
  let doc = "Hex encoding" in
  let hex = HEX, Arg.info["hex"] ~doc in
  let doc = "Binary encoding" in
  let binary = BINARY, Arg.info ["binary"] ~doc in
  Arg.(last & vflag_all [HEX] [binary; hex])

let c =
  let doc = "print out digest in 2 digit groups separated by semicolon if hex encoded" in
  Arg.(value & flag & info ["c"] ~doc)

let r =
  let doc = "output in coreutils format" in
  Arg.(value & flag & info ["r"] ~doc)

let hmackey =
  let doc = "flag this if hmac required and enter your key" in
  Arg.(value & opt string "NA" & info ["hmac"] ~doc)
    
let sign =
  let doc = "sign digest with private key in file; flag and enter filename (key.pem)" in 
  Arg.(value & opt string "NA" & info ["sign"] ~doc)
  
let verify =
  let doc = "verify signature with public key in file; flag and enter filename (PEM)" in 
  Arg.(value & opt string "NA" & info ["verify"] ~doc)
  
let prverify =
  let doc = "verify signature with private key in file; flag and enter filename (PEM)" in
  Arg.(value & opt string "NA" & info ["prverify"] ~doc)
  
let signature =
  let doc = "actual signature to be verified" in 
  Arg.(value & opt string "NA" & info ["signature"] ~doc)
