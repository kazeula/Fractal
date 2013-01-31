import Point
import Matrix
import Fractal

type Color   = (Int,Int,Int)

writePoint :: Point -> String
writePoint (x,y) = (show x) ++ "," ++ (show y) ++ " "

writePolygon :: (Color,Polygon) -> String
writePolygon ((r,g,b),p) = "<polyline points=\""
                           ++ (concatMap writePoint p)
                           ++ "\" style=\"fill:"++color2++";stroke:rgb("
                           ++ (show r)++","++(show g)++","++(show b)
                           ++ ");stroke-width:2\"/>\n"
writePolygons :: [(Color,Polygon)] -> String
writePolygons p = "<svg xmlns=\"http://www.w3.org/2000/svg\" "
                  ++ "witdh=\"465px\" height=\"400px\">\n"
                  ++ (concatMap writePolygon p) ++ "</svg>"

colorize :: Color -> [Polygon] -> [(Color,Polygon)]
colorize = zip.repeat

rainbow@[red,green,blue,yellow,purple,teal]
    = map colorize
      [(255,0,0),(0,255,0),(0,0,255),(255,255,0),(255,0,255),(0,255,255)]

red' = colorize (0xb2,0x3b,0x00)
white = colorize (255,255,255)
--color1 = colorize (0xbe,0xd4,0xff)
color1 = colorize (0x8c,0x46,0x00)
color2 = "#f0aa32"

--gen  = Generator [(0,0),(0.5,0.289),(1,0)]
--gen   = Generator [(0,0),(0.25,-0.242),(0.75,0.242),(1,0)] --[(0,0),(0.5,0.25),(1,0)]
--gen = Generator [(0,0),(0.4,0.2),(0.6,-0.2),(1,0)]
--gen = Generator [(0,0),(0.25,-0.25),(0.75,0.25),(1,0)]
gen = Generator [(0,0),(0.25,sin(1/3*pi)*0.5),(0.75,sin(1/3*pi)*0.5),(1,0)]
--gen'  = Generator [(0,0),(0.5,-0.289),(1,0)]
--gen' = Generator [(0,0),(0.4,-0.2),(0.6,0.2),(1,0)]
gen' = Generator [(0,0),(0.25,0.25),(0.75,-0.25),(1,0)]
--gen' = Generator [(0,0),(0.25,-sin(1/3*pi)*0.5),(0.75,-sin(1/3*pi)*0.5),(1,0)]

times :: Int -> (a -> a) -> (a -> a)
times n = foldr (.) id . replicate n

times2 :: Int -> (a -> a) -> (a -> a) -> (a -> a)
times2 n f g = foldr (.) id . take n . concat . repeat $ [f,g]

times3 :: Int -> (a -> a) -> (a -> a) -> (a -> a) -> (a -> a)
times3 n f g h = foldr (.) id . take n . concat . repeat $ [f,g,h]

mat = (translation (80,130)) * (scalingSame 200)
i0 = Initiater $ transform mat triangleC
i1 = applyGenerator gen i0
--i0' = applyGenerator gen' $ Initiater $ transform mat triangle

--i  = times 5 (applyGenerators [gen,gen']) i0
--i' = times 6 (applyGenerators [gen,gen']) i0

is = (map f (reverse [7..7])) -- ++ (map g [6])
    where f i = times2 i (applyGenerator gen) (applyGenerator gen') i0
--           g i = times i (applyGenerators [gen',gen]) i0'
--is = [(times2 7 (applyGenerator gen') (applyGenerator gen)) i0]

toShow (Initiater p) = map f p
    where f (a,b) = (fromInteger $ round a, fromInteger $ round b)

main = do
  writeFile "tut4.svg" $ writePolygons
            (color1 $ map toShow is)
--  let mat = translationBack (150,150) ((scaling 1.5 0.5) * (rotation (pi/4)))
--  writeFile "tut0.svg" $ writePolygons
--                (blue [[(100,100),(200,100),(200,200),(100,200)]
--                      ,[(200,200),(300,200),(300,300),(200,300)]])
                     
