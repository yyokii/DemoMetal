//
//  CircleShader.metal
//  DemoMetal
//
//  Created by Higashihara Yoki on 2021/05/30.
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct VertexOut {
    vector_float4 position [[position]];
    vector_float4 color;
};


/*
 The first parameter is us taking in our array of vertex points that we’ll be passing in. Breaking down the syntax, we see we have a pointer to an array of vector floats. The vertex data, as you will see soon, needs to be passed in as “buffer data”. The [[buffer(0)]] specifies that we want the first (and our only) buffer data to be passed into this parameter. The constant attribute tells metal to store the vertex data in read-only memory space.
 The second parameter vid stands for “vector id”. This uniquely identifies which vertex we’re currently on; it will be used as the index for our vertexArray. Just as how in our vertexArray parameter we needed to let metal know that it needs to pass in, we let metal know to pass our vertex id into the vid parameter using [[vertex_id]] .

 */
vertex VertexOut vertexShader(const constant vector_float2 *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]]){
    vector_float2 currentVertex = vertexArray[vid]; //fetch the current vertex we're on using the vid to index into our buffer data which holds all of our vertex points that we passed in
    VertexOut output;
    
    output.position = vector_float4(currentVertex.x, currentVertex.y, 0, 1); //populate the output position with the x and y values of our input vertex data
    output.color = vector_float4(1,1,1,1); //set the color
    
    return output;
}

fragment vector_float4 fragmentShader(VertexOut interpolated [[stage_in]]){
    return interpolated.color;
}
