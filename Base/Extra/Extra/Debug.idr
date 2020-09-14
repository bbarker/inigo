module Extra.Debug

export
log : Show a => String -> a -> a
log msg x =
	let
		_ = unsafePerformIO (putStrLn $ msg ++ ": " ++ show x)
	in
		x
