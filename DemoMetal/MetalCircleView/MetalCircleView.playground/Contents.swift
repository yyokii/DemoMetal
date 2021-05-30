import Cocoa
import simd

var circleVertices = [simd_float2]()

func createVertexPoints(){
    func rads(forDegree d: Float)->Float32{
        return (Float.pi*d)/180
    }
    
    for i in 0...720 {
        let position : simd_float2 = [
            cos(rads(forDegree: Float(Float(i)/2.0))),
            sin(rads(forDegree: Float(Float(i)/2.0)))
        ]
        circleVertices.append(position)
    }
}

createVertexPoints()

print(circleVertices)
