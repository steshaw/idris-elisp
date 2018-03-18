module Main

pythag : Int -> List (Int, Int, Int)
pythag max = [(x, y, z) | z <- [1..max], y <- [1..z], x <- [1..y],
                          x * x + y *y == z * z]

println : Show a => a -> IO ()
println a = do
  print a
  putStrLn ""

main : IO ()
main = print (pythag 50)
