Shader "Vision"
{
	Properties
	{
		_TextureChannel0 ("Texture", 2D) = "gray" {}
		_TextureChannel1 ("Texture", 2D) = "gray" {}
		_TextureChannel2 ("Texture", 2D) = "gray" {}
		_TextureChannel3 ("Texture", 2D) = "gray" {}


	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" "DisableBatching" ="true" }
		LOD 100

		Pass
		{
		    ZWrite Off
		    Cull off
		    Blend SrcAlpha OneMinusSrcAlpha
		    
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
                  #pragma multi_compile_instancing
			
			#include "UnityCG.cginc"

			struct vertexPoints
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
                  UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct pixel
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

                  UNITY_INSTANCING_BUFFER_START(CommonProps)
                  UNITY_DEFINE_INSTANCED_PROP(fixed4, _FillColor)
                  UNITY_DEFINE_INSTANCED_PROP(float, _AASmoothing)
                  UNITY_DEFINE_INSTANCED_PROP(float, _rangeZero_Ten)
                  UNITY_DEFINE_INSTANCED_PROP(float, _rangeSOne_One)
                  UNITY_DEFINE_INSTANCED_PROP(float, _rangeZoro_OneH)
                  UNITY_DEFINE_INSTANCED_PROP(float, _mousePosition_x)
                  UNITY_DEFINE_INSTANCED_PROP(float, _mousePosition_y)

                  UNITY_INSTANCING_BUFFER_END(CommonProps)

            

			pixel vert (vertexPoints v)
			{
				pixel o;
				
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.vertex.xy;
				return o;
			}
            
                sampler2D _TextureChannel0;
                sampler2D _TextureChannel1;
                sampler2D _TextureChannel2;
                sampler2D _TextureChannel3;
      			
                #define PI 3.1415927
                #define TIME _Time.y
      
                float2 mouseCoordinateFunc(float x, float y)
                {
                	return normalize(float2(x,y));
                }
            /////////////////////////////////////////////////////////////////////////////////////////////
            // Default 
            /////////////////////////////////////////////////////////////////////////////////////////////


             const float2x2 m = {0.80, 0.60, -0.60, 0.80};
             const float2x2 m2 = {0.60, 0.80, -0.80, 0.6};

			
			float hash(float x) {
			    return frac(abs(sin(sin(239.929 + x) * (x + 193.453)) * 434.111));
			}
			float hash(float x, float y) {
			    return frac(abs(sin(sin(239.929 + x) * (y + 193.453)) * 434.111));
			}

			// float hash( float n )
			// {
			//     return frac(sin(n)*43758.5453);
			// }
 
			// float perlin(float2 value){
			//     float col = 0.0;
			//     float x = value.x;
			//     float y = value.y;
			//     for (int i = 0; i < 8; i++) 
			//     {
			//         float fx = floor(x);
			//         float fy = floor(y);
			//         float cx = ceil(x);
			//         float cy = ceil(y);
			//         float a = hash(fx);
			//         float b = hash(fx);
			//         float c = hash(cx);
			//         float d = hash(cx);
			//         col += lerp(lerp(a, b, frac(y)), lerp(c, d, frac(y)), frac(x));
			//         col /= 2.0;
			//         x /= 2.0;
			//         y /= 2.0;
			//     }
			//     return col;
			// }

			float perlin( in float2 x )
			{
			    float2 p = floor(x);
			    float2 f = frac(x);
			
			    f = f*f*(3.0-2.0*f);
			
			    float n = p.x + p.y*57.0;
			
			    return lerp(lerp( hash(n+  0.0), hash(n+  1.0),f.x),
			               	lerp( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
			}

// #define NOISE_SIMPLEX_1_DIV_289 0.00346020761245674740484429065744f

// float mod289(float x) {
//     return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
// }

// float2 mod289(float2 x) {
//     return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
// }

// float3 mod289(float3 x) {
//     return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
// }

// float4 mod289(float4 x) {
//     return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
// }

// float permute(float x) {
//     return mod289(
//         x*x*34.0 + x
//     );
// }

// float3 permute(float3 x) {
//     return mod289(
//         x*x*34.0 + x
//     );
// }

// float4 permute(float4 x) {
//     return mod289(
//         x*x*34.0 + x
//     );
// }



// float taylorInvSqrt(float r) {
//     return 1.79284291400159 - 0.85373472095314 * r;
// }

// float4 taylorInvSqrt(float4 r) {
//     return 1.79284291400159 - 0.85373472095314 * r;
// }


// float perlin(float2 v)
// {
//     const float4 C = float4(
//         0.211324865405187, // (3.0-sqrt(3.0))/6.0
//         0.366025403784439, // 0.5*(sqrt(3.0)-1.0)
//      -0.577350269189626, // -1.0 + 2.0 * C.x
//         0.024390243902439  // 1.0 / 41.0
//     );
    
// // First corner
//     float2 i = floor( v + dot(v, C.yy) );
//     float2 x0 = v - i + dot(i, C.xx);
    
// // Other corners
//     // float2 i1 = (x0.x > x0.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
//     // Lex-DRL: afaik, step() in GPU is faster than if(), so:
//     // step(x, y) = x <= y
//     int xLessEqual = step(x0.x, x0.y); // x <= y ?
//     int2 i1 =
//         int2(1, 0) * (1 - xLessEqual) // x > y
//         + int2(0, 1) * xLessEqual // x <= y
//     ;
//     float4 x12 = x0.xyxy + C.xxzz;
//     x12.xy -= i1;
    
// // Permutations
//     i = mod289(i); // Avoid truncation effects in permutation
//     float3 p = permute(
//         permute(
//                 i.y + float3(0.0, i1.y, 1.0 )
//         ) + i.x + float3(0.0, i1.x, 1.0 )
//     );
    
//     float3 m = max(
//         0.5 - float3(
//             dot(x0, x0),
//             dot(x12.xy, x12.xy),
//             dot(x12.zw, x12.zw)
//         ),
//         0.0
//     );
//     m = m*m ;
//     m = m*m ;
    
// // Gradients: 41 points uniformly over a line, mapped onto a diamond.
// // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
    
//     float3 x = 2.0 * frac(p * C.www) - 1.0;
//     float3 h = abs(x) - 0.5;
//     float3 ox = floor(x + 0.5);
//     float3 a0 = x - ox;

// // Normalise gradients implicitly by scaling m
// // Approximation of: m *= inversesqrt( a0*a0 + h*h );
//     m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// // Compute final noise value at P
//     float3 g;
//     g.x = a0.x * x0.x + h.x * x0.y;
//     g.yz = a0.yz * x12.xz + h.yz * x12.yw;
//     return 130.0 * dot(m, g);
// }

			float fbm( float2 p )
			{
			    float f = 0.0;
			
			    f += 0.50000*perlin( p ); 
			    p = mul(m,p*2.02);
			    f += 0.25000*perlin( p ); 
			    p = mul(m,p*2.03);
			    f += 0.12500*perlin( p ); 
			    p = mul(m,p*2.01);
			    f += 0.06250*perlin( p ); 
			    p = mul(m,p*2.04);
			    f += 0.03125*perlin( p );
			
			    return f/0.984375;
			}

			float length2( float2 p )
			{
			    float2 q = p*p*p*p;
			    return pow( q.x + q.y, 1.0/4.0 );
			}

            fixed4 frag (pixel i) : SV_Target
			{
				
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////

			    UNITY_SETUP_INSTANCE_ID(i);
			    
		    	float aaSmoothing = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _AASmoothing);
			    fixed4 fillColor = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _FillColor);
			   	float _rangeZero_Ten = UNITY_ACCESS_INSTANCED_PROP(CommonProps,_rangeZero_Ten);
				float _rangeSOne_One = UNITY_ACCESS_INSTANCED_PROP(CommonProps,_rangeSOne_One);
			    float _rangeZoro_OneH = UNITY_ACCESS_INSTANCED_PROP(CommonProps,_rangeZoro_OneH);
                float _mousePosition_x = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _mousePosition_x);
                float _mousePosition_y = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _mousePosition_y);

                float2 mouseCoordinate = mouseCoordinateFunc(_mousePosition_x, _mousePosition_y);

                float2 coordinateBase = i.uv;

                float2 coordinate = i.uv/float2(2,2);

				float2 scaleResolution = i.uv + 1;

    			float2 coordinateScale = scaleResolution.xy/float2(2, 2);


                //Test Output 
                float3 col = float3(coordinate.x + coordinate.y, coordinate.y - coordinate.x, pow(coordinate.x,2.0f));
                float3 col2 = float3(coordinateBase.x + coordinateBase.y, coordinateBase.y - coordinateBase.x, pow(coordinateBase.x,2.0f));
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////
	
                col = 0.0;
                //////////////////////////////////////////////////////////////////////////////////////////////


                float r = length(coordinate);
                float a = atan2(coordinate.y, coordinate.x);

                float dd = 0.2 * sin(4.0 * TIME);

                float ss = 1.0 + clamp(1.0 - r, 0.0, 1.0) * dd;

                r *= ss;


                col = float3(0.9, 0.4, 0.1);

                float f = fbm(5.0 * coordinate); 

                col = lerp(col, float3(0.9,0.5,0.0), f);

                col = lerp(col, float3(0.9,0.6,0.0), 1.0 - smoothstep(0.2,0.6,r));

                a += 0.05 * fbm(20.0 * coordinate);

                f = smoothstep(0.3, 1.0, fbm(float2(20.0 * a, 6.0 *r)));

                col = lerp(col, float3(1.0, 1.0, 1.0), f);

                f = smoothstep(0.4, 0.9, fbm(float2(15.0 * a, 10.0 * r)));
                 
                col *= 1.0 - 0.5 * f;

                col *= 1.0 - 0.2 * smoothstep(0.6, 0.8, r);

                // f = 1.0 - smoothstep(0.0, 0.6, length2(mul(m2, (coordinate - float2(0.3,0.5)))) * float2(1.0,2.0));
             // //    // return float4(value, 0.0, 1.0);
            	col += float3(0, 0.5, 0.5) * f * 0.5;

            	float value = 0.8 + 0.2 * cos(r * a);
            	col.xyz *= value;
 
            	f = 1.0 - smoothstep(0.05, 0.09, r);
            	col = lerp(col, float3(0.0,0.0,0.0), f);
// 
            	f = smoothstep(0.25, 0.3, r);
            	col = lerp(col, float3(1.0,1.0,1.0), f);
// 
            	// col *= 0.5 + 0.5 * pow(16.0 * coordinateScale.x * coordinateScale.y * (1.0 - coordinateScale.x) * (1.0 - coordinateScale.y), 0.1);
                // return float4(coordinateScale, 0.0, 1.0);

            	if(col.x > 0.99 && col.y > 0.99 && col.z > 0.99)
            	{
            		return float4(col2, 1.0);
            	}
            	else
            	{
	                return float4(col, 1.0);

            	}



				
			}

			ENDCG
		}
	}
}

























