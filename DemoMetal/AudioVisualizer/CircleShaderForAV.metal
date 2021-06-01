//
//  CircleShaderForAV.metal
//  DemoMetal
//
//  Created by Higashihara Yoki on 2021/06/02.
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct VertexOutForAV {
    vector_float4 position [[position]];
    vector_float4 color;
};

vertex VertexOutForAV vertexShaderForAV(const constant vector_float2 *vertexArray [[buffer(0)]], const constant float *loudnessUniform [[buffer(1)]], const constant float *lineArray[[buffer(2)]], unsigned int vid [[vertex_id]]){
    vector_float2 currentVertex = vertexArray[vid]; //fetch the current vertex we're on using the vid to index into our buffer data which holds all of our vertex points that we passed in
    float circleScaler = loudnessUniform[0];
    VertexOutForAV output;
    
    if(vid<1081){ //circle
        vector_float2 currentVertex = vertexArray[vid]; //fetch the current vertex we're on using the vid to index into our buffer data which holds all of our vertex points that we passed in
        output.position = vector_float4(currentVertex.x*circleScaler, currentVertex.y*circleScaler, 0, 1); //populate the output position with the x and y values of our input vertex data
        output.color = vector_float4(0,0,0,1);//set the color
    } else { //frequency lines
        int circleId = vid-1081;
        vector_float2 circleVertex;
        
        if(circleId%3 == 0){
            //place line vertex off circle
            circleVertex = vertexArray[circleId];
            float lineScale = 1 + lineArray[(vid-1081)/3];
            output.position = vector_float4(circleVertex.x*circleScaler*lineScale, circleVertex.y*circleScaler*lineScale, 0, 1);
            output.color = vector_float4(0,0,1,1);
        } else {
            //place line vertex on circle
            circleVertex = vertexArray[circleId-1];
            output.position = vector_float4(circleVertex.x*circleScaler, circleVertex.y*circleScaler, 0, 1);
            output.color = vector_float4(1,0,0,1);
        }
    }
    
    return output;
}

fragment vector_float4 fragmentShaderForAV(VertexOutForAV interpolated [[stage_in]]){
    return interpolated.color;
}


